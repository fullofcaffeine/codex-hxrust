#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/headless-jsonl-adapter
haxe -cp src -cp test -main HeadlessJsonlAdapterHarness --interp
haxe hxml/headless-jsonl-adapter.hxml
cargo check --manifest-path generated/headless-jsonl-adapter/Cargo.toml --locked
cargo test --manifest-path generated/headless-jsonl-adapter/Cargo.toml --locked
cargo run --manifest-path generated/headless-jsonl-adapter/Cargo.toml --locked --quiet

echo "Headless JSONL adapter harness passed."
