#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPARISON="${ROOT}/fixtures/cafex/cafex-hxrust-friction-comparison.v1.json"
HXRUST_LEDGER="${ROOT}/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json"
CAFEX_LEDGER="${ROOT}/../../../fullofcaffeine/tools/cafetera/modules/codex/tests/fixtures/cafex-fork-seam-ledger.v1.json"
CAFEX_PATCH="${ROOT}/../../../fullofcaffeine/tools/cafetera/modules/codex/runtime/patches/0001-cafex-runtime-0.135.patch"

jq -e '
  .schema == "codex-hxrust.cafex-hxrust-friction-comparison.v1"
  and .summary.productionReplacement == false
  and .decisionRecordFeed == "HXCX-6.3"
  and .summary.recommendation != ""
  and .summary.rebaseFrictionClaim != ""
' "$COMPARISON" >/dev/null

jq -e --slurpfile ledger "$HXRUST_LEDGER" '
  .hxrustBurden.seamLedgerRows.total == $ledger[0].summary.rows
  and .hxrustBurden.seamLedgerRows.supported == $ledger[0].summary.supported
  and .hxrustBurden.seamLedgerRows.unsupported == $ledger[0].summary.unsupported
  and .hxrustBurden.seamLedgerRows.reviewOnly == $ledger[0].summary.reviewOnly
' "$COMPARISON" >/dev/null

jq -e --slurpfile ledger "$HXRUST_LEDGER" '
  (.hxrustBurden.seamPatchClasses[] | select(.patchClass == "fork_only_caf_adapter").count)
    == ([$ledger[0].rows[] | select(.patchClass == "fork_only_caf_adapter")] | length)
  and
  (.hxrustBurden.seamPatchClasses[] | select(.patchClass == "upstreamable_seam").count)
    == ([$ledger[0].rows[] | select(.patchClass == "upstreamable_seam")] | length)
  and
  (.hxrustBurden.seamPatchClasses[] | select(.patchClass == "temporary_sync_shim").count)
    == ([$ledger[0].rows[] | select(.patchClass == "temporary_sync_shim")] | length)
' "$COMPARISON" >/dev/null

jq -e --slurpfile ledger "$CAFEX_LEDGER" '
  .cafexPatchStack.seamFamilies == ($ledger[0].seams | length)
  and
  (.cafexPatchStack.seamPatchClasses[] | select(.patchClass == "fork_only_caf_adapter").count)
    == ([$ledger[0].seams[] | select(.patchClass == "fork_only_caf_adapter")] | length)
  and
  (.cafexPatchStack.seamPatchClasses[] | select(.patchClass == "upstreamable_seam").count)
    == ([$ledger[0].seams[] | select(.patchClass == "upstreamable_seam")] | length)
  and
  (.cafexPatchStack.seamPatchClasses[] | select(.patchClass == "temporary_sync_shim").count)
    == ([$ledger[0].seams[] | select(.patchClass == "temporary_sync_shim")] | length)
' "$COMPARISON" >/dev/null

patch_files=$(find "$(dirname "$CAFEX_PATCH")" -maxdepth 1 -type f -name '*.patch' | wc -l | tr -d ' ')
unique_paths=$(awk '/^diff --git / {print $4}' "$CAFEX_PATCH" | sort -u | wc -l | tr -d ' ')
added_lines=$(awk 'BEGIN{add=0} /^\+/ && $0 !~ /^\+\+\+/ {add++} END{print add}' "$CAFEX_PATCH")
deleted_lines=$(awk 'BEGIN{del=0} /^-/ && $0 !~ /^---/ {del++} END{print del}' "$CAFEX_PATCH")
total_delta=$((added_lines + deleted_lines))

[[ "$(jq -r '.cafexPatchStack.runtimePatchFiles' "$COMPARISON")" == "$patch_files" ]]
[[ "$(jq -r '.cafexPatchStack.uniqueTouchedPaths' "$COMPARISON")" == "$unique_paths" ]]
[[ "$(jq -r '.cafexPatchStack.patchDeltaLines.added' "$COMPARISON")" == "$added_lines" ]]
[[ "$(jq -r '.cafexPatchStack.patchDeltaLines.deleted' "$COMPARISON")" == "$deleted_lines" ]]
[[ "$(jq -r '.cafexPatchStack.patchDeltaLines.total' "$COMPARISON")" == "$total_delta" ]]

core_paths=$(awk '/^diff --git / {print $4}' "$CAFEX_PATCH" | sed 's#^w/tools/cafetera/modules/codex/runtime/compose/codex-rs/##' | sort -u | awk '/^core\// {count++} END{print count + 0}')
tui_paths=$(awk '/^diff --git / {print $4}' "$CAFEX_PATCH" | sed 's#^w/tools/cafetera/modules/codex/runtime/compose/codex-rs/##' | sort -u | awk '/^tui\// {count++} END{print count + 0}')
cli_paths=$(awk '/^diff --git / {print $4}' "$CAFEX_PATCH" | sed 's#^w/tools/cafetera/modules/codex/runtime/compose/codex-rs/##' | sort -u | awk '/^cli\// {count++} END{print count + 0}')
other_paths=$((unique_paths - core_paths - tui_paths - cli_paths))

[[ "$(jq -r '.cafexPatchStack.pathAreas[] | select(.area == "core").uniqueTouchedPaths' "$COMPARISON")" == "$core_paths" ]]
[[ "$(jq -r '.cafexPatchStack.pathAreas[] | select(.area == "tui").uniqueTouchedPaths' "$COMPARISON")" == "$tui_paths" ]]
[[ "$(jq -r '.cafexPatchStack.pathAreas[] | select(.area == "cli").uniqueTouchedPaths' "$COMPARISON")" == "$cli_paths" ]]
[[ "$(jq -r '.cafexPatchStack.pathAreas[] | select(.area == "other").uniqueTouchedPaths' "$COMPARISON")" == "$other_paths" ]]

haxe_surface_files=$(find \
  "$ROOT/src/codexhx/adapters/cafex" \
  "$ROOT/src/codexhx/tools" \
  "$ROOT/src/codexhx/state/goals" \
  "$ROOT/src/codexhx/protocol/goals" \
  -type f -name '*.hx' | wc -l | tr -d ' ')
cafex_fixture_files=$(find "$ROOT/fixtures/cafex" -type f | wc -l | tr -d ' ')
gate_scripts=$(find "$ROOT/harness" -maxdepth 1 -type f -name 'check-*.sh' | wc -l | tr -d ' ')

[[ "$(jq -r '.hxrustBurden.haxeSourceFilesInComparedSurface' "$COMPARISON")" == "$haxe_surface_files" ]]
[[ "$(jq -r '.hxrustBurden.cafexFixtureFiles' "$COMPARISON")" == "$cafex_fixture_files" ]]
[[ "$(jq -r '.hxrustBurden.experimentGateScripts' "$COMPARISON")" == "$gate_scripts" ]]

jq -e '
  .hxrustBurden.generatedRustCommitted == false
  and (.comparison.decisionInputs | length) >= 3
  and (.comparison.netResult | test("not yet a broad Cafex replacement"))
' "$COMPARISON" >/dev/null

echo "Cafex hxrust friction comparison passed."
