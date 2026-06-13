#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-story-replay
haxe -cp src -cp test -main TuiStoryReplayHarness --interp
haxe hxml/tui-story-replay.hxml
cargo check --manifest-path generated/tui-story-replay/Cargo.toml --locked
cargo test --manifest-path generated/tui-story-replay/Cargo.toml --locked
cargo run --manifest-path generated/tui-story-replay/Cargo.toml --locked --quiet

echo "TUI story replay harness passed."
