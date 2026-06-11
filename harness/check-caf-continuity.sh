#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/caf-continuity generated/cafex-continuity
haxe -cp src -cp test -main CafContinuityHarness --interp
haxe hxml/caf-continuity.hxml
cargo check --manifest-path generated/caf-continuity/Cargo.toml --locked
cargo test --manifest-path generated/caf-continuity/Cargo.toml --locked
cargo run --manifest-path generated/caf-continuity/Cargo.toml --locked --quiet

echo "Caf continuity harness passed."
