#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/caf-bridge generated/cafex-bridge
haxe -cp src -cp test -main CafBridgeHarness --interp
haxe hxml/caf-bridge.hxml
cargo check --manifest-path generated/caf-bridge/Cargo.toml --locked
cargo test --manifest-path generated/caf-bridge/Cargo.toml --locked
cargo run --manifest-path generated/caf-bridge/Cargo.toml --locked --quiet

echo "Caf bridge harness passed."
