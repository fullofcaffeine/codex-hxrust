# Cafex Hxrust Seam Ledger

**Date:** 2026-06-10
**Bead:** `HXCX-5.6` / `codex-hxrust-6h4.6`
**Source:** Cafetera `cafex-fork-seam-ledger-v1`

## Purpose

This ledger maps Cafex fork seams to the current hxrust adapter state. It is for replacement review, not a production replacement claim.

Machine-readable fixture:

`experiments/codex-hxrust/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json`

Validation gate:

```bash
cd experiments/codex-hxrust
harness/check-cafex-seam-ledger.sh
```

## Support Levels

| Level | Meaning |
| --- | --- |
| `supported` | There is hxrust implementation plus fixture and harness evidence. |
| `unsupported` | The seam is known, but hxrust does not implement it yet; `unsupportedReason` is required. |
| `review_only` | The row supports governance/replacement review but is not runtime behavior. |

Every row has a fork-strategy patch class: `upstreamable_seam`, `fork_only_caf_adapter`, or `temporary_sync_shim`.

## Supported Rows

| Delta | Patch class | Implementation | Evidence | Replacement status |
| --- | --- | --- | --- | --- |
| Caf session receipt | `fork_only_caf_adapter` | `CafReceiptWriter` | `check-caf-receipts.sh`, `check-caf-continuity.sh` | `supported_fixture` |
| Caf turn receipt | `fork_only_caf_adapter` | `CafReceiptWriter` | `check-caf-receipts.sh`, `check-caf-continuity.sh` | `supported_fixture` |
| Continuity metadata | `fork_only_caf_adapter` | `CafContinuityEnv` | `check-caf-continuity.sh` | `supported_fixture` |
| Effort apply bridge | `fork_only_caf_adapter` | `CafBridgeProcessor` | `check-caf-bridge.sh` | `supported_fixture` |
| Mode apply next-turn bridge rails | `fork_only_caf_adapter` | `CafBridgeProcessor` | `check-caf-bridge.sh`, `check-cafetera-contract-subset.sh` | `supported_fixture_rails_only` |
| Wake request/receipt | `fork_only_caf_adapter` | `CafBridgeProcessor` | `check-caf-bridge.sh` | `supported_fixture` |
| Minimal thread goal lifecycle | `fork_only_caf_adapter` | `ThreadGoal`, `ThreadGoalStore`, `GoalToolHandler` | `check-goals.sh` | `supported_fixture` |
| Caf goal-apply request bridge | `fork_only_caf_adapter` | `CafBridgeProcessor`, `ThreadGoalStore` | `check-caf-bridge.sh`, `check-cafetera-contract-subset.sh` | `supported_fixture` |
| Queue reconcile request/receipt rails | `fork_only_caf_adapter` | `CafBridgeProcessor` | `check-caf-bridge.sh`, `check-cafetera-contract-subset.sh` | `supported_fixture_rails_only` |
| Active-lane capability advertisement | `fork_only_caf_adapter` | `CafActiveLaneWriter`, `CafActiveLaneEnv`, `CafNativeLiveStatus` | `check-caf-active-lane.sh`, `check-cafetera-contract-subset.sh` | `supported_fixture` |

## Unsupported Rows

| Delta | Patch class | Reason |
| --- | --- | --- |
| Live mode apply runtime | `fork_only_caf_adapter` | Mode bridge rails emit next-turn receipts, but no live collaboration-mode transition is implemented. |
| Restart apply runtime bridge | `fork_only_caf_adapter` | Continuity metadata is covered, but restart request validation, receipts, inherited env, pid handoff, and exec are not. |
| Plan-checkpoint continuation guard | `fork_only_caf_adapter` | hxrust does not own visible-plan capture, pending input queues, or pre-model continuation eligibility hooks. |
| Live TUI and credentialed model runtime | `fork_only_caf_adapter` | Current gates are credential-free fixture/generated-Cargo proofs only. |

## Review-Only Row

| Delta | Patch class | Use |
| --- | --- | --- |
| Fork lineage and upstream sync replay governance | `upstreamable_seam` | Carries replacement-review governance evidence and update workflow refs; it is not runtime behavior. |

## Replacement Boundary

The ledger preserves the HXCX-5.5 boundary:

- `productionReplacement` remains `false`.
- Supported rows mean fixture-backed hxrust compatibility only.
- Unsupported rows are explicit so replacement review cannot silently omit a Cafex seam.
- Minimal goal lifecycle support remains separate from the Caf/Ralph `goal-apply-request` bridge: HXCX-5.3 proves core goal DTO/tool flow, while HXCX-8.1 proves request/receipt adapter behavior. Live app-server/TUI persistence is still outside both rows.
- Active-lane support covers deterministic capability DTO writing and fail-closed PID proof only; live process/TUI ownership remains a later runtime boundary.
- Queue reconcile support covers deterministic request/receipt rails only; live pending-input queue mutation and plan-checkpoint continuation eligibility remain in the unsupported plan-checkpoint/TUI boundary.
- Mode apply support covers deterministic plan/default next-turn receipts and invalid-mode refusal only; current-turn/native TUI mode mutation remains in the unsupported live runtime boundary.
