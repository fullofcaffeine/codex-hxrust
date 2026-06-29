#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-live-shell-runner
haxe -cp src -cp test -main TuiLiveShellRunnerHarness --interp
haxe hxml/tui-live-shell-runner.hxml
cargo check --manifest-path generated/tui-live-shell-runner/Cargo.toml --locked
cargo test --manifest-path generated/tui-live-shell-runner/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-shell-runner/Cargo.toml --locked --quiet

echo "TUI live shell runner harness passed."
