#!/usr/bin/env bash
#
# Turn whatever the Gemini pass returned into a findings-<pass>.json file the
# final round can rely on. A pass that fails, times out or answers with prose
# still produces a well-formed file, so one bad pass never blocks the review.
set -uo pipefail

OUT="findings-${PASS}.json"

write_stub() {
  jq -nc --arg pass "${PASS}" --arg err "$1" '{pass: $pass, findings: [], error: $err}' > "${OUT}"
  echo "::warning title=PR review (${PASS})::${1}"
}

finish() {
  {
    echo "findings_file=${OUT}"
  } >> "${GITHUB_OUTPUT}"
  echo "--- ${OUT} ---"
  cat "${OUT}"
  exit 0
}

RAW="${RAW_OUTPUT:-}"

if [[ -z "${RAW//[[:space:]]/}" ]]; then
  ERR="pass produced no output"
  if [[ -n "${RAW_ERROR:-}" ]]; then
    ERR="${ERR}: $(printf '%s' "${RAW_ERROR}" | head -c 300 | tr '\n' ' ')"
  fi
  write_stub "${ERR}"
  finish
fi

# Drop markdown fences the model may have wrapped the JSON in.
CANDIDATE="$(printf '%s\n' "${RAW}" | sed '/^[[:space:]]*```/d')"

if ! printf '%s' "${CANDIDATE}" | jq -e . >/dev/null 2>&1; then
  # Fall back to the span between the first '{' and the last '}', which strips
  # any preamble or trailing commentary around the object.
  TRIMMED="${CANDIDATE#*\{}"
  TRIMMED="{${TRIMMED}"
  TRIMMED="${TRIMMED%\}*}"
  CANDIDATE="${TRIMMED}}"
fi

if ! printf '%s' "${CANDIDATE}" | jq -e 'type == "object" and (.findings | type == "array")' >/dev/null 2>&1; then
  write_stub "non-json output"
  finish
fi

# Coerce every field to the shape the final round expects, drop findings that
# name no file or carry no title, and keep at most eight.
if ! printf '%s' "${CANDIDATE}" | jq -c --arg pass "${PASS}" '
  {
    pass: $pass,
    findings: [
      .findings[]?
      | select(type == "object")
      | {
          file: ((.file // "") | tostring),
          line: ((try ((.line | tonumber) | floor) catch 0) // 0),
          severity: (((.severity // "low") | tostring | ascii_downcase)
                     | if . == "high" or . == "medium" or . == "low" then . else "low" end),
          title: (((.title // "") | tostring)[0:80]),
          body: (((.body // "") | tostring)[0:600]),
          evidence: (((.evidence // "") | tostring)[0:600]),
          confidence: ((try (.confidence | tonumber) catch 0.5) // 0.5)
        }
      | select(.file != "" and .title != "")
    ][0:8]
  }
' > "${OUT}" 2>/dev/null; then
  write_stub "output could not be normalized"
fi

finish
