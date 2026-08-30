#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIN_FILE="${PIN_FILE:-${ROOT}/reference/haxe-rust.pin.json}"
CHECKOUT_ROOT="${HAXE_RUST_ROOT:-}"
TARGET_COMMIT=""
DO_FETCH=0
REQUIRE_CLEAN=0
REQUIRE_HEAD=0
REQUIRE_REACHABLE=0

usage() {
  echo "usage: $0 [--root path] [--pin file] [--target commit] [--fetch] [--require-clean] [--require-head commit] [--require-reachable]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      CHECKOUT_ROOT="${2:?missing value for --root}"
      shift 2
      ;;
    --pin)
      PIN_FILE="${2:?missing value for --pin}"
      shift 2
      ;;
    --target)
      TARGET_COMMIT="${2:?missing value for --target}"
      shift 2
      ;;
    --fetch)
      DO_FETCH=1
      shift
      ;;
    --require-clean)
      REQUIRE_CLEAN=1
      shift
      ;;
    --require-head)
      TARGET_COMMIT="${2:?missing value for --require-head}"
      REQUIRE_HEAD=1
      shift 2
      ;;
    --require-reachable)
      REQUIRE_REACHABLE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ ! -f "$PIN_FILE" ]]; then
  echo "haxe.rust pin file is missing: ${PIN_FILE}" >&2
  exit 1
fi

if [[ -z "$CHECKOUT_ROOT" ]]; then
  local_path="$(jq -er '.localPath' "$PIN_FILE")"
  CHECKOUT_ROOT="${ROOT}/${local_path}"
fi

if [[ ! -d "$CHECKOUT_ROOT" ]]; then
  echo "haxe.rust checkout is missing: ${CHECKOUT_ROOT}" >&2
  exit 1
fi

CHECKOUT_ROOT="$(cd "$CHECKOUT_ROOT" && pwd -P)"

if [[ "$(git -C "$CHECKOUT_ROOT" rev-parse --is-inside-work-tree 2>/dev/null || true)" != "true" ]]; then
  echo "haxe.rust checkout is not a Git worktree: ${CHECKOUT_ROOT}" >&2
  exit 1
fi

normalize_remote() {
  local value="$1"

  value="${value%.git}"
  case "$value" in
    git@github.com:*)
      printf 'github.com/%s\n' "${value#git@github.com:}"
      ;;
    ssh://git@github.com/*)
      printf 'github.com/%s\n' "${value#ssh://git@github.com/}"
      ;;
    https://github.com/*)
      printf 'github.com/%s\n' "${value#https://github.com/}"
      ;;
    http://github.com/*)
      printf 'github.com/%s\n' "${value#http://github.com/}"
      ;;
    *)
      printf '%s\n' "$value"
      ;;
  esac
}

pin_commit="$(jq -er '.commit' "$PIN_FILE")"
expected_remote="$(jq -er '.remote' "$PIN_FILE")"
branch="$(jq -er '.branch' "$PIN_FILE")"
actual_remote="$(git -C "$CHECKOUT_ROOT" config --get remote.origin.url || true)"

if [[ -z "$actual_remote" ]]; then
  echo "haxe.rust checkout has no origin remote: ${CHECKOUT_ROOT}" >&2
  exit 1
fi

expected_remote_id="$(normalize_remote "$expected_remote")"
actual_remote_id="$(normalize_remote "$actual_remote")"
remote_matches=false
if [[ "$expected_remote_id" == "$actual_remote_id" ]]; then
  remote_matches=true
fi

if [[ "$remote_matches" != "true" ]]; then
  echo "haxe.rust origin mismatch: expected ${expected_remote}, found ${actual_remote}" >&2
  exit 1
fi

if [[ "$DO_FETCH" == "1" ]]; then
  git -C "$CHECKOUT_ROOT" fetch origin "$branch"
fi

upstream_ref="origin/${branch}"
if ! git -C "$CHECKOUT_ROOT" rev-parse --verify --quiet "$upstream_ref" >/dev/null; then
  echo "haxe.rust upstream ref is missing: ${upstream_ref}" >&2
  exit 1
fi

head_commit="$(git -C "$CHECKOUT_ROOT" rev-parse HEAD)"
dirty_entries="$(git -C "$CHECKOUT_ROOT" status --porcelain --untracked-files=normal | wc -l | tr -d ' ')"
head_matches_pin=false
if [[ "$head_commit" == "$pin_commit" ]]; then
  head_matches_pin=true
fi

if [[ -z "$TARGET_COMMIT" ]]; then
  TARGET_COMMIT="$pin_commit"
fi

if [[ ! "$TARGET_COMMIT" =~ ^[0-9a-fA-F]{40}$ ]]; then
  echo "haxe.rust target must be a full 40-character commit: ${TARGET_COMMIT}" >&2
  exit 1
fi

if ! git -C "$CHECKOUT_ROOT" cat-file -e "${TARGET_COMMIT}^{commit}" 2>/dev/null; then
  echo "haxe.rust target commit is missing from checkout: ${TARGET_COMMIT}" >&2
  exit 1
fi

head_matches_target=false
if [[ "$head_commit" == "$TARGET_COMMIT" ]]; then
  head_matches_target=true
fi

target_reachable=false
if git -C "$CHECKOUT_ROOT" merge-base --is-ancestor "$TARGET_COMMIT" "$upstream_ref"; then
  target_reachable=true
fi

if [[ "$REQUIRE_CLEAN" == "1" && "$dirty_entries" != "0" ]]; then
  echo "haxe.rust checkout is dirty: ${dirty_entries} entries in ${CHECKOUT_ROOT}" >&2
  exit 1
fi

if [[ "$REQUIRE_HEAD" == "1" && "$head_matches_target" != "true" ]]; then
  echo "haxe.rust HEAD ${head_commit} does not match target ${TARGET_COMMIT}" >&2
  exit 1
fi

if [[ "$REQUIRE_REACHABLE" == "1" && "$target_reachable" != "true" ]]; then
  echo "haxe.rust target ${TARGET_COMMIT} is not reachable from ${upstream_ref}" >&2
  exit 1
fi

jq -n \
  --arg root "$CHECKOUT_ROOT" \
  --arg pinFile "$PIN_FILE" \
  --arg pinCommit "$pin_commit" \
  --arg headCommit "$head_commit" \
  --arg targetCommit "$TARGET_COMMIT" \
  --arg expectedRemote "$expected_remote" \
  --arg actualRemote "$actual_remote" \
  --arg branch "$branch" \
  --arg upstreamRef "$upstream_ref" \
  --argjson dirtyEntries "$dirty_entries" \
  --argjson remoteMatches "$remote_matches" \
  --argjson headMatchesPin "$head_matches_pin" \
  --argjson headMatchesTarget "$head_matches_target" \
  --argjson targetReachableFromUpstream "$target_reachable" \
  '{
    schema: "codex-hxrust.haxe-rust-identity.v1",
    root: $root,
    pinFile: $pinFile,
    pinCommit: $pinCommit,
    headCommit: $headCommit,
    targetCommit: $targetCommit,
    dirtyEntries: $dirtyEntries,
    expectedRemote: $expectedRemote,
    actualRemote: $actualRemote,
    remoteMatches: $remoteMatches,
    branch: $branch,
    upstreamRef: $upstreamRef,
    headMatchesPin: $headMatchesPin,
    headMatchesTarget: $headMatchesTarget,
    targetReachableFromUpstream: $targetReachableFromUpstream
  }'
