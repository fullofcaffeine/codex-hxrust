# G6 Replacement Go/No-Go

**Date:** 2026-06-11
**Gate:** G6
**Milestone:** M6
**Bead:** `HXCX-6.3` / `codex-hxrust-ryo.3`
**Owner:** Marcelo Serpa
**Decision:** Cafex adapter candidate

## Decision

Proceed only with helper/headless work and named, fixture-backed adapter-slice candidates.

Do not pursue broad Codex/Cafex replacement from current evidence.

Production routing remains disabled. No production default changes from this decision record.

Machine-readable fixture:

`reference/replacement-go-no-go.v1.json`

Validation gate:

```bash
cd experiments/codex-hxrust
harness/check-replacement-go-no-go.sh
```

## Evidence

| Artifact / command | Result | Notes |
| --- | --- | --- |
| `reference/haxe-rust-production-readiness.v1.json` | conditional go / broad no-go | haxe.rust is viable for helper, headless, and selected adapter slices; broad replacement is not ready. |
| `experiments/codex-hxrust/fixtures/cafex/cafex-hxrust-friction-comparison.v1.json` | selected slices only | hxrust reduces rebase friction only for supported fixture-backed rows. |
| `reference/migration-modes.v1.json` | selected adapter-slice allowed | Upstream tests are necessary but not sufficient for broad replacement. |
| `reference/operator-runbook.v1.json` | production default disabled | Rollback, disable, distribution, and diagnostics are documented. |
| `reference/state-backend-spike.v1.json` | JSONL accepted for current experiment; SQLite required for persistent state replacement | No production state migration is implied. |
| `reference/tool-registry-skeleton.v1.json` | registry lookup accepted; real MCP transport unsupported | Unsupported MCP operations fail closed. |
| `experiments/codex-hxrust/fixtures/cafex/cafex-hxrust-seam-ledger.v1.json` | 7 supported, 7 unsupported, 1 review-only | Unsupported surfaces are explicit. |
| `experiments/codex-hxrust/fixtures/cafex/cafetera-contract-subset-report.v1.json` | 4 covered/pass, 5 gaps | No production replacement claim. |

## Scorecard

| Area | Status | Evidence | Follow-up |
| --- | --- | --- | --- |
| build | green | generated Cargo gates and pin workflow exist | keep pin updates gated |
| protocol | green | protocol/JSON/schema fixtures are active | expand upstream parity as scope grows |
| runtime | yellow | credential-free headless runtime works | live model/TUI/restart stay unsupported |
| tools/state | yellow | process, sandbox, diagnostics, apply-patch gates fail closed; JSONL state and registry lookup are accepted for current fixtures | SQLite remains a gate for persistent state replacement; real MCP transport remains open |
| Cafex adapter | yellow | selected receipt/bridge/goal/continuity fixtures pass | 7 seam rows unsupported |
| security | yellow | fail-closed wrappers and diagnostics redaction exist | real OS sandbox and production drills remain |
| licensing | red-for-release | haxe.rust GPL-3.0, Codex/Cafex Apache-2.0 | review before bundling or binary distribution |

## Unsupported Surfaces

- Active-lane capability advertisement.
- Queue reconcile runtime bridge.
- Caf goal-apply request bridge.
- Live mode apply runtime.
- Restart apply runtime bridge.
- Plan-checkpoint continuation guard.
- Live TUI and credentialed model runtime.
- `haxe.io.Path.directory` lowering.
- `String.lastIndexOf` lowering.
- License/distribution for bundled or binary release.

## Security And Licensing Notes

- Process execution, sandbox permission, diagnostics redaction, and mutation paths remain fail-closed fixture-backed surfaces.
- Real OS sandbox enforcement and live host-effect ownership remain native/future boundaries.
- haxe.rust is GPL-3.0; upstream Codex and Cafex are Apache-2.0. Local experiment may continue, but release/bundling requires license review.
- No production default may change without a later decision record and rollback drill.

## Kill Criteria Reviewed

| Criterion | Status | Notes |
| --- | --- | --- |
| haxe.rust cannot build portable/metal scaffold | pass | Current generated Cargo gates pass. |
| Generated Rust is too non-deterministic for CI | pass | Generated output is disposable and gate-checked. |
| Upstream envelopes require pervasive raw Rust/Dynamic | pass | Current raw Rust escape pressure is 0 matches in app/test Haxe source. |
| Credential-free one-turn fixture cannot run | pass | Headless runtime fixtures exist. |
| Process/sandbox/mutation cannot fail closed | pass | M4 fail-closed gates exist. |
| Cafex behavior leaks into upstream core | pass | Cafex remains under adapter modules. |
| Licensing blocks intended distribution | accepted blocker | Blocks release/bundling, not local experiment. |
| Required haxe.rust changes cannot be upstreamed | yellow | Seven pressure gaps resolved upstream; three gaps need follow-up. |
| Unsupported surfaces cannot produce structured errors | yellow | Some live runtime surfaces are still unsupported rather than fully diagnosed. |
| Parity requires copying whole source trees | pass | External pins and focused fixtures are used. |

## Risks Accepted

- Selected adapter-slice work may still uncover generic haxe.rust compiler gaps.
- Helper/headless success does not imply live TUI/model/runtime ownership.
- JSONL state evidence does not imply persistent goal/runtime/app-server state parity; SQLite/sqlx or equivalent production persistence remains required for that claim.
- Tool registry lookup evidence does not imply real MCP transport, OAuth, resource, or execution parity.
- License/distribution review is deferred but blocks any release.
- Cafex fork remains required for unsupported live runtime seams.

## Follow-Up Beads

- `codex-hxrust-rat.2`: create upstreamable haxe.rust fixtures/issues for remaining gaps.
- `codex-hxrust-rat.4`: write post-experiment decision/archive record.

## Rollback / Downgrade Path

1. Keep production routing disabled.
2. Use helper-only mode if selected adapter-slice evidence regresses.
3. Route live Cafetera/Cafex workflows back to upstream Codex or the Cafex fork.
4. Revert any experimental integration commit and run `bd sync` plus `git push`.
5. Delete generated output directories; do not migrate production state.

## Final Notes

This is a bounded go. codexhx should continue as a useful haxe.rust pressure-test consumer and as a candidate for selected adapter slices. It should not be represented as a full Codex/Cafex replacement until unsupported seams, compiler gaps, operational drills, and license/distribution review are resolved or explicitly accepted.
