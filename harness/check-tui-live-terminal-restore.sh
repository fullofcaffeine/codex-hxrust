#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-live-terminal-restore
haxe -cp src -cp test -main TuiLiveTerminalRestoreHarness --interp
haxe hxml/tui-live-terminal-restore.hxml
cargo check --manifest-path generated/tui-live-terminal-restore/Cargo.toml --locked
cargo test --manifest-path generated/tui-live-terminal-restore/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-terminal-restore/Cargo.toml --locked --quiet

echo "TUI live terminal restore harness passed."
