#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/caf-active-lane
haxe -cp src -cp test -main CafActiveLaneHarness --interp
haxe hxml/caf-active-lane.hxml
cargo check --manifest-path generated/caf-active-lane/Cargo.toml --locked
cargo test --manifest-path generated/caf-active-lane/Cargo.toml --locked
cargo run --manifest-path generated/caf-active-lane/Cargo.toml --locked --quiet

echo "Caf active-lane harness passed."
