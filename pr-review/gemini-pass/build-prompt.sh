#!/usr/bin/env bash
#
# Assemble the prompt for one review pass: the shared preamble followed by the
# pass-specific instructions, with the run's values substituted in.
#
# Substitution is a plain bash replacement of {{PLACEHOLDER}} markers rather than
# envsubst, so nothing in the prompt text can be expanded by accident.
set -euo pipefail

PROMPTS_DIR="${GITHUB_ACTION_PATH}/prompts"
PASS_FILE="${PROMPTS_DIR}/${PASS}.md"

if [[ ! -f "${PASS_FILE}" ]]; then
  echo "Unknown pass '${PASS}'. Expected one of: correctness, security, conventions, tests." >&2
  exit 1
fi

PROMPT="$(cat "${PROMPTS_DIR}/_common.md"; printf '\n\n'; cat "${PASS_FILE}")"

if [[ -n "${TYPECHECK_COMMAND:-}" ]]; then
  TYPECHECK_LINE="${TYPECHECK_COMMAND}"
else
  TYPECHECK_LINE="(none configured — skip typechecking)"
fi

if [[ -n "${TEST_COMMAND:-}" ]]; then
  TEST_LINE="${TEST_COMMAND}"
else
  TEST_LINE="(none configured — skip running tests)"
fi

PROMPT="${PROMPT//\{\{PASS\}\}/${PASS}}"
PROMPT="${PROMPT//\{\{REPO\}\}/${REPO}}"
PROMPT="${PROMPT//\{\{PR_NUMBER\}\}/${PR_NUMBER}}"
PROMPT="${PROMPT//\{\{BASE_SHA\}\}/${BASE_SHA}}"
PROMPT="${PROMPT//\{\{HEAD_SHA\}\}/${HEAD_SHA}}"
PROMPT="${PROMPT//\{\{CHANGED_FILES\}\}/${CHANGED_FILES}}"
PROMPT="${PROMPT//\{\{TYPECHECK_COMMAND\}\}/${TYPECHECK_LINE}}"
PROMPT="${PROMPT//\{\{TEST_COMMAND\}\}/${TEST_LINE}}"
PROMPT="${PROMPT//\{\{KNOWLEDGE_FILE\}\}/${KNOWLEDGE_FILE}}"

DELIMITER="PROMPT_EOF_$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
{
  printf 'value<<%s\n' "${DELIMITER}"
  printf '%s\n' "${PROMPT}"
  printf '%s\n' "${DELIMITER}"
} >> "${GITHUB_OUTPUT}"

printf 'Built %s prompt (%s characters).\n' "${PASS}" "${#PROMPT}"
