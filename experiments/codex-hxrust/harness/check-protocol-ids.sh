#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/protocol-ids
haxe -cp src -cp test -main ProtocolIdsHarness --interp
haxe hxml/protocol-ids.hxml
(cd generated/protocol-ids && cargo check --locked && cargo test --locked)

echo "Protocol ID harness passed."
