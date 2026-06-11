#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
LEDGER="${REPO_ROOT}/reference/haxe-rust-pressure-gaps.v1.json"

jq -e '
  .schema == "codex-hxrust.haxe-rust-pressure-gaps.v1"
  and .bead == "HXCX-7.1"
  and .decisionRecordFeed == "HXCX-7.3"
  and .summary.totalGaps == (.gaps | length)
  and .summary.resolvedUpstream == ([.gaps[] | select(.status == "resolved_upstream")] | length)
  and .summary.openUpstream == ([.gaps[] | select(.status == "open_upstream")] | length)
  and .summary.localWorkaround == ([.gaps[] | select(.status == "local_workaround")] | length)
' "$LEDGER" >/dev/null

jq -e '
  .summary.severity.high == ([.gaps[] | select(.severity == "high")] | length)
  and .summary.severity.medium == ([.gaps[] | select(.severity == "medium")] | length)
  and .summary.severity.low == ([.gaps[] | select(.severity == "low")] | length)
' "$LEDGER" >/dev/null

jq -e '
  .summary.sourceAreas.build_profile_tooling == ([.gaps[] | select(.sourceArea == "build_profile_tooling")] | length)
  and .summary.sourceAreas.protocol_json_dto == ([.gaps[] | select(.sourceArea == "protocol_json_dto")] | length)
  and .summary.sourceAreas.runtime_model_session == ([.gaps[] | select(.sourceArea == "runtime_model_session")] | length)
  and .summary.sourceAreas.cafex_adapter == ([.gaps[] | select(.sourceArea == "cafex_adapter")] | length)
' "$LEDGER" >/dev/null

jq -e '
  [.gaps[] | select(
    (.id // "") == ""
    or (.status // "") == ""
    or (.severity // "") == ""
    or (.sourceArea // "") == ""
    or (.reproduction // "") == ""
    or (.workaround // "") == ""
    or (.validation | length) == 0
    or (.haxeRustRefs | length) == 0
  )] | length == 0
' "$LEDGER" >/dev/null

jq -e '
  [.gaps[] | select(.status == "open_upstream" or .status == "local_workaround") | select((.followUp // "") == "")] | length == 0
' "$LEDGER" >/dev/null

source_files=$(find "$ROOT/src" "$ROOT/test" -type f -name '*.hx' | wc -l | tr -d ' ')
raw_matches=$({ rg --count-matches '__rust__|rust\.metal\.Code|@:rustAllowRaw|@:rust[A-Z]|untyped' "$ROOT/src" "$ROOT/test" -g '*.hx' || true; } | awk -F: '{sum += $2} END{print sum + 0}')

[[ "$(jq -r '.rawRustPressure.sourceFilesScanned' "$LEDGER")" == "$source_files" ]]
[[ "$(jq -r '.rawRustPressure.rawEscapeMatches' "$LEDGER")" == "$raw_matches" ]]

jq -e '
  .rawRustPressure.rawEscapeMatches == 0
  and (.gaps[] | select(.id == "nullable-interface-values").status == "open_upstream")
  and (.gaps[] | select(.id == "path-directory-lowering").status == "local_workaround")
  and (.gaps[] | select(.id == "string-last-index-of-lowering").status == "local_workaround")
' "$LEDGER" >/dev/null

echo "haxe.rust pressure gap ledger passed."
