#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-live-shell-demo generated/tui-live-shell-demo-harness
haxe -cp src -cp test -main TuiLiveShellDemoHarness --interp
haxe hxml/tui-live-shell-demo-harness.hxml
cargo check --manifest-path generated/tui-live-shell-demo-harness/Cargo.toml --locked
cargo test --manifest-path generated/tui-live-shell-demo-harness/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-shell-demo-harness/Cargo.toml --locked --quiet
haxe hxml/tui-live-shell-demo.hxml
cargo check --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked --quiet
cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked --quiet -- --transport=line-stdio --line-command=codex --line-arg=app-server --line-arg=--json-rpc
scripted_output="$(cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked --quiet -- --transport=line-stdio --scripted-prompt=demo)"
printf '%s\n' "$scripted_output"
if [[ "$scripted_output" != *"transport=line_stdio"* || "$scripted_output" != *"prompts=1"* ]]; then
	echo "scripted line-stdio demo did not report expected accepted prompt" >&2
	exit 1
fi

echo "TUI live shell demo harness passed."
