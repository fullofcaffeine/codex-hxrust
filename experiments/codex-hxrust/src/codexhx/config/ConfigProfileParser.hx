package codexhx.config;

import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.SerdeBridge;
import haxe.json.Value;

class ConfigProfileParser {
    static final ALLOWED_FIELDS:Array<String> = [
        "schema",
        "profileName",
        "model",
        "modelProviderId",
        "reasoningEffort",
        "approvalPolicy",
        "sandboxMode",
        "webSearchEnabled",
        "imageGenerationEnabled",
        "developerInstructions",
        "writableRoots",
        "apiKey",
        "openaiApiKey",
        "token",
        "secrets"
    ];

    public static function parse(text:String):ConfigProfileParseOutcome {
        final parsed = SerdeBridge.parse(text);
        if (!parsed.ok) {
            return ConfigProfileParseOutcome.failure(parsed.errorCode, parsed.errorPath, parsed.errorMessage);
        }
        return fromValue(parsed.value);
    }

    public static function fromValue(value:Value):ConfigProfileParseOutcome {
        return switch value {
            case JObject(keys, values):
                build(keys, values, value);
            case _:
                ConfigProfileParseOutcome.failure("expected_object", "$", "expected config profile object");
        }
    }

    static function build(keys:Array<String>, values:Array<Value>, object:Value):ConfigProfileParseOutcome {
        final schema = optionalString(keys, values, "schema", "codex-hxrust.config-profile.v1");
        final profileName = requiredString(keys, values, "profileName");
        if (!profileName.ok) return profileName.toParseOutcome("$.profileName");
        if (!validProfileName(profileName.value)) {
            return ConfigProfileParseOutcome.failure("invalid_profile_name", "$.profileName", "profile names must use ASCII letters, digits, '_' or '-'");
        }

        final model = requiredString(keys, values, "model");
        if (!model.ok) return model.toParseOutcome("$.model");
        if (model.value.length == 0) {
            return ConfigProfileParseOutcome.failure("empty_model", "$.model", "model must not be empty");
        }

        final modelProviderId = optionalString(keys, values, "modelProviderId", "openai");
        final reasoningEffort = optionalString(keys, values, "reasoningEffort", "medium");
        if (!validReasoningEffort(reasoningEffort)) {
            return ConfigProfileParseOutcome.failure("invalid_reasoning_effort", "$.reasoningEffort", "reasoning effort must be a non-empty Codex effort value");
        }

        final approvalPolicy = requiredString(keys, values, "approvalPolicy");
        if (!approvalPolicy.ok) return approvalPolicy.toParseOutcome("$.approvalPolicy");
        if (!validApprovalPolicy(approvalPolicy.value)) {
            return ConfigProfileParseOutcome.failure("invalid_approval_policy", "$.approvalPolicy", "unsupported approval policy");
        }

        final sandboxMode = requiredString(keys, values, "sandboxMode");
        if (!sandboxMode.ok) return sandboxMode.toParseOutcome("$.sandboxMode");
        if (!validSandboxMode(sandboxMode.value)) {
            return ConfigProfileParseOutcome.failure("invalid_sandbox_mode", "$.sandboxMode", "unsupported sandbox mode");
        }

        final webSearchEnabled = optionalBool(keys, values, "webSearchEnabled", false);
        final imageGenerationEnabled = optionalBool(keys, values, "imageGenerationEnabled", false);
        final developerInstructions = optionalString(keys, values, "developerInstructions", "");
        final writableRoots = optionalStringArray(keys, values, "writableRoots");
        if (!writableRoots.ok) return writableRoots.toParseOutcome("$.writableRoots");

        final unsupported = CodexJson.unknownFields(object, ALLOWED_FIELDS);
        unsupported.sort(compareStrings);

        return ConfigProfileParseOutcome.success(new ConfigProfile(
            schema,
            profileName.value,
            model.value,
            modelProviderId,
            reasoningEffort,
            approvalPolicy.value,
            sandboxMode.value,
            webSearchEnabled,
            imageGenerationEnabled,
            developerInstructions,
            writableRoots.values,
            unsupported,
            hasSecretField(keys)
        ));
    }

    static function requiredString(keys:Array<String>, values:Array<Value>, name:String):ConfigStringField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ConfigStringField.failure("missing_field", "required field is missing");
        return switch values[i] {
            case JString(value): ConfigStringField.success(value);
            case _: ConfigStringField.failure("expected_string", "expected JSON string");
        }
    }

    static function optionalString(keys:Array<String>, values:Array<Value>, name:String, fallback:String):String {
        final i = fieldIndex(keys, name);
        if (i < 0) return fallback;
        return switch values[i] {
            case JString(value): value;
            case JNull: fallback;
            case _: fallback;
        }
    }

    static function optionalBool(keys:Array<String>, values:Array<Value>, name:String, fallback:Bool):Bool {
        final i = fieldIndex(keys, name);
        if (i < 0) return fallback;
        return switch values[i] {
            case JBool(value): value;
            case JNull: fallback;
            case _: fallback;
        }
    }

    static function optionalStringArray(keys:Array<String>, values:Array<Value>, name:String):ConfigStringArrayField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ConfigStringArrayField.success([]);
        return switch values[i] {
            case JArray(entries):
                final out:Array<String> = [];
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    switch entries[entryIndex] {
                        case JString(value):
                            out.push(value);
                        case _:
                            return ConfigStringArrayField.failure("expected_string", "expected writableRoots entries to be strings");
                    }
                    entryIndex = entryIndex + 1;
                }
                ConfigStringArrayField.success(out);
            case JNull:
                ConfigStringArrayField.success([]);
            case _:
                ConfigStringArrayField.failure("expected_array", "expected JSON array");
        }
    }

    static function validProfileName(value:String):Bool {
        if (value.length == 0) return false;
        final allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-";
        var i = 0;
        while (i < value.length) {
            if (allowed.indexOf(value.charAt(i)) < 0) return false;
            i = i + 1;
        }
        return true;
    }

    static function validReasoningEffort(value:String):Bool {
        return value.length > 0;
    }

    static function validApprovalPolicy(value:String):Bool {
        return value == "untrusted" || value == "on-failure" || value == "on-request" || value == "granular" || value == "never";
    }

    static function validSandboxMode(value:String):Bool {
        return value == "danger-full-access" || value == "read-only" || value == "external-sandbox" || value == "workspace-write";
    }

    static function hasSecretField(keys:Array<String>):Bool {
        for (key in keys) {
            final lower = key.toLowerCase();
            if (lower.indexOf("apikey") >= 0 || lower.indexOf("api_key") >= 0 || lower.indexOf("token") >= 0 || lower == "secrets") {
                return true;
            }
        }
        return false;
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function compareStrings(a:String, b:String):Int {
        if (a < b) return -1;
        if (a > b) return 1;
        return 0;
    }
}

class ConfigStringField {
    public final ok:Bool;
    public final value:String;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, value:String, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(value:String):ConfigStringField {
        return new ConfigStringField(true, value, "", "");
    }

    public static function failure(code:String, message:String):ConfigStringField {
        return new ConfigStringField(false, "", code, message);
    }

    public function toParseOutcome(path:String):ConfigProfileParseOutcome {
        return ConfigProfileParseOutcome.failure(errorCode, path, errorMessage);
    }
}

class ConfigStringArrayField {
    public final ok:Bool;
    public final values:Array<String>;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, values:Array<String>, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.values = values;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(values:Array<String>):ConfigStringArrayField {
        return new ConfigStringArrayField(true, values, "", "");
    }

    public static function failure(code:String, message:String):ConfigStringArrayField {
        return new ConfigStringArrayField(false, [], code, message);
    }

    public function toParseOutcome(path:String):ConfigProfileParseOutcome {
        return ConfigProfileParseOutcome.failure(errorCode, path, errorMessage);
    }
}
