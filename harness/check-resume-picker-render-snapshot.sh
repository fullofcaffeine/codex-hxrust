#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-render-snapshot generated/tmp/resume-picker-render-snapshot
haxe -cp src -cp test -main ResumePickerRenderSnapshotHarness --interp
haxe hxml/resume-picker-render-snapshot.hxml
cargo check --manifest-path generated/resume-picker-render-snapshot/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-render-snapshot/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-render-snapshot/Cargo.toml --locked --quiet

echo "Resume picker render snapshot harness passed."
