#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIN_FILE="${PIN_FILE:-${ROOT}/reference/haxe-rust.pin.json}"
DO_FETCH=1

if [[ "${1:-}" == "--no-fetch" ]]; then
  DO_FETCH=0
  shift
fi

if [[ $# -gt 0 ]]; then
  PIN_FILE="$1"
fi

pin_commit="$(jq -r '.commit' "$PIN_FILE")"
local_path="$(jq -r '.localPath' "$PIN_FILE")"
remote_expected="$(jq -r '.remote' "$PIN_FILE")"
branch="$(jq -r '.branch' "$PIN_FILE")"

hxrust_dir="$(cd "$ROOT" && cd "$local_path" && pwd)"

if [[ ! -d "${hxrust_dir}/.git" ]]; then
  echo "haxe.rust checkout is missing or is not a git repository: ${hxrust_dir}" >&2
  exit 1
fi

if [[ "$DO_FETCH" == "1" ]]; then
  git -C "$hxrust_dir" fetch origin "$branch"
fi

upstream_ref="origin/${branch}"
if ! git -C "$hxrust_dir" rev-parse --verify --quiet "$upstream_ref" >/dev/null; then
  upstream_ref="$branch"
fi

local_branch="$(git -C "$hxrust_dir" branch --show-current || true)"
local_commit="$(git -C "$hxrust_dir" rev-parse HEAD)"
remote_actual="$(git -C "$hxrust_dir" config --get remote.origin.url || true)"
dirty_count="$(git -C "$hxrust_dir" status --porcelain | wc -l | tr -d ' ')"

commit_count="$(git -C "$hxrust_dir" rev-list --count "${pin_commit}..${upstream_ref}" || echo 0)"
commits="$(git -C "$hxrust_dir" log --oneline "${pin_commit}..${upstream_ref}" || true)"
changed_files="$(git -C "$hxrust_dir" diff --name-only "${pin_commit}..${upstream_ref}" || true)"

categories=()
if [[ -n "$changed_files" ]]; then
  if echo "$changed_files" | rg -q '(^|/)(std|src|runtime|hxrt|macros)(/|$)|\.hx$'; then
    categories+=("portable-codegen-or-runtime")
  fi
  if echo "$changed_files" | rg -q 'metal|async|interop|native|rust_async|haxeMetal'; then
    categories+=("metal-async-native-interop")
  fi
  if echo "$changed_files" | rg -q '(^|/)(Cargo\.toml|Cargo\.lock|package\.json|package-lock\.json|haxelib\.json|scripts|\.github)(/|$)'; then
    categories+=("cargo-dependency-toolchain")
  fi
  if echo "$changed_files" | rg -qi '(^|/)(license|copying|notice)(\.|$)|licen[cs]e'; then
    categories+=("license-distribution")
  fi
  if [[ ${#categories[@]} -eq 0 ]]; then
    categories+=("docs-test-or-unknown")
  fi
else
  categories+=("no-upstream-changes")
fi

echo "# haxe.rust upstream audit"
echo
echo "pin_file: ${PIN_FILE}"
echo "pin_commit: ${pin_commit}"
echo "local_path: ${local_path}"
echo "checkout: ${hxrust_dir}"
echo "expected_remote: ${remote_expected}"
echo "actual_remote: ${remote_actual}"
echo "branch: ${branch}"
echo "local_branch: ${local_branch}"
echo "local_commit: ${local_commit}"
echo "dirty_entries: ${dirty_count}"
echo "upstream_ref: ${upstream_ref}"
echo "commits_since_pin: ${commit_count}"
echo

echo "## commits since pin"
if [[ -n "$commits" ]]; then
  echo "$commits"
else
  echo "(none)"
fi
echo

echo "## changed files"
if [[ -n "$changed_files" ]]; then
  echo "$changed_files"
else
  echo "(none)"
fi
echo

echo "## classified areas"
printf '%s\n' "${categories[@]}"
echo

echo "## required gates before pin update"
echo "1. scripts/check-generated-cargo.sh"
echo "2. G2 upstream DTO/schema fixtures, once they exist"
echo "3. G3 headless runtime fixtures, once they exist"
echo "4. G5 Cafex adapter fixtures for runtime-affecting updates, once they exist"
echo
echo "Update through:"
echo "  scripts/update-haxe-rust-pin.sh <candidate-sha>"
