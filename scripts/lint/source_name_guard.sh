#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
RESUME_DIR="$ROOT_DIR/src/codexhx/runtime/tui/resume"
MAX_STEM_LENGTH=40

if [ ! -d "$RESUME_DIR" ]; then
  exit 0
fi

bad_files=()
while IFS= read -r file; do
  bad_files+=("${file#$ROOT_DIR/}")
done < <(
  find "$RESUME_DIR" -type f -name '*.hx' \
    \( -name 'ResumePickerAppServerTypedResponseRecovery*' \
      -o -name 'DeterministicResumePickerAppServerTypedResponseRecovery*' \
      -o -name '*PostCompletionPostRenderReplayAwareRenderedState*' \
      -o -name '*KeyboardRenderSnapshotReplay*' \
      -o -name '*KeyboardRenderStateRenderGate*' \)
)

long_files=()
while IFS= read -r file; do
  stem="$(basename "$file" .hx)"
  if [ "${#stem}" -gt "$MAX_STEM_LENGTH" ]; then
    long_files+=("${file#$ROOT_DIR/} (${#stem} chars)")
  fi
done < <(find "$RESUME_DIR" -type f -name '*.hx')

bad_declarations=()
while IFS= read -r match; do
  bad_declarations+=("$match")
done < <(
  rg -n '^(class|typedef) (ResumePickerAppServerTypedResponseRecovery|DeterministicResumePickerAppServerTypedResponseRecovery|.*PostCompletionPostRenderReplayAwareRenderedState|.*KeyboardRenderSnapshotReplay|.*KeyboardRenderStateRenderGate)' "$RESUME_DIR" || true
)

if [ "${#bad_files[@]}" -gt 0 ] || [ "${#long_files[@]}" -gt 0 ] || [ "${#bad_declarations[@]}" -gt 0 ]; then
  echo "[guard:source-names] ERROR: resume production source names are too long or encode full scenario/test-history names." >&2
  echo "[guard:source-names] Put audit detail in Beads/docs/harnesses; keep implementation names concise and package-owned." >&2
  echo "[guard:source-names] Max production filename stem length under src/codexhx/runtime/tui/resume is ${MAX_STEM_LENGTH} characters." >&2
  if [ "${#bad_files[@]}" -gt 0 ]; then
    printf '[guard:source-names] bad file: %s\n' "${bad_files[@]}" >&2
  fi
  if [ "${#long_files[@]}" -gt 0 ]; then
    printf '[guard:source-names] long file: %s\n' "${long_files[@]}" >&2
  fi
  if [ "${#bad_declarations[@]}" -gt 0 ]; then
    printf '[guard:source-names] bad declaration: %s\n' "${bad_declarations[@]}" >&2
  fi
  exit 1
fi

echo "[guard:source-names] OK"
