# Github Composite Actions

Utility composite and docker actions for Parsley Workflows

- [`tag-draft-release`](./tag-draft-release/README.md) creates a new tag based on a semver or properties file and then creates a draft release including content from `CHANGELOG.md`
- [`slack-job-status`](./slack-job-status/README.md) creates outputs based on the job status usable with [voxmedia/github-action-slack-notify-build](https://github.com/voxmedia/github-action-slack-notify-build)
- [`service-name-gen`](./service-name-gen/README.md) creates a unique service name and corresponding hostname for an endpoint
- [`bit-tag-export`](./bit-tag-export/README.md) tags and exports bit components
- [`bdd-xray-export`](./bdd-xray-export/README.md) runs cucumber BDD tests and exports results to Xray
- [`build-push-action`](./build-push-action/README.md) builds and pushes docker image to GCR using workload id federation
- [`get-secretmanager-secret`](./get-secretmanager-secret/README.md) get secret from google cloud secret manager using workload id federation
- [`go-ci`](./go-ci/README.md) common CI patterns for running test, lint and sonar scans on go services
- [`release-notes`](./release-notes/README.md) push release notes from our core products to a Notion database
- [`goose-migration`](./goose-migration/README.md) run goose migrations against cloud sql instances
- [`setup-node`](./setup-node/README.md) replacement for `actions/setup-node`
- [`db-init-action`](./db-init-action/README.md) replacement for `actions/setup-node`

- [`claude-pr-review`](./.github/workflows/claude-pr-review.yml) reusable workflow for automatic Claude Code PR reviews (auto-review on PR open/push, interactive via `@claude` comments)

## Contributing

- make sure to add documentation to a `README.md` in a well-named subfolder
- if possible: dogfood your new action and add a test in this repo
- bump `version.txt` according to semver
- add to `CHANGELOG.md` a description of changes made to project
- create PR and ping reviewers
- after merging PR, a draft release will be created, make sure to publish the release and the latest major version tag will be bumped and published
