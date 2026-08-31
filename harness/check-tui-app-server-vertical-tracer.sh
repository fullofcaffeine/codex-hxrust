#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-app-server-vertical-tracer
haxe -cp src -cp test -main TuiAppServerVerticalTracerHarness --interp
scripts/run-haxe-rust.sh hxml/tui-app-server-vertical-tracer.checkout.hxml
cargo check --manifest-path generated/tui-app-server-vertical-tracer/Cargo.toml --locked
cargo test --manifest-path generated/tui-app-server-vertical-tracer/Cargo.toml --locked
cargo fmt --manifest-path generated/tui-app-server-vertical-tracer/Cargo.toml --check
cargo clippy --manifest-path generated/tui-app-server-vertical-tracer/Cargo.toml --locked -- -A clippy::all -D clippy::correctness -D clippy::suspicious
cargo run --manifest-path generated/tui-app-server-vertical-tracer/Cargo.toml --locked --quiet

echo "TUI app-server vertical tracer passed."
