# haxe.rust Production Readiness

**Date:** 2026-06-11
**Bead:** `HXCX-7.3` / `codex-hxrust-rat.3`
**Decision feed:** `HXCX-6.3`

## Purpose

This report scores haxe.rust against the Codex-shaped pressure test and gives a go/no-go recommendation for the replacement review.

Machine-readable fixture:

`reference/haxe-rust-production-readiness.v1.json`

Validation gate:

```bash
harness/check-haxe-rust-production-readiness.sh
```

## Recommendation

Conditional go for helper-only, sidecar/headless, and selected fixture-backed adapter slices.

No-go for broad Codex/Cafex replacement today.

haxe.rust has handled the current pressure test better than a toy compiler would: 14 of 19 pressure gaps were resolved upstream, app/test Haxe source has zero raw Rust escape matches, and the helper/headless/runtime/TUI/persistence-boundary/native-SQLite/read-view/thread-read projection/pagination/active-turn-merge/turn-items unsupported-runtime/token-usage owner/token-usage replay/goal-continuation admission/goal-runtime restore/active-turn and budget-limit goal steering/active-goal and idle-goal progress accounting/turn-start accounting/turn finalization/turn-error active-goal stop/goal token-usage contribution/tool-finish goal-progress admission/goal-tool contributor visibility/get_goal/create_goal/update_goal executors/goal-tool dispatch/provider admission/model catalog/Cafex fixture slices compile through generated Cargo gates. But broad replacement still has hard caveats:

- selected-slice compiler pressure is clean, but broader haxe.rust parity beyond these fixtures is not established;
- `haxe.rust-362` remains open for nullable `Array<Class>.shift()` return lowering;
- `haxe.rust-ojj` remains open for non-copy class field assign-op lowering;
- `haxe.rust-fzl` remains open for non-copy local reuse across conditional expression results;
- `haxe.rust-3f0g` remains open for static final class field access path lowering;
- `haxe.rust-fz20` remains open for Reflect.compare lowering;
- Cafex has four unsupported seam-ledger rows;
- license/distribution review is unresolved for haxe.rust GPL-3.0 with Codex/Cafex Apache-2.0 artifacts;
- no production default has changed, and rollback drills remain decision-review work.

## Scorecard

| Dimension | Score | Readiness read |
| --- | --- | --- |
| Language | `yellow_green` | DTOs, enums, null scalar patterns, nullable interface values, try/catch returns, reusable enum values, enum class-payload equality, runtime app-client/bootstrap/transport, selected native SQLite metal pressure, thread/read turn projection, pagination, active-turn merge, turn-items unsupported-runtime boundary, token-usage replay payload construction, token-usage replay delivery policy, resume-goal snapshot ordering, resume idle continuation, goal steering, try_start_turn_if_idle admission, goal runtime restore, active-turn goal steering injection, budget-limit goal steering, active-goal progress accounting, idle-goal progress accounting, turn-start accounting, turn finalization, turn-error active-goal stop, goal token-usage contribution, tool-finish goal-progress admission, goal-tool contributor visibility, get_goal/create_goal/update_goal executors, goal-tool dispatch, provider admission, model catalog, TUI story/render, and turn reducers are viable; nullable `Array.shift()` class-return, non-copy field assign-op, non-copy local reuse, static final path, and Reflect.compare lowering remain open. |
| Runtime | `yellow` | Credential-free headless runtime, runtime app-client/bootstrap/transport, persistence-boundary, native SQLite metadata upsert/query/read-view proof, selected thread/read turn projection, pagination, active-turn merge, turn-items unsupported-runtime boundary, token-usage owner attribution, token-usage replay payload construction, token-usage replay delivery policy, resume-goal snapshot ordering, resume idle continuation, goal steering, try_start_turn_if_idle admission, goal runtime restore, active-turn goal steering injection, budget-limit goal steering, active-goal progress accounting, idle-goal progress accounting, turn-start accounting, turn finalization, turn-error active-goal stop, goal token-usage contribution, tool-finish goal-progress admission, goal-tool contributor visibility, get_goal/create_goal/update_goal executors, goal-tool dispatch, provider admission, model catalog, selected TUI story/render, and turn reducer slices are viable; live model, full production SQLite/log state, full TUI, restart, and plan-checkpoint ownership are not covered. |
| Interop | `yellow_green` | Typed Haxe boundaries are holding; current app/test source has zero raw Rust escape matches. |
| Security | `yellow` | Process, sandbox, diagnostics, and mutation controls fail closed in fixtures; real platform enforcement and production drills remain. |
| Performance | `yellow` | Locked generated Cargo gates are repeatable, and HXCX-7.5 defines the portable/metal convergence benchmark plan; codexhx still has no production runtime benchmark suite. |
| Maintenance | `yellow_green` | Fixes have been upstreamable and checked; broad replacement remains too expensive with current unsupported seams. |
| Licensing/distribution | `red_for_release` | Local experiment is acceptable, but binary/bundled release needs license review. |

## Evidence

| Input | Current value |
| --- | --- |
| haxe.rust pressure gaps | 19 total, 14 resolved upstream, 5 open upstream, 0 local workarounds |
| Generic upstream repros for remaining gaps | 0 expected-failure fixtures in `../haxe.rust` |
| Raw Rust escape pressure | 0 matches across 368 Haxe source/test files |
| Cafetera contract subset | 8 covered, 8 passed, 0 failed, 5 gaps |
| Cafex seam ledger | 15 rows, 10 supported, 4 unsupported, 1 review-only |
| Production replacement claim | false |
| Production default | disabled |
| haxe.rust license | GPL-3.0 |
| upstream Codex/Cafex license | Apache-2.0 |

## Caveats

- The current compiler proof is strongest for selected portable DTO/helper/headless/adapter code, not broad upstream parity.
- The current proof is strongest for portable DTO/helper/headless code, not live native/metal runtime ownership.
- `haxe.rust-362`, `haxe.rust-ojj`, `haxe.rust-fzl`, `haxe.rust-3f0g`, and `haxe.rust-fz20` need product-neutral compiler regressions before broad replacement evidence can be called clean.
- Generated Rust quality is build-checked, but fmt/clippy and performance are not hard gates yet.
- Distribution remains blocked until license obligations are reviewed.

## Replacement Review Input

Feed `HXCX-6.3` with:

1. Select helper-only, sidecar/headless, or selected adapter-slice mode.
2. Do not select broad replacement from current evidence.
3. Keep unsupported surfaces explicit and fail-closed.
4. Treat `haxe.rust-362`, `haxe.rust-ojj`, `haxe.rust-fzl`, `haxe.rust-3f0g`, and `haxe.rust-fz20` as open compiler risks until fixed upstream.
5. Treat license/distribution as a release blocker, not a local-experiment blocker.
