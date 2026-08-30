#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <checkout-hxml> [haxe arguments...]" >&2
  exit 2
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIN_FILE="${PIN_FILE:-${ROOT}/reference/haxe-rust.pin.json}"
HAXE_BIN="${HAXE_BIN:-haxe}"
HXML="$1"
shift

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
checkout_root="$(printf '%s\n' "$identity" | jq -er '.root')"
head_commit="$(printf '%s\n' "$identity" | jq -er '.headCommit')"
dirty_entries="$(printf '%s\n' "$identity" | jq -er '.dirtyEntries')"
head_matches_pin="$(printf '%s\n' "$identity" | jq -r '.headMatchesPin')"
package_version="$(jq -er '.packageVersion' "$PIN_FILE")"

printf 'haxe_rust_identity=%s\n' "$(printf '%s\n' "$identity" | jq -c .)"

exec "$HAXE_BIN" \
  -cp "${checkout_root}/src" \
  -cp "${checkout_root}/std" \
  -cp "${checkout_root}/std/rust/_std" \
  -cp "${checkout_root}/vendor/reflaxe/src" \
  -D "reflaxe=${package_version}" \
  -D "reflaxe.rust=${package_version}" \
  -D rust_nested_modules \
  -D "codex_hxrust_haxe_rust_commit=${head_commit}" \
  -D "codex_hxrust_haxe_rust_dirty_entries=${dirty_entries}" \
  -D "codex_hxrust_haxe_rust_matches_pin=${head_matches_pin}" \
  --macro 'nullSafety("reflaxe.rust")' \
  --macro 'reflaxe.rust.CompilerBootstrap.Start()' \
  --macro 'reflaxe.rust.CompilerInit.Start()' \
  "$HXML" \
  "$@"
