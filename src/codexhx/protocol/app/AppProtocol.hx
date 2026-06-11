package codexhx.protocol.app;

import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

class AppProtocol {
    static final REQUEST_METHODS:Array<String> = ["thread/start", "turn/start", "turn/interrupt", "thread/read"];
    static final NOTIFICATION_METHODS:Array<String> = ["thread/started", "thread/status/changed", "turn/started", "turn/completed", "turn/plan/updated", "item/started", "item/completed", "item/agentMessage/delta", "item/plan/delta", "rawResponseItem/completed", "error"];
    static final FINGERPRINT_BASIS:String = "app-server-protocol:v2|requests:thread/read,thread/start,turn/interrupt,turn/start|notifications:error,item/agentMessage/delta,item/plan/delta,item/completed,item/started,rawResponseItem/completed,thread/started,thread/status/changed,turn/completed,turn/plan/updated,turn/started|items:agentMessage,plan,userMessage|errors:jsonrpc+turn-error";
    static final FINGERPRINT:String = "hxcx-app-protocol-v2-subset-2026-06-11-007";

    public static function schemaFingerprint():String {
        return FINGERPRINT;
    }

    public static function schemaFingerprintJson():String {
        return "{\"basis\":" + quote(FINGERPRINT_BASIS) + ",\"fingerprint\":" + quote(FINGERPRINT) + ",\"schema\":\"codex-hxrust.app-protocol-fingerprint.v1\"}";
    }

    public static function parseFixtureItem(item:Value):AppProtocolParseOutcome {
        return switch item {
            case JObject(keys, values):
                final id = requiredString(keys, values, "id", "$.id");
                if (!id.ok) return id.toOutcome();

                final kind = requiredString(keys, values, "kind", "$.kind");
                if (!kind.ok) return kind.toOutcome();

                final method = optionalString(keys, values, "method", "");
                final message = requiredValue(keys, values, "message", "$.message");
                if (!message.ok) return message.toOutcome();

                final validation = validateMessage(kind.value, method, message.value);
                if (!validation.ok) return validation;

                AppProtocolParseOutcome.success(new AppProtocolMessage(
                    id.value,
                    kind.value,
                    method,
                    JsonValueCodec.encode(message.value),
                    validation.message.summary,
                    FINGERPRINT
                ));
            case _:
                AppProtocolParseOutcome.failure("expected_object", "$", "expected fixture item object");
        }
    }

    public static function errorAffectsTurnStatus(errorInfo:Value):Bool {
        return switch errorInfo {
            case JString(value):
                value != "threadRollbackFailed";
            case JObject(keys, _):
                !hasField(keys, "activeTurnNotSteerable");
            case _:
                true;
        }
    }

    static function validateMessage(kind:String, fixtureMethod:String, message:Value):AppProtocolParseOutcome {
        final object = requireObject(message, "$.message");
        if (!object.ok) return object.toOutcome();

        final jsonrpc = requiredString(object.keys, object.values, "jsonrpc", "$.message.jsonrpc");
        if (!jsonrpc.ok) return jsonrpc.toOutcome();
        if (jsonrpc.value != "2.0") return fail("invalid_jsonrpc_version", "$.message.jsonrpc", "expected JSON-RPC 2.0");

        return switch kind {
            case "request":
                validateRequest(fixtureMethod, object);
            case "response":
                validateResponse(fixtureMethod, object);
            case "notification":
                validateNotification(fixtureMethod, object);
            case "error":
                validateJsonRpcError(object);
            case _:
                fail("unsupported_kind", "$.kind", "unsupported fixture item kind");
        }
    }

    static function validateRequest(fixtureMethod:String, object:ProtocolObjectField):AppProtocolParseOutcome {
        if (!contains(REQUEST_METHODS, fixtureMethod)) return fail("unsupported_method", "$.method", "unsupported request method");
        final id = requiredId(object.keys, object.values, "$.message.id");
        if (!id.ok) return id.toOutcome();

        final method = requiredString(object.keys, object.values, "method", "$.message.method");
        if (!method.ok) return method.toOutcome();
        if (method.value != fixtureMethod) return fail("method_mismatch", "$.message.method", "message method differs from fixture method");

        final params = requiredObjectField(object.keys, object.values, "params", "$.message.params");
        if (!params.ok) return params.toOutcome();

        final paramsResult = validateParams(fixtureMethod, params);
        if (!paramsResult.ok) return paramsResult;
        return success("request:" + fixtureMethod);
    }

    static function validateResponse(fixtureMethod:String, object:ProtocolObjectField):AppProtocolParseOutcome {
        if (!contains(REQUEST_METHODS, fixtureMethod)) return fail("unsupported_method", "$.method", "unsupported response method");
        final id = requiredId(object.keys, object.values, "$.message.id");
        if (!id.ok) return id.toOutcome();

        final result = requiredObjectField(object.keys, object.values, "result", "$.message.result");
        if (!result.ok) return result.toOutcome();

        return switch fixtureMethod {
            case "thread/start" | "thread/read":
                final thread = requiredObjectField(result.keys, result.values, "thread", "$.message.result.thread");
                if (!thread.ok) return thread.toOutcome();
                validateThread(thread, "$.message.result.thread");
            case "turn/start":
                final turn = requiredObjectField(result.keys, result.values, "turn", "$.message.result.turn");
                if (!turn.ok) return turn.toOutcome();
                validateTurn(turn, "$.message.result.turn");
            case "turn/interrupt":
                success("response:turn/interrupt");
            case _:
                fail("unsupported_method", "$.method", "unsupported response method");
        }
    }

    static function validateNotification(fixtureMethod:String, object:ProtocolObjectField):AppProtocolParseOutcome {
        if (!contains(NOTIFICATION_METHODS, fixtureMethod)) return fail("unsupported_method", "$.method", "unsupported notification method");
        final method = requiredString(object.keys, object.values, "method", "$.message.method");
        if (!method.ok) return method.toOutcome();
        if (method.value != fixtureMethod) return fail("method_mismatch", "$.message.method", "message method differs from fixture method");

        final params = requiredObjectField(object.keys, object.values, "params", "$.message.params");
        if (!params.ok) return params.toOutcome();

        return switch fixtureMethod {
            case "thread/started":
                final thread = requiredObjectField(params.keys, params.values, "thread", "$.message.params.thread");
                if (!thread.ok) return thread.toOutcome();
                validateThread(thread, "$.message.params.thread");
            case "thread/status/changed":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final status = requiredObjectField(params.keys, params.values, "status", "$.message.params.status");
                if (!status.ok) return status.toOutcome();
                validateThreadStatus(status, "$.message.params.status");
            case "turn/started" | "turn/completed":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final turn = requiredObjectField(params.keys, params.values, "turn", "$.message.params.turn");
                if (!turn.ok) return turn.toOutcome();
                validateTurn(turn, "$.message.params.turn");
            case "turn/plan/updated":
                validateTurnPlanUpdatedNotification(params);
            case "item/started":
                validateItemNotification(params, true);
            case "item/agentMessage/delta":
                validateAgentMessageDeltaNotification(params);
            case "item/plan/delta":
                validatePlanDeltaNotification(params);
            case "rawResponseItem/completed":
                validateRawResponseItemCompletedNotification(params);
            case "item/completed":
                validateItemNotification(params, false);
            case "error":
                validateErrorNotification(params);
            case _:
                fail("unsupported_method", "$.method", "unsupported notification method");
        }
    }

    static function validateJsonRpcError(object:ProtocolObjectField):AppProtocolParseOutcome {
        final id = requiredId(object.keys, object.values, "$.message.id");
        if (!id.ok) return id.toOutcome();
        final error = requiredObjectField(object.keys, object.values, "error", "$.message.error");
        if (!error.ok) return error.toOutcome();
        final code = requiredNumber(error.keys, error.values, "code", "$.message.error.code");
        if (!code.ok) return code.toOutcome();
        final message = requiredString(error.keys, error.values, "message", "$.message.error.message");
        if (!message.ok) return message.toOutcome();
        return success("jsonrpc-error");
    }

    static function validateParams(method:String, params:ProtocolObjectField):AppProtocolParseOutcome {
        return switch method {
            case "thread/start":
                success("params:thread/start");
            case "turn/start":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final input = requiredArray(params.keys, params.values, "input", "$.message.params.input");
                if (!input.ok) return input.toOutcome();
                validateUserInputArray(input.values, "$.message.params.input");
            case "turn/interrupt":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
                if (!turnId.ok) return turnId.toOutcome();
                success("params:turn/interrupt");
            case "thread/read":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final includeTurns = optionalValue(params.keys, params.values, "includeTurns");
                if (includeTurns.ok) {
                    switch includeTurns.value {
                        case JBool(_):
                        case _:
                            return fail("expected_bool", "$.message.params.includeTurns", "expected JSON boolean");
                    }
                }
                success("params:thread/read");
            case _:
                fail("unsupported_method", "$.method", "unsupported params method");
        }
    }

    static function validateThread(thread:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final id = requiredString(thread.keys, thread.values, "id", path + ".id");
        if (!id.ok) return id.toOutcome();
        final sessionId = requiredString(thread.keys, thread.values, "sessionId", path + ".sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        final status = requiredObjectField(thread.keys, thread.values, "status", path + ".status");
        if (!status.ok) return status.toOutcome();
        final statusResult = validateThreadStatus(status, path + ".status");
        if (!statusResult.ok) return statusResult;
        final turns = requiredArray(thread.keys, thread.values, "turns", path + ".turns");
        if (!turns.ok) return turns.toOutcome();
        var i = 0;
        while (i < turns.values.length) {
            final turn = requireObject(turns.values[i], path + ".turns[" + Std.string(i) + "]");
            if (!turn.ok) return turn.toOutcome();
            final turnResult = validateTurn(turn, path + ".turns[" + Std.string(i) + "]");
            if (!turnResult.ok) return turnResult;
            i = i + 1;
        }
        return success("thread");
    }

    static function validateTurn(turn:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final id = requiredString(turn.keys, turn.values, "id", path + ".id");
        if (!id.ok) return id.toOutcome();
        final status = requiredString(turn.keys, turn.values, "status", path + ".status");
        if (!status.ok) return status.toOutcome();
        if (!validTurnStatus(status.value)) return fail("invalid_turn_status", path + ".status", "unsupported turn status");
        final items = requiredArray(turn.keys, turn.values, "items", path + ".items");
        if (!items.ok) return items.toOutcome();
        var i = 0;
        while (i < items.values.length) {
            final item = requireObject(items.values[i], path + ".items[" + Std.string(i) + "]");
            if (!item.ok) return item.toOutcome();
            final itemResult = validateTranscriptItem(item, path + ".items[" + Std.string(i) + "]");
            if (!itemResult.ok) return itemResult;
            i = i + 1;
        }
        return success("turn");
    }

    static function validateThreadStatus(status:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final statusType = requiredString(status.keys, status.values, "type", path + ".type");
        if (!statusType.ok) return statusType.toOutcome();
        if (statusType.value == "active") {
            final flags = requiredArray(status.keys, status.values, "activeFlags", path + ".activeFlags");
            if (!flags.ok) return flags.toOutcome();
            var i = 0;
            while (i < flags.values.length) {
                switch flags.values[i] {
                    case JString(_):
                    case _:
                        return fail("expected_string", path + ".activeFlags[" + Std.string(i) + "]", "expected active flag string");
                }
                i = i + 1;
            }
            return success("status:active");
        }
        if (statusType.value == "idle" || statusType.value == "notLoaded" || statusType.value == "systemError") {
            return success("status:" + statusType.value);
        }
        return fail("invalid_thread_status", path + ".type", "unsupported thread status");
    }

    static function validateTranscriptItem(item:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final itemType = requiredString(item.keys, item.values, "type", path + ".type");
        if (!itemType.ok) return itemType.toOutcome();
        return switch itemType.value {
            case "userMessage":
                final id = requiredString(item.keys, item.values, "id", path + ".id");
                if (!id.ok) return id.toOutcome();
                final content = requiredArray(item.keys, item.values, "content", path + ".content");
                if (!content.ok) return content.toOutcome();
                validateUserInputArray(content.values, path + ".content");
            case "agentMessage":
                final id = requiredString(item.keys, item.values, "id", path + ".id");
                if (!id.ok) return id.toOutcome();
                final text = requiredString(item.keys, item.values, "text", path + ".text");
                if (!text.ok) return text.toOutcome();
                success("item:agentMessage");
            case "plan":
                final id = requiredString(item.keys, item.values, "id", path + ".id");
                if (!id.ok) return id.toOutcome();
                final text = requiredString(item.keys, item.values, "text", path + ".text");
                if (!text.ok) return text.toOutcome();
                success("item:plan");
            case _:
                fail("unsupported_transcript_item", path + ".type", "unsupported transcript item type");
        }
    }

    static function validateItemNotification(params:ProtocolObjectField, started:Bool):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final item = requiredObjectField(params.keys, params.values, "item", "$.message.params.item");
        if (!item.ok) return item.toOutcome();
        final itemResult = validateTranscriptItem(item, "$.message.params.item");
        if (!itemResult.ok) return itemResult;
        final timestamp = if (started) {
            requiredNumber(params.keys, params.values, "startedAtMs", "$.message.params.startedAtMs");
        } else {
            requiredNumber(params.keys, params.values, "completedAtMs", "$.message.params.completedAtMs");
        }
        if (!timestamp.ok) return timestamp.toOutcome();
        return success(if (started) "notification:item/started" else "notification:item/completed");
    }

    static function validateTurnPlanUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final explanationIndex = fieldIndex(params.keys, "explanation");
        if (explanationIndex >= 0) {
            switch params.values[explanationIndex] {
                case JString(_) | JNull:
                case _:
                    return fail("expected_nullable_string", "$.message.params.explanation", "expected JSON string or null");
            }
        }
        final plan = requiredArray(params.keys, params.values, "plan", "$.message.params.plan");
        if (!plan.ok) return plan.toOutcome();
        return validateTurnPlanSteps(plan.values, "$.message.params.plan");
    }

    static function validateTurnPlanSteps(entries:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            final stepPath = path + "[" + Std.string(i) + "]";
            final step = requireObject(entries[i], stepPath);
            if (!step.ok) return step.toOutcome();
            final text = requiredString(step.keys, step.values, "step", stepPath + ".step");
            if (!text.ok) return text.toOutcome();
            final status = requiredString(step.keys, step.values, "status", stepPath + ".status");
            if (!status.ok) return status.toOutcome();
            if (!validPlanStepStatus(status.value)) return fail("invalid_plan_step_status", stepPath + ".status", "unsupported plan step status");
            i = i + 1;
        }
        return success("notification:turn/plan/updated");
    }

    static function validateAgentMessageDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/agentMessage/delta");
    }

    static function validatePlanDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/plan/delta");
    }

    static function validateRawResponseItemCompletedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final item = requiredObjectField(params.keys, params.values, "item", "$.message.params.item");
        if (!item.ok) return item.toOutcome();
        final itemResult = validateRawResponseItem(item, "$.message.params.item");
        if (!itemResult.ok) return itemResult;
        return success("notification:rawResponseItem/completed");
    }

    static function validateRawResponseItem(item:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final itemType = requiredString(item.keys, item.values, "type", path + ".type");
        if (!itemType.ok) return itemType.toOutcome();
        if (itemType.value != "message") return fail("unsupported_raw_response_item", path + ".type", "only raw message response items are supported in this subset");

        final role = requiredString(item.keys, item.values, "role", path + ".role");
        if (!role.ok) return role.toOutcome();
        final content = requiredArray(item.keys, item.values, "content", path + ".content");
        if (!content.ok) return content.toOutcome();
        return validateRawResponseContentArray(content.values, path + ".content");
    }

    static function validateRawResponseContentArray(entries:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            final entryPath = path + "[" + Std.string(i) + "]";
            final entry = requireObject(entries[i], entryPath);
            if (!entry.ok) return entry.toOutcome();
            final contentType = requiredString(entry.keys, entry.values, "type", entryPath + ".type");
            if (!contentType.ok) return contentType.toOutcome();
            if (contentType.value != "input_text" && contentType.value != "output_text") {
                return fail("unsupported_raw_response_content", entryPath + ".type", "only raw text response content is supported in this subset");
            }
            final text = requiredString(entry.keys, entry.values, "text", entryPath + ".text");
            if (!text.ok) return text.toOutcome();
            i = i + 1;
        }
        return success("raw-response-content:text");
    }

    static function validateUserInputArray(entries:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            final entryPath = path + "[" + Std.string(i) + "]";
            final input = requireObject(entries[i], entryPath);
            if (!input.ok) return input.toOutcome();
            final inputType = requiredString(input.keys, input.values, "type", entryPath + ".type");
            if (!inputType.ok) return inputType.toOutcome();
            if (inputType.value != "text") return fail("unsupported_user_input", entryPath + ".type", "only text user input is supported in this subset");
            final text = requiredString(input.keys, input.values, "text", entryPath + ".text");
            if (!text.ok) return text.toOutcome();
            i = i + 1;
        }
        return success("user-input:text");
    }

    static function validateErrorNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final willRetry = requiredBool(params.keys, params.values, "willRetry", "$.message.params.willRetry");
        if (!willRetry.ok) return willRetry.toOutcome();
        final error = requiredObjectField(params.keys, params.values, "error", "$.message.params.error");
        if (!error.ok) return error.toOutcome();
        final message = requiredString(error.keys, error.values, "message", "$.message.params.error.message");
        if (!message.ok) return message.toOutcome();
        final info = optionalValue(error.keys, error.values, "codexErrorInfo");
        if (info.ok) {
            final affects = errorAffectsTurnStatus(info.value);
            return success(if (affects) "error:affects-turn" else "error:non-turn-affecting");
        }
        return success("error:affects-turn");
    }

    static function validTurnStatus(value:String):Bool {
        return value == "inProgress" || value == "completed" || value == "interrupted" || value == "failed";
    }

    static function validPlanStepStatus(value:String):Bool {
        return value == "pending" || value == "inProgress" || value == "completed";
    }

    static function success(summary:String):AppProtocolParseOutcome {
        return AppProtocolParseOutcome.success(new AppProtocolMessage("", "", "", "", summary, FINGERPRINT));
    }

    static function fail(code:String, path:String, message:String):AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(code, path, message);
    }

    static function requiredString(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolStringField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolStringField.failure("missing_field", path, "required field is missing");
        return switch values[i] {
            case JString(value): ProtocolStringField.success(value);
            case _: ProtocolStringField.failure("expected_string", path, "expected JSON string");
        }
    }

    static function optionalString(keys:Array<String>, values:Array<Value>, name:String, fallback:String):String {
        final i = fieldIndex(keys, name);
        if (i < 0) return fallback;
        return switch values[i] {
            case JString(value): value;
            case _: fallback;
        }
    }

    static function requiredNumber(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolNumberField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolNumberField.failure("missing_field", path, "required field is missing");
        return switch values[i] {
            case JNumber(value): ProtocolNumberField.success(value);
            case _: ProtocolNumberField.failure("expected_number", path, "expected JSON number");
        }
    }

    static function requiredBool(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolBoolField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolBoolField.failure("missing_field", path, "required field is missing");
        return switch values[i] {
            case JBool(value): ProtocolBoolField.success(value);
            case _: ProtocolBoolField.failure("expected_bool", path, "expected JSON boolean");
        }
    }

    static function requiredId(keys:Array<String>, values:Array<Value>, path:String):ProtocolValueField {
        final i = fieldIndex(keys, "id");
        if (i < 0) return ProtocolValueField.failure("missing_field", path, "required id is missing");
        return switch values[i] {
            case JString(_) | JNumber(_): ProtocolValueField.success(values[i]);
            case _: ProtocolValueField.failure("expected_request_id", path, "expected string or numeric request id");
        }
    }

    static function requiredValue(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolValueField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolValueField.failure("missing_field", path, "required field is missing");
        return ProtocolValueField.success(values[i]);
    }

    static function optionalValue(keys:Array<String>, values:Array<Value>, name:String):ProtocolValueField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolValueField.failure("missing_field", "$." + name, "optional field is missing");
        return ProtocolValueField.success(values[i]);
    }

    static function requiredObjectField(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolObjectField {
        final value = requiredValue(keys, values, name, path);
        if (!value.ok) return ProtocolObjectField.failure(value.errorCode, value.errorPath, value.errorMessage);
        return requireObject(value.value, path);
    }

    static function requireObject(value:Value, path:String):ProtocolObjectField {
        return switch value {
            case JObject(keys, values):
                ProtocolObjectField.success(keys, values);
            case _:
                ProtocolObjectField.failure("expected_object", path, "expected JSON object");
        }
    }

    static function requiredArray(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolArrayField {
        final value = requiredValue(keys, values, name, path);
        if (!value.ok) return ProtocolArrayField.failure(value.errorCode, value.errorPath, value.errorMessage);
        return switch value.value {
            case JArray(entries):
                ProtocolArrayField.success(entries);
            case _:
                ProtocolArrayField.failure("expected_array", path, "expected JSON array");
        }
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function contains(values:Array<String>, needle:String):Bool {
        for (value in values) {
            if (value == needle) return true;
        }
        return false;
    }

    static function hasField(keys:Array<String>, name:String):Bool {
        return fieldIndex(keys, name) >= 0;
    }

    static function quote(value:String):String {
        return codexhx.protocol.JsonScalar.quote(value);
    }
}

class ProtocolStringField {
    public final ok:Bool;
    public final value:String;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:String, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:String):ProtocolStringField {
        return new ProtocolStringField(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolStringField {
        return new ProtocolStringField(false, "", code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ProtocolNumberField {
    public final ok:Bool;
    public final value:Float;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Float, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Float):ProtocolNumberField {
        return new ProtocolNumberField(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolNumberField {
        return new ProtocolNumberField(false, 0, code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ProtocolBoolField {
    public final ok:Bool;
    public final value:Bool;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Bool, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Bool):ProtocolBoolField {
        return new ProtocolBoolField(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolBoolField {
        return new ProtocolBoolField(false, false, code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ProtocolValueField {
    public final ok:Bool;
    public final value:Value;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Value, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Value):ProtocolValueField {
        return new ProtocolValueField(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolValueField {
        return new ProtocolValueField(false, JNull, code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ProtocolObjectField {
    public final ok:Bool;
    public final keys:Array<String>;
    public final values:Array<Value>;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, keys:Array<String>, values:Array<Value>, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.keys = keys;
        this.values = values;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(keys:Array<String>, values:Array<Value>):ProtocolObjectField {
        return new ProtocolObjectField(true, keys, values, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolObjectField {
        return new ProtocolObjectField(false, [], [], code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ProtocolArrayField {
    public final ok:Bool;
    public final values:Array<Value>;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, values:Array<Value>, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.values = values;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(values:Array<Value>):ProtocolArrayField {
        return new ProtocolArrayField(true, values, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ProtocolArrayField {
        return new ProtocolArrayField(false, [], code, path, message);
    }

    public function toOutcome():AppProtocolParseOutcome {
        return AppProtocolParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}
