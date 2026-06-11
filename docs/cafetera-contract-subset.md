# Cafetera Contract Subset

**Date:** 2026-06-10  
**Bead:** `HXCX-5.5` / `codex-hxrust-6h4.5`  
**Scope:** Cafetera Codex module contract subset against hxrust-generated harnesses

## Contract Subset

This gate runs selected Cafex/Cafetera-facing contracts through the Haxe interpreter and through generated Rust from haxe.rust.

Covered contracts:

- `HXCX-5.1`: Caf session and turn receipt writer via `harness/check-caf-receipts.sh`.
- `HXCX-5.2`: Caf effort, wake, and invalid mode directory bridge via `harness/check-caf-bridge.sh`.
- `HXCX-5.3`: Minimal Caf goal DTO, in-memory state, and goal tools via `harness/check-goals.sh`.
- `HXCX-5.4`: Wake/restart successor and predecessor continuity metadata via `harness/check-caf-continuity.sh`.
- `HXCX-8.1`: Caf/Ralph goal-apply request and receipt bridge via `harness/check-caf-bridge.sh`.
- `HXCX-8.2`: Caf active-lane capability and native live-status DTO writer via `harness/check-caf-active-lane.sh`.
- `HXCX-8.3`: Caf queue-reconcile request and receipt bridge rails via `harness/check-caf-bridge.sh`.
- `HXCX-8.4`: Caf mode-apply request and next-turn receipt bridge rails via `harness/check-caf-bridge.sh`.

Each covered contract is classified as `fixture_pass` only. That means the selected fixture and adapter behavior passed under hxrust; it does not mean the generated binary can replace production Codex or Cafetera yet.

## Gap Classification

Unsupported failures are recorded in `fixtures/cafex/cafetera-contract-subset-report.v1.json` and regenerated under `generated/reports/cafetera-contract-subset.v1.json`.

Current gap classifications:

- `unsupported_full_cafetera_cli`: the full Cafetera Codex module runner is not yet targeting a production hxrust binary.
- `unsupported_live_tui_runtime`: receipt and bridge fixtures do not replace the native Codex TUI event loop.
- `unsupported_native_restart_cutover`: continuity metadata is covered, but process fork/exec handoff is not.
- `unsupported_mode_apply_runtime`: mode-apply bridge rails emit next-turn receipts for supported modes, but live TUI/runtime collaboration-mode mutation is not implemented.
- `unsupported_live_model_runtime`: fixture gates stay credential-free and do not use live model credentials or network calls.

## Report Policy

The report must keep:

- `"productionReplacement": false`
- `"replacementClaim": "none"`
- `"scope": "fixture-backed hxrust subset only"`

Do not use this gate as a production replacement claim. It is a compatibility and gap-reporting gate for the Cafex seam.

## Gate

Run from `.`:

```bash
harness/check-cafetera-contract-subset.sh
```

The gate runs the underlying Cafex/hxrust harnesses, then validates and regenerates the contract subset report through:

- Haxe interpreter harness
- haxe.rust generation through `hxml/cafetera-contract-subset.hxml`
- generated `cargo check --locked`
- generated `cargo test --locked`
- generated binary execution
- fixture comparison with `fixtures/cafex/cafetera-contract-subset-report.v1.json`
