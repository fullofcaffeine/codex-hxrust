#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-terminal-contract
haxe -cp src -cp test -main TuiTerminalBackendHarness --interp
haxe hxml/tui-terminal-contract.hxml
cargo check --manifest-path generated/tui-terminal-contract/Cargo.toml --locked
cargo test --manifest-path generated/tui-terminal-contract/Cargo.toml --locked
cargo run --manifest-path generated/tui-terminal-contract/Cargo.toml --locked --quiet

echo "TUI terminal contract harness passed."
