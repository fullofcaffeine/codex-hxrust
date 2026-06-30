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
process_responder='read request
id="$(printf "%s" "$request" | sed -E "s/.*\"id\":([0-9]+).*/\1/")"
thread="$(printf "%s" "$request" | sed -E "s/.*\"threadId\":\"([^\"]+)\".*/\1/")"
prompt="$(printf "%s" "$request" | sed -E "s/.*\"text\":\"([^\"]*)\".*/\1/")"
printf "{\"id\":%s,\"jsonrpc\":\"2.0\",\"result\":{\"turn\":{\"id\":\"turn-%s\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}}\n" "$id" "$id"
printf "{\"jsonrpc\":\"2.0\",\"method\":\"turn/started\",\"params\":{\"threadId\":\"%s\",\"turn\":{\"id\":\"turn-%s\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}}\n" "$thread" "$id"
printf "{\"jsonrpc\":\"2.0\",\"method\":\"item/agentMessage/delta\",\"params\":{\"threadId\":\"%s\",\"turnId\":\"turn-%s\",\"itemId\":\"item-%s\",\"delta\":\"echo: %s\"}}\n" "$thread" "$id" "$id" "$prompt"
printf "{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{\"threadId\":\"%s\",\"turn\":{\"id\":\"turn-%s\",\"items\":[],\"itemsView\":\"full\",\"status\":\"completed\"}}}\n" "$thread" "$id"'
process_output="$(cargo run --manifest-path generated/tui-live-shell-demo/Cargo.toml --locked --quiet -- --transport=process-stdio --line-command=sh --line-arg=-c --line-arg="$process_responder" --scripted-prompt=demo)"
printf '%s\n' "$process_output"
if [[ "$process_output" != *"transport=process_stdio"* || "$process_output" != *"prompts=1"* ]]; then
	echo "scripted process-stdio demo did not report expected accepted prompt" >&2
	exit 1
fi

echo "TUI live shell demo harness passed."
