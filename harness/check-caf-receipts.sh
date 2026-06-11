#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/caf-receipts
haxe -cp src -cp test -main CafReceiptHarness --interp
haxe hxml/caf-receipts.hxml
cargo check --manifest-path generated/caf-receipts/Cargo.toml --locked
cargo test --manifest-path generated/caf-receipts/Cargo.toml --locked
cargo run --manifest-path generated/caf-receipts/Cargo.toml --locked --quiet

echo "Caf receipt harness passed."
