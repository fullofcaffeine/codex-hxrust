package codexhx;

class Doctor {
    public static function reportJson():String {
        return "{"
            + "\"schema\":\"codex-hxrust.doctor.v1\","
            + "\"stage\":\"scaffold\","
            + "\"coreBaseline\":\"upstream-codex\","
            + "\"cafexMode\":\"adapter-later\","
            + "\"profile\":{"
            + "\"name\":\"" + profileName() + "\","
            + "\"features\":" + profileFeaturesJson()
            + "},"
            + "\"build\":{"
            + "\"profile\":\"" + profileName() + "\","
            + "\"features\":" + buildFeaturesJson()
            + "},"
            + "\"runtime\":{"
            + "\"featureFlags\":" + runtimeFeatureFlagsJson()
            + "},"
            + "\"toolchain\":{"
            + "\"haxe\":\"" + ToolchainInfo.haxeVersion + "\","
            + "\"rustc\":\"" + ToolchainInfo.rustcVersion + "\","
            + "\"cargo\":\"" + ToolchainInfo.cargoVersion + "\""
            + "},"
            + "\"haxeRust\":{"
            + "\"pinFile\":\"" + HaxeRustPin.pinFile + "\","
            + "\"localPath\":\"" + HaxeRustPin.localPath + "\","
            + "\"remote\":\"" + HaxeRustPin.remote + "\","
            + "\"branch\":\"" + HaxeRustPin.branch + "\","
            + "\"commit\":\"" + HaxeRustPin.commit + "\","
            + "\"packageName\":\"" + HaxeRustPin.packageName + "\","
            + "\"packageVersion\":\"" + HaxeRustPin.packageVersion + "\","
            + "\"license\":\"" + HaxeRustPin.license + "\","
            + "\"localPatches\":\"" + HaxeRustPin.localPatches + "\""
            + "},"
            + "\"generatedRustPolicy\":\"do-not-edit\""
            + "}";
    }

    static function profileName():String {
        #if (reflaxe_rust_profile == "metal")
        return "metal";
        #elseif (reflaxe_rust_profile == "portable")
        return "portable";
        #else
        return "unknown";
        #end
    }

    static function profileFeaturesJson():String {
        #if rust_metal_allow_fallback
        return "[\"rust_metal_allow_fallback\"]";
        #else
        return "[]";
        #end
    }

    static function buildFeaturesJson():String {
        return "[\"generated-rust-policy:do-not-edit\",\"portable-by-default\",\"rust-native-opt-in\"]";
    }

    static function runtimeFeatureFlagsJson():String {
        return "["
            + "\"headless-jsonl-adapter\","
            + "\"apply-patch-dry-run\","
            + "\"process-exec-approval\","
            + "\"sandbox-permission-gate\","
            + "\"diagnostics-redaction\""
            + "]";
    }
}
