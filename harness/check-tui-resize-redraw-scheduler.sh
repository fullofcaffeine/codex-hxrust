#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-resize-redraw-scheduler
haxe -cp src -cp test -main TuiResizeRedrawSchedulerHarness --interp
haxe hxml/tui-resize-redraw-scheduler.hxml
cargo check --manifest-path generated/tui-resize-redraw-scheduler/Cargo.toml --locked
cargo test --manifest-path generated/tui-resize-redraw-scheduler/Cargo.toml --locked
cargo run --manifest-path generated/tui-resize-redraw-scheduler/Cargo.toml --locked --quiet

echo "TUI resize redraw scheduler harness passed."
