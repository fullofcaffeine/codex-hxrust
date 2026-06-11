.schema == "codex-hxrust.doctor.v1"
and .stage == "scaffold"
and .coreBaseline == "upstream-codex"
and .cafexMode == "adapter-later"
and .generatedRustPolicy == "do-not-edit"
and .profile.name == $profile
and (.profile.features | type) == "array"
and .build.profile == $profile
and (.build.features | index("generated-rust-policy:do-not-edit")) != null
and (.build.features | index("portable-by-default")) != null
and (.build.features | index("rust-native-opt-in")) != null
and (.runtime.featureFlags | index("headless-jsonl-adapter")) != null
and (.runtime.featureFlags | index("apply-patch-dry-run")) != null
and (.runtime.featureFlags | index("process-exec-approval")) != null
and (.runtime.featureFlags | index("sandbox-permission-gate")) != null
and (.runtime.featureFlags | index("diagnostics-redaction")) != null
and .toolchain.haxe == "4.3.7"
and (.toolchain.rustc | startswith("rustc "))
and (.toolchain.cargo | startswith("cargo "))
and .haxeRust.pinFile == "reference/haxe-rust.pin.json"
and .haxeRust.remote == "git@github.com:fullofcaffeine/reflaxe.rust.git"
and .haxeRust.branch == "main"
and .haxeRust.commit == $haxe_rust_commit
and .haxeRust.packageName == "reflaxe.rust"
and .haxeRust.packageVersion == "1.0.0"
and .haxeRust.localPatches == "reference/haxe-rust-local-patches.v1.json"
