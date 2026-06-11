#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/config-profile
haxe -cp src -cp test -main ConfigProfileHarness --interp
haxe hxml/config-profile.hxml
cargo check --manifest-path generated/config-profile/Cargo.toml --locked
cargo test --manifest-path generated/config-profile/Cargo.toml --locked
cargo run --manifest-path generated/config-profile/Cargo.toml --locked --quiet

echo "Config profile harness passed."
