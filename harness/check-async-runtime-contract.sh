#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/async-runtime-contract
haxe -cp src -cp test -main AsyncRuntimeContractHarness --interp
haxe hxml/async-runtime-contract.hxml
cargo check --manifest-path generated/async-runtime-contract/Cargo.toml --locked
cargo test --manifest-path generated/async-runtime-contract/Cargo.toml --locked
cargo run --manifest-path generated/async-runtime-contract/Cargo.toml --locked --quiet
