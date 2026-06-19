#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-empty-error-render
haxe -cp src -cp test -main ResumePickerEmptyErrorRenderHarness --interp
haxe hxml/resume-picker-empty-error-render.hxml
cargo check --manifest-path generated/resume-picker-empty-error-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-empty-error-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-empty-error-render/Cargo.toml --locked --quiet

echo "Resume picker empty/error render harness passed."
