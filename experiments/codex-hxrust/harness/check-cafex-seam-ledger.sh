#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LEDGER="${ROOT}/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json"

jq -e '
  .schema == "codex-hxrust.cafex-hxrust-seam-ledger.v1"
  and .policy.productionReplacement == false
  and .summary.rows == (.rows | length)
  and .summary.supported == ([.rows[] | select(.supportLevel == "supported")] | length)
  and .summary.unsupported == ([.rows[] | select(.supportLevel == "unsupported")] | length)
  and .summary.reviewOnly == ([.rows[] | select(.supportLevel == "review_only")] | length)
' "$LEDGER" >/dev/null

jq -e '
  [.rows[] | select((.patchClass == "upstreamable_seam" or .patchClass == "fork_only_caf_adapter" or .patchClass == "temporary_sync_shim") | not)] | length == 0
' "$LEDGER" >/dev/null

jq -e '
  [.rows[] | select(.id == null or .title == null or .sourceSeam == null or .owner == null or .replacementStatus == null or .replacementReviewNote == null)] | length == 0
' "$LEDGER" >/dev/null

jq -e '
  [.rows[] | select(.supportLevel == "supported") | select((.hxrustImplementation | length) == 0 or (.fixtures | length) == 0 or (.harnesses | length) == 0)] | length == 0
' "$LEDGER" >/dev/null

jq -e '
  [.rows[] | select(.supportLevel == "unsupported") | select((.unsupportedReason // "") == "")] | length == 0
' "$LEDGER" >/dev/null

jq -e '
  ([.rows[].sourceSeam] | unique | sort) == [
    "caf-runtime-active-lane-capabilities",
    "effort-mode-runtime-bridge",
    "fork-lineage-upstream-sync",
    "goal-apply-runtime-bridge",
    "plan-checkpoint-continuation-guard",
    "queue-reconcile-runtime-bridge",
    "restart-wake-session-continuity"
  ]
' "$LEDGER" >/dev/null

echo "Cafex hxrust seam ledger passed."
