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
cd experiments/codex-hxrust
harness/check-haxe-rust-production-readiness.sh
```

## Recommendation

Conditional go for helper-only, sidecar/headless, and selected fixture-backed adapter slices.

No-go for broad Codex/Cafex replacement today.

haxe.rust has handled the current pressure test better than a toy compiler would: all ten pressure gaps were resolved upstream, app/test Haxe source has zero raw Rust escape matches, and the helper/headless/Cafex fixture slices compile through generated Cargo gates. But broad replacement still has hard caveats:

- selected-slice compiler pressure is clean, but broader haxe.rust parity beyond these fixtures is not established;
- Cafex has seven unsupported seam-ledger rows;
- license/distribution review is unresolved for haxe.rust GPL-3.0 with Codex/Cafex Apache-2.0 artifacts;
- no production default has changed, and rollback drills remain decision-review work.

## Scorecard

| Dimension | Score | Readiness read |
| --- | --- | --- |
| Language | `yellow_green` | DTOs, enums, null scalar patterns, nullable interface values, try/catch returns, and reusable enum values are viable after generic upstream fixes. |
| Runtime | `yellow` | Credential-free headless runtime slices are viable; live model, TUI, restart, queue, and plan-checkpoint ownership are not covered. |
| Interop | `yellow_green` | Typed Haxe boundaries are holding; current app/test source has zero raw Rust escape matches. |
| Security | `yellow` | Process, sandbox, diagnostics, and mutation controls fail closed in fixtures; real platform enforcement and production drills remain. |
| Performance | `yellow` | Locked generated Cargo gates are repeatable; no benchmark suite supports performance claims yet. |
| Maintenance | `yellow_green` | Fixes have been upstreamable and checked; broad replacement remains too expensive with current unsupported seams. |
| Licensing/distribution | `red_for_release` | Local experiment is acceptable, but binary/bundled release needs license review. |

## Evidence

| Input | Current value |
| --- | --- |
| haxe.rust pressure gaps | 10 total, 10 resolved upstream, 0 open upstream, 0 local workarounds |
| Generic upstream repros for remaining gaps | 0 expected-failure fixtures in `../haxe.rust` |
| Raw Rust escape pressure | 0 matches across 92 Haxe source/test files |
| Cafetera contract subset | 4 covered, 4 passed, 0 failed, 5 gaps |
| Cafex seam ledger | 15 rows, 7 supported, 7 unsupported, 1 review-only |
| Production replacement claim | false |
| Production default | disabled |
| haxe.rust license | GPL-3.0 |
| upstream Codex/Cafex license | Apache-2.0 |

## Caveats

- The current compiler proof is strongest for selected portable DTO/helper/headless/adapter code, not broad upstream parity.
- The current proof is strongest for portable DTO/helper/headless code, not live native/metal runtime ownership.
- Generated Rust quality is build-checked, but fmt/clippy and performance are not hard gates yet.
- Distribution remains blocked until license obligations are reviewed.

## Replacement Review Input

Feed `HXCX-6.3` with:

1. Select helper-only, sidecar/headless, or selected adapter-slice mode.
2. Do not select broad replacement from current evidence.
3. Keep unsupported surfaces explicit and fail-closed.
4. Treat license/distribution as a release blocker, not a local-experiment blocker.
