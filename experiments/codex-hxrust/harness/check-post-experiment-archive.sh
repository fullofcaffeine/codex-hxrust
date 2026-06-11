#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
ARCHIVE="${REPO_ROOT}/reference/post-experiment-archive.v1.json"
G6="${REPO_ROOT}/reference/replacement-go-no-go.v1.json"
READINESS="${REPO_ROOT}/reference/haxe-rust-production-readiness.v1.json"
STATE_BACKEND="${REPO_ROOT}/reference/state-backend-spike.v1.json"
TOOL_REGISTRY="${REPO_ROOT}/reference/tool-registry-skeleton.v1.json"
UPSTREAM_REPROS="${REPO_ROOT}/reference/haxe-rust-upstream-repros.v1.json"

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
  and (.followUpBeads | length) == 0
  and (.resolvedFollowUpBeads | length) >= 4
  and (.brewConversionNotes | length) >= 4
  and (.finalChecks | index("experiments/codex-hxrust/harness/check-replacement-go-no-go.sh") != null)
  and (.finalChecks | index("experiments/codex-hxrust/harness/check-state-backend-spike.sh") != null)
  and (.finalChecks | index("experiments/codex-hxrust/harness/check-tool-registry.sh") != null)
  and (.finalChecks | index("experiments/codex-hxrust/harness/check-haxe-rust-upstream-repros.sh") != null)
' "$ARCHIVE" >/dev/null

jq -e --slurpfile s "$STATE_BACKEND" '
  (.reusableArtifacts[] | select(.id == "state_backend_decision").paths | index("reference/state-backend-spike.v1.json") != null)
  and ((.followUpBeads | any(.id == "codex-hxrust-hpu.4")) | not)
  and (.resolvedFollowUpBeads | any(.id == "codex-hxrust-hpu.4"))
  and (.brewConversionNotes[] | select(.target == "state_backend").note | test("SQLite"))
  and $s[0].decision.productionStateMigrationImplied == false
' "$ARCHIVE" >/dev/null

jq -e --slurpfile t "$TOOL_REGISTRY" '
  (.reusableArtifacts[] | select(.id == "tool_registry_skeleton").paths | index("reference/tool-registry-skeleton.v1.json") != null)
  and ((.followUpBeads | any(.id == "codex-hxrust-hpu.5")) | not)
  and (.resolvedFollowUpBeads | any(.id == "codex-hxrust-hpu.5"))
  and (.brewConversionNotes[] | select(.target == "tool_registry").note | test("MCP"))
  and $t[0].decision.realMcpTransportImplemented == false
' "$ARCHIVE" >/dev/null

jq -e --slurpfile u "$UPSTREAM_REPROS" '
  (.reusableArtifacts[] | select(.id == "haxe_rust_pressure_fixes").paths | index("reference/haxe-rust-upstream-repros.v1.json") != null)
  and (.resolvedFollowUpBeads | any(.id == "codex-hxrust-rat.2"))
  and (.brewConversionNotes[] | select(.target == "haxe_rust_upstream_issues").note | test("expected-failure fixtures"))
  and $u[0].summary.totalRepros == 3
' "$ARCHIVE" >/dev/null

jq -e '
  (.abandonedOrDeferredPaths[] | select(.id == "broad_replacement_now").status == "abandoned_for_current_phase")
  and (.abandonedOrDeferredPaths[] | select(.id == "codex_specific_compiler_hacks").status == "abandoned")
  and ((.followUpBeads | any(.id == "codex-hxrust-rat.2")) | not)
  and (.brewConversionNotes[] | select(.target == "haxe_rust_upstream_issues"))
' "$ARCHIVE" >/dev/null

echo "Post-experiment archive passed."
