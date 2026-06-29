#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-live-input-backend
haxe -cp src -cp test -main TuiLiveInputBackendHarness --interp
haxe hxml/tui-live-input-backend.hxml
cargo check --manifest-path generated/tui-live-input-backend/Cargo.toml --locked
cargo test --manifest-path generated/tui-live-input-backend/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-input-backend/Cargo.toml --locked --quiet

echo "TUI live input backend harness passed."
