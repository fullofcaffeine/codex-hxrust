#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

HAXE_BIN="${HAXE_BIN:-haxe}"
CARGO_BIN="${CARGO_BIN:-cargo}"
PIN_FILE="${PIN_FILE:-${ROOT}/reference/haxe-rust.pin.json}"

identity_args=(--pin "$PIN_FILE")
if [[ -n "${HAXE_RUST_ROOT:-}" ]]; then
  identity_args+=(--root "$HAXE_RUST_ROOT")
fi
if [[ -n "${HAXE_RUST_TARGET_COMMIT:-}" ]]; then
  identity_args+=(--target "$HAXE_RUST_TARGET_COMMIT")
fi
if [[ "${HAXE_RUST_FETCH:-0}" == "1" ]]; then
  identity_args+=(--fetch)
fi
if [[ "${HAXE_RUST_REQUIRE_CLEAN:-0}" == "1" ]]; then
  identity_args+=(--require-clean)
fi
if [[ "${HAXE_RUST_REQUIRE_HEAD:-0}" == "1" ]]; then
  target="${HAXE_RUST_TARGET_COMMIT:-$(jq -er '.commit' "$PIN_FILE")}"
  identity_args+=(--require-head "$target")
fi
if [[ "${HAXE_RUST_REQUIRE_REACHABLE:-0}" == "1" ]]; then
  identity_args+=(--require-reachable)
fi
identity="$(${ROOT}/scripts/haxe-rust-identity.sh "${identity_args[@]}")"
echo "==> haxe.rust identity"
printf '%s\n' "$identity" | jq .

run_profile() {
  local profile="$1"
  local hxml="hxml/${profile}.checkout.hxml"
  local crate_dir="generated/${profile}"

  echo "==> ${profile}: regenerate and run haxe.rust cargo check"
  rm -rf "$crate_dir"
  HAXE_BIN="$HAXE_BIN" "${ROOT}/scripts/run-haxe-rust.sh" "$hxml"

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

  echo "==> ${profile}: cargo fmt --check"
  (cd "$crate_dir" && "$CARGO_BIN" fmt --check)

  echo "==> ${profile}: cargo clippy correctness and suspicious lints"
  (cd "$crate_dir" && "$CARGO_BIN" clippy --locked -- -A clippy::all -D clippy::correctness -D clippy::suspicious)
}

run_profile portable
run_profile metal

echo "Generated Cargo gates passed."
