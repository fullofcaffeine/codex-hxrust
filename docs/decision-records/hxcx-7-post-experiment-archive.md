# HXCX-7 Post-Experiment Archive

**Date:** 2026-06-11
**Bead:** `HXCX-7.4` / `codex-hxrust-rat.4`
**Owner:** Marcelo Serpa
**Source decision:** `docs/decision-records/g6-replacement-go-no-go.md`

## Decision

Archive this phase as a bounded success.

codexhx is useful as a haxe.rust production pressure-test consumer and may continue toward named fixture-backed adapter slices. Broad Codex/Cafex replacement is not supported by current evidence, and production routing remains disabled.

Machine-readable archive:

`reference/post-experiment-archive.v1.json`

Validation gate:

```bash
cd experiments/codex-hxrust
harness/check-post-experiment-archive.sh
```

## Reusable Artifacts

| Artifact group | Keep | Reuse |
| --- | --- | --- |
| Protocol/JSON/runtime harnesses | protocol IDs, JSON boundary, app protocol, mock stream, headless JSONL | Upstream-shaped helper/headless parity gates. |
| Native tool/security harnesses | apply-patch dry-run, process exec, sandbox gate, diagnostics | Fail-closed host-effect and diagnostic proof. |
| Cafex adapter harnesses | receipts, bridge, active-lane, continuity, goals, contract subset | Selected adapter-slice evidence only. |
| Decision ledgers | migration modes, operator runbook, G6 decision, readiness, pressure gaps | Evidence bundle for future replacement review. |
| State backend decision | JSONL versus SQLite spike | JSONL is reusable for fixture evidence; SQLite remains required for persistent state replacement. |
| Tool registry skeleton | MCP/tool registry lookup fixtures | Registry metadata is reusable; real MCP transport remains deferred. |
| haxe.rust pressure findings | direct workflow, pressure gap ledger, beads import | Generic compiler issue/fixture conversion map. |

## Abandoned Or Deferred Paths

| Path | Status | Reason |
| --- | --- | --- |
| Broad replacement now | abandoned for current phase | G6 rejected it due to unsupported seams, contract gaps, and unresolved distribution/licensing. |
| Production default change | deferred | Production routing remains disabled until a later decision record and rollback drill. |
| Live TUI/model/restart runtime | deferred | Live TUI, credentialed model, queue, plan checkpoint, and restart ownership are unsupported seam rows. |
| Bundled or binary distribution | deferred | haxe.rust GPL-3.0 with Codex/Cafex Apache-2.0 artifacts requires license review. |
| Codex-specific compiler hacks | abandoned | haxe.rust fixes must remain generic and upstreamable. |

## Follow-Up Beads

- `codex-hxrust-rat.2`: create upstreamable haxe.rust fixtures/issues for nullable interface values, `haxe.io.Path.directory`, and `String.lastIndexOf`; all three later resolved upstream in haxe.rust.

## Brew Conversion Notes

- Selected adapter-slice review: convert Cafex adapter harness outputs into Brew/Cafetera acceptance evidence only per named slice.
- haxe.rust upstream issues: the generic expected-failure backlog is now empty; add new repros here only for future compiler gaps.
- Operator rollout: any Cafetera workflow wiring must consume operator-runbook disable/rollback rules and cannot change defaults without a new decision record.
- State backend: keep JSONL for fixture evidence; add a SQLite/sqlx or equivalent persistence spike before any persistent state replacement claim.
- Tool registry: keep lookup fixtures; add real MCP transport/resource/OAuth/execution gates before any MCP parity claim.
- Archive bundle: preserve docs, reference ledgers, fixtures, and harnesses; do not preserve generated Rust as source.

## Final Notes

The reusable core of this experiment is the evidence system: focused fixtures, haxe.rust pin discipline, fail-closed host-effect harnesses, and explicit unsupported-surface ledgers. That is worth keeping even if broad replacement never proceeds.
