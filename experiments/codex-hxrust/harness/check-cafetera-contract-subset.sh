#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

harness/check-caf-receipts.sh
harness/check-caf-bridge.sh
harness/check-goals.sh
harness/check-caf-continuity.sh

rm -rf generated/cafetera-contract-subset
rm -f generated/reports/cafetera-contract-subset.v1.json
haxe -cp src -cp test -main CafeteraContractSubsetHarness --interp
haxe hxml/cafetera-contract-subset.hxml
cargo check --manifest-path generated/cafetera-contract-subset/Cargo.toml --locked
cargo test --manifest-path generated/cafetera-contract-subset/Cargo.toml --locked
cargo run --manifest-path generated/cafetera-contract-subset/Cargo.toml --locked --quiet
cmp fixtures/cafex/cafetera-contract-subset-report.v1.json generated/reports/cafetera-contract-subset.v1.json

echo "Cafetera contract subset harness passed."
