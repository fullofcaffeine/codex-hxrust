#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <candidate-sha> [pin-file]" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANDIDATE="$1"
PIN_FILE="${2:-${ROOT}/reference/haxe-rust.pin.json}"

local_path="$(jq -r '.localPath' "$PIN_FILE")"
hxrust_dir="${HAXE_RUST_ROOT:-${ROOT}/${local_path}}"

echo "Checking exact haxe.rust pin identity..."
identity="$("${ROOT}/scripts/haxe-rust-identity.sh" \
  --root "$hxrust_dir" \
  --pin "$PIN_FILE" \
  --target "$CANDIDATE" \
  --fetch \
  --require-clean \
  --require-head "$CANDIDATE" \
  --require-reachable)"
printf '%s\n' "$identity" | jq .
hxrust_dir="$(printf '%s\n' "$identity" | jq -er '.root')"

echo "Running required generated Cargo gates before pin update..."
HAXE_RUST_ROOT="$hxrust_dir" \
HAXE_RUST_TARGET_COMMIT="$CANDIDATE" \
HAXE_RUST_REQUIRE_CLEAN=1 \
HAXE_RUST_REQUIRE_HEAD=1 \
HAXE_RUST_REQUIRE_REACHABLE=1 \
  "${ROOT}/scripts/check-generated-cargo.sh"

tmp="$(mktemp)"
jq --arg commit "$CANDIDATE" '.commit = $commit' "$PIN_FILE" > "$tmp"
mv "$tmp" "$PIN_FILE"

"${ROOT}/scripts/sync-haxe-rust-pin-hx.sh"

echo "Updated haxe.rust pin to ${CANDIDATE}"
