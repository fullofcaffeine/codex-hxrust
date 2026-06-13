#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/provider-admission
haxe -cp src -cp test -main ProviderAdmissionHarness --interp
haxe hxml/provider-admission.hxml
cargo check --manifest-path generated/provider-admission/Cargo.toml --locked
cargo test --manifest-path generated/provider-admission/Cargo.toml --locked
cargo run --manifest-path generated/provider-admission/Cargo.toml --locked --quiet
