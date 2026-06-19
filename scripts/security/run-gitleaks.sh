#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
MODE="full"

if [ "${1:-}" = "--staged" ]; then
  MODE="staged"
fi

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "[gitleaks] ERROR: gitleaks is required but not installed." >&2
  echo "[gitleaks] Install: https://github.com/gitleaks/gitleaks#installing" >&2
  exit 1
fi

CONFIG_ARGS=()
if [ -f "$ROOT_DIR/.gitleaks.toml" ]; then
  CONFIG_ARGS+=(--config "$ROOT_DIR/.gitleaks.toml")
fi

GITLEAKS_HELP="$(gitleaks --help 2>&1 || true)"

if [ "$MODE" = "staged" ]; then
  echo "[gitleaks] Scanning staged changes"
  if printf '%s' "$GITLEAKS_HELP" | grep -q '\<protect\>'; then
    (cd "$ROOT_DIR" && gitleaks protect --staged --redact "${CONFIG_ARGS[@]}")
  elif printf '%s' "$GITLEAKS_HELP" | grep -q '\<git\>'; then
    (cd "$ROOT_DIR" && gitleaks git --staged --redact "${CONFIG_ARGS[@]}")
  else
    echo "[gitleaks] ERROR: unsupported gitleaks CLI; expected 'protect' or 'git' command." >&2
    exit 1
  fi
  exit 0
fi

COMMIT_COUNT="$(git -C "$ROOT_DIR" rev-list --all --count)"
echo "[gitleaks] Scanning repository history"
echo "[gitleaks] Git commits in scope: $COMMIT_COUNT"

TMP_OUTPUT="$(mktemp)"
trap 'rm -f "$TMP_OUTPUT"' EXIT

set +e
if printf '%s' "$GITLEAKS_HELP" | grep -q '\<git\>'; then
  (cd "$ROOT_DIR" && gitleaks git --redact --log-opts="--all" "${CONFIG_ARGS[@]}") 2>&1 | tee "$TMP_OUTPUT"
  STATUS="${PIPESTATUS[0]}"
elif printf '%s' "$GITLEAKS_HELP" | grep -q '\<detect\>'; then
  (cd "$ROOT_DIR" && gitleaks detect --source "$ROOT_DIR" --redact --log-opts="--all" "${CONFIG_ARGS[@]}") 2>&1 | tee "$TMP_OUTPUT"
  STATUS="${PIPESTATUS[0]}"
else
  echo "[gitleaks] ERROR: unsupported gitleaks CLI; expected 'detect' or 'git' command." >&2
  exit 1
fi
set -e

if [ "$STATUS" -ne 0 ]; then
  exit "$STATUS"
fi

if [ "$COMMIT_COUNT" -gt 0 ] && grep -Eq '(^|[[:space:]])0 commits scanned\.' "$TMP_OUTPUT"; then
  echo "[gitleaks] WARNING: gitleaks git reported 0 commits scanned for a repository with $COMMIT_COUNT commits." >&2
  echo "[gitleaks] Falling back to git-log patch stream plus current-tree directory scan." >&2

  git -C "$ROOT_DIR" log -p --all --no-ext-diff \
    | gitleaks detect --pipe --redact --no-banner "${CONFIG_ARGS[@]}"

  (cd "$ROOT_DIR" && gitleaks detect --source . --no-git --redact --no-banner "${CONFIG_ARGS[@]}")
fi

echo "[gitleaks] OK"
