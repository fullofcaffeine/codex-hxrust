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
haxe_rust_identity="$(${REPO_ROOT}/scripts/haxe-rust-identity.sh)"
haxe_rust_checkout_commit="$(printf '%s\n' "$haxe_rust_identity" | jq -r '.headCommit')"
haxe_rust_dirty_entries="$(printf '%s\n' "$haxe_rust_identity" | jq -r '.dirtyEntries')"
haxe_rust_matches_pin="$(printf '%s\n' "$haxe_rust_identity" | jq -r '.headMatchesPin')"

run_profile() {
  local profile="$1"
  local crate_dir="generated/${profile}"
  local output

  rm -rf "$crate_dir"
	HAXE_BIN="$HAXE_BIN" "${REPO_ROOT}/scripts/run-haxe-rust.sh" "hxml/${profile}.checkout.hxml"

  output="$(cd "$crate_dir" && "$CARGO_BIN" run --locked --quiet)"

  printf '%s\n' "$output" | jq \
		--arg profile "$profile" \
		--arg haxe_rust_commit "$haxe_rust_commit" \
		--arg haxe_rust_checkout_commit "$haxe_rust_checkout_commit" \
		--argjson haxe_rust_dirty_entries "$haxe_rust_dirty_entries" \
		--argjson haxe_rust_matches_pin "$haxe_rust_matches_pin" \
    -e -f "$SHAPE_FIXTURE" >/dev/null

  echo "${profile}: doctor JSON shape ok"
}

run_profile portable
run_profile metal

echo "Doctor JSON harness passed."
