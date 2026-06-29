#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-prompt-submit-envelope
haxe -cp src -cp test -main TuiPromptSubmitEnvelopeHarness --interp
haxe hxml/tui-prompt-submit-envelope.hxml
cargo check --manifest-path generated/tui-prompt-submit-envelope/Cargo.toml --locked
cargo test --manifest-path generated/tui-prompt-submit-envelope/Cargo.toml --locked
cargo run --manifest-path generated/tui-prompt-submit-envelope/Cargo.toml --locked --quiet

echo "TUI prompt submit envelope harness passed."
