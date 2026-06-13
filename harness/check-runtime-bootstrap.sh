#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/runtime-bootstrap
haxe -cp src -cp test -main RuntimeBootstrapHarness --interp
haxe hxml/runtime-bootstrap.hxml
cargo check --manifest-path generated/runtime-bootstrap/Cargo.toml --locked
cargo test --manifest-path generated/runtime-bootstrap/Cargo.toml --locked
cargo run --manifest-path generated/runtime-bootstrap/Cargo.toml --locked --quiet

echo "Runtime bootstrap harness passed."
