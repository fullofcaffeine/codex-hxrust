# Reference Pins

This directory records small provenance artifacts for external repositories used by the codex-hxrust experiment.

It should contain pins, manifests, fixture indexes, and drift reports. It should not contain copied upstream source trees.

Current external references:

- `upstream-codex.pin.json`: mainstream OpenAI Codex baseline.
- `cafex-codex.pin.json`: Cafex/Cafetera fork used for later adapter seams.
- `haxe-rust.pin.json`: haxe.rust compiler/runtime backend used by the experiment.
- `haxe-rust-local-patches.v1.json`: local haxe.rust patch ledger. It currently records the resolved CallStack workaround for audit history; there are no active local haxe.rust patches required by current gates.
- `haxe-rust-beads-import.v1.json`: compact imported reference map of the haxe.rust Beads ledger and codex-hxrust compiler-gap mappings.
- `haxe-rust-pressure-gaps.v1.json`: HXCX-7.1 compiler/runtime/interop pressure-gap ledger with reproduction, severity, workaround, source-area, and raw Rust escape-pressure counts.
- `haxe-rust-production-readiness.v1.json`: HXCX-7.3 haxe.rust capability scorecard and evidence-backed go/no-go recommendation for replacement review.
- `fixture-sources.v1.json`: fixture family inventory and initial harness source map.
- `app-protocol-schema-fingerprints.v1.json`: accepted upstream app-server schema subset fingerprint for the G2 protocol gate.
- `parity-scorecard.v1.json`: machine-readable gate and kill-criteria summary.
