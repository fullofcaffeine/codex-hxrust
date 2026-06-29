#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-live-agent-navigation
haxe -cp src -cp test -main TuiLiveAgentNavigationHarness --interp
haxe hxml/tui-live-agent-navigation.hxml
cargo check --manifest-path generated/tui-live-agent-navigation/Cargo.toml --locked
cargo test --manifest-path generated/tui-live-agent-navigation/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-agent-navigation/Cargo.toml --locked --quiet

echo "TUI live agent navigation harness passed."
