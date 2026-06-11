#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
MODES="${REPO_ROOT}/reference/migration-modes.v1.json"

jq -e '
  .schema == "codex-hxrust.migration-modes.v1"
  and .bead == "HXCX-6.2"
  and .decisionRecordFeed == "HXCX-6.3"
  and .principles.completionIsModeSpecific == true
  and .principles.upstreamTestsNecessaryForBroadReplacement == true
  and .principles.upstreamTestsSufficientForBroadReplacement == false
  and .principles.noModeBypassesContracts == true
' "$MODES" >/dev/null

jq -e '
  ([.modes[].id] | sort) == [
    "broad_replacement",
    "helper_only",
    "selected_adapter_slice",
    "sidecar_headless"
  ]
' "$MODES" >/dev/null

jq -e '
  [.modes[] | select(
    (.entryCriteria | length) == 0
    or (.exitCriteria | length) == 0
    or (.completionGate | length) == 0
    or (.rollbackPath | length) == 0
    or (.operatorImpact | length) == 0
    or (.developerImpact | length) == 0
    or (.contractRequirements | length) == 0
    or .contractBypassAllowed != false
  )] | length == 0
' "$MODES" >/dev/null

jq -e '
  (.modes[] | select(.id == "helper_only").claim | test("does not run Codex turns"))
  and (.modes[] | select(.id == "sidecar_headless").entryCriteria[] | select(test("G2.*G3")))
  and (.modes[] | select(.id == "selected_adapter_slice").entryCriteria[] | select(test("G5 Cafex contract subset")))
  and (.modes[] | select(.id == "broad_replacement").completionGate[] | select(test("necessary but not sufficient")))
' "$MODES" >/dev/null

jq -e '
  [.modes[].rollbackPath[]] | any(test("upstream Codex|upstream Codex/Cafex|Cafex fork|last known-good"))
' "$MODES" >/dev/null

echo "Migration modes rollout policy passed."
