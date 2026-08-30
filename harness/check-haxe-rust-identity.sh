#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECKER="${ROOT}/scripts/haxe-rust-identity.sh"
UPDATER="${ROOT}/scripts/update-haxe-rust-pin.sh"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

remote="${TMP_ROOT}/remote.git"
checkout="${TMP_ROOT}/checkout"
linked="${TMP_ROOT}/linked"
pin_file="${TMP_ROOT}/pin.json"

git init --bare --quiet "$remote"
git init --quiet "$checkout"
git -C "$checkout" config user.name repository-maintainer
git -C "$checkout" config user.email repository-maintainer@invalid.example
git -C "$checkout" switch --create main --quiet
git -C "$checkout" commit --allow-empty --message baseline --quiet
git -C "$checkout" remote add origin "$remote"
git -C "$checkout" push --set-upstream origin main --quiet

baseline="$(git -C "$checkout" rev-parse HEAD)"

jq -n \
  --arg local_path "$checkout" \
  --arg remote "$remote" \
  --arg commit "$baseline" \
  '{localPath: $local_path, remote: $remote, branch: "main", commit: $commit}' > "$pin_file"

identity="$($CHECKER --root "$checkout" --pin "$pin_file" --require-clean --require-head "$baseline" --require-reachable)"
printf '%s\n' "$identity" | jq -e \
  --arg baseline "$baseline" \
  '.headCommit == $baseline
   and .pinCommit == $baseline
   and .dirtyEntries == 0
   and .remoteMatches
   and .headMatchesPin
   and .targetReachableFromUpstream' >/dev/null

git -C "$checkout" worktree add --detach "$linked" "$baseline" --quiet
$CHECKER --root "$linked" --pin "$pin_file" --require-clean --require-head "$baseline" --require-reachable >/dev/null

touch "${checkout}/dirty-file"
if $CHECKER --root "$checkout" --pin "$pin_file" --require-clean >/dev/null 2>&1; then
  echo "identity checker accepted a dirty compiler checkout" >&2
  exit 1
fi
if HAXE_RUST_ROOT="$checkout" "$UPDATER" "$baseline" "$pin_file" >/dev/null 2>&1; then
  echo "pin updater accepted a dirty compiler checkout" >&2
  exit 1
fi
rm "${checkout}/dirty-file"

git -C "$checkout" commit --allow-empty --message unpushed --quiet
unpushed="$(git -C "$checkout" rev-parse HEAD)"
if $CHECKER --root "$checkout" --pin "$pin_file" --require-head "$unpushed" --require-reachable >/dev/null 2>&1; then
  echo "identity checker accepted a commit that is not reachable from origin/main" >&2
  exit 1
fi
if HAXE_RUST_ROOT="$checkout" "$UPDATER" "$unpushed" "$pin_file" >/dev/null 2>&1; then
  echo "pin updater accepted a commit that is not reachable from origin/main" >&2
  exit 1
fi

wrong_remote="${TMP_ROOT}/wrong-remote.git"
git init --bare --quiet "$wrong_remote"
git -C "$checkout" remote set-url origin "$wrong_remote"
if $CHECKER --root "$checkout" --pin "$pin_file" >/dev/null 2>&1; then
  echo "identity checker accepted the wrong compiler remote" >&2
  exit 1
fi
if HAXE_RUST_ROOT="$checkout" "$UPDATER" "$unpushed" "$pin_file" >/dev/null 2>&1; then
  echo "pin updater accepted the wrong compiler remote" >&2
  exit 1
fi

echo "haxe.rust identity harness passed."
