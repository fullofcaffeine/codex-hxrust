#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if rg -n 'FakeTuiAppServerFacade' src/codexhx/runtime/tui; then
  echo "Live app-server ownership still exposes FakeTuiAppServerFacade." >&2
  exit 1
fi

if [[ -e src/codexhx/runtime/tui/appserver/FakeTuiAppServerFacade.hx ]]; then
  echo "FakeTuiAppServerFacade must remain in the test source tree." >&2
  exit 1
fi

rm -rf generated/tui-app-server-session-contract
haxe -cp src -cp test -main TuiAppServerSessionContractHarness --interp
scripts/run-haxe-rust.sh hxml/tui-app-server-session-contract.checkout.hxml
cargo check --manifest-path generated/tui-app-server-session-contract/Cargo.toml --locked
cargo test --manifest-path generated/tui-app-server-session-contract/Cargo.toml --locked
cargo fmt --manifest-path generated/tui-app-server-session-contract/Cargo.toml --check
cargo clippy --manifest-path generated/tui-app-server-session-contract/Cargo.toml --locked -- -A clippy::all -D clippy::correctness -D clippy::suspicious
cargo run --manifest-path generated/tui-app-server-session-contract/Cargo.toml --locked --quiet

echo "TUI app-server session contract harness passed."
