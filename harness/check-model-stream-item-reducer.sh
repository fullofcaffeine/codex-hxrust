#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/model-stream-item-reducer
haxe -cp src -cp test -main ModelStreamItemReducerHarness --interp
haxe hxml/model-stream-item-reducer.hxml
cargo check --manifest-path generated/model-stream-item-reducer/Cargo.toml --locked
cargo test --manifest-path generated/model-stream-item-reducer/Cargo.toml --locked
cargo run --manifest-path generated/model-stream-item-reducer/Cargo.toml --locked --quiet
