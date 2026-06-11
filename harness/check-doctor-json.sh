#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
PIN_FILE="${REPO_ROOT}/reference/haxe-rust.pin.json"
SHAPE_FIXTURE="${ROOT}/fixtures/hxrust/doctor-shape.v1.jq"
HAXE_BIN="${HAXE_BIN:-haxe}"
CARGO_BIN="${CARGO_BIN:-cargo}"

cd "$ROOT"

haxe_rust_commit="$(jq -r '.commit' "$PIN_FILE")"

run_profile() {
  local profile="$1"
  local crate_dir="generated/${profile}"
  local output

  rm -rf "$crate_dir"
  "$HAXE_BIN" "hxml/${profile}.hxml"

  output="$(cd "$crate_dir" && "$CARGO_BIN" run --locked --quiet)"

  printf '%s\n' "$output" | jq \
    --arg profile "$profile" \
    --arg haxe_rust_commit "$haxe_rust_commit" \
    -e -f "$SHAPE_FIXTURE" >/dev/null

  echo "${profile}: doctor JSON shape ok"
}

run_profile portable
run_profile metal

echo "Doctor JSON harness passed."
