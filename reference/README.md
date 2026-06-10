# Reference Pins

This directory records small provenance artifacts for external repositories used by the codex-hxrust experiment.

It should contain pins, manifests, fixture indexes, and drift reports. It should not contain copied upstream source trees.

Current external references:

- `upstream-codex.pin.json`: mainstream OpenAI Codex baseline.
- `cafex-codex.pin.json`: Cafex/Cafetera fork used for later adapter seams.
- `haxe-rust.pin.json`: haxe.rust compiler/runtime backend used by the experiment.
- `haxe-rust-local-patches.v1.json`: local haxe.rust working-tree patches needed by current gates.
- `haxe-rust-beads-import.v1.json`: compact imported reference map of the haxe.rust Beads ledger and codex-hxrust compiler-gap mappings.
- `fixture-sources.v1.json`: fixture family inventory and initial harness source map.
- `app-protocol-schema-fingerprints.v1.json`: accepted upstream app-server schema subset fingerprint for the G2 protocol gate.
- `parity-scorecard.v1.json`: machine-readable gate and kill-criteria summary.
