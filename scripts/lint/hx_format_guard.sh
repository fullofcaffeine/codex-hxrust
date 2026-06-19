#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
MODE="check"
CHANGED_BASE=""

if [ "${1:-}" = "--write" ]; then
  MODE="write"
  shift
fi

if [ "${1:-}" = "--changed" ]; then
  CHANGED_BASE="${2:-}"
  if [ -z "$CHANGED_BASE" ]; then
    echo "[guard:hx-format] ERROR: --changed requires a git base ref." >&2
    exit 1
  fi
fi

if ! command -v haxelib >/dev/null 2>&1; then
  echo "[guard:hx-format] ERROR: haxelib is required." >&2
  exit 1
fi

if ! haxelib run formatter --help >/dev/null 2>&1; then
  echo "[guard:hx-format] ERROR: formatter haxelib is not installed." >&2
  echo "[guard:hx-format] Install it with: haxelib install formatter" >&2
  exit 1
fi

sources=()
if [ -n "$CHANGED_BASE" ]; then
  echo "[guard:hx-format] Checking changed Haxe files since $CHANGED_BASE"
  while IFS= read -r changed_file; do
    if [ -n "$changed_file" ] && [ -f "$ROOT_DIR/$changed_file" ]; then
      case "$changed_file" in
        generated/*|src-gen/*|dist/*|target/*|test/.generated/*|vendor/*)
          ;;
        *.hx)
          sources+=("-s" "$ROOT_DIR/$changed_file")
          ;;
      esac
    fi
  done < <(
    git -C "$ROOT_DIR" diff --name-only --diff-filter=ACMR "$CHANGED_BASE"...HEAD \
      | sort
  )
else
  for source_dir in src test harness tools examples; do
    if [ -d "$ROOT_DIR/$source_dir" ]; then
      while IFS= read -r hx_source; do
        sources+=("-s" "$hx_source")
      done < <(
        find "$ROOT_DIR/$source_dir" -name '*.hx' \
          -not -path "$ROOT_DIR/test/.generated/*" \
          -not -path "$ROOT_DIR/src-gen/*" \
          -not -path "$ROOT_DIR/generated/*" \
          -not -path "$ROOT_DIR/vendor/*" \
          | sort
      )
    fi
  done
fi

if [ "${#sources[@]}" -eq 0 ]; then
  echo "[guard:hx-format] OK: no Haxe sources found."
  exit 0
fi

if [ "$MODE" = "write" ]; then
  echo "[guard:hx-format] Formatting Haxe sources..."
  haxelib run formatter "${sources[@]}"
else
  echo "[guard:hx-format] Checking Haxe formatting..."
  haxelib run formatter "${sources[@]}" --check
fi

echo "[guard:hx-format] OK"
