#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-keyboard-navigation-render
haxe -cp src -cp test -main ResumePickerKeyboardNavigationRenderHarness --interp
haxe hxml/resume-picker-keyboard-navigation-render.hxml
cargo check --manifest-path generated/resume-picker-keyboard-navigation-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-keyboard-navigation-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-keyboard-navigation-render/Cargo.toml --locked --quiet

echo "Resume picker keyboard navigation render harness passed."
