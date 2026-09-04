# pr-review

A multi-pass pull request review that runs on Vertex AI. Four Gemini Flash passes read the
change in parallel, each writing findings as JSON. A Claude final round then verifies every
finding against the code, discards what it cannot confirm, merges duplicates, and posts a
single review.

```
preflight     draft / docs-only / dependency-bump PRs are skipped here
              emits the merge base, the head SHA and the changed-file list
                              |
passes        correctness   security   conventions   tests      (parallel, Gemini Flash)
              each writes findings-<pass>.json as an artifact
                              |
final-round   Claude reads every finding, tries to disprove it, ranks what survives,
              and posts one GitHub review with at most 10 inline comments
```

The passes look for bugs; the final round is the only thing that speaks to the author.
A pass that fails or times out does not block the review, because `final-round` runs on
`always()` and reviews whatever findings did arrive.

## Using it

```yaml
name: PR Review

on:
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
    paths-ignore:
      - '**/*.md'
      - 'docs/**'

concurrency:
  group: pr-review-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  review:
    if: github.event.pull_request.draft == false
    uses: parsleyhealth/github-composite-actions/.github/workflows/pr-review.yml@main
    permissions:
      contents: read
      pull-requests: write
      id-token: write
    with:
      gcp_workload_identity_provider: ${{ vars.GCP_WIF_PROVIDER }}
      gcp_service_account: ${{ vars.GCP_PR_REVIEWER_SA }}
      install_command: corepack enable && yarn install --immutable
      typecheck_command: yarn typecheck
      test_command: TZ=UTC yarn test
    secrets:
      NPM_TOKEN: ${{ secrets.PERSONAL_ACCESS_TOKEN }}
```

## Inputs

| Input | Default | Description |
| --- | --- | --- |
| `gcp_project_id` | `parsley-staging-1` | Project hosting the Vertex AI endpoint. |
| `gcp_location` | `global` | Vertex AI location. Leave it on `global`; see Models. |
| `gcp_workload_identity_provider` | required | Full resource name of the workload identity provider. |
| `gcp_service_account` | required | Service account the workflow impersonates. |
| `gemini_model` | `gemini-3.8-flash` | Model that runs the four passes. |
| `final_model` | `claude-opus-5` | Model that verifies findings and posts the review. |
| `node_version` | `20` | Node version set up before install. |
| `install_command` | empty | Dependency install command. Leave empty for repositories that need none. |
| `typecheck_command` | empty | Run once per pass. Leave empty to skip. |
| `test_command` | empty | Passes append specific test files to it. Leave empty to skip. |
| `knowledge_file` | `.github/pr-review-knowledge.md` | Repository-specific reviewer notes. |

`NPM_TOKEN` is an optional secret, exported as `YARN_NPM_AUTH_TOKEN` during install.

## What callers must set up

Two repository variables, under **Settings → Secrets and variables → Actions → Variables**:

- `GCP_WIF_PROVIDER` — the full workload identity provider resource name,
  `projects/<number>/locations/global/workloadIdentityPools/<pool>/providers/<provider>`.
- `GCP_PR_REVIEWER_SA` — the email of the dedicated least-privilege reviewer service account.

The service account needs `roles/aiplatform.user` on the project named by `gcp_project_id`
and nothing else. It is provisioned separately, in Pulumi. Tokens are minted per run through
workload identity federation, so no long-lived key exists.

The caller's job also needs `id-token: write`, or federation cannot mint a token.

## The knowledge file

`.github/pr-review-knowledge.md` is where a repository records the traps a reviewer would
otherwise have to learn the hard way: how it deploys, which commands regenerate committed
artefacts, which hooks return a third state, what must never reach analytics. Every pass reads
it before reading the diff, and the final round checks convention findings against it.

Keep it short and factual, and verify each line against the repository before adding it. A
wrong entry is worse than a missing one, because every pass will act on it.

## Models

The passes run on Gemini Flash, which is cheap enough to run four times per push. The final
round runs on Opus 5 via Vertex, because verification is the step that decides what the author
actually sees and is worth the stronger model. Sonnet 4.6 is the cheaper fallback: set
`final_model: claude-sonnet-4-6` to use it.

Every Claude Code model alias is pinned inside the action, so the CLI can never fall back to a
model the project has not enabled. Sonnet 4.6 backs the Sonnet and Haiku aliases, since Haiku
is not enabled here.

Leave `gcp_location` on `global`, and do not pin a region later. It is not a preference; it is
the only location the final round can run in. Probing `parsley-staging-1` directly found:

| Location | Opus |
| --- | --- |
| `global` | serves |
| `us-central1` | 400, model not servable |
| `us-east5` | 429 on the first token, no quota |

`us-east5` is the trap, because it serves the model with no usable quota, and the failure
reads like transient load rather than a misconfiguration. Gemini Flash is `global` only too.

Two limits on that probe: it ran as a human user, so it proves the models are enabled on the
project rather than that the reviewer service account can reach them, and it only checked that
a single request succeeds. Sustained throughput at `global` under four parallel passes plus an
Opus final round has not been measured, so quota under real load is still an open question.

## Cost

The four Flash passes come to a few cents together per pull request. The final round dominates
the bill, because it runs on Opus and reads whatever code it needs to check each finding.
Expect on the order of a dollar or two for a substantial change, less for a small one. That is
an estimate, not a measurement: nothing has run against Vertex yet, so watch the first week of
real reviews before trusting a number. Dropping `final_model` to `claude-sonnet-4-6` cuts it
sharply if the verification quality holds up.

Preflight skips drafts, documentation-only changes and lockfile-only dependency bumps, which
removes a good share of runs. Concurrency is per pull request with `cancel-in-progress`, so a
fast series of pushes costs one review, not one per push.

## Tool restrictions

The Gemini CLI runs under `--yolo`, which ships a rule allowing every tool. The passes take
that back with a user-tier policy written to `~/.gemini/policies/pr-review.toml`, which
outranks it: `write_file` and `replace` are denied outright, and `run_shell_command` is
allowed only for `git diff`, `git log`, `git show`, `git blame`, and the configured typecheck
and test commands. Everything else is denied. The policy has to live in the user tier because
workspace-tier policies are currently non-functional upstream. Alongside it, `tools.core` in
the CLI settings restricts the built-in tool set to the read-only tools plus the shell, and
usage statistics and telemetry are both switched off.

The final round is restricted through Claude Code's own `--allowedTools`, to reads, greps,
`git` inspection, and the `gh` calls it needs to read prior reviews and post its own.
