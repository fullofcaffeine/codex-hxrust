#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/json-boundary
haxe -cp src -cp test -main JsonBoundaryHarness --interp
haxe hxml/json-boundary.hxml
(cd generated/json-boundary && cargo check --locked && cargo test --locked && cargo run --locked --quiet)

echo "JSON boundary harness passed."
