#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUNNER="${ROOT}/scripts/run-haxe-rust.sh"
PIN="${ROOT}/reference/haxe-rust.pin.json"
DEFAULT_ROOT="$(cd "${ROOT}/$(jq -er '.localPath' "$PIN")" && pwd -P)"
EXPECTED_REMOTE="$(jq -er '.remote' "$PIN")"
HAXE_BIN="${HAXE_BIN:-${ROOT}/node_modules/.bin/haxe}"
TMP_ROOT="$(mktemp -d)"
SELECTED_ROOT="${TMP_ROOT}/selected-haxe-rust"
TEMP_PIN="${TMP_ROOT}/pin.json"
VERBOSE_LOG="${TMP_ROOT}/verbose.log"
trap 'rm -rf "$TMP_ROOT"' EXIT

git clone --quiet --shared "$DEFAULT_ROOT" "$SELECTED_ROOT"
SELECTED_ROOT="$(cd "$SELECTED_ROOT" && pwd -P)"
git -C "$SELECTED_ROOT" remote set-url origin "$EXPECTED_REMOTE"
selected_head="$(git -C "$SELECTED_ROOT" rev-parse HEAD)"

jq \
  --arg localPath "$SELECTED_ROOT" \
  --arg commit "$selected_head" \
  '.localPath = $localPath | .commit = $commit' \
  "$PIN" > "$TEMP_PIN"

HAXE_RUST_ROOT="$SELECTED_ROOT" \
HAXE_RUST_TARGET_COMMIT="$selected_head" \
HAXE_RUST_REQUIRE_CLEAN=1 \
HAXE_RUST_REQUIRE_HEAD=1 \
HAXE_RUST_REQUIRE_REACHABLE=1 \
PIN_FILE="$TEMP_PIN" \
HAXE_BIN="$HAXE_BIN" \
  "$RUNNER" hxml/compiler-selection.hxml \
  -v \
  -D "rust_output=${TMP_ROOT}/out" \
  -D rust_no_build > "$VERBOSE_LOG" 2>&1

selected_compiler="Parsed ${SELECTED_ROOT}/src/reflaxe/rust/RustCompiler.hx"
default_compiler="Parsed ${DEFAULT_ROOT}/src/reflaxe/rust/RustCompiler.hx"
selected_std="Parsed ${SELECTED_ROOT}/std/rust/_std/Sys.hx"
default_std="Parsed ${DEFAULT_ROOT}/std/rust/_std/Sys.hx"

if ! rg --fixed-strings --quiet "$selected_compiler" "$VERBOSE_LOG"; then
	echo "HAXE_RUST_ROOT did not select the requested RustCompiler.hx" >&2
	rg 'Parsed .*/reflaxe/rust/RustCompiler\.hx' "$VERBOSE_LOG" >&2 || true
	exit 1
fi

if [[ "$SELECTED_ROOT" != "$DEFAULT_ROOT" ]] && rg --fixed-strings --quiet "$default_compiler" "$VERBOSE_LOG"; then
	echo "the fixed sibling checkout shadowed HAXE_RUST_ROOT" >&2
	exit 1
fi

if ! rg --fixed-strings --quiet "$selected_std" "$VERBOSE_LOG"; then
	echo "HAXE_RUST_ROOT did not select the requested Rust standard-library override" >&2
	rg 'Parsed .*/std/rust/_std/Sys\.hx' "$VERBOSE_LOG" >&2 || true
	exit 1
fi

if [[ "$SELECTED_ROOT" != "$DEFAULT_ROOT" ]] && rg --fixed-strings --quiet "$default_std" "$VERBOSE_LOG"; then
	echo "the fixed sibling standard-library override shadowed HAXE_RUST_ROOT" >&2
	exit 1
fi

echo "haxe.rust compiler selection harness passed."
