#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/runtime-transport
haxe -cp src -cp test -main RuntimeTransportHarness --interp
haxe hxml/runtime-transport.hxml
cargo check --manifest-path generated/runtime-transport/Cargo.toml --locked
cargo test --manifest-path generated/runtime-transport/Cargo.toml --locked
cargo run --manifest-path generated/runtime-transport/Cargo.toml --locked --quiet

echo "Runtime transport harness passed."
