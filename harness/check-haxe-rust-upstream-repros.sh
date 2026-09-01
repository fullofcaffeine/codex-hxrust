#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
LEDGER="${REPO_ROOT}/reference/haxe-rust-upstream-repros.v1.json"
PRESSURE="${REPO_ROOT}/reference/haxe-rust-pressure-gaps.v1.json"
HAXE_RUST_REPO="${HAXE_RUST_REPO:-${REPO_ROOT}/../haxe.rust}"
CONTRACT="${REPO_ROOT}/harness/haxe-rust-upstream-repros-contract.jq"

jq -e '
  .schema == "codex-hxrust.haxe-rust-upstream-repros.v1"
  and .bead == "HXCX-7.2"
  and .haxeRustRepo == "../haxe.rust"
  and .haxeRustRunner == "scripts/ci/check-upstream-open-gap-repros.sh"
  and .runnerMode == (
    if any(.repros[]; .status == "expected_cargo_failure") then
      "expected_cargo_failure_until_upstream_fix"
    elif any(.repros[]; .status == "fix_in_review") then
      "active_fix_in_review"
    else
      "no_open_expected_failure_repros"
    end
  )
  and .policy.compilerScope == "generic_haxe_to_rust"
  and .policy.codexSpecificCompilerCodeAllowed == false
  and .policy.fixturesCanRunOutsideCafetera == true
  and .summary.totalRepros == (.repros | length)
  and .summary.expectedCargoFailures == ([.repros[] | select(.status == "expected_cargo_failure")] | length)
  and .summary.openHaxeRustBeads == ([.repros[].haxeRustBead] | unique | length)
  and .summary.codexSpecificContextRemoved == true
' "$LEDGER" >/dev/null

jq -e --slurpfile p "$PRESSURE" -f "$CONTRACT" "$LEDGER" >/dev/null

# Prove that the shared contract rejects an empty repro list while the pressure
# ledger contains active compiler work.
contract_tmp="$(mktemp -d)"
trap 'rm -rf "$contract_tmp"' EXIT
jq '.repros = []' "$LEDGER" >"${contract_tmp}/empty-repros.json"
if jq -e --slurpfile p "$PRESSURE" -f "$CONTRACT" "${contract_tmp}/empty-repros.json" >/dev/null; then
  echo "Upstream repro contract accepted an unmapped active compiler gap." >&2
  exit 1
fi

runner="${HAXE_RUST_REPO}/$(jq -r '.haxeRustRunner' "$LEDGER")"
[[ -x "$runner" ]]

while IFS= read -r path; do
  [[ -d "${HAXE_RUST_REPO}/${path}" ]]
  [[ -f "${HAXE_RUST_REPO}/${path}/Main.hx" ]]
  [[ -f "${HAXE_RUST_REPO}/${path}/compile.hxml" ]]
done < <(jq -r '.repros[] | select(.status == "expected_cargo_failure") | .haxeRustFixturePath' "$LEDGER")

repo_head="$(git -C "$HAXE_RUST_REPO" rev-parse HEAD)"
while IFS=$'\t' read -r id path fixture_commit; do
  if [[ "$repo_head" != "$fixture_commit" ]]; then
    echo "[fix-in-review] metadata only: ${id} requires ${fixture_commit}, checkout is ${repo_head}"
    continue
  fi

  fixture_dir="${HAXE_RUST_REPO}/${path}"
  [[ -d "$fixture_dir" ]]
  [[ -f "${fixture_dir}/Main.hx" ]]
  while IFS= read -r compile_file; do
    [[ -f "${fixture_dir}/${compile_file}" ]]
  done < <(jq -r --arg id "$id" '.repros[] | select(.id == $id) | .profileCompileFiles[]' "$LEDGER")

  for forbidden in $(jq -r '.policy.fixtureSourceForbiddenTerms[]' "$LEDGER"); do
    if rg -n --fixed-strings "$forbidden" "$fixture_dir" -g '*.hx' >/dev/null; then
      echo "Forbidden fixture-source term found in haxe.rust fix-in-review source: ${forbidden}" >&2
      exit 1
    fi
  done

  (
    cd "$HAXE_RUST_REPO"
    bash test/run-snapshots.sh --case "$id" --clippy
  )
done < <(jq -r '.repros[] | select(.status == "fix_in_review") | [.id, .haxeRustFixturePath, .fixtureCommit] | @tsv' "$LEDGER")

for forbidden in $(jq -r '.policy.fixtureSourceForbiddenTerms[]' "$LEDGER"); do
  if [[ -d "${HAXE_RUST_REPO}/test/repro/upstream_open_gaps" ]] \
    && rg -n --fixed-strings "$forbidden" "${HAXE_RUST_REPO}/test/repro/upstream_open_gaps" -g '*.hx' >/dev/null; then
    echo "Forbidden fixture-source term found in haxe.rust repro source: ${forbidden}" >&2
    exit 1
  fi
done

(
  cd "$HAXE_RUST_REPO"
  bash "$(jq -r '.haxeRustRunner' "$LEDGER")"
)

echo "haxe.rust upstream repro ledger passed."
