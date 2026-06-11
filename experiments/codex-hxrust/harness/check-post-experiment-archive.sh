#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
ARCHIVE="${REPO_ROOT}/reference/post-experiment-archive.v1.json"
G6="${REPO_ROOT}/reference/replacement-go-no-go.v1.json"
READINESS="${REPO_ROOT}/reference/haxe-rust-production-readiness.v1.json"

jq -e '
  .schema == "codex-hxrust.post-experiment-archive.v1"
  and .bead == "HXCX-7.4"
  and .sourceDecision == "reference/replacement-go-no-go.v1.json"
  and .outcome.selectedMode == "selected_adapter_slice"
  and .outcome.broadReplacement == "not_supported_by_current_evidence"
  and .outcome.productionDefaultChanged == false
  and .outcome.currentProductionDefault == "disabled"
' "$ARCHIVE" >/dev/null

jq -e --slurpfile g "$G6" '
  .outcome.selectedMode == $g[0].decision.selectedMode
  and .outcome.productionDefaultChanged == $g[0].decision.productionDefaultChanged
  and .outcome.currentProductionDefault == $g[0].decision.currentProductionDefault
  and $g[0].decision.rejectedModes[0] == "broader_replacement_candidate"
' "$ARCHIVE" >/dev/null

jq -e --slurpfile r "$READINESS" '
  $r[0].recommendation.broadReplacement == "no_go"
  and $r[0].measuredInputs.operatorRunbook.productionDefaultChanged == false
' "$ARCHIVE" >/dev/null

jq -e '
  (.reusableArtifacts | length) >= 5
  and (.abandonedOrDeferredPaths | length) >= 5
  and (.followUpBeads | length) >= 3
  and (.brewConversionNotes | length) >= 4
  and (.finalChecks | index("experiments/codex-hxrust/harness/check-replacement-go-no-go.sh") != null)
' "$ARCHIVE" >/dev/null

jq -e '
  (.abandonedOrDeferredPaths[] | select(.id == "broad_replacement_now").status == "abandoned_for_current_phase")
  and (.abandonedOrDeferredPaths[] | select(.id == "codex_specific_compiler_hacks").status == "abandoned")
  and (.followUpBeads[] | select(.id == "codex-hxrust-rat.2"))
  and (.brewConversionNotes[] | select(.target == "haxe_rust_upstream_issues"))
' "$ARCHIVE" >/dev/null

echo "Post-experiment archive passed."
