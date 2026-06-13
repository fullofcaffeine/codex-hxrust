#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-render
haxe -cp src -cp test -main TuiRenderHarness --interp
haxe hxml/tui-render.hxml
cargo check --manifest-path generated/tui-render/Cargo.toml --locked
cargo test --manifest-path generated/tui-render/Cargo.toml --locked
cargo run --manifest-path generated/tui-render/Cargo.toml --locked --quiet

echo "TUI render harness passed."
