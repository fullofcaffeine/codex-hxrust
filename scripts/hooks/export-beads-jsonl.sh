#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
cd "$ROOT_DIR"

if [ ! -d ".beads" ]; then
  exit 0
fi

if ! command -v bd >/dev/null 2>&1; then
  echo "[pre-commit] ERROR: bd is required to export tracked Beads JSONL." >&2
  echo "[pre-commit] Install Beads or bypass only when intentionally committing without Beads changes." >&2
  exit 1
fi

echo "[pre-commit] Exporting Beads embedded backend to tracked JSONL..."
bd export -o .beads/issues.jsonl >/dev/null

git add -- .beads/issues.jsonl .beads/interactions.jsonl
