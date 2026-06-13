#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/runtime-app-client
haxe -cp src -cp test -main RuntimeAppClientHarness --interp
haxe hxml/runtime-app-client.hxml
cargo check --manifest-path generated/runtime-app-client/Cargo.toml --locked
cargo test --manifest-path generated/runtime-app-client/Cargo.toml --locked
cargo run --manifest-path generated/runtime-app-client/Cargo.toml --locked --quiet

echo "Runtime app-client harness passed."
