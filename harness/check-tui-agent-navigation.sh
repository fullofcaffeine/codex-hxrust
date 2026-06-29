#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-agent-navigation
haxe -cp src -cp test -main TuiAgentNavigationHarness --interp
haxe hxml/tui-agent-navigation.hxml
cargo check --manifest-path generated/tui-agent-navigation/Cargo.toml --locked
cargo test --manifest-path generated/tui-agent-navigation/Cargo.toml --locked
cargo run --manifest-path generated/tui-agent-navigation/Cargo.toml --locked --quiet

echo "TUI agent navigation harness passed."
