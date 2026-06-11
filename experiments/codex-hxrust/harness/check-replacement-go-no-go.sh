#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
DECISION="${REPO_ROOT}/reference/replacement-go-no-go.v1.json"
READINESS="${REPO_ROOT}/reference/haxe-rust-production-readiness.v1.json"
FRICTION="${ROOT}/fixtures/cafex/cafex-hxrust-friction-comparison.v1.json"
SEAMS="${ROOT}/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json"
CONTRACT="${ROOT}/fixtures/cafex/cafetera-contract-subset-report.v1.json"
RUNBOOK="${REPO_ROOT}/reference/operator-runbook.v1.json"

jq -e '
  .schema == "codex-hxrust.replacement-go-no-go.v1"
  and .bead == "HXCX-6.3"
  and .gate == "G6"
  and .milestone == "M6"
  and .decision.selectedMode == "selected_adapter_slice"
  and (.decision.rejectedModes | index("broader_replacement_candidate") != null)
  and .decision.productionDefaultChanged == false
  and .decision.currentProductionDefault == "disabled"
' "$DECISION" >/dev/null

jq -e --slurpfile r "$READINESS" '
  .measuredInputs.pressureGaps.total == $r[0].measuredInputs.pressureGaps.total
  and .measuredInputs.pressureGaps.resolvedUpstream == $r[0].measuredInputs.pressureGaps.resolvedUpstream
  and .measuredInputs.pressureGaps.openUpstream == $r[0].measuredInputs.pressureGaps.openUpstream
  and .measuredInputs.pressureGaps.localWorkaround == $r[0].measuredInputs.pressureGaps.localWorkaround
  and .measuredInputs.pressureGaps.rawRustEscapeMatches == $r[0].measuredInputs.pressureGaps.rawRustEscapeMatches
  and $r[0].recommendation.broadReplacement == "no_go"
' "$DECISION" >/dev/null

jq -e --slurpfile s "$SEAMS" '
  .measuredInputs.cafexSeamLedger.rows == $s[0].summary.rows
  and .measuredInputs.cafexSeamLedger.supported == $s[0].summary.supported
  and .measuredInputs.cafexSeamLedger.unsupported == $s[0].summary.unsupported
  and .measuredInputs.cafexSeamLedger.reviewOnly == $s[0].summary.reviewOnly
' "$DECISION" >/dev/null

jq -e --slurpfile c "$CONTRACT" '
  .measuredInputs.cafeteraContractSubset.covered == $c[0].summary.covered
  and .measuredInputs.cafeteraContractSubset.passed == $c[0].summary.passed
  and .measuredInputs.cafeteraContractSubset.failed == $c[0].summary.failed
  and .measuredInputs.cafeteraContractSubset.gaps == $c[0].summary.gaps
  and .measuredInputs.cafeteraContractSubset.productionReplacement == $c[0].productionReplacement
' "$DECISION" >/dev/null

jq -e --slurpfile o "$RUNBOOK" '
  .decision.productionDefaultChanged == $o[0].productionDefaultChanged
  and .decision.currentProductionDefault == $o[0].currentProductionDefault
  and $o[0].decisionRecordRequiredBeforeDefaultChange == true
' "$DECISION" >/dev/null

jq -e --slurpfile f "$FRICTION" '
  $f[0].summary.productionReplacement == false
  and ($f[0].comparison.netResult | test("not yet a broad Cafex replacement"))
' "$DECISION" >/dev/null

jq -e '
  (.unsupportedSurfaces | length) >= 10
  and (.securityLicensingNotes | length) >= 4
  and (.goCriteriaForSelectedSlice | length) >= 5
  and (.noGoCriteriaForBroadReplacement | length) >= 5
  and (.rollbackDowngradePath | length) >= 5
  and (.followUpBeads | index("codex-hxrust-rat.4") != null)
' "$DECISION" >/dev/null

echo "Replacement go/no-go decision passed."
