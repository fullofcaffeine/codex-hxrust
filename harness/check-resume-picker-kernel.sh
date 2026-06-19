#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-kernel
haxe -cp src -cp test -main ResumePickerKernelHarness --interp
haxe hxml/resume-picker-kernel.hxml
cargo check --manifest-path generated/resume-picker-kernel/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-kernel/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-kernel/Cargo.toml --locked --quiet

echo "Resume picker kernel harness passed."
