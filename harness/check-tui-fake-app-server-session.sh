#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-fake-app-server-session
haxe -cp src -cp test -main TuiFakeAppServerSessionHarness --interp
haxe hxml/tui-fake-app-server-session.hxml
cargo check --manifest-path generated/tui-fake-app-server-session/Cargo.toml --locked
cargo test --manifest-path generated/tui-fake-app-server-session/Cargo.toml --locked
cargo run --manifest-path generated/tui-fake-app-server-session/Cargo.toml --locked --quiet

echo "TUI fake app-server session harness passed."
