#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/model-stream-route
haxe -cp src -cp test -main ModelStreamRouteHarness --interp
haxe hxml/model-stream-route.hxml
cargo check --manifest-path generated/model-stream-route/Cargo.toml --locked
cargo test --manifest-path generated/model-stream-route/Cargo.toml --locked
cargo run --manifest-path generated/model-stream-route/Cargo.toml --locked --quiet
