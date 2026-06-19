#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-host-backpressure-render
haxe -cp src -cp test -main ResumePickerHostBackpressureRenderHarness --interp
haxe hxml/resume-picker-host-backpressure-render.hxml
cargo check --manifest-path generated/resume-picker-host-backpressure-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-host-backpressure-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-host-backpressure-render/Cargo.toml --locked --quiet

echo "Resume picker host backpressure render harness passed."
