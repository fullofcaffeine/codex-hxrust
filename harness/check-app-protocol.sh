#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/app-protocol
haxe -cp src -cp test -main AppProtocolHarness --interp
haxe hxml/app-protocol.hxml
cargo check --manifest-path generated/app-protocol/Cargo.toml --locked
cargo test --manifest-path generated/app-protocol/Cargo.toml --locked
cargo run --manifest-path generated/app-protocol/Cargo.toml --locked --quiet

echo "App protocol harness passed."
