#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-pagination-render
haxe -cp src -cp test -main ResumePickerPaginationRenderHarness --interp
haxe hxml/resume-picker-pagination-render.hxml
cargo check --manifest-path generated/resume-picker-pagination-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-pagination-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-pagination-render/Cargo.toml --locked --quiet

echo "Resume picker pagination render harness passed."
