#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/model-request-envelope
haxe -cp src -cp test -main ModelRequestEnvelopeHarness --interp
haxe hxml/model-request-envelope.hxml
cargo check --manifest-path generated/model-request-envelope/Cargo.toml --locked
cargo test --manifest-path generated/model-request-envelope/Cargo.toml --locked
cargo run --manifest-path generated/model-request-envelope/Cargo.toml --locked --quiet
