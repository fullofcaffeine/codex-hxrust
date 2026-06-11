#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
PIN_FILE="${REPO_ROOT}/reference/upstream-codex.pin.json"
GOLDEN="${REPO_ROOT}/reference/app-protocol-schema-fingerprints.v1.json"
REPORT_DIR="${ROOT}/generated/reports"
ACTUAL="${REPORT_DIR}/app-protocol-schema-fingerprints.actual.v1.json"
DIFF_REPORT="${REPORT_DIR}/app-protocol-schema-diff.v1.json"

mkdir -p "$REPORT_DIR"

upstream_path="$(jq -r '.localPath' "$PIN_FILE")"
upstream_commit="$(jq -r '.commit' "$PIN_FILE")"
schema_root="${REPO_ROOT}/${upstream_path}/codex-rs/app-server-protocol/schema/json"

if [[ ! -d "$schema_root" ]]; then
  echo "Upstream app-server schema root is missing: ${schema_root}" >&2
  exit 1
fi

selected_schemas=(
  "ThreadStartParams:v2/ThreadStartParams.json"
  "ThreadStartResponse:v2/ThreadStartResponse.json"
  "TurnStartParams:v2/TurnStartParams.json"
  "TurnStartResponse:v2/TurnStartResponse.json"
  "TurnInterruptParams:v2/TurnInterruptParams.json"
  "TurnInterruptResponse:v2/TurnInterruptResponse.json"
  "ThreadReadParams:v2/ThreadReadParams.json"
  "ThreadReadResponse:v2/ThreadReadResponse.json"
  "ThreadStartedNotification:v2/ThreadStartedNotification.json"
  "ThreadStatusChangedNotification:v2/ThreadStatusChangedNotification.json"
  "TurnStartedNotification:v2/TurnStartedNotification.json"
  "TurnCompletedNotification:v2/TurnCompletedNotification.json"
  "ItemStartedNotification:v2/ItemStartedNotification.json"
  "AgentMessageDeltaNotification:v2/AgentMessageDeltaNotification.json"
  "ItemCompletedNotification:v2/ItemCompletedNotification.json"
  "ErrorNotification:v2/ErrorNotification.json"
  "JSONRPCError:JSONRPCError.json"
)

entries_dir="$(mktemp -d)"
trap 'rm -rf "$entries_dir"' EXIT

for selected in "${selected_schemas[@]}"; do
  id="${selected%%:*}"
  rel="${selected#*:}"
  file="${schema_root}/${rel}"
  if [[ ! -f "$file" ]]; then
    echo "Selected schema is missing: ${rel}" >&2
    exit 1
  fi

  canonical="$(jq -S -c . "$file")"
  hash="$(printf '%s' "$canonical" | shasum -a 256 | awk '{print $1}')"
  fields="$(jq -S -c '
    ([(.required // [])[] | "required:" + .]
    + [(.properties // {}) | keys[] | "property:" + .]
    + [(.definitions // {}) | keys[] | "definition:" + .])
    | sort
  ' "$file")"

  jq -n \
    --arg id "$id" \
    --arg sourcePath "$rel" \
    --arg sha256 "$hash" \
    --argjson fields "$fields" \
    '{id: $id, sourcePath: $sourcePath, sha256: $sha256, fields: $fields}' \
    > "${entries_dir}/${id}.json"
done

entries_json="${entries_dir}/entries.json"
jq -s 'sort_by(.id)' "${entries_dir}"/*.json > "$entries_json"

fingerprint_payload="$(jq -S -c '{schemas: [.[] | {id, sourcePath, sha256, fields}]}' "$entries_json")"
fingerprint="$(printf '%s' "$fingerprint_payload" | shasum -a 256 | awk '{print $1}')"

jq -n \
  --arg schema "codex-hxrust.app-protocol-schema-fingerprints.v1" \
  --arg owner "upstream-codex" \
  --arg pinFile "reference/upstream-codex.pin.json" \
  --arg sourceRoot "../codex/codex-rs/app-server-protocol/schema/json" \
  --arg sourceCommit "$upstream_commit" \
  --arg fingerprint "sha256:${fingerprint}" \
  --slurpfile schemas "$entries_json" \
  '{
    schema: $schema,
    source: {
      owner: $owner,
      pinFile: $pinFile,
      sourceRoot: $sourceRoot,
      sourceCommit: $sourceCommit
    },
    fingerprint: $fingerprint,
    schemas: $schemas[0],
    gaps: [
      {
        id: "cafex-schema-diff",
        status: "deferred_to_M5",
        reason: "Cafex/Cafetera fixtures are adapter oracles and are intentionally inactive until the upstream-shaped core exists."
      }
    ]
  }' > "$ACTUAL"

if [[ "${ACCEPT_SCHEMA_FINGERPRINT:-0}" == "1" ]]; then
  cp "$ACTUAL" "$GOLDEN"
  echo "Accepted schema fingerprint golden: ${GOLDEN}"
fi

if [[ ! -f "$GOLDEN" ]]; then
  echo "Missing golden schema fingerprint: ${GOLDEN}" >&2
  echo "Run with ACCEPT_SCHEMA_FINGERPRINT=1 to create it after review." >&2
  exit 1
fi

jq -n \
  --slurpfile expected "$GOLDEN" \
  --slurpfile actual "$ACTUAL" '
  def by_id($items):
    reduce $items[] as $item ({}; .[$item.id] = $item);
  def status_for($expected; $actual):
    if $expected == null then "extra_schema"
    elif $actual == null then "missing_schema"
    elif $expected.sha256 != $actual.sha256 then "changed_schema"
    elif (($expected.fields // []) - ($actual.fields // []) | length) > 0 then "field_drift"
    elif (($actual.fields // []) - ($expected.fields // []) | length) > 0 then "field_drift"
    else "match"
    end;
  ($expected[0].schemas // []) as $expectedSchemas
  | ($actual[0].schemas // []) as $actualSchemas
  | (by_id($expectedSchemas)) as $expectedById
  | (by_id($actualSchemas)) as $actualById
  | (($expectedById | keys) + ($actualById | keys) | unique | sort) as $ids
  | {
      schema: "codex-hxrust.app-protocol-schema-diff.v1",
      status: (if $expected[0].fingerprint == $actual[0].fingerprint then "match" else "mismatch" end),
      expectedFingerprint: $expected[0].fingerprint,
      actualFingerprint: $actual[0].fingerprint,
      schemas: [
        $ids[] as $id
        | ($expectedById[$id] // null) as $expectedSchema
        | ($actualById[$id] // null) as $actualSchema
        | {
            id: $id,
            status: status_for($expectedSchema; $actualSchema),
            missingFields: (($expectedSchema.fields // []) - ($actualSchema.fields // [])),
            extraFields: (($actualSchema.fields // []) - ($expectedSchema.fields // [])),
            changedFields: (if ($expectedSchema != null and $actualSchema != null and $expectedSchema.sha256 != $actualSchema.sha256 and (($expectedSchema.fields // []) - ($actualSchema.fields // []) | length) == 0 and (($actualSchema.fields // []) - ($expectedSchema.fields // []) | length) == 0) then ["schema-content"] else [] end)
          }
      ],
      gaps: ($actual[0].gaps // [])
    }
  ' > "$DIFF_REPORT"

if ! cmp -s "$GOLDEN" "$ACTUAL"; then
  echo "Schema fingerprint mismatch." >&2
  jq '.status, .expectedFingerprint, .actualFingerprint, [.schemas[] | select(.status != "match")]' "$DIFF_REPORT" >&2
  echo "Actual: ${ACTUAL}" >&2
  echo "Diff: ${DIFF_REPORT}" >&2
  echo "Review upstream schema drift, then rerun with ACCEPT_SCHEMA_FINGERPRINT=1 if accepted." >&2
  exit 1
fi

echo "Schema fingerprint gate passed: ${DIFF_REPORT}"
