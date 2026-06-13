#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/native-state-adapter
haxe -cp src -cp test -main NativeStateAdapterHarness --interp
haxe hxml/native-state-adapter.hxml
cargo check --manifest-path generated/native-state-adapter/Cargo.toml --locked
cargo test --manifest-path generated/native-state-adapter/Cargo.toml --locked
cargo run --manifest-path generated/native-state-adapter/Cargo.toml --locked --quiet

echo "Native state adapter harness passed."
