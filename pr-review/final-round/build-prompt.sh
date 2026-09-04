#!/usr/bin/env bash
#
# Assemble the final round prompt with this run's values substituted in.
#
# Substitution is a plain bash replacement of {{PLACEHOLDER}} markers rather than
# envsubst, so nothing in the prompt text can be expanded by accident.
set -euo pipefail

PROMPT="$(cat "${GITHUB_ACTION_PATH}/prompts/final-round.md")"

PROMPT="${PROMPT//\{\{REPO\}\}/${REPO}}"
PROMPT="${PROMPT//\{\{PR_NUMBER\}\}/${PR_NUMBER}}"
PROMPT="${PROMPT//\{\{BASE_SHA\}\}/${BASE_SHA}}"
PROMPT="${PROMPT//\{\{HEAD_SHA\}\}/${HEAD_SHA}}"
PROMPT="${PROMPT//\{\{FINDINGS_DIR\}\}/${FINDINGS_DIR}}"
PROMPT="${PROMPT//\{\{KNOWLEDGE_FILE\}\}/${KNOWLEDGE_FILE}}"

DELIMITER="PROMPT_EOF_$(head -c 16 /dev/urandom | od -An -tx1 | tr -d ' \n')"
{
  printf 'value<<%s\n' "${DELIMITER}"
  printf '%s\n' "${PROMPT}"
  printf '%s\n' "${DELIMITER}"
} >> "${GITHUB_OUTPUT}"

printf 'Built final round prompt (%s characters).\n' "${#PROMPT}"
