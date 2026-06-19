#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-query-reload-render
haxe -cp src -cp test -main ResumePickerQueryReloadRenderHarness --interp
haxe hxml/resume-picker-query-reload-render.hxml
cargo check --manifest-path generated/resume-picker-query-reload-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-query-reload-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-query-reload-render/Cargo.toml --locked --quiet

echo "Resume picker query reload render harness passed."
