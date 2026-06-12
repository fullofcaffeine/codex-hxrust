package codexhx.protocol.app;

import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

class AppProtocol {
    static final REQUEST_METHODS:Array<String> = ["thread/start", "turn/start", "turn/interrupt", "thread/read", "windowsSandbox/setupStart", "windowsSandbox/readiness", "account/login/start", "account/login/cancel", "account/logout", "account/rateLimits/read", "account/usage/read", "account/sendAddCreditsNudgeEmail", "feedback/upload", "command/exec", "command/exec/write", "command/exec/terminate", "command/exec/resize", "process/spawn", "process/writeStdin", "process/kill", "process/resizePty", "config/read"];
    static final NOTIFICATION_METHODS:Array<String> = ["thread/started", "thread/status/changed", "thread/compacted", "turn/started", "turn/completed", "turn/plan/updated", "turn/moderationMetadata", "item/started", "item/completed", "item/agentMessage/delta", "item/plan/delta", "item/reasoning/summaryTextDelta", "item/reasoning/summaryPartAdded", "item/reasoning/textDelta", "item/commandExecution/outputDelta", "item/commandExecution/terminalInteraction", "item/fileChange/outputDelta", "item/fileChange/patchUpdated", "item/mcpToolCall/progress", "mcpServer/oauthLogin/completed", "mcpServer/startupStatus/updated", "account/updated", "account/login/completed", "account/rateLimits/updated", "app/list/updated", "remoteControl/status/changed", "model/rerouted", "model/verification", "warning", "guardianWarning", "deprecationNotice", "configWarning", "fuzzyFileSearch/sessionUpdated", "fuzzyFileSearch/sessionCompleted", "thread/realtime/started", "thread/realtime/itemAdded", "thread/realtime/transcript/delta", "thread/realtime/transcript/done", "thread/realtime/outputAudio/delta", "thread/realtime/sdp", "thread/realtime/error", "thread/realtime/closed", "windows/worldWritableWarning", "windowsSandbox/setupCompleted", "externalAgentConfig/import/completed", "fs/changed", "rawResponseItem/completed", "serverRequest/resolved", "command/exec/outputDelta", "process/outputDelta", "process/exited", "error"];
    static final FINGERPRINT_BASIS:String = "app-server-protocol:v2|requests:account/login/cancel,account/login/start,account/logout,account/rateLimits/read,account/sendAddCreditsNudgeEmail,account/usage/read,command/exec,command/exec/resize,command/exec/terminate,command/exec/write,config/read,feedback/upload,process/kill,process/resizePty,process/spawn,process/writeStdin,thread/read,thread/start,turn/interrupt,turn/start,windowsSandbox/readiness,windowsSandbox/setupStart|notifications:account/login/completed,account/rateLimits/updated,account/updated,app/list/updated,command/exec/outputDelta,configWarning,deprecationNotice,error,externalAgentConfig/import/completed,fs/changed,fuzzyFileSearch/sessionCompleted,fuzzyFileSearch/sessionUpdated,guardianWarning,item/agentMessage/delta,item/commandExecution/outputDelta,item/commandExecution/terminalInteraction,item/fileChange/outputDelta,item/fileChange/patchUpdated,item/mcpToolCall/progress,item/plan/delta,item/reasoning/summaryPartAdded,item/reasoning/summaryTextDelta,item/reasoning/textDelta,item/completed,item/started,mcpServer/oauthLogin/completed,mcpServer/startupStatus/updated,model/rerouted,model/verification,process/exited,process/outputDelta,rawResponseItem/completed,remoteControl/status/changed,serverRequest/resolved,thread/compacted,thread/realtime/closed,thread/realtime/error,thread/realtime/itemAdded,thread/realtime/outputAudio/delta,thread/realtime/sdp,thread/realtime/started,thread/realtime/transcript/delta,thread/realtime/transcript/done,thread/started,thread/status/changed,turn/completed,turn/moderationMetadata,turn/plan/updated,turn/started,warning,windows/worldWritableWarning,windowsSandbox/setupCompleted|items:agentMessage,plan,userMessage|errors:jsonrpc+turn-error";
    static final FINGERPRINT:String = "hxcx-app-protocol-v2-subset-2026-06-12-049";

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

        final params = if (acceptsOptionalEmptyParams(fixtureMethod)) {
            optionalEmptyParams(object);
        } else {
            requiredObjectField(object.keys, object.values, "params", "$.message.params");
        }
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
            case "windowsSandbox/setupStart":
                validateWindowsSandboxSetupStartResponse(result);
            case "windowsSandbox/readiness":
                validateWindowsSandboxReadinessResponse(result);
            case "account/login/start":
                validateLoginAccountResponse(result);
            case "account/login/cancel":
                validateCancelLoginAccountResponse(result);
            case "account/logout":
                validateEmptyObject(result, "$.message.result", "response:account/logout");
            case "account/rateLimits/read":
                validateGetAccountRateLimitsResponse(result);
            case "account/usage/read":
                validateGetAccountTokenUsageResponse(result);
            case "account/sendAddCreditsNudgeEmail":
                validateSendAddCreditsNudgeEmailResponse(result);
            case "feedback/upload":
                validateFeedbackUploadResponse(result);
            case "command/exec":
                validateCommandExecResponse(result);
            case "command/exec/write":
                validateEmptyObject(result, "$.message.result", "response:command/exec/write");
            case "command/exec/terminate":
                validateEmptyObject(result, "$.message.result", "response:command/exec/terminate");
            case "command/exec/resize":
                validateEmptyObject(result, "$.message.result", "response:command/exec/resize");
            case "process/spawn":
                validateEmptyObject(result, "$.message.result", "response:process/spawn");
            case "process/writeStdin":
                validateEmptyObject(result, "$.message.result", "response:process/writeStdin");
            case "process/kill":
                validateEmptyObject(result, "$.message.result", "response:process/kill");
            case "process/resizePty":
                validateEmptyObject(result, "$.message.result", "response:process/resizePty");
            case "config/read":
                validateConfigReadResponse(result);
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
            case "thread/compacted":
                validateContextCompactedNotification(params);
            case "turn/started" | "turn/completed":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final turn = requiredObjectField(params.keys, params.values, "turn", "$.message.params.turn");
                if (!turn.ok) return turn.toOutcome();
                validateTurn(turn, "$.message.params.turn");
            case "turn/plan/updated":
                validateTurnPlanUpdatedNotification(params);
            case "turn/moderationMetadata":
                validateTurnModerationMetadataNotification(params);
            case "item/started":
                validateItemNotification(params, true);
            case "item/agentMessage/delta":
                validateAgentMessageDeltaNotification(params);
            case "item/plan/delta":
                validatePlanDeltaNotification(params);
            case "item/reasoning/summaryTextDelta":
                validateReasoningSummaryTextDeltaNotification(params);
            case "item/reasoning/summaryPartAdded":
                validateReasoningSummaryPartAddedNotification(params);
            case "item/reasoning/textDelta":
                validateReasoningTextDeltaNotification(params);
            case "item/commandExecution/outputDelta":
                validateCommandExecutionOutputDeltaNotification(params);
            case "item/commandExecution/terminalInteraction":
                validateTerminalInteractionNotification(params);
            case "item/fileChange/outputDelta":
                validateFileChangeOutputDeltaNotification(params);
            case "item/fileChange/patchUpdated":
                validateFileChangePatchUpdatedNotification(params);
            case "item/mcpToolCall/progress":
                validateMcpToolCallProgressNotification(params);
            case "mcpServer/oauthLogin/completed":
                validateMcpServerOauthLoginCompletedNotification(params);
            case "mcpServer/startupStatus/updated":
                validateMcpServerStatusUpdatedNotification(params);
            case "account/updated":
                validateAccountUpdatedNotification(params);
            case "account/login/completed":
                validateAccountLoginCompletedNotification(params);
            case "account/rateLimits/updated":
                validateAccountRateLimitsUpdatedNotification(params);
            case "app/list/updated":
                validateAppListUpdatedNotification(params);
            case "remoteControl/status/changed":
                validateRemoteControlStatusChangedNotification(params);
            case "model/rerouted":
                validateModelReroutedNotification(params);
            case "model/verification":
                validateModelVerificationNotification(params);
            case "warning":
                validateWarningNotification(params);
            case "guardianWarning":
                validateGuardianWarningNotification(params);
            case "deprecationNotice":
                validateDeprecationNoticeNotification(params);
            case "configWarning":
                validateConfigWarningNotification(params);
            case "fuzzyFileSearch/sessionUpdated":
                validateFuzzyFileSearchSessionUpdatedNotification(params);
            case "fuzzyFileSearch/sessionCompleted":
                validateFuzzyFileSearchSessionCompletedNotification(params);
            case "thread/realtime/started":
                validateThreadRealtimeStartedNotification(params);
            case "thread/realtime/itemAdded":
                validateThreadRealtimeItemAddedNotification(params);
            case "thread/realtime/transcript/delta":
                validateThreadRealtimeTranscriptDeltaNotification(params);
            case "thread/realtime/transcript/done":
                validateThreadRealtimeTranscriptDoneNotification(params);
            case "thread/realtime/outputAudio/delta":
                validateThreadRealtimeOutputAudioDeltaNotification(params);
            case "thread/realtime/sdp":
                validateThreadRealtimeSdpNotification(params);
            case "thread/realtime/error":
                validateThreadRealtimeErrorNotification(params);
            case "thread/realtime/closed":
                validateThreadRealtimeClosedNotification(params);
            case "windows/worldWritableWarning":
                validateWindowsWorldWritableWarningNotification(params);
            case "windowsSandbox/setupCompleted":
                validateWindowsSandboxSetupCompletedNotification(params);
            case "externalAgentConfig/import/completed":
                validateExternalAgentConfigImportCompletedNotification(params);
            case "fs/changed":
                validateFsChangedNotification(params);
            case "rawResponseItem/completed":
                validateRawResponseItemCompletedNotification(params);
            case "serverRequest/resolved":
                validateServerRequestResolvedNotification(params);
            case "command/exec/outputDelta":
                validateCommandExecOutputDeltaNotification(params);
            case "process/outputDelta":
                validateProcessOutputDeltaNotification(params);
            case "process/exited":
                validateProcessExitedNotification(params);
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

    static function acceptsOptionalEmptyParams(method:String):Bool {
        return method == "windowsSandbox/readiness" || method == "account/logout" || method == "account/rateLimits/read" || method == "account/usage/read";
    }

    static function optionalEmptyParams(object:ProtocolObjectField):ProtocolObjectField {
        final paramsIndex = fieldIndex(object.keys, "params");
        if (paramsIndex < 0) return ProtocolObjectField.success([], []);
        return switch object.values[paramsIndex] {
            case JNull:
                ProtocolObjectField.success([], []);
            case JObject(keys, values):
                ProtocolObjectField.success(keys, values);
            case _:
                ProtocolObjectField.failure("expected_nullable_object", "$.message.params", "expected JSON object, null, or missing params");
        }
    }

    static function validateEmptyObject(object:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        if (object.keys.length != 0) return fail("unexpected_field", path + "." + object.keys[0], "expected empty JSON object");
        return success(label);
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
            case "windowsSandbox/setupStart":
                validateWindowsSandboxSetupStartParams(params);
            case "windowsSandbox/readiness":
                success("params:windowsSandbox/readiness");
            case "account/login/start":
                validateLoginAccountParams(params);
            case "account/login/cancel":
                validateCancelLoginAccountParams(params);
            case "account/logout":
                success("params:account/logout");
            case "account/rateLimits/read":
                success("params:account/rateLimits/read");
            case "account/usage/read":
                success("params:account/usage/read");
            case "account/sendAddCreditsNudgeEmail":
                validateSendAddCreditsNudgeEmailParams(params);
            case "feedback/upload":
                validateFeedbackUploadParams(params);
            case "command/exec":
                validateCommandExecParams(params);
            case "command/exec/write":
                validateCommandExecWriteParams(params);
            case "command/exec/terminate":
                validateCommandExecProcessOnlyParams(params, "params:command/exec/terminate");
            case "command/exec/resize":
                validateCommandExecResizeParams(params);
            case "process/spawn":
                validateProcessSpawnParams(params);
            case "process/writeStdin":
                validateProcessWriteStdinParams(params);
            case "process/kill":
                validateProcessHandleOnlyParams(params, "params:process/kill");
            case "process/resizePty":
                validateProcessResizePtyParams(params);
            case "config/read":
                validateConfigReadParams(params);
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

    static function validateContextCompactedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        return success("notification:thread/compacted");
    }

    static function validateTurnModerationMetadataNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final metadata = requiredValue(params.keys, params.values, "metadata", "$.message.params.metadata");
        if (!metadata.ok) return metadata.toOutcome();
        return success("notification:turn/moderationMetadata");
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

    static function validateReasoningSummaryTextDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final summaryIndex = requiredInteger(params.keys, params.values, "summaryIndex", "$.message.params.summaryIndex");
        if (!summaryIndex.ok) return summaryIndex.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/reasoning/summaryTextDelta");
    }

    static function validateReasoningSummaryPartAddedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final summaryIndex = requiredInteger(params.keys, params.values, "summaryIndex", "$.message.params.summaryIndex");
        if (!summaryIndex.ok) return summaryIndex.toOutcome();
        return success("notification:item/reasoning/summaryPartAdded");
    }

    static function validateReasoningTextDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final contentIndex = requiredInteger(params.keys, params.values, "contentIndex", "$.message.params.contentIndex");
        if (!contentIndex.ok) return contentIndex.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/reasoning/textDelta");
    }

    static function validateCommandExecutionOutputDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/commandExecution/outputDelta");
    }

    static function validateTerminalInteractionNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final processId = requiredString(params.keys, params.values, "processId", "$.message.params.processId");
        if (!processId.ok) return processId.toOutcome();
        final stdin = requiredString(params.keys, params.values, "stdin", "$.message.params.stdin");
        if (!stdin.ok) return stdin.toOutcome();
        return success("notification:item/commandExecution/terminalInteraction");
    }

    static function validateFileChangeOutputDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:item/fileChange/outputDelta");
    }

    static function validateFileChangePatchUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final changes = requiredArray(params.keys, params.values, "changes", "$.message.params.changes");
        if (!changes.ok) return changes.toOutcome();
        return validateFileUpdateChanges(changes.values, "$.message.params.changes");
    }

    static function validateFileUpdateChanges(entries:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            final changePath = path + "[" + Std.string(i) + "]";
            final change = requireObject(entries[i], changePath);
            if (!change.ok) return change.toOutcome();
            final diff = requiredString(change.keys, change.values, "diff", changePath + ".diff");
            if (!diff.ok) return diff.toOutcome();
            final kind = requiredObjectField(change.keys, change.values, "kind", changePath + ".kind");
            if (!kind.ok) return kind.toOutcome();
            final kindResult = validatePatchChangeKind(kind, changePath + ".kind");
            if (!kindResult.ok) return kindResult;
            final filePath = requiredString(change.keys, change.values, "path", changePath + ".path");
            if (!filePath.ok) return filePath.toOutcome();
            i = i + 1;
        }
        return success("notification:item/fileChange/patchUpdated");
    }

    static function validatePatchChangeKind(kind:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final kindType = requiredString(kind.keys, kind.values, "type", path + ".type");
        if (!kindType.ok) return kindType.toOutcome();

        return switch kindType.value {
            case "add" | "delete":
                success("patch-change-kind:" + kindType.value);
            case "update":
                final movePathIndex = fieldIndex(kind.keys, "move_path");
                if (movePathIndex >= 0) {
                    switch kind.values[movePathIndex] {
                        case JString(_) | JNull:
                        case _:
                            return fail("expected_nullable_string", path + ".move_path", "expected JSON string or null");
                    }
                }
                success("patch-change-kind:update");
            case _:
                fail("invalid_patch_change_kind", path + ".type", "unsupported patch change kind");
        }
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

    static function validateServerRequestResolvedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final requestId = requiredRequestId(params.keys, params.values, "requestId", "$.message.params.requestId");
        if (!requestId.ok) return requestId.toOutcome();
        return success("notification:serverRequest/resolved");
    }

    static function validateMcpToolCallProgressNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", "$.message.params.itemId");
        if (!itemId.ok) return itemId.toOutcome();
        final message = requiredString(params.keys, params.values, "message", "$.message.params.message");
        if (!message.ok) return message.toOutcome();
        return success("notification:item/mcpToolCall/progress");
    }

    static function validateMcpServerOauthLoginCompletedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final name = requiredString(params.keys, params.values, "name", "$.message.params.name");
        if (!name.ok) return name.toOutcome();
        final successFlag = requiredBool(params.keys, params.values, "success", "$.message.params.success");
        if (!successFlag.ok) return successFlag.toOutcome();
        final errorIndex = fieldIndex(params.keys, "error");
        if (errorIndex >= 0) {
            switch params.values[errorIndex] {
                case JString(_) | JNull:
                case _:
                    return fail("expected_nullable_string", "$.message.params.error", "expected JSON string or null");
            }
        }
        return success("notification:mcpServer/oauthLogin/completed");
    }

    static function validateMcpServerStatusUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final name = requiredString(params.keys, params.values, "name", "$.message.params.name");
        if (!name.ok) return name.toOutcome();
        final status = requiredString(params.keys, params.values, "status", "$.message.params.status");
        if (!status.ok) return status.toOutcome();
        if (!validMcpServerStartupStatus(status.value)) return fail("invalid_mcp_server_startup_status", "$.message.params.status", "unsupported MCP server startup status");

        final threadIdIndex = fieldIndex(params.keys, "threadId");
        if (threadIdIndex >= 0) {
            switch params.values[threadIdIndex] {
                case JString(_) | JNull:
                case _:
                    return fail("expected_nullable_string", "$.message.params.threadId", "expected JSON string or null");
            }
        }
        final errorIndex = fieldIndex(params.keys, "error");
        if (errorIndex >= 0) {
            switch params.values[errorIndex] {
                case JString(_) | JNull:
                case _:
                    return fail("expected_nullable_string", "$.message.params.error", "expected JSON string or null");
            }
        }
        return success("notification:mcpServer/startupStatus/updated");
    }

    static function validateAccountUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final authModeIndex = fieldIndex(params.keys, "authMode");
        if (authModeIndex >= 0) {
            switch params.values[authModeIndex] {
                case JNull:
                case JString(value):
                    if (!validAccountAuthMode(value)) return fail("invalid_account_auth_mode", "$.message.params.authMode", "unsupported account auth mode");
                case _:
                    return fail("expected_nullable_string", "$.message.params.authMode", "expected JSON string or null");
            }
        }

        final planTypeIndex = fieldIndex(params.keys, "planType");
        if (planTypeIndex >= 0) {
            switch params.values[planTypeIndex] {
                case JNull:
                case JString(value):
                    if (!validAccountPlanType(value)) return fail("invalid_account_plan_type", "$.message.params.planType", "unsupported account plan type");
                case _:
                    return fail("expected_nullable_string", "$.message.params.planType", "expected JSON string or null");
            }
        }

        return success("notification:account/updated");
    }

    static function validateLoginAccountParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final typeField = requiredString(params.keys, params.values, "type", "$.message.params.type");
        if (!typeField.ok) return typeField.toOutcome();

        return switch typeField.value {
            case "apiKey":
                final apiKey = requiredString(params.keys, params.values, "apiKey", "$.message.params.apiKey");
                if (!apiKey.ok) return apiKey.toOutcome();
                success("params:account/login/start:apiKey");
            case "chatgpt":
                final streamlined = validateOptionalBool(params, "codexStreamlinedLogin", "$.message.params.codexStreamlinedLogin");
                if (!streamlined.ok) return streamlined;
                success("params:account/login/start:chatgpt");
            case "chatgptDeviceCode":
                success("params:account/login/start:chatgptDeviceCode");
            case "chatgptAuthTokens":
                final accessToken = requiredString(params.keys, params.values, "accessToken", "$.message.params.accessToken");
                if (!accessToken.ok) return accessToken.toOutcome();
                final accountId = requiredString(params.keys, params.values, "chatgptAccountId", "$.message.params.chatgptAccountId");
                if (!accountId.ok) return accountId.toOutcome();
                final planType = validateOptionalNullableString(params, "chatgptPlanType", "$.message.params.chatgptPlanType");
                if (!planType.ok) return planType;
                success("params:account/login/start:chatgptAuthTokens");
            case _:
                fail("invalid_login_account_type", "$.message.params.type", "unsupported account login type");
        }
    }

    static function validateLoginAccountResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final typeField = requiredString(result.keys, result.values, "type", "$.message.result.type");
        if (!typeField.ok) return typeField.toOutcome();

        return switch typeField.value {
            case "apiKey":
                success("response:account/login/start:apiKey");
            case "chatgpt":
                final loginId = requiredString(result.keys, result.values, "loginId", "$.message.result.loginId");
                if (!loginId.ok) return loginId.toOutcome();
                final authUrl = requiredString(result.keys, result.values, "authUrl", "$.message.result.authUrl");
                if (!authUrl.ok) return authUrl.toOutcome();
                success("response:account/login/start:chatgpt");
            case "chatgptDeviceCode":
                final loginId = requiredString(result.keys, result.values, "loginId", "$.message.result.loginId");
                if (!loginId.ok) return loginId.toOutcome();
                final verificationUrl = requiredString(result.keys, result.values, "verificationUrl", "$.message.result.verificationUrl");
                if (!verificationUrl.ok) return verificationUrl.toOutcome();
                final userCode = requiredString(result.keys, result.values, "userCode", "$.message.result.userCode");
                if (!userCode.ok) return userCode.toOutcome();
                success("response:account/login/start:chatgptDeviceCode");
            case "chatgptAuthTokens":
                success("response:account/login/start:chatgptAuthTokens");
            case _:
                fail("invalid_login_account_type", "$.message.result.type", "unsupported account login type");
        }
    }

    static function validateCancelLoginAccountParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final loginId = requiredString(params.keys, params.values, "loginId", "$.message.params.loginId");
        if (!loginId.ok) return loginId.toOutcome();
        return success("params:account/login/cancel");
    }

    static function validateCancelLoginAccountResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final status = requiredString(result.keys, result.values, "status", "$.message.result.status");
        if (!status.ok) return status.toOutcome();
        if (!validCancelLoginAccountStatus(status.value)) return fail("invalid_cancel_login_account_status", "$.message.result.status", "unsupported account login cancel status");
        return success("response:account/login/cancel");
    }

    static function validateAccountLoginCompletedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final successFlag = requiredBool(params.keys, params.values, "success", "$.message.params.success");
        if (!successFlag.ok) return successFlag.toOutcome();
        final loginId = validateOptionalNullableString(params, "loginId", "$.message.params.loginId");
        if (!loginId.ok) return loginId;
        final error = validateOptionalNullableString(params, "error", "$.message.params.error");
        if (!error.ok) return error;
        return success("notification:account/login/completed");
    }

    static function validateGetAccountRateLimitsResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final rateLimits = requiredObjectField(result.keys, result.values, "rateLimits", "$.message.result.rateLimits");
        if (!rateLimits.ok) return rateLimits.toOutcome();
        final rateLimitsResult = validateRateLimitSnapshot(rateLimits, "$.message.result.rateLimits");
        if (!rateLimitsResult.ok) return rateLimitsResult;
        final byLimitId = validateOptionalRateLimitSnapshotMap(result, "rateLimitsByLimitId", "$.message.result.rateLimitsByLimitId");
        if (!byLimitId.ok) return byLimitId;
        return success("response:account/rateLimits/read");
    }

    static function validateOptionalRateLimitSnapshotMap(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("rate-limits:missing-map");
        return switch object.values[i] {
            case JNull:
                success("rate-limits:null-map");
            case JObject(keys, values):
                var entryIndex = 0;
                while (entryIndex < values.length) {
                    final snapshot = requireObject(values[entryIndex], path + "." + keys[entryIndex]);
                    if (!snapshot.ok) return snapshot.toOutcome();
                    final snapshotResult = validateRateLimitSnapshot(snapshot, path + "." + keys[entryIndex]);
                    if (!snapshotResult.ok) return snapshotResult;
                    entryIndex = entryIndex + 1;
                }
                success("rate-limits:map");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateGetAccountTokenUsageResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final summary = requiredObjectField(result.keys, result.values, "summary", "$.message.result.summary");
        if (!summary.ok) return summary.toOutcome();
        final summaryResult = validateAccountTokenUsageSummary(summary, "$.message.result.summary");
        if (!summaryResult.ok) return summaryResult;
        final buckets = validateOptionalNullableAccountTokenUsageBuckets(result, "dailyUsageBuckets", "$.message.result.dailyUsageBuckets");
        if (!buckets.ok) return buckets;
        return success("response:account/usage/read");
    }

    static function validateAccountTokenUsageSummary(summary:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        for (field in ["lifetimeTokens", "peakDailyTokens", "longestRunningTurnSec", "currentStreakDays", "longestStreakDays"]) {
            final result = validateOptionalNullableInteger(summary, field, path + "." + field);
            if (!result.ok) return result;
        }
        return success("account-token-usage:summary");
    }

    static function validateOptionalNullableAccountTokenUsageBuckets(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("account-token-usage:missing-buckets");
        return switch object.values[i] {
            case JNull:
                success("account-token-usage:null-buckets");
            case JArray(values):
                var j = 0;
                while (j < values.length) {
                    final bucketPath = path + "[" + Std.string(j) + "]";
                    final bucket = requireObject(values[j], bucketPath);
                    if (!bucket.ok) return bucket.toOutcome();
                    final startDate = requiredString(bucket.keys, bucket.values, "startDate", bucketPath + ".startDate");
                    if (!startDate.ok) return startDate.toOutcome();
                    final tokens = requiredInteger(bucket.keys, bucket.values, "tokens", bucketPath + ".tokens");
                    if (!tokens.ok) return tokens.toOutcome();
                    j = j + 1;
                }
                success("account-token-usage:buckets");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateSendAddCreditsNudgeEmailParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final creditType = requiredString(params.keys, params.values, "creditType", "$.message.params.creditType");
        if (!creditType.ok) return creditType.toOutcome();
        if (!validAddCreditsNudgeCreditType(creditType.value)) return fail("invalid_add_credits_nudge_credit_type", "$.message.params.creditType", "unsupported add-credits nudge credit type");
        return success("params:account/sendAddCreditsNudgeEmail");
    }

    static function validateSendAddCreditsNudgeEmailResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final status = requiredString(result.keys, result.values, "status", "$.message.result.status");
        if (!status.ok) return status.toOutcome();
        if (!validAddCreditsNudgeEmailStatus(status.value)) return fail("invalid_add_credits_nudge_email_status", "$.message.result.status", "unsupported add-credits nudge email status");
        return success("response:account/sendAddCreditsNudgeEmail");
    }

    static function validateFeedbackUploadParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final classification = requiredString(params.keys, params.values, "classification", "$.message.params.classification");
        if (!classification.ok) return classification.toOutcome();
        final reason = validateOptionalNullableString(params, "reason", "$.message.params.reason");
        if (!reason.ok) return reason;
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        final includeLogs = validateOptionalBool(params, "includeLogs", "$.message.params.includeLogs");
        if (!includeLogs.ok) return includeLogs;
        final extraLogFiles = validateOptionalStringArray(params, "extraLogFiles", "$.message.params.extraLogFiles", true);
        if (!extraLogFiles.ok) return extraLogFiles;
        final tags = validateOptionalStringMap(params, "tags", "$.message.params.tags");
        if (!tags.ok) return tags;
        return success("params:feedback/upload");
    }

    static function validateFeedbackUploadResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(result.keys, result.values, "threadId", "$.message.result.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        return success("response:feedback/upload");
    }

    static function validateCommandExecParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final command = requiredArray(params.keys, params.values, "command", "$.message.params.command");
        if (!command.ok) return command.toOutcome();
        final commandResult = validateRequiredNonEmptyStringArray(command.values, "$.message.params.command");
        if (!commandResult.ok) return commandResult;

        final processId = validateOptionalNullableString(params, "processId", "$.message.params.processId");
        if (!processId.ok) return processId;
        final tty = optionalBoolValue(params, "tty", "$.message.params.tty");
        if (!tty.ok) return tty.toOutcome();
        final streamStdin = optionalBoolValue(params, "streamStdin", "$.message.params.streamStdin");
        if (!streamStdin.ok) return streamStdin.toOutcome();
        final streamStdoutStderr = optionalBoolValue(params, "streamStdoutStderr", "$.message.params.streamStdoutStderr");
        if (!streamStdoutStderr.ok) return streamStdoutStderr.toOutcome();

        if ((tty.value || streamStdin.value || streamStdoutStderr.value) && !hasNonNullField(params, "processId")) {
            return fail("missing_process_id", "$.message.params.processId", "processId is required for tty or streaming command execution");
        }

        final outputBytesCap = validateOptionalNullableUInt(params, "outputBytesCap", "$.message.params.outputBytesCap");
        if (!outputBytesCap.ok) return outputBytesCap;
        final disableOutputCap = optionalBoolValue(params, "disableOutputCap", "$.message.params.disableOutputCap");
        if (!disableOutputCap.ok) return disableOutputCap.toOutcome();
        if (disableOutputCap.value && hasNonNullField(params, "outputBytesCap")) {
            return fail("incompatible_output_cap", "$.message.params.outputBytesCap", "outputBytesCap cannot be combined with disableOutputCap");
        }

        final timeoutMs = validateOptionalNullableInteger(params, "timeoutMs", "$.message.params.timeoutMs");
        if (!timeoutMs.ok) return timeoutMs;
        final disableTimeout = optionalBoolValue(params, "disableTimeout", "$.message.params.disableTimeout");
        if (!disableTimeout.ok) return disableTimeout.toOutcome();
        if (disableTimeout.value && hasNonNullField(params, "timeoutMs")) {
            return fail("incompatible_timeout", "$.message.params.timeoutMs", "timeoutMs cannot be combined with disableTimeout");
        }

        final cwd = validateOptionalNullableString(params, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd;
        final env = validateOptionalNullableStringMap(params, "env", "$.message.params.env");
        if (!env.ok) return env;
        final size = validateOptionalCommandExecTerminalSize(params, "size", "$.message.params.size");
        if (!size.ok) return size;
        if (hasNonNullField(params, "size") && !tty.value) return fail("terminal_size_without_tty", "$.message.params.size", "size is only valid when tty is true");

        final sandboxPolicy = validateOptionalCommandExecSandboxPolicy(params, "sandboxPolicy", "$.message.params.sandboxPolicy");
        if (!sandboxPolicy.ok) return sandboxPolicy;
        final permissionProfile = validateOptionalNullableString(params, "permissionProfile", "$.message.params.permissionProfile");
        if (!permissionProfile.ok) return permissionProfile;
        if (hasNonNullField(params, "sandboxPolicy") && hasNonNullField(params, "permissionProfile")) {
            return fail("incompatible_sandbox_policy", "$.message.params.permissionProfile", "permissionProfile cannot be combined with sandboxPolicy");
        }

        return success("params:command/exec");
    }

    static function validateCommandExecWriteParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processId = requiredString(params.keys, params.values, "processId", "$.message.params.processId");
        if (!processId.ok) return processId.toOutcome();
        final deltaBase64 = validateOptionalNullableString(params, "deltaBase64", "$.message.params.deltaBase64");
        if (!deltaBase64.ok) return deltaBase64;
        final closeStdin = validateOptionalBool(params, "closeStdin", "$.message.params.closeStdin");
        if (!closeStdin.ok) return closeStdin;
        return success("params:command/exec/write");
    }

    static function validateCommandExecProcessOnlyParams(params:ProtocolObjectField, label:String):AppProtocolParseOutcome {
        final processId = requiredString(params.keys, params.values, "processId", "$.message.params.processId");
        if (!processId.ok) return processId.toOutcome();
        return success(label);
    }

    static function validateCommandExecResizeParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processId = requiredString(params.keys, params.values, "processId", "$.message.params.processId");
        if (!processId.ok) return processId.toOutcome();
        final size = requiredObjectField(params.keys, params.values, "size", "$.message.params.size");
        if (!size.ok) return size.toOutcome();
        final sizeResult = validateCommandExecTerminalSizeObject(size, "$.message.params.size");
        if (!sizeResult.ok) return sizeResult;
        return success("params:command/exec/resize");
    }

    static function validateProcessSpawnParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final command = requiredArray(params.keys, params.values, "command", "$.message.params.command");
        if (!command.ok) return command.toOutcome();
        final commandResult = validateRequiredNonEmptyStringArray(command.values, "$.message.params.command");
        if (!commandResult.ok) return commandResult;

        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        final cwd = requiredString(params.keys, params.values, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd.toOutcome();

        final tty = optionalBoolValue(params, "tty", "$.message.params.tty");
        if (!tty.ok) return tty.toOutcome();
        final streamStdin = optionalBoolValue(params, "streamStdin", "$.message.params.streamStdin");
        if (!streamStdin.ok) return streamStdin.toOutcome();
        final streamStdoutStderr = optionalBoolValue(params, "streamStdoutStderr", "$.message.params.streamStdoutStderr");
        if (!streamStdoutStderr.ok) return streamStdoutStderr.toOutcome();

        final outputBytesCap = validateOptionalNullableUInt(params, "outputBytesCap", "$.message.params.outputBytesCap");
        if (!outputBytesCap.ok) return outputBytesCap;
        final timeoutMs = validateOptionalNullableInteger(params, "timeoutMs", "$.message.params.timeoutMs");
        if (!timeoutMs.ok) return timeoutMs;
        final env = validateOptionalNullableStringMap(params, "env", "$.message.params.env");
        if (!env.ok) return env;
        final size = validateOptionalCommandExecTerminalSize(params, "size", "$.message.params.size");
        if (!size.ok) return size;
        if (hasNonNullField(params, "size") && !tty.value) return fail("terminal_size_without_tty", "$.message.params.size", "size is only valid when tty is true");

        return success("params:process/spawn");
    }

    static function validateProcessWriteStdinParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        final deltaBase64 = validateOptionalNullableString(params, "deltaBase64", "$.message.params.deltaBase64");
        if (!deltaBase64.ok) return deltaBase64;
        final closeStdin = validateOptionalBool(params, "closeStdin", "$.message.params.closeStdin");
        if (!closeStdin.ok) return closeStdin;
        return success("params:process/writeStdin");
    }

    static function validateProcessHandleOnlyParams(params:ProtocolObjectField, label:String):AppProtocolParseOutcome {
        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        return success(label);
    }

    static function validateProcessResizePtyParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        final size = requiredObjectField(params.keys, params.values, "size", "$.message.params.size");
        if (!size.ok) return size.toOutcome();
        final sizeResult = validateCommandExecTerminalSizeObject(size, "$.message.params.size");
        if (!sizeResult.ok) return sizeResult;
        return success("params:process/resizePty");
    }

    static function validateConfigReadParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final includeLayers = validateOptionalBool(params, "includeLayers", "$.message.params.includeLayers");
        if (!includeLayers.ok) return includeLayers;
        final cwd = validateOptionalNullableString(params, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd;
        return success("params:config/read");
    }

    static function validateConfigReadResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final config = requiredObjectField(result.keys, result.values, "config", "$.message.result.config");
        if (!config.ok) return config.toOutcome();
        final configResult = validateConfigReadConfig(config, "$.message.result.config");
        if (!configResult.ok) return configResult;
        final origins = requiredObjectField(result.keys, result.values, "origins", "$.message.result.origins");
        if (!origins.ok) return origins.toOutcome();
        final originsResult = validateConfigLayerMetadataMap(origins, "$.message.result.origins");
        if (!originsResult.ok) return originsResult;
        final layers = validateOptionalNullableConfigLayers(result, "layers", "$.message.result.layers");
        if (!layers.ok) return layers;
        return success("response:config/read");
    }

    static function validateConfigReadConfig(config:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        for (field in ["model", "review_model", "model_provider", "instructions", "developer_instructions", "compact_prompt", "service_tier"]) {
            final result = validateOptionalNullableString(config, field, path + "." + field);
            if (!result.ok) return result;
        }
        for (field in ["model_context_window", "model_auto_compact_token_limit"]) {
            final result = validateOptionalNullableInteger(config, field, path + "." + field);
            if (!result.ok) return result;
        }

        final autoCompactScope = validateOptionalNullableStringEnum(config, "model_auto_compact_token_limit_scope", path + ".model_auto_compact_token_limit_scope", ["total", "body_after_prefix"], "invalid_auto_compact_token_limit_scope");
        if (!autoCompactScope.ok) return autoCompactScope;
        final approvalPolicy = validateOptionalAskForApproval(config, "approval_policy", path + ".approval_policy");
        if (!approvalPolicy.ok) return approvalPolicy;
        final approvalsReviewer = validateOptionalNullableStringEnum(config, "approvals_reviewer", path + ".approvals_reviewer", ["user", "auto_review", "guardian_subagent"], "invalid_approvals_reviewer");
        if (!approvalsReviewer.ok) return approvalsReviewer;
        final sandboxMode = validateOptionalNullableStringEnum(config, "sandbox_mode", path + ".sandbox_mode", ["read-only", "workspace-write", "danger-full-access"], "invalid_sandbox_mode");
        if (!sandboxMode.ok) return sandboxMode;
        final sandboxWorkspaceWrite = validateOptionalSandboxWorkspaceWrite(config, "sandbox_workspace_write", path + ".sandbox_workspace_write");
        if (!sandboxWorkspaceWrite.ok) return sandboxWorkspaceWrite;
        final forcedWorkspaceId = validateOptionalForcedChatgptWorkspaceId(config, "forced_chatgpt_workspace_id", path + ".forced_chatgpt_workspace_id");
        if (!forcedWorkspaceId.ok) return forcedWorkspaceId;
        final forcedLoginMethod = validateOptionalNullableStringEnum(config, "forced_login_method", path + ".forced_login_method", ["chatgpt", "api"], "invalid_forced_login_method");
        if (!forcedLoginMethod.ok) return forcedLoginMethod;
        final webSearch = validateOptionalNullableStringEnum(config, "web_search", path + ".web_search", ["disabled", "cached", "live"], "invalid_web_search_mode");
        if (!webSearch.ok) return webSearch;
        final tools = validateOptionalToolsV2(config, "tools", path + ".tools");
        if (!tools.ok) return tools;
        final reasoningEffort = validateOptionalNullableNonEmptyString(config, "model_reasoning_effort", path + ".model_reasoning_effort");
        if (!reasoningEffort.ok) return reasoningEffort;
        final reasoningSummary = validateOptionalNullableStringEnum(config, "model_reasoning_summary", path + ".model_reasoning_summary", ["auto", "concise", "detailed", "none"], "invalid_reasoning_summary");
        if (!reasoningSummary.ok) return reasoningSummary;
        final verbosity = validateOptionalNullableStringEnum(config, "model_verbosity", path + ".model_verbosity", ["low", "medium", "high"], "invalid_model_verbosity");
        if (!verbosity.ok) return verbosity;
        final analytics = validateOptionalAnalyticsConfig(config, "analytics", path + ".analytics");
        if (!analytics.ok) return analytics;
        final desktop = validateOptionalNullableObject(config, "desktop", path + ".desktop");
        if (!desktop.ok) return desktop;
        final apps = validateOptionalAppsConfig(config, "apps", path + ".apps");
        if (!apps.ok) return apps;
        return success("config");
    }

    static function validateOptionalAskForApproval(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("ask-for-approval:missing");
        return switch object.values[i] {
            case JNull:
                success("ask-for-approval:null");
            case JString(value):
                if (contains(["untrusted", "on-failure", "on-request", "never"], value)) success("ask-for-approval") else fail("invalid_approval_policy", path, "unsupported approval policy");
            case JObject(keys, values):
                final granular = requiredObjectField(keys, values, "granular", path + ".granular");
                if (!granular.ok) return granular.toOutcome();
                for (field in ["mcp_elicitations", "rules", "sandbox_approval"]) {
                    final required = requiredBool(granular.keys, granular.values, field, path + ".granular." + field);
                    if (!required.ok) return required.toOutcome();
                }
                for (field in ["request_permissions", "skill_approval"]) {
                    final optional = validateOptionalBool(granular, field, path + ".granular." + field);
                    if (!optional.ok) return optional;
                }
                success("ask-for-approval:granular");
            case _:
                fail("expected_approval_policy", path, "expected approval policy string, granular object, or null");
        }
    }

    static function validateOptionalSandboxWorkspaceWrite(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("sandbox-workspace-write:missing");
        return switch object.values[i] {
            case JNull:
                success("sandbox-workspace-write:null");
            case JObject(keys, values):
                final workspace = ProtocolObjectField.success(keys, values);
                final writableRoots = validateOptionalStringArray(workspace, "writable_roots", path + ".writable_roots", false);
                if (!writableRoots.ok) return writableRoots;
                for (field in ["network_access", "exclude_tmpdir_env_var", "exclude_slash_tmp"]) {
                    final result = validateOptionalBool(workspace, field, path + "." + field);
                    if (!result.ok) return result;
                }
                success("sandbox-workspace-write");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalForcedChatgptWorkspaceId(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("forced-chatgpt-workspace-id:missing");
        return switch object.values[i] {
            case JNull | JString(_):
                success("forced-chatgpt-workspace-id");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    switch entries[entryIndex] {
                        case JString(_):
                        case _:
                            return fail("expected_string", path + "[" + Std.string(entryIndex) + "]", "expected JSON string");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("forced-chatgpt-workspace-id");
            case _:
                fail("expected_string_or_string_array", path, "expected JSON string, string array, or null");
        }
    }

    static function validateOptionalToolsV2(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("tools-v2:missing");
        return switch object.values[i] {
            case JNull:
                success("tools-v2:null");
            case JObject(keys, values):
                final tools = ProtocolObjectField.success(keys, values);
                final webSearch = validateOptionalWebSearchToolConfig(tools, "web_search", path + ".web_search");
                if (!webSearch.ok) return webSearch;
                success("tools-v2");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalWebSearchToolConfig(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("web-search-tool:missing");
        return switch object.values[i] {
            case JNull:
                success("web-search-tool:null");
            case JObject(keys, values):
                final config = ProtocolObjectField.success(keys, values);
                final allowedDomains = validateOptionalStringArray(config, "allowed_domains", path + ".allowed_domains", true);
                if (!allowedDomains.ok) return allowedDomains;
                final contextSize = validateOptionalNullableStringEnum(config, "context_size", path + ".context_size", ["low", "medium", "high"], "invalid_web_search_context_size");
                if (!contextSize.ok) return contextSize;
                final location = validateOptionalWebSearchLocation(config, "location", path + ".location");
                if (!location.ok) return location;
                success("web-search-tool");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalWebSearchLocation(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("web-search-location:missing");
        return switch object.values[i] {
            case JNull:
                success("web-search-location:null");
            case JObject(keys, values):
                final location = ProtocolObjectField.success(keys, values);
                for (field in ["city", "country", "region", "timezone"]) {
                    final result = validateOptionalNullableString(location, field, path + "." + field);
                    if (!result.ok) return result;
                }
                success("web-search-location");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalAnalyticsConfig(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("analytics:missing");
        return switch object.values[i] {
            case JNull:
                success("analytics:null");
            case JObject(keys, values):
                final enabled = validateOptionalNullableBool(ProtocolObjectField.success(keys, values), "enabled", path + ".enabled");
                if (!enabled.ok) enabled else success("analytics");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalAppsConfig(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("apps:missing");
        return switch object.values[i] {
            case JNull:
                success("apps:null");
            case JObject(keys, values):
                var entryIndex = 0;
                while (entryIndex < keys.length) {
                    final entryPath = path + "." + keys[entryIndex];
                    switch values[entryIndex] {
                        case JNull:
                        case JObject(appKeys, appValues):
                            final app = ProtocolObjectField.success(appKeys, appValues);
                            if (keys[entryIndex] == "_default") {
                                for (field in ["enabled", "destructive_enabled", "open_world_enabled"]) {
                                    final result = validateOptionalBool(app, field, entryPath + "." + field);
                                    if (!result.ok) return result;
                                }
                            } else {
                                final enabled = validateOptionalNullableBool(app, "enabled", entryPath + ".enabled");
                                if (!enabled.ok) return enabled;
                                final approvalMode = validateOptionalNullableStringEnum(app, "approval_mode", entryPath + ".approval_mode", ["auto", "prompt", "approve"], "invalid_app_tool_approval");
                                if (!approvalMode.ok) return approvalMode;
                            }
                        case _:
                            return fail("expected_nullable_object", entryPath, "expected JSON object or null");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("apps");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateConfigLayerMetadataMap(origins:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < origins.keys.length) {
            final entryPath = path + "." + origins.keys[i];
            switch origins.values[i] {
                case JObject(keys, values):
                    final result = validateConfigLayerMetadata(ProtocolObjectField.success(keys, values), entryPath);
                    if (!result.ok) return result;
                case _:
                    return fail("expected_object", entryPath, "expected config layer metadata object");
            }
            i = i + 1;
        }
        return success("config-layer-metadata-map");
    }

    static function validateConfigLayerMetadata(metadata:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final name = requiredObjectField(metadata.keys, metadata.values, "name", path + ".name");
        if (!name.ok) return name.toOutcome();
        final source = validateConfigLayerSource(name, path + ".name");
        if (!source.ok) return source;
        final version = requiredString(metadata.keys, metadata.values, "version", path + ".version");
        if (!version.ok) return version.toOutcome();
        return success("config-layer-metadata");
    }

    static function validateOptionalNullableConfigLayers(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("config-layers:missing");
        return switch object.values[i] {
            case JNull:
                success("config-layers:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    switch entries[entryIndex] {
                        case JObject(keys, values):
                            final layer = validateConfigLayer(ProtocolObjectField.success(keys, values), entryPath);
                            if (!layer.ok) return layer;
                        case _:
                            return fail("expected_object", entryPath, "expected config layer object");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("config-layers");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateConfigLayer(layer:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final metadata = validateConfigLayerMetadata(layer, path);
        if (!metadata.ok) return metadata;
        final config = requiredValue(layer.keys, layer.values, "config", path + ".config");
        if (!config.ok) return config.toOutcome();
        final disabledReason = validateOptionalNullableString(layer, "disabledReason", path + ".disabledReason");
        if (!disabledReason.ok) return disabledReason;
        return success("config-layer");
    }

    static function validateConfigLayerSource(source:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final sourceType = requiredString(source.keys, source.values, "type", path + ".type");
        if (!sourceType.ok) return sourceType.toOutcome();
        switch sourceType.value {
            case "mdm":
                return validateRequiredStrings(source, ["domain", "key"], path);
            case "system":
                return validateRequiredStrings(source, ["file"], path);
            case "enterpriseManaged":
                return validateRequiredStrings(source, ["id", "name"], path);
            case "user":
                final file = requiredString(source.keys, source.values, "file", path + ".file");
                if (!file.ok) return file.toOutcome();
                final profile = validateOptionalNullableString(source, "profile", path + ".profile");
                if (!profile.ok) return profile;
                return success("config-layer-source:user");
            case "project":
                return validateRequiredStrings(source, ["dotCodexFolder"], path);
            case "sessionFlags" | "legacyManagedConfigTomlFromMdm":
                return success("config-layer-source:" + sourceType.value);
            case "legacyManagedConfigTomlFromFile":
                return validateRequiredStrings(source, ["file"], path);
            case _:
                return fail("invalid_config_layer_source", path + ".type", "unsupported config layer source");
        }
    }

    static function validateRequiredStrings(object:ProtocolObjectField, names:Array<String>, path:String):AppProtocolParseOutcome {
        for (name in names) {
            final result = requiredString(object.keys, object.values, name, path + "." + name);
            if (!result.ok) return result.toOutcome();
        }
        return success("required-strings");
    }

    static function validateRequiredNonEmptyStringArray(values:Array<Value>, path:String):AppProtocolParseOutcome {
        if (values.length == 0) return fail("empty_array", path, "expected non-empty string array");
        var i = 0;
        while (i < values.length) {
            switch values[i] {
                case JString(_):
                case _:
                    return fail("expected_string", path + "[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }
        return success("string-array:non-empty");
    }

    static function validateOptionalCommandExecTerminalSize(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("command-exec-size:missing");
        return switch object.values[i] {
            case JNull:
                success("command-exec-size:null");
            case JObject(keys, values):
                validateCommandExecTerminalSizeObject(ProtocolObjectField.success(keys, values), path);
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateCommandExecTerminalSizeObject(size:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final rows = requiredUInt(size.keys, size.values, "rows", path + ".rows");
        if (!rows.ok) return rows.toOutcome();
        final cols = requiredUInt(size.keys, size.values, "cols", path + ".cols");
        if (!cols.ok) return cols.toOutcome();
        if (rows.value > 65535) return fail("expected_uint16", path + ".rows", "expected unsigned 16-bit JSON integer");
        if (cols.value > 65535) return fail("expected_uint16", path + ".cols", "expected unsigned 16-bit JSON integer");
        return success("command-exec-size");
    }

    static function validateOptionalCommandExecSandboxPolicy(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("sandbox-policy:missing");
        return switch object.values[i] {
            case JNull:
                success("sandbox-policy:null");
            case JObject(keys, values):
                final policyType = requiredString(keys, values, "type", path + ".type");
                if (!policyType.ok) return policyType.toOutcome();
                switch policyType.value {
                    case "dangerFullAccess":
                        success("sandbox-policy:dangerFullAccess");
                    case "readOnly":
                        final networkAccess = validateOptionalBool(ProtocolObjectField.success(keys, values), "networkAccess", path + ".networkAccess");
                        if (!networkAccess.ok) networkAccess else success("sandbox-policy:readOnly");
                    case "externalSandbox":
                        final networkAccess = validateOptionalExternalSandboxNetworkAccess(keys, values, path + ".networkAccess");
                        if (!networkAccess.ok) networkAccess else success("sandbox-policy:externalSandbox");
                    case "workspaceWrite":
                        final networkAccess = validateOptionalBool(ProtocolObjectField.success(keys, values), "networkAccess", path + ".networkAccess");
                        if (!networkAccess.ok) return networkAccess;
                        final excludeSlashTmp = validateOptionalBool(ProtocolObjectField.success(keys, values), "excludeSlashTmp", path + ".excludeSlashTmp");
                        if (!excludeSlashTmp.ok) return excludeSlashTmp;
                        final excludeTmpdirEnvVar = validateOptionalBool(ProtocolObjectField.success(keys, values), "excludeTmpdirEnvVar", path + ".excludeTmpdirEnvVar");
                        if (!excludeTmpdirEnvVar.ok) return excludeTmpdirEnvVar;
                        final writableRoots = validateOptionalStringArray(ProtocolObjectField.success(keys, values), "writableRoots", path + ".writableRoots", false);
                        if (!writableRoots.ok) writableRoots else success("sandbox-policy:workspaceWrite");
                    case _:
                        fail("invalid_sandbox_policy_type", path + ".type", "unsupported sandbox policy type");
                }
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalExternalSandboxNetworkAccess(keys:Array<String>, values:Array<Value>, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(keys, "networkAccess");
        if (i < 0) return success("external-sandbox-network:missing");
        return switch values[i] {
            case JString(value):
                if (value == "restricted" || value == "enabled") success("external-sandbox-network") else fail("invalid_network_access", path, "unsupported external sandbox network access");
            case _:
                fail("expected_string", path, "expected JSON string");
        }
    }

    static function validateCommandExecResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final exitCode = requiredInteger(result.keys, result.values, "exitCode", "$.message.result.exitCode");
        if (!exitCode.ok) return exitCode.toOutcome();
        final stdout = requiredString(result.keys, result.values, "stdout", "$.message.result.stdout");
        if (!stdout.ok) return stdout.toOutcome();
        final stderr = requiredString(result.keys, result.values, "stderr", "$.message.result.stderr");
        if (!stderr.ok) return stderr.toOutcome();
        return success("response:command/exec");
    }

    static function validateAccountRateLimitsUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final rateLimits = requiredObjectField(params.keys, params.values, "rateLimits", "$.message.params.rateLimits");
        if (!rateLimits.ok) return rateLimits.toOutcome();
        final snapshotResult = validateRateLimitSnapshot(rateLimits, "$.message.params.rateLimits");
        if (!snapshotResult.ok) return snapshotResult;
        return success("notification:account/rateLimits/updated");
    }

    static function validateAppListUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(params.keys, params.values, "data", "$.message.params.data");
        if (!data.ok) return data.toOutcome();

        var i = 0;
        while (i < data.values.length) {
            final appPath = "$.message.params.data[" + Std.string(i) + "]";
            final app = requireObject(data.values[i], appPath);
            if (!app.ok) return app.toOutcome();
            final appResult = validateAppInfo(app, appPath);
            if (!appResult.ok) return appResult;
            i = i + 1;
        }

        return success("notification:app/list/updated");
    }

    static function validateRemoteControlStatusChangedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final installationId = requiredString(params.keys, params.values, "installationId", "$.message.params.installationId");
        if (!installationId.ok) return installationId.toOutcome();
        final serverName = requiredString(params.keys, params.values, "serverName", "$.message.params.serverName");
        if (!serverName.ok) return serverName.toOutcome();
        final status = requiredString(params.keys, params.values, "status", "$.message.params.status");
        if (!status.ok) return status.toOutcome();
        if (!validRemoteControlStatus(status.value)) return fail("invalid_remote_control_status", "$.message.params.status", "unsupported remote control status");
        final environmentId = validateOptionalNullableString(params, "environmentId", "$.message.params.environmentId");
        if (!environmentId.ok) return environmentId;
        return success("notification:remoteControl/status/changed");
    }

    static function validateModelReroutedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final fromModel = requiredString(params.keys, params.values, "fromModel", "$.message.params.fromModel");
        if (!fromModel.ok) return fromModel.toOutcome();
        final toModel = requiredString(params.keys, params.values, "toModel", "$.message.params.toModel");
        if (!toModel.ok) return toModel.toOutcome();
        final reason = requiredString(params.keys, params.values, "reason", "$.message.params.reason");
        if (!reason.ok) return reason.toOutcome();
        if (!validModelRerouteReason(reason.value)) return fail("invalid_model_reroute_reason", "$.message.params.reason", "unsupported model reroute reason");
        return success("notification:model/rerouted");
    }

    static function validateModelVerificationNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final verifications = requiredArray(params.keys, params.values, "verifications", "$.message.params.verifications");
        if (!verifications.ok) return verifications.toOutcome();

        var i = 0;
        while (i < verifications.values.length) {
            switch verifications.values[i] {
                case JString(value):
                    if (!validModelVerification(value)) return fail("invalid_model_verification", "$.message.params.verifications[" + Std.string(i) + "]", "unsupported model verification");
                case _:
                    return fail("expected_string", "$.message.params.verifications[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }

        return success("notification:model/verification");
    }

    static function validateWarningNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final message = requiredString(params.keys, params.values, "message", "$.message.params.message");
        if (!message.ok) return message.toOutcome();
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        return success("notification:warning");
    }

    static function validateGuardianWarningNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final message = requiredString(params.keys, params.values, "message", "$.message.params.message");
        if (!message.ok) return message.toOutcome();
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        return success("notification:guardianWarning");
    }

    static function validateDeprecationNoticeNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final summary = requiredString(params.keys, params.values, "summary", "$.message.params.summary");
        if (!summary.ok) return summary.toOutcome();
        final details = validateOptionalNullableString(params, "details", "$.message.params.details");
        if (!details.ok) return details;
        return success("notification:deprecationNotice");
    }

    static function validateConfigWarningNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final summary = requiredString(params.keys, params.values, "summary", "$.message.params.summary");
        if (!summary.ok) return summary.toOutcome();
        final details = validateOptionalNullableString(params, "details", "$.message.params.details");
        if (!details.ok) return details;
        final path = validateOptionalNullableString(params, "path", "$.message.params.path");
        if (!path.ok) return path;
        final range = validateOptionalNullableTextRange(params, "range", "$.message.params.range");
        if (!range.ok) return range;
        return success("notification:configWarning");
    }

    static function validateOptionalNullableTextRange(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("text-range:missing");
        return switch object.values[i] {
            case JNull:
                success("text-range:null");
            case JObject(keys, values):
                final start = requiredObjectField(keys, values, "start", path + ".start");
                if (!start.ok) return start.toOutcome();
                final startResult = validateTextPosition(start, path + ".start");
                if (!startResult.ok) return startResult;
                final end = requiredObjectField(keys, values, "end", path + ".end");
                if (!end.ok) return end.toOutcome();
                validateTextPosition(end, path + ".end");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateTextPosition(position:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final line = requiredInteger(position.keys, position.values, "line", path + ".line");
        if (!line.ok) return line.toOutcome();
        if (line.value < 0) return fail("expected_uint", path + ".line", "expected unsigned JSON integer");
        final column = requiredInteger(position.keys, position.values, "column", path + ".column");
        if (!column.ok) return column.toOutcome();
        if (column.value < 0) return fail("expected_uint", path + ".column", "expected unsigned JSON integer");
        return success("text-position");
    }

    static function validateFuzzyFileSearchSessionUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final sessionId = requiredString(params.keys, params.values, "sessionId", "$.message.params.sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        final query = requiredString(params.keys, params.values, "query", "$.message.params.query");
        if (!query.ok) return query.toOutcome();
        final files = requiredArray(params.keys, params.values, "files", "$.message.params.files");
        if (!files.ok) return files.toOutcome();

        var i = 0;
        while (i < files.values.length) {
            final filePath = "$.message.params.files[" + Std.string(i) + "]";
            final file = requireObject(files.values[i], filePath);
            if (!file.ok) return file.toOutcome();
            final result = validateFuzzyFileSearchResult(file, filePath);
            if (!result.ok) return result;
            i = i + 1;
        }

        return success("notification:fuzzyFileSearch/sessionUpdated");
    }

    static function validateFuzzyFileSearchSessionCompletedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final sessionId = requiredString(params.keys, params.values, "sessionId", "$.message.params.sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        return success("notification:fuzzyFileSearch/sessionCompleted");
    }

    static function validateFuzzyFileSearchResult(file:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final fileName = requiredString(file.keys, file.values, "file_name", path + ".file_name");
        if (!fileName.ok) return fileName.toOutcome();
        final matchType = requiredString(file.keys, file.values, "match_type", path + ".match_type");
        if (!matchType.ok) return matchType.toOutcome();
        if (!validFuzzyFileSearchMatchType(matchType.value)) return fail("invalid_fuzzy_file_search_match_type", path + ".match_type", "unsupported fuzzy file search match type");
        final filePath = requiredString(file.keys, file.values, "path", path + ".path");
        if (!filePath.ok) return filePath.toOutcome();
        final root = requiredString(file.keys, file.values, "root", path + ".root");
        if (!root.ok) return root.toOutcome();
        final score = requiredInteger(file.keys, file.values, "score", path + ".score");
        if (!score.ok) return score.toOutcome();
        if (score.value < 0) return fail("expected_uint", path + ".score", "expected unsigned JSON integer");

        final indices = validateOptionalNullableUIntArray(file, "indices", path + ".indices");
        if (!indices.ok) return indices;
        return success("fuzzy-file-search-result");
    }

    static function validateOptionalNullableUIntArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("uint-array:missing");
        return switch object.values[i] {
            case JNull:
                success("uint-array:null");
            case JArray(values):
                var j = 0;
                while (j < values.length) {
                    switch values[j] {
                        case JNumber(value):
                            if (value % 1 != 0) return fail("expected_integer", path + "[" + Std.string(j) + "]", "expected JSON integer");
                            if (value < 0) return fail("expected_uint", path + "[" + Std.string(j) + "]", "expected unsigned JSON integer");
                        case _:
                            return fail("expected_integer", path + "[" + Std.string(j) + "]", "expected JSON integer");
                    }
                    j = j + 1;
                }
                success("uint-array");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateThreadRealtimeStartedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final version = requiredString(params.keys, params.values, "version", "$.message.params.version");
        if (!version.ok) return version.toOutcome();
        if (!validRealtimeConversationVersion(version.value)) return fail("invalid_realtime_conversation_version", "$.message.params.version", "unsupported realtime conversation version");
        final realtimeSessionId = validateOptionalNullableString(params, "realtimeSessionId", "$.message.params.realtimeSessionId");
        if (!realtimeSessionId.ok) return realtimeSessionId;
        return success("notification:thread/realtime/started");
    }

    static function validateThreadRealtimeItemAddedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final item = requiredValue(params.keys, params.values, "item", "$.message.params.item");
        if (!item.ok) return item.toOutcome();
        return success("notification:thread/realtime/itemAdded");
    }

    static function validateThreadRealtimeTranscriptDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final role = requiredString(params.keys, params.values, "role", "$.message.params.role");
        if (!role.ok) return role.toOutcome();
        final delta = requiredString(params.keys, params.values, "delta", "$.message.params.delta");
        if (!delta.ok) return delta.toOutcome();
        return success("notification:thread/realtime/transcript/delta");
    }

    static function validateThreadRealtimeTranscriptDoneNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final role = requiredString(params.keys, params.values, "role", "$.message.params.role");
        if (!role.ok) return role.toOutcome();
        final text = requiredString(params.keys, params.values, "text", "$.message.params.text");
        if (!text.ok) return text.toOutcome();
        return success("notification:thread/realtime/transcript/done");
    }

    static function validateThreadRealtimeOutputAudioDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final audio = requiredObjectField(params.keys, params.values, "audio", "$.message.params.audio");
        if (!audio.ok) return audio.toOutcome();
        final audioResult = validateThreadRealtimeAudioChunk(audio, "$.message.params.audio");
        if (!audioResult.ok) return audioResult;
        return success("notification:thread/realtime/outputAudio/delta");
    }

    static function validateThreadRealtimeAudioChunk(audio:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final data = requiredString(audio.keys, audio.values, "data", path + ".data");
        if (!data.ok) return data.toOutcome();
        final itemId = validateOptionalNullableString(audio, "itemId", path + ".itemId");
        if (!itemId.ok) return itemId;
        final numChannels = requiredUInt(audio.keys, audio.values, "numChannels", path + ".numChannels");
        if (!numChannels.ok) return numChannels.toOutcome();
        final sampleRate = requiredUInt(audio.keys, audio.values, "sampleRate", path + ".sampleRate");
        if (!sampleRate.ok) return sampleRate.toOutcome();
        final samplesPerChannel = validateOptionalNullableUInt(audio, "samplesPerChannel", path + ".samplesPerChannel");
        if (!samplesPerChannel.ok) return samplesPerChannel;
        return success("thread-realtime-audio-chunk");
    }

    static function validateThreadRealtimeSdpNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final sdp = requiredString(params.keys, params.values, "sdp", "$.message.params.sdp");
        if (!sdp.ok) return sdp.toOutcome();
        return success("notification:thread/realtime/sdp");
    }

    static function validateThreadRealtimeErrorNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final message = requiredString(params.keys, params.values, "message", "$.message.params.message");
        if (!message.ok) return message.toOutcome();
        return success("notification:thread/realtime/error");
    }

    static function validateThreadRealtimeClosedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final reason = validateOptionalNullableString(params, "reason", "$.message.params.reason");
        if (!reason.ok) return reason;
        return success("notification:thread/realtime/closed");
    }

    static function validateWindowsSandboxSetupStartParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final mode = requiredString(params.keys, params.values, "mode", "$.message.params.mode");
        if (!mode.ok) return mode.toOutcome();
        if (!validWindowsSandboxSetupMode(mode.value)) return fail("invalid_windows_sandbox_setup_mode", "$.message.params.mode", "unsupported Windows sandbox setup mode");
        final cwd = validateOptionalNullableString(params, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd;
        return success("params:windowsSandbox/setupStart");
    }

    static function validateWindowsSandboxSetupStartResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final started = requiredBool(result.keys, result.values, "started", "$.message.result.started");
        if (!started.ok) return started.toOutcome();
        return success("response:windowsSandbox/setupStart");
    }

    static function validateWindowsSandboxReadinessResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final status = requiredString(result.keys, result.values, "status", "$.message.result.status");
        if (!status.ok) return status.toOutcome();
        if (!validWindowsSandboxReadiness(status.value)) return fail("invalid_windows_sandbox_readiness", "$.message.result.status", "unsupported Windows sandbox readiness status");
        return success("response:windowsSandbox/readiness");
    }

    static function validateWindowsWorldWritableWarningNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final samplePaths = requiredArray(params.keys, params.values, "samplePaths", "$.message.params.samplePaths");
        if (!samplePaths.ok) return samplePaths.toOutcome();
        var i = 0;
        while (i < samplePaths.values.length) {
            switch samplePaths.values[i] {
                case JString(_):
                case _:
                    return fail("expected_string", "$.message.params.samplePaths[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }

        final extraCount = requiredUInt(params.keys, params.values, "extraCount", "$.message.params.extraCount");
        if (!extraCount.ok) return extraCount.toOutcome();
        final failedScan = requiredBool(params.keys, params.values, "failedScan", "$.message.params.failedScan");
        if (!failedScan.ok) return failedScan.toOutcome();
        return success("notification:windows/worldWritableWarning");
    }

    static function validateWindowsSandboxSetupCompletedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final mode = requiredString(params.keys, params.values, "mode", "$.message.params.mode");
        if (!mode.ok) return mode.toOutcome();
        if (!validWindowsSandboxSetupMode(mode.value)) return fail("invalid_windows_sandbox_setup_mode", "$.message.params.mode", "unsupported Windows sandbox setup mode");
        final successFlag = requiredBool(params.keys, params.values, "success", "$.message.params.success");
        if (!successFlag.ok) return successFlag.toOutcome();
        final error = validateOptionalNullableString(params, "error", "$.message.params.error");
        if (!error.ok) return error;
        return success("notification:windowsSandbox/setupCompleted");
    }

    static function validateExternalAgentConfigImportCompletedNotification(_params:ProtocolObjectField):AppProtocolParseOutcome {
        return success("notification:externalAgentConfig/import/completed");
    }

    static function validateFsChangedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final watchId = requiredString(params.keys, params.values, "watchId", "$.message.params.watchId");
        if (!watchId.ok) return watchId.toOutcome();
        final changedPaths = requiredArray(params.keys, params.values, "changedPaths", "$.message.params.changedPaths");
        if (!changedPaths.ok) return changedPaths.toOutcome();

        var i = 0;
        while (i < changedPaths.values.length) {
            switch changedPaths.values[i] {
                case JString(_):
                case _:
                    return fail("expected_string", "$.message.params.changedPaths[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }

        return success("notification:fs/changed");
    }

    static function validateAppInfo(app:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final id = requiredString(app.keys, app.values, "id", path + ".id");
        if (!id.ok) return id.toOutcome();
        final name = requiredString(app.keys, app.values, "name", path + ".name");
        if (!name.ok) return name.toOutcome();

        for (field in ["description", "distributionChannel", "installUrl", "logoUrl", "logoUrlDark"]) {
            final result = validateOptionalNullableString(app, field, path + "." + field);
            if (!result.ok) return result;
        }

        final accessible = validateOptionalBool(app, "isAccessible", path + ".isAccessible");
        if (!accessible.ok) return accessible;
        final enabled = validateOptionalBool(app, "isEnabled", path + ".isEnabled");
        if (!enabled.ok) return enabled;
        final plugins = validateOptionalStringArray(app, "pluginDisplayNames", path + ".pluginDisplayNames", false);
        if (!plugins.ok) return plugins;
        final labels = validateOptionalStringMap(app, "labels", path + ".labels");
        if (!labels.ok) return labels;
        final branding = validateOptionalAppBranding(app, "branding", path + ".branding");
        if (!branding.ok) return branding;
        final metadata = validateOptionalAppMetadata(app, "appMetadata", path + ".appMetadata");
        if (!metadata.ok) return metadata;

        return success("app-list:app-info");
    }

    static function validateOptionalAppBranding(app:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(app.keys, name);
        if (i < 0) return success("app-list:missing-branding");
        return switch app.values[i] {
            case JNull:
                success("app-list:null-branding");
            case JObject(keys, values):
                final branding = ProtocolObjectField.success(keys, values);
                final isDiscoverable = requiredBool(keys, values, "isDiscoverableApp", path + ".isDiscoverableApp");
                if (!isDiscoverable.ok) return isDiscoverable.toOutcome();
                for (field in ["category", "developer", "privacyPolicy", "termsOfService", "website"]) {
                    final result = validateOptionalNullableString(branding, field, path + "." + field);
                    if (!result.ok) return result;
                }
                success("app-list:branding");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalAppMetadata(app:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(app.keys, name);
        if (i < 0) return success("app-list:missing-metadata");
        return switch app.values[i] {
            case JNull:
                success("app-list:null-metadata");
            case JObject(keys, values):
                final metadata = ProtocolObjectField.success(keys, values);
                for (field in ["developer", "firstPartyType", "seoDescription", "version", "versionId", "versionNotes"]) {
                    final result = validateOptionalNullableString(metadata, field, path + "." + field);
                    if (!result.ok) return result;
                }
                for (field in ["firstPartyRequiresInstall", "showInComposerWhenUnlinked"]) {
                    final result = validateOptionalNullableBool(metadata, field, path + "." + field);
                    if (!result.ok) return result;
                }
                for (field in ["categories", "subCategories"]) {
                    final result = validateOptionalStringArray(metadata, field, path + "." + field, true);
                    if (!result.ok) return result;
                }
                final review = validateOptionalNullableObject(metadata, "review", path + ".review");
                if (!review.ok) return review;
                final screenshots = validateOptionalArrayOrNull(metadata, "screenshots", path + ".screenshots");
                if (!screenshots.ok) return screenshots;
                success("app-list:metadata");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateRateLimitSnapshot(snapshot:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final limitId = validateOptionalNullableString(snapshot, "limitId", path + ".limitId");
        if (!limitId.ok) return limitId;
        final limitName = validateOptionalNullableString(snapshot, "limitName", path + ".limitName");
        if (!limitName.ok) return limitName;

        final primary = validateOptionalRateLimitWindow(snapshot, "primary", path + ".primary");
        if (!primary.ok) return primary;
        final secondary = validateOptionalRateLimitWindow(snapshot, "secondary", path + ".secondary");
        if (!secondary.ok) return secondary;
        final credits = validateOptionalCreditsSnapshot(snapshot, "credits", path + ".credits");
        if (!credits.ok) return credits;
        final individualLimit = validateOptionalSpendControlLimitSnapshot(snapshot, "individualLimit", path + ".individualLimit");
        if (!individualLimit.ok) return individualLimit;
        final planType = validateOptionalAccountPlanType(snapshot, "planType", path + ".planType");
        if (!planType.ok) return planType;
        final reachedType = validateOptionalRateLimitReachedType(snapshot, "rateLimitReachedType", path + ".rateLimitReachedType");
        if (!reachedType.ok) return reachedType;

        return success("rate-limits:snapshot");
    }

    static function validateOptionalRateLimitWindow(snapshot:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(snapshot.keys, name);
        if (i < 0) return success("rate-limits:missing-window");
        return switch snapshot.values[i] {
            case JNull:
                success("rate-limits:null-window");
            case JObject(keys, values):
                final usedPercent = requiredNumber(keys, values, "usedPercent", path + ".usedPercent");
                if (!usedPercent.ok) return usedPercent.toOutcome();
                final window = ProtocolObjectField.success(keys, values);
                final resetsAt = validateOptionalNullableNumber(window, "resetsAt", path + ".resetsAt");
                if (!resetsAt.ok) return resetsAt;
                final windowDuration = validateOptionalNullableNumber(window, "windowDurationMins", path + ".windowDurationMins");
                if (!windowDuration.ok) return windowDuration;
                success("rate-limits:window");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalCreditsSnapshot(snapshot:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(snapshot.keys, name);
        if (i < 0) return success("rate-limits:missing-credits");
        return switch snapshot.values[i] {
            case JNull:
                success("rate-limits:null-credits");
            case JObject(keys, values):
                final hasCredits = requiredBool(keys, values, "hasCredits", path + ".hasCredits");
                if (!hasCredits.ok) return hasCredits.toOutcome();
                final unlimited = requiredBool(keys, values, "unlimited", path + ".unlimited");
                if (!unlimited.ok) return unlimited.toOutcome();
                final credits = ProtocolObjectField.success(keys, values);
                final balance = validateOptionalNullableString(credits, "balance", path + ".balance");
                if (!balance.ok) return balance;
                success("rate-limits:credits");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalSpendControlLimitSnapshot(snapshot:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(snapshot.keys, name);
        if (i < 0) return success("rate-limits:missing-spend-control");
        return switch snapshot.values[i] {
            case JNull:
                success("rate-limits:null-spend-control");
            case JObject(keys, values):
                final limit = requiredString(keys, values, "limit", path + ".limit");
                if (!limit.ok) return limit.toOutcome();
                final remainingPercent = requiredNumber(keys, values, "remainingPercent", path + ".remainingPercent");
                if (!remainingPercent.ok) return remainingPercent.toOutcome();
                final resetsAt = requiredNumber(keys, values, "resetsAt", path + ".resetsAt");
                if (!resetsAt.ok) return resetsAt.toOutcome();
                final used = requiredString(keys, values, "used", path + ".used");
                if (!used.ok) return used.toOutcome();
                success("rate-limits:spend-control");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalAccountPlanType(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("account:missing-plan-type");
        return switch object.values[i] {
            case JNull:
                success("account:null-plan-type");
            case JString(value):
                if (!validAccountPlanType(value)) fail("invalid_account_plan_type", path, "unsupported account plan type") else success("account:plan-type");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateOptionalRateLimitReachedType(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("rate-limits:missing-reached-type");
        return switch object.values[i] {
            case JNull:
                success("rate-limits:null-reached-type");
            case JString(value):
                if (!validRateLimitReachedType(value)) fail("invalid_rate_limit_reached_type", path, "unsupported rate limit reached type") else success("rate-limits:reached-type");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateCommandExecOutputDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processId = requiredString(params.keys, params.values, "processId", "$.message.params.processId");
        if (!processId.ok) return processId.toOutcome();
        final stream = requiredString(params.keys, params.values, "stream", "$.message.params.stream");
        if (!stream.ok) return stream.toOutcome();
        if (!validCommandExecOutputStream(stream.value)) return fail("invalid_command_exec_stream", "$.message.params.stream", "unsupported command exec output stream");
        final deltaBase64 = requiredString(params.keys, params.values, "deltaBase64", "$.message.params.deltaBase64");
        if (!deltaBase64.ok) return deltaBase64.toOutcome();
        final capReached = requiredBool(params.keys, params.values, "capReached", "$.message.params.capReached");
        if (!capReached.ok) return capReached.toOutcome();
        return success("notification:command/exec/outputDelta");
    }

    static function validateProcessOutputDeltaNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        final stream = requiredString(params.keys, params.values, "stream", "$.message.params.stream");
        if (!stream.ok) return stream.toOutcome();
        if (!validProcessOutputStream(stream.value)) return fail("invalid_process_output_stream", "$.message.params.stream", "unsupported process output stream");
        final deltaBase64 = requiredString(params.keys, params.values, "deltaBase64", "$.message.params.deltaBase64");
        if (!deltaBase64.ok) return deltaBase64.toOutcome();
        final capReached = requiredBool(params.keys, params.values, "capReached", "$.message.params.capReached");
        if (!capReached.ok) return capReached.toOutcome();
        return success("notification:process/outputDelta");
    }

    static function validateProcessExitedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final processHandle = requiredString(params.keys, params.values, "processHandle", "$.message.params.processHandle");
        if (!processHandle.ok) return processHandle.toOutcome();
        final exitCode = requiredNumber(params.keys, params.values, "exitCode", "$.message.params.exitCode");
        if (!exitCode.ok) return exitCode.toOutcome();
        final stdout = requiredString(params.keys, params.values, "stdout", "$.message.params.stdout");
        if (!stdout.ok) return stdout.toOutcome();
        final stdoutCapReached = requiredBool(params.keys, params.values, "stdoutCapReached", "$.message.params.stdoutCapReached");
        if (!stdoutCapReached.ok) return stdoutCapReached.toOutcome();
        final stderr = requiredString(params.keys, params.values, "stderr", "$.message.params.stderr");
        if (!stderr.ok) return stderr.toOutcome();
        final stderrCapReached = requiredBool(params.keys, params.values, "stderrCapReached", "$.message.params.stderrCapReached");
        if (!stderrCapReached.ok) return stderrCapReached.toOutcome();
        return success("notification:process/exited");
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

    static function validMcpServerStartupStatus(value:String):Bool {
        return value == "starting" || value == "ready" || value == "failed" || value == "cancelled";
    }

    static function validAccountAuthMode(value:String):Bool {
        return value == "apikey" || value == "chatgpt" || value == "chatgptAuthTokens" || value == "agentIdentity" || value == "personalAccessToken";
    }

    static function validAccountPlanType(value:String):Bool {
        return value == "free" || value == "go" || value == "plus" || value == "pro" || value == "prolite" || value == "team" || value == "self_serve_business_usage_based" || value == "business" || value == "enterprise_cbp_usage_based" || value == "enterprise" || value == "edu" || value == "unknown";
    }

    static function validRateLimitReachedType(value:String):Bool {
        return value == "rate_limit_reached" || value == "workspace_owner_credits_depleted" || value == "workspace_member_credits_depleted" || value == "workspace_owner_usage_limit_reached" || value == "workspace_member_usage_limit_reached";
    }

    static function validRemoteControlStatus(value:String):Bool {
        return value == "disabled" || value == "connecting" || value == "connected" || value == "errored";
    }

    static function validModelRerouteReason(value:String):Bool {
        return value == "highRiskCyberActivity";
    }

    static function validModelVerification(value:String):Bool {
        return value == "trustedAccessForCyber";
    }

    static function validFuzzyFileSearchMatchType(value:String):Bool {
        return value == "file" || value == "directory";
    }

    static function validRealtimeConversationVersion(value:String):Bool {
        return value == "v1" || value == "v2";
    }

    static function validCommandExecOutputStream(value:String):Bool {
        return value == "stdout" || value == "stderr";
    }

    static function validProcessOutputStream(value:String):Bool {
        return value == "stdout" || value == "stderr";
    }

    static function validWindowsSandboxSetupMode(value:String):Bool {
        return value == "elevated" || value == "unelevated";
    }

    static function validWindowsSandboxReadiness(value:String):Bool {
        return value == "ready" || value == "notConfigured" || value == "updateRequired";
    }

    static function validCancelLoginAccountStatus(value:String):Bool {
        return value == "canceled" || value == "notFound";
    }

    static function validAddCreditsNudgeCreditType(value:String):Bool {
        return value == "credits" || value == "usage_limit";
    }

    static function validAddCreditsNudgeEmailStatus(value:String):Bool {
        return value == "sent" || value == "cooldown_active";
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

    static function requiredInteger(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolNumberField {
        final number = requiredNumber(keys, values, name, path);
        if (!number.ok) return number;
        if (number.value % 1 != 0) return ProtocolNumberField.failure("expected_integer", path, "expected JSON integer");
        return number;
    }

    static function requiredUInt(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolNumberField {
        final number = requiredInteger(keys, values, name, path);
        if (!number.ok) return number;
        if (number.value < 0) return ProtocolNumberField.failure("expected_uint", path, "expected unsigned JSON integer");
        return number;
    }

    static function requiredBool(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolBoolField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolBoolField.failure("missing_field", path, "required field is missing");
        return switch values[i] {
            case JBool(value): ProtocolBoolField.success(value);
            case _: ProtocolBoolField.failure("expected_bool", path, "expected JSON boolean");
        }
    }

    static function validateOptionalNullableString(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-string:missing");
        return switch object.values[i] {
            case JString(_) | JNull:
                success("nullable-string");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateOptionalNullableNonEmptyString(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-non-empty-string:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-non-empty-string:null");
            case JString(value):
                if (value.length == 0) fail("empty_string", path, "expected non-empty JSON string") else success("nullable-non-empty-string");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateOptionalNullableStringEnum(object:ProtocolObjectField, name:String, path:String, values:Array<String>, errorCode:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-string-enum:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-string-enum:null");
            case JString(value):
                if (contains(values, value)) success("nullable-string-enum") else fail(errorCode, path, "unsupported enum value");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateOptionalNullableNumber(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-number:missing");
        return switch object.values[i] {
            case JNumber(_) | JNull:
                success("nullable-number");
            case _:
                fail("expected_nullable_number", path, "expected JSON number or null");
        }
    }

    static function validateOptionalNullableInteger(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-integer:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-integer:null");
            case JNumber(value):
                if (value % 1 != 0) fail("expected_integer", path, "expected JSON integer") else success("nullable-integer");
            case _:
                fail("expected_nullable_integer", path, "expected JSON integer or null");
        }
    }

    static function validateOptionalNullableUInt(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-uint:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-uint:null");
            case JNumber(value):
                if (value % 1 != 0) fail("expected_integer", path, "expected JSON integer") else if (value < 0) fail("expected_uint", path, "expected unsigned JSON integer") else success("nullable-uint");
            case _:
                fail("expected_nullable_integer", path, "expected JSON integer or null");
        }
    }

    static function optionalBoolValue(object:ProtocolObjectField, name:String, path:String):ProtocolBoolField {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return ProtocolBoolField.success(false);
        return switch object.values[i] {
            case JBool(value):
                ProtocolBoolField.success(value);
            case _:
                ProtocolBoolField.failure("expected_bool", path, "expected JSON boolean");
        }
    }

    static function validateOptionalBool(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("bool:missing");
        return switch object.values[i] {
            case JBool(_):
                success("bool");
            case _:
                fail("expected_bool", path, "expected JSON boolean");
        }
    }

    static function validateOptionalNullableBool(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-bool:missing");
        return switch object.values[i] {
            case JBool(_) | JNull:
                success("nullable-bool");
            case _:
                fail("expected_nullable_bool", path, "expected JSON boolean or null");
        }
    }

    static function validateOptionalStringArray(object:ProtocolObjectField, name:String, path:String, nullable:Bool):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("string-array:missing");
        return switch object.values[i] {
            case JNull if (nullable):
                success("string-array:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    switch entries[entryIndex] {
                        case JString(_):
                        case _:
                            return fail("expected_string", path + "[" + Std.string(entryIndex) + "]", "expected JSON string");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("string-array");
            case _:
                if (nullable) fail("expected_nullable_array", path, "expected JSON array or null") else fail("expected_array", path, "expected JSON array");
        }
    }

    static function validateOptionalStringMap(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("string-map:missing");
        return switch object.values[i] {
            case JNull:
                success("string-map:null");
            case JObject(keys, values):
                var entryIndex = 0;
                while (entryIndex < values.length) {
                    switch values[entryIndex] {
                        case JString(_):
                        case _:
                            return fail("expected_string", path + "." + keys[entryIndex], "expected JSON string");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("string-map");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalNullableStringMap(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-string-map:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-string-map:null");
            case JObject(keys, values):
                var entryIndex = 0;
                while (entryIndex < values.length) {
                    switch values[entryIndex] {
                        case JString(_) | JNull:
                        case _:
                            return fail("expected_nullable_string", path + "." + keys[entryIndex], "expected JSON string or null");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("nullable-string-map");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalNullableObject(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-object:missing");
        return switch object.values[i] {
            case JObject(_, _) | JNull:
                success("nullable-object");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalArrayOrNull(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-array:missing");
        return switch object.values[i] {
            case JArray(_) | JNull:
                success("nullable-array");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
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

    static function requiredRequestId(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolValueField {
        final value = requiredValue(keys, values, name, path);
        if (!value.ok) return value;
        return switch value.value {
            case JString(_) | JNumber(_): ProtocolValueField.success(value.value);
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

    static function hasNonNullField(object:ProtocolObjectField, name:String):Bool {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return false;
        return switch object.values[i] {
            case JNull: false;
            case _: true;
        }
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
