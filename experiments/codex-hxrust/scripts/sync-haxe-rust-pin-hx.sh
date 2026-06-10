#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
PIN_FILE="${PIN_FILE:-${ROOT}/reference/haxe-rust.pin.json}"
OUT_FILE="${OUT_FILE:-${ROOT}/experiments/codex-hxrust/src/codexhx/HaxeRustPin.hx}"

schema="$(jq -r '.schema' "$PIN_FILE")"
local_path="$(jq -r '.localPath' "$PIN_FILE")"
remote="$(jq -r '.remote' "$PIN_FILE")"
branch="$(jq -r '.branch' "$PIN_FILE")"
commit="$(jq -r '.commit' "$PIN_FILE")"
package_name="$(jq -r '.packageName' "$PIN_FILE")"
package_version="$(jq -r '.packageVersion' "$PIN_FILE")"
license="$(jq -r '.license' "$PIN_FILE")"
local_patches="$(jq -r '.localPatches' "$PIN_FILE")"

cat > "$OUT_FILE" <<EOF
package codexhx;

class HaxeRustPin {
    public static inline final schema:String = "${schema}";
    public static inline final pinFile:String = "reference/haxe-rust.pin.json";
    public static inline final localPath:String = "${local_path}";
    public static inline final remote:String = "${remote}";
    public static inline final branch:String = "${branch}";
    public static inline final commit:String = "${commit}";
    public static inline final packageName:String = "${package_name}";
    public static inline final packageVersion:String = "${package_version}";
    public static inline final license:String = "${license}";
    public static inline final localPatches:String = "${local_patches}";
}
EOF

echo "Synced ${OUT_FILE} from ${PIN_FILE}"
