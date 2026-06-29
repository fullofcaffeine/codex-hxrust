#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
RUNTIME_DIR="$ROOT_DIR/src/codexhx/runtime"
SMOKE_DIR="$ROOT_DIR/src/codexhx/runtime/tui/smoke"

if [ ! -d "$RUNTIME_DIR" ]; then
  exit 0
fi

pattern='(^[[:space:]]*import[[:space:]]+codexhx\.(runtime\.tui\.smoke|validation)(\.|;))|codexhx\.(runtime\.tui\.smoke|validation)\.'
violations=()

while IFS= read -r -d '' file; do
  while IFS= read -r match; do
    violations+=("${match#$ROOT_DIR/}")
  done < <(rg -n "$pattern" "$file" || true)
done < <(
  find "$RUNTIME_DIR" -type f -name '*.hx' \
    ! -path "$SMOKE_DIR/*" \
    -print0
)

if [ "${#violations[@]}" -gt 0 ]; then
  echo "[guard:import-boundaries] ERROR: production runtime source imports validation or TUI smoke code." >&2
  echo "[guard:import-boundaries] Keep fixture/smoke machinery under validation-owned surfaces; extract a runtime abstraction before production code depends on it." >&2
  printf '[guard:import-boundaries] violation: %s\n' "${violations[@]}" >&2
  exit 1
fi

echo "[guard:import-boundaries] OK"
