#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
LEDGER="${REPO_ROOT}/reference/haxe-rust-upstream-repros.v1.json"
PRESSURE="${REPO_ROOT}/reference/haxe-rust-pressure-gaps.v1.json"
HAXE_RUST_REPO="${HAXE_RUST_REPO:-${REPO_ROOT}/../haxe.rust}"

jq -e '
  .schema == "codex-hxrust.haxe-rust-upstream-repros.v1"
  and .bead == "HXCX-7.2"
  and .haxeRustRepo == "../haxe.rust"
  and .haxeRustRunner == "scripts/ci/check-upstream-open-gap-repros.sh"
  and .runnerMode == "expected_cargo_failure_until_upstream_fix"
  and .policy.compilerScope == "generic_haxe_to_rust"
  and .policy.codexSpecificCompilerCodeAllowed == false
  and .policy.fixturesCanRunOutsideCafetera == true
  and .summary.totalRepros == (.repros | length)
  and .summary.expectedCargoFailures == ([.repros[] | select(.status == "expected_cargo_failure")] | length)
  and .summary.openHaxeRustBeads == ([.repros[].haxeRustBead] | unique | length)
  and .summary.codexSpecificContextRemoved == true
' "$LEDGER" >/dev/null

jq -e --slurpfile p "$PRESSURE" '
  ([.repros[].pressureGapId] | sort) == [
    "path-directory-lowering",
    "string-last-index-of-lowering"
  ]
  and all(.repros[]; (.haxeRustFixturePath | startswith("test/repro/upstream_open_gaps/")))
  and all(.repros[]; (.entrypoint == "Main.hx" and .compileFile == "compile.hxml"))
  and all(.repros[]; (.expectedFailureSignature // "") != "")
  and all(.repros[]; (.upstreamableContract // "") != "")
  and all(.repros[]; ($p[0].gaps[] | select(.id == .pressureGapId)).id == .pressureGapId)
' "$LEDGER" >/dev/null

runner="${HAXE_RUST_REPO}/$(jq -r '.haxeRustRunner' "$LEDGER")"
[[ -x "$runner" ]]

while IFS= read -r path; do
  [[ -d "${HAXE_RUST_REPO}/${path}" ]]
  [[ -f "${HAXE_RUST_REPO}/${path}/Main.hx" ]]
  [[ -f "${HAXE_RUST_REPO}/${path}/compile.hxml" ]]
done < <(jq -r '.repros[].haxeRustFixturePath' "$LEDGER")

for forbidden in $(jq -r '.policy.fixtureSourceForbiddenTerms[]' "$LEDGER"); do
  if rg -n --fixed-strings "$forbidden" "${HAXE_RUST_REPO}/test/repro/upstream_open_gaps" -g '*.hx' >/dev/null; then
    echo "Forbidden fixture-source term found in haxe.rust repro source: ${forbidden}" >&2
    exit 1
  fi
done

(
  cd "$HAXE_RUST_REPO"
  bash "$(jq -r '.haxeRustRunner' "$LEDGER")"
)

echo "haxe.rust upstream repro ledger passed."
