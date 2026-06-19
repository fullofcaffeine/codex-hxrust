#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-density-persistence-render
haxe -cp src -cp test -main ResumePickerDensityPersistenceRenderHarness --interp
haxe hxml/resume-picker-density-persistence-render.hxml
cargo check --manifest-path generated/resume-picker-density-persistence-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-density-persistence-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-density-persistence-render/Cargo.toml --locked --quiet

echo "Resume picker density persistence render harness passed."
