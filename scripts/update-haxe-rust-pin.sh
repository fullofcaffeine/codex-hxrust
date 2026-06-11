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
hxrust_dir="$(cd "$ROOT" && cd "$local_path" && pwd)"

git -C "$hxrust_dir" cat-file -e "${CANDIDATE}^{commit}"

echo "Running required generated Cargo gates before pin update..."
"${ROOT}/scripts/check-generated-cargo.sh"

tmp="$(mktemp)"
jq --arg commit "$CANDIDATE" '.commit = $commit' "$PIN_FILE" > "$tmp"
mv "$tmp" "$PIN_FILE"

"${ROOT}/scripts/sync-haxe-rust-pin-hx.sh"

echo "Updated haxe.rust pin to ${CANDIDATE}"
