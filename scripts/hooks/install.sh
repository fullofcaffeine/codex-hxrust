#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"

chmod +x "$ROOT_DIR/scripts/hooks/pre-commit"
chmod +x "$ROOT_DIR/scripts/hooks/export-beads-jsonl.sh"
git config core.hooksPath scripts/hooks

echo "[hooks] Installed repo hooks from scripts/hooks."
echo "[hooks] Requirements: bd, gitleaks, haxelib, and haxelib formatter."
echo "[hooks] Install formatter with: haxelib install formatter"
