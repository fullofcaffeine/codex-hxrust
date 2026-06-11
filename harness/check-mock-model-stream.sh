#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/mock-model-stream
haxe -cp src -cp test -main MockModelStreamHarness --interp
haxe hxml/mock-model-stream.hxml
cargo check --manifest-path generated/mock-model-stream/Cargo.toml --locked
cargo test --manifest-path generated/mock-model-stream/Cargo.toml --locked
cargo run --manifest-path generated/mock-model-stream/Cargo.toml --locked --quiet

echo "Mock model stream harness passed."
