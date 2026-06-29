#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-app-server-event-pump
haxe -cp src -cp test -main TuiAppServerEventPumpHarness --interp
haxe hxml/tui-app-server-event-pump.hxml
cargo check --manifest-path generated/tui-app-server-event-pump/Cargo.toml --locked
cargo test --manifest-path generated/tui-app-server-event-pump/Cargo.toml --locked
cargo run --manifest-path generated/tui-app-server-event-pump/Cargo.toml --locked --quiet

echo "TUI app-server event pump harness passed."
