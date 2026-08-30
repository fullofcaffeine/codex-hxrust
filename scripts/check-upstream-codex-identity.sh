#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PIN_FILE="${UPSTREAM_CODEX_PIN_FILE:-${ROOT}/reference/upstream-codex.pin.json}"

checkout="$(jq -er '.localPath' "$PIN_FILE")"
expected_remote="$(jq -er '.remote' "$PIN_FILE")"
branch="$(jq -er '.branch' "$PIN_FILE")"
pin="$(jq -er '.commit' "$PIN_FILE")"

if [[ "$checkout" != /* ]]; then
  checkout="$(cd "$ROOT" && cd "$(dirname "$checkout")" && pwd)/$(basename "$checkout")"
fi

git -C "$checkout" rev-parse --is-inside-work-tree >/dev/null
head="$(git -C "$checkout" rev-parse HEAD)"
actual_remote="$(git -C "$checkout" remote get-url origin)"
dirty_entries="$(git -C "$checkout" status --porcelain | wc -l | tr -d ' ')"

normalize_remote() {
  printf '%s\n' "$1" \
    | sed -E 's#^git@github.com:#https://github.com/#; s#\.git$##'
}

if [[ "$(normalize_remote "$actual_remote")" != "$(normalize_remote "$expected_remote")" ]]; then
  echo "upstream Codex remote mismatch: ${actual_remote}" >&2
  exit 1
fi
if [[ "$head" != "$pin" ]]; then
  echo "upstream Codex HEAD does not match the pin: ${head}" >&2
  exit 1
fi
if [[ "$dirty_entries" != "0" ]]; then
  echo "upstream Codex reference has ${dirty_entries} dirty entries" >&2
  exit 1
fi
if ! git -C "$checkout" merge-base --is-ancestor "$pin" "origin/${branch}"; then
  echo "upstream Codex pin is not reachable from origin/${branch}: ${pin}" >&2
  exit 1
fi

jq -n \
  --arg checkout "$checkout" \
  --arg commit "$head" \
  --arg remote "$actual_remote" \
  --arg upstream "origin/${branch}" \
  '{
    schema: "codex-hxrust.upstream-codex-identity.v1",
    checkout: $checkout,
    commit: $commit,
    dirtyEntries: 0,
    remote: $remote,
    upstreamRef: $upstream,
    matchesPin: true,
    reachableFromUpstream: true
  }'
