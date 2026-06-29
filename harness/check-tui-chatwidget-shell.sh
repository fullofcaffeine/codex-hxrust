#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-chatwidget-shell
haxe -cp src -cp test -main TuiChatWidgetShellHarness --interp
haxe hxml/tui-chatwidget-shell.hxml
cargo check --manifest-path generated/tui-chatwidget-shell/Cargo.toml --locked
cargo test --manifest-path generated/tui-chatwidget-shell/Cargo.toml --locked
cargo run --manifest-path generated/tui-chatwidget-shell/Cargo.toml --locked --quiet

echo "TUI ChatWidget shell harness passed."
