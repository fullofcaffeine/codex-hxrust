#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

HAXE_BIN="${HAXE_BIN:-haxe}"
CARGO_BIN="${CARGO_BIN:-cargo}"

run_profile() {
  local profile="$1"
  local hxml="hxml/${profile}.hxml"
  local crate_dir="generated/${profile}"

  echo "==> ${profile}: regenerate and run haxe.rust cargo check"
  rm -rf "$crate_dir"
  "$HAXE_BIN" "$hxml"

  if [[ ! -f "${crate_dir}/Cargo.toml" ]]; then
    echo "missing generated Cargo.toml: ${crate_dir}/Cargo.toml" >&2
    exit 1
  fi

  if [[ ! -f "${crate_dir}/Cargo.lock" ]]; then
    echo "missing generated Cargo.lock: ${crate_dir}/Cargo.lock" >&2
    exit 1
  fi

  echo "==> ${profile}: cargo check --locked"
  (cd "$crate_dir" && "$CARGO_BIN" check --locked)

  echo "==> ${profile}: cargo test --locked"
  (cd "$crate_dir" && "$CARGO_BIN" test --locked)

  if [[ "${HXCX_RUN_FMT:-0}" == "1" ]]; then
    echo "==> ${profile}: cargo fmt --check"
    (cd "$crate_dir" && "$CARGO_BIN" fmt --check)
  fi

  if [[ "${HXCX_RUN_CLIPPY:-0}" == "1" ]]; then
    echo "==> ${profile}: cargo clippy --locked"
    (cd "$crate_dir" && "$CARGO_BIN" clippy --locked)
  fi
}

run_profile portable
run_profile metal

echo "Generated Cargo gates passed."
