#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
REPORT="${REPO_ROOT}/reference/haxe-rust-production-readiness.v1.json"
PRESSURE="${REPO_ROOT}/reference/haxe-rust-pressure-gaps.v1.json"
CONTRACT="${ROOT}/fixtures/cafex/cafetera-contract-subset-report.v1.json"
SEAMS="${ROOT}/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json"
RUNBOOK="${REPO_ROOT}/reference/operator-runbook.v1.json"
HXRUST_PIN="${REPO_ROOT}/reference/haxe-rust.pin.json"
UPSTREAM_PIN="${REPO_ROOT}/reference/upstream-codex.pin.json"
CAFEX_PIN="${REPO_ROOT}/reference/cafex-codex.pin.json"
UPSTREAM_REPROS="${REPO_ROOT}/reference/haxe-rust-upstream-repros.v1.json"

jq -e '
  .schema == "codex-hxrust.haxe-rust-production-readiness.v1"
  and .bead == "HXCX-7.3"
  and .decisionRecordFeed == "HXCX-6.3"
  and .recommendation.mode == "conditional_go_for_helper_sidecar_and_selected_adapter_slices"
  and .recommendation.broadReplacement == "no_go"
' "$REPORT" >/dev/null

jq -e '
  ([.scorecard[].dimension] | sort) == [
    "interop",
    "language",
    "licensing_distribution",
    "maintenance",
    "performance",
    "runtime",
    "security"
  ]
  and ([.scorecard[] | select((.strengths | length) == 0 or (.caveats | length) == 0 or (.evidenceRefs | length) == 0)] | length == 0)
' "$REPORT" >/dev/null

jq -e --slurpfile p "$PRESSURE" '
  .measuredInputs.pressureGaps.total == $p[0].summary.totalGaps
  and .measuredInputs.pressureGaps.resolvedUpstream == $p[0].summary.resolvedUpstream
  and .measuredInputs.pressureGaps.openUpstream == $p[0].summary.openUpstream
  and .measuredInputs.pressureGaps.localWorkaround == $p[0].summary.localWorkaround
  and .measuredInputs.pressureGaps.rawRustEscapeMatches == $p[0].rawRustPressure.rawEscapeMatches
  and .measuredInputs.pressureGaps.sourceFilesScanned == $p[0].rawRustPressure.sourceFilesScanned
  and .measuredInputs.pressureGaps.upstreamRepros == $p[0].summary.upstreamRepros
' "$REPORT" >/dev/null

jq -e --slurpfile u "$UPSTREAM_REPROS" '
  .evidence.upstreamRepros == "reference/haxe-rust-upstream-repros.v1.json"
  and .measuredInputs.pressureGaps.upstreamRepros == $u[0].summary.totalRepros
  and $u[0].summary.codexSpecificContextRemoved == true
' "$REPORT" >/dev/null

jq -e --slurpfile c "$CONTRACT" '
  .measuredInputs.cafeteraContractSubset.covered == $c[0].summary.covered
  and .measuredInputs.cafeteraContractSubset.passed == $c[0].summary.passed
  and .measuredInputs.cafeteraContractSubset.failed == $c[0].summary.failed
  and .measuredInputs.cafeteraContractSubset.gaps == $c[0].summary.gaps
  and .measuredInputs.cafeteraContractSubset.productionReplacement == $c[0].productionReplacement
' "$REPORT" >/dev/null

jq -e --slurpfile s "$SEAMS" '
  .measuredInputs.cafexSeamLedger.rows == $s[0].summary.rows
  and .measuredInputs.cafexSeamLedger.supported == $s[0].summary.supported
  and .measuredInputs.cafexSeamLedger.unsupported == $s[0].summary.unsupported
  and .measuredInputs.cafexSeamLedger.reviewOnly == $s[0].summary.reviewOnly
  and .measuredInputs.cafexSeamLedger.productionReplacement == $s[0].policy.productionReplacement
' "$REPORT" >/dev/null

jq -e --slurpfile r "$RUNBOOK" '
  .measuredInputs.operatorRunbook.productionDefaultChanged == $r[0].productionDefaultChanged
  and .measuredInputs.operatorRunbook.currentProductionDefault == $r[0].currentProductionDefault
' "$REPORT" >/dev/null

jq -e --slurpfile h "$HXRUST_PIN" --slurpfile u "$UPSTREAM_PIN" --slurpfile c "$CAFEX_PIN" '
  .measuredInputs.licenses.haxeRust == $h[0].license
  and .measuredInputs.licenses.upstreamCodex == $u[0].license
  and .measuredInputs.licenses.cafexCodex == $c[0].license
' "$REPORT" >/dev/null

jq -e '
  (.feedsReplacementReview | length) >= 4
  and (.recommendation.requiredBeforeBroadReplacement | length) >= 5
  and (.scorecard[] | select(.dimension == "licensing_distribution").score == "red_for_release")
' "$REPORT" >/dev/null

echo "haxe.rust production readiness report passed."
