#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-app-server-stream-pressure-render
haxe -cp src -cp test -main ResumePickerAppServerStreamPressureRenderHarness --interp
haxe hxml/resume-picker-app-server-stream-pressure-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-stream-pressure-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-app-server-stream-pressure-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-app-server-stream-pressure-render/Cargo.toml --locked --quiet

echo "Resume picker app-server stream pressure render harness passed."
