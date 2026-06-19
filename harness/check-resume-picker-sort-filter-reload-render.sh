#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-sort-filter-reload-render
haxe -cp src -cp test -main ResumePickerSortFilterReloadRenderHarness --interp
haxe hxml/resume-picker-sort-filter-reload-render.hxml
cargo check --manifest-path generated/resume-picker-sort-filter-reload-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-sort-filter-reload-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-sort-filter-reload-render/Cargo.toml --locked --quiet

echo "Resume picker sort/filter reload render harness passed."
