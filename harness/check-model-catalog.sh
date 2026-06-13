#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/model-catalog
haxe -cp src -cp test -main ModelCatalogHarness --interp
haxe hxml/model-catalog.hxml
cargo check --manifest-path generated/model-catalog/Cargo.toml --locked
cargo test --manifest-path generated/model-catalog/Cargo.toml --locked
cargo run --manifest-path generated/model-catalog/Cargo.toml --locked --quiet
