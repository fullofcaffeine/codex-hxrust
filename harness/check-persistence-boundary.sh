#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/persistence-boundary
haxe -cp src -cp test -main PersistenceBoundaryHarness --interp
haxe hxml/persistence-boundary.hxml
cargo check --manifest-path generated/persistence-boundary/Cargo.toml --locked
cargo test --manifest-path generated/persistence-boundary/Cargo.toml --locked
cargo run --manifest-path generated/persistence-boundary/Cargo.toml --locked --quiet

echo "Persistence boundary harness passed."
