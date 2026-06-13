#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/turn-runtime-reducer
haxe -cp src -cp test -main TurnRuntimeReducerHarness --interp
haxe hxml/turn-runtime-reducer.hxml
cargo check --manifest-path generated/turn-runtime-reducer/Cargo.toml --locked
cargo test --manifest-path generated/turn-runtime-reducer/Cargo.toml --locked
cargo run --manifest-path generated/turn-runtime-reducer/Cargo.toml --locked --quiet

echo "Turn runtime reducer harness passed."
