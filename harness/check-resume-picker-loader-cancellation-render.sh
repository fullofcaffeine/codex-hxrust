#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-loader-cancellation-render
haxe -cp src -cp test -main ResumePickerLoaderCancellationRenderHarness --interp
haxe hxml/resume-picker-loader-cancellation-render.hxml
cargo check --manifest-path generated/resume-picker-loader-cancellation-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-loader-cancellation-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-loader-cancellation-render/Cargo.toml --locked --quiet

echo "Resume picker loader cancellation render harness passed."
