package codexhx.protocol.app;

import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;
import StringTools;

class AppProtocol {
    static final REQUEST_METHODS:Array<String> = ["thread/start", "thread/resume", "thread/fork", "thread/archive", "thread/unarchive", "thread/unsubscribe", "thread/increment_elicitation", "thread/decrement_elicitation", "thread/name/set", "thread/goal/set", "thread/goal/get", "thread/goal/clear", "thread/metadata/update", "thread/settings/update", "thread/memoryMode/set", "memory/reset", "thread/compact/start", "thread/shellCommand", "thread/approveGuardianDeniedAction", "thread/backgroundTerminals/clean", "thread/rollback", "thread/inject_items", "thread/turns/list", "thread/turns/items/list", "turn/start", "turn/steer", "turn/interrupt", "review/start", "thread/list", "thread/search", "thread/loaded/list", "thread/read", "fuzzyFileSearch/sessionStart", "fuzzyFileSearch/sessionUpdate", "fuzzyFileSearch/sessionStop", "thread/realtime/start", "thread/realtime/appendAudio", "thread/realtime/appendText", "thread/realtime/stop", "thread/realtime/listVoices", "remoteControl/enable", "remoteControl/disable", "remoteControl/status/read", "remoteControl/pairing/start", "remoteControl/pairing/status", "remoteControl/client/list", "remoteControl/client/revoke", "windowsSandbox/setupStart", "windowsSandbox/readiness", "account/login/start", "account/login/cancel", "account/logout", "account/read", "account/rateLimits/read", "account/usage/read", "account/sendAddCreditsNudgeEmail", "feedback/upload", "command/exec", "command/exec/write", "command/exec/terminate", "command/exec/resize", "process/spawn", "process/writeStdin", "process/kill", "process/resizePty", "config/read", "externalAgentConfig/detect", "externalAgentConfig/import", "config/value/write", "config/batchWrite", "configRequirements/read", "environment/add", "collaborationMode/list", "app/list", "skills/list", "skills/extraRoots/set", "skills/config/write", "hooks/list", "marketplace/add", "marketplace/remove", "marketplace/upgrade", "plugin/list", "plugin/installed", "plugin/read", "plugin/skill/read", "plugin/install", "plugin/uninstall", "plugin/share/save", "plugin/share/updateTargets", "plugin/share/list", "plugin/share/checkout", "plugin/share/delete", "fs/readFile", "fs/writeFile", "fs/createDirectory", "fs/getMetadata", "fs/readDirectory", "fs/remove", "fs/copy", "fs/watch", "fs/unwatch", "model/list", "modelProvider/capabilities/read", "experimentalFeature/list", "experimentalFeature/enablement/set", "permissionProfile/list", "mcpServer/oauth/login", "config/mcpServer/reload", "mcpServerStatus/list", "mcpServer/resource/read", "mcpServer/tool/call"];
    static final SERVER_REQUEST_METHODS:Array<String> = ["account/chatgptAuthTokens/refresh", "attestation/generate", "item/commandExecution/requestApproval", "item/fileChange/requestApproval", "item/permissions/requestApproval", "item/tool/call", "item/tool/requestUserInput", "mcpServer/elicitation/request"];
    static final NOTIFICATION_METHODS:Array<String> = ["thread/started", "thread/status/changed", "thread/archived", "thread/unarchived", "thread/closed", "thread/name/updated", "thread/goal/updated", "thread/goal/cleared", "thread/settings/updated", "thread/tokenUsage/updated", "thread/compacted", "turn/started", "turn/completed", "turn/plan/updated", "turn/moderationMetadata", "item/started", "item/completed", "item/agentMessage/delta", "item/plan/delta", "item/reasoning/summaryTextDelta", "item/reasoning/summaryPartAdded", "item/reasoning/textDelta", "item/commandExecution/outputDelta", "item/commandExecution/terminalInteraction", "item/fileChange/outputDelta", "item/fileChange/patchUpdated", "item/mcpToolCall/progress", "mcpServer/oauthLogin/completed", "mcpServer/startupStatus/updated", "account/updated", "account/login/completed", "account/rateLimits/updated", "app/list/updated", "remoteControl/status/changed", "model/rerouted", "model/verification", "warning", "guardianWarning", "deprecationNotice", "configWarning", "fuzzyFileSearch/sessionUpdated", "fuzzyFileSearch/sessionCompleted", "thread/realtime/started", "thread/realtime/itemAdded", "thread/realtime/transcript/delta", "thread/realtime/transcript/done", "thread/realtime/outputAudio/delta", "thread/realtime/sdp", "thread/realtime/error", "thread/realtime/closed", "windows/worldWritableWarning", "windowsSandbox/setupCompleted", "externalAgentConfig/import/completed", "fs/changed", "rawResponseItem/completed", "serverRequest/resolved", "command/exec/outputDelta", "process/outputDelta", "process/exited", "error"];
    static final FINGERPRINT_BASIS:String = "app-server-protocol:v2|requests:account/login/cancel,account/login/start,account/logout,account/rateLimits/read,account/read,account/sendAddCreditsNudgeEmail,account/usage/read,app/list,collaborationMode/list,command/exec,command/exec/resize,command/exec/terminate,command/exec/write,config/batchWrite,config/mcpServer/reload,config/read,config/value/write,configRequirements/read,environment/add,experimentalFeature/enablement/set,experimentalFeature/list,externalAgentConfig/detect,externalAgentConfig/import,feedback/upload,fs/copy,fs/createDirectory,fs/getMetadata,fs/readDirectory,fs/readFile,fs/remove,fs/unwatch,fs/watch,fs/writeFile,fuzzyFileSearch/sessionStart,fuzzyFileSearch/sessionStop,fuzzyFileSearch/sessionUpdate,hooks/list,marketplace/add,marketplace/remove,marketplace/upgrade,mcpServer/oauth/login,mcpServer/resource/read,mcpServer/tool/call,mcpServerStatus/list,memory/reset,model/list,modelProvider/capabilities/read,permissionProfile/list,plugin/installed,plugin/install,plugin/list,plugin/read,plugin/share/checkout,plugin/share/delete,plugin/share/list,plugin/share/save,plugin/share/updateTargets,plugin/skill/read,plugin/uninstall,process/kill,process/resizePty,process/spawn,process/writeStdin,remoteControl/client/list,remoteControl/client/revoke,remoteControl/disable,remoteControl/enable,remoteControl/pairing/start,remoteControl/pairing/status,remoteControl/status/read,review/start,skills/config/write,skills/extraRoots/set,skills/list,thread/approveGuardianDeniedAction,thread/archive,thread/backgroundTerminals/clean,thread/compact/start,thread/decrement_elicitation,thread/fork,thread/goal/clear,thread/goal/get,thread/goal/set,thread/increment_elicitation,thread/inject_items,thread/list,thread/loaded/list,thread/memoryMode/set,thread/metadata/update,thread/name/set,thread/read,thread/realtime/appendAudio,thread/realtime/appendText,thread/realtime/listVoices,thread/realtime/start,thread/realtime/stop,thread/resume,thread/rollback,thread/search,thread/settings/update,thread/shellCommand,thread/start,thread/turns/items/list,thread/turns/list,thread/unarchive,thread/unsubscribe,turn/interrupt,turn/start,turn/steer,windowsSandbox/readiness,windowsSandbox/setupStart|serverRequests:account/chatgptAuthTokens/refresh,attestation/generate,item/commandExecution/requestApproval,item/fileChange/requestApproval,item/permissions/requestApproval,item/tool/call,item/tool/requestUserInput,mcpServer/elicitation/request|notifications:account/login/completed,account/rateLimits/updated,account/updated,app/list/updated,command/exec/outputDelta,configWarning,deprecationNotice,error,externalAgentConfig/import/completed,fs/changed,fuzzyFileSearch/sessionCompleted,fuzzyFileSearch/sessionUpdated,guardianWarning,item/agentMessage/delta,item/commandExecution/outputDelta,item/commandExecution/terminalInteraction,item/fileChange/outputDelta,item/fileChange/patchUpdated,item/mcpToolCall/progress,item/plan/delta,item/reasoning/summaryPartAdded,item/reasoning/summaryTextDelta,item/reasoning/textDelta,item/completed,item/started,mcpServer/oauthLogin/completed,mcpServer/startupStatus/updated,model/rerouted,model/verification,process/exited,process/outputDelta,rawResponseItem/completed,remoteControl/status/changed,serverRequest/resolved,thread/archived,thread/closed,thread/compacted,thread/goal/cleared,thread/goal/updated,thread/name/updated,thread/realtime/closed,thread/realtime/error,thread/realtime/itemAdded,thread/realtime/outputAudio/delta,thread/realtime/sdp,thread/realtime/started,thread/realtime/transcript/delta,thread/realtime/transcript/done,thread/settings/updated,thread/started,thread/status/changed,thread/tokenUsage/updated,thread/unarchived,turn/completed,turn/moderationMetadata,turn/plan/updated,turn/started,warning,windows/worldWritableWarning,windowsSandbox/setupCompleted|items:agentMessage,plan,userMessage|errors:jsonrpc+turn-error";
    static final FINGERPRINT:String = "hxcx-app-protocol-v2-subset-2026-06-12-065";

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

        if (kind == "serverRequest") return validateServerRequest(fixtureMethod, object);
        if (kind == "serverResponse") return validateServerResponse(fixtureMethod, object);

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
            case "serverRequest" | "serverResponse":
                fail("invalid_jsonrpc_kind", "$.kind", "server request kinds must not use JSON-RPC message validation");
            case _:
                fail("unsupported_kind", "$.kind", "unsupported fixture item kind");
        }
    }

    static function validateServerRequest(fixtureMethod:String, object:ProtocolObjectField):AppProtocolParseOutcome {
        if (!contains(SERVER_REQUEST_METHODS, fixtureMethod)) return fail("unsupported_method", "$.method", "unsupported server request method");
        final id = requiredId(object.keys, object.values, "$.message.id");
        if (!id.ok) return id.toOutcome();

        final method = requiredString(object.keys, object.values, "method", "$.message.method");
        if (!method.ok) return method.toOutcome();
        if (method.value != fixtureMethod) return fail("method_mismatch", "$.message.method", "message method differs from fixture method");

        final params = requiredObjectField(object.keys, object.values, "params", "$.message.params");
        if (!params.ok) return params.toOutcome();

        return validateServerRequestParams(fixtureMethod, params);
    }

    static function validateServerResponse(fixtureMethod:String, object:ProtocolObjectField):AppProtocolParseOutcome {
        if (!contains(SERVER_REQUEST_METHODS, fixtureMethod)) return fail("unsupported_method", "$.method", "unsupported server response method");
        final id = requiredId(object.keys, object.values, "$.message.id");
        if (!id.ok) return id.toOutcome();

        final method = requiredString(object.keys, object.values, "method", "$.message.method");
        if (!method.ok) return method.toOutcome();
        if (method.value != fixtureMethod) return fail("method_mismatch", "$.message.method", "message method differs from fixture method");

        final response = requiredObjectField(object.keys, object.values, "response", "$.message.response");
        if (!response.ok) return response.toOutcome();

        return validateServerResponsePayload(fixtureMethod, response);
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
            case "thread/start" | "thread/read" | "thread/unarchive":
                final thread = requiredObjectField(result.keys, result.values, "thread", "$.message.result.thread");
                if (!thread.ok) return thread.toOutcome();
                validateThread(thread, "$.message.result.thread");
            case "thread/resume" | "thread/fork":
                validateThreadOpenResponse(result, "$.message.result", "response:" + fixtureMethod);
            case "thread/archive":
                validateEmptyObject(result, "$.message.result", "response:thread/archive");
            case "thread/increment_elicitation" | "thread/decrement_elicitation":
                validateThreadElicitationResponse(result, fixtureMethod);
            case "thread/name/set" | "thread/settings/update" | "thread/memoryMode/set" | "memory/reset" | "thread/compact/start" | "thread/shellCommand" | "thread/approveGuardianDeniedAction" | "thread/backgroundTerminals/clean" | "thread/inject_items":
                validateEmptyObject(result, "$.message.result", "response:" + fixtureMethod);
            case "thread/goal/set":
                validateThreadGoalResponse(result, "$.message.result", "response:thread/goal/set");
            case "thread/goal/get":
                validateThreadGoalGetResponse(result);
            case "thread/goal/clear":
                validateThreadGoalClearResponse(result);
            case "thread/metadata/update" | "thread/rollback":
                final thread = requiredObjectField(result.keys, result.values, "thread", "$.message.result.thread");
                if (!thread.ok) return thread.toOutcome();
                validateThread(thread, "$.message.result.thread");
            case "thread/turns/list":
                validateThreadTurnsListResponse(result);
            case "thread/turns/items/list":
                validateThreadTurnsItemsListResponse(result);
            case "thread/unsubscribe":
                validateThreadUnsubscribeResponse(result);
            case "thread/list":
                validateThreadListResponse(result);
            case "thread/search":
                validateThreadSearchResponse(result);
            case "thread/loaded/list":
                validateThreadLoadedListResponse(result);
            case "fuzzyFileSearch/sessionStart" | "fuzzyFileSearch/sessionUpdate" | "fuzzyFileSearch/sessionStop":
                validateEmptyObject(result, "$.message.result", "response:" + fixtureMethod);
            case "thread/realtime/start" | "thread/realtime/appendAudio" | "thread/realtime/appendText" | "thread/realtime/stop":
                validateEmptyObject(result, "$.message.result", "response:" + fixtureMethod);
            case "thread/realtime/listVoices":
                validateThreadRealtimeListVoicesResponse(result);
            case "remoteControl/enable" | "remoteControl/disable" | "remoteControl/status/read":
                validateRemoteControlStatusResponse(result, "$.message.result", "response:" + fixtureMethod);
            case "remoteControl/pairing/start":
                validateRemoteControlPairingStartResponse(result);
            case "remoteControl/pairing/status":
                validateRemoteControlPairingStatusResponse(result);
            case "remoteControl/client/list":
                validateRemoteControlClientsListResponse(result);
            case "remoteControl/client/revoke":
                validateEmptyObject(result, "$.message.result", "response:remoteControl/client/revoke");
            case "turn/start":
                final turn = requiredObjectField(result.keys, result.values, "turn", "$.message.result.turn");
                if (!turn.ok) return turn.toOutcome();
                validateTurn(turn, "$.message.result.turn");
            case "turn/steer":
                validateTurnSteerResponse(result);
            case "turn/interrupt":
                success("response:turn/interrupt");
            case "review/start":
                validateReviewStartResponse(result);
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
            case "account/read":
                validateGetAccountResponse(result);
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
            case "externalAgentConfig/detect":
                validateExternalAgentConfigDetectResponse(result);
            case "externalAgentConfig/import":
                validateEmptyObject(result, "$.message.result", "response:externalAgentConfig/import");
            case "config/value/write":
                validateConfigWriteResponse(result);
            case "config/batchWrite":
                validateConfigWriteResponse(result);
            case "configRequirements/read":
                validateConfigRequirementsReadResponse(result);
            case "environment/add":
                validateEmptyObject(result, "$.message.result", "response:environment/add");
            case "collaborationMode/list":
                validateCollaborationModeListResponse(result);
            case "app/list":
                validateAppsListResponse(result);
            case "skills/list":
                validateObjectDataResponse(result, "$.message.result", "response:skills/list");
            case "skills/extraRoots/set":
                validateEmptyObject(result, "$.message.result", "response:skills/extraRoots/set");
            case "skills/config/write":
                validateSkillsConfigWriteResponse(result);
            case "hooks/list":
                validateObjectDataResponse(result, "$.message.result", "response:hooks/list");
            case "marketplace/add":
                validateMarketplaceAddResponse(result);
            case "marketplace/remove":
                validateMarketplaceRemoveResponse(result);
            case "marketplace/upgrade":
                validateMarketplaceUpgradeResponse(result);
            case "plugin/list":
                validatePluginMarketplaceResponse(result, true, "response:plugin/list");
            case "plugin/installed":
                validatePluginMarketplaceResponse(result, false, "response:plugin/installed");
            case "plugin/read":
                validateRequiredObjectResponse(result, "plugin", "$.message.result.plugin", "response:plugin/read");
            case "plugin/skill/read":
                validatePluginSkillReadResponse(result);
            case "plugin/install":
                validatePluginInstallResponse(result);
            case "plugin/uninstall":
                validateEmptyObject(result, "$.message.result", "response:plugin/uninstall");
            case "plugin/share/save":
                validatePluginShareSaveResponse(result);
            case "plugin/share/updateTargets":
                validatePluginShareUpdateTargetsResponse(result);
            case "plugin/share/list":
                validateObjectDataResponse(result, "$.message.result", "response:plugin/share/list");
            case "plugin/share/checkout":
                validatePluginShareCheckoutResponse(result);
            case "plugin/share/delete":
                validateEmptyObject(result, "$.message.result", "response:plugin/share/delete");
            case "fs/readFile":
                validateFsReadFileResponse(result);
            case "fs/writeFile" | "fs/createDirectory" | "fs/remove" | "fs/copy" | "fs/unwatch":
                validateEmptyObject(result, "$.message.result", "response:" + fixtureMethod);
            case "fs/getMetadata":
                validateFsGetMetadataResponse(result);
            case "fs/readDirectory":
                validateFsReadDirectoryResponse(result);
            case "fs/watch":
                validateFsWatchResponse(result);
            case "model/list" | "experimentalFeature/list" | "permissionProfile/list" | "mcpServerStatus/list":
                validateObjectDataPaginatedResponse(result, "$.message.result", "response:" + fixtureMethod);
            case "modelProvider/capabilities/read":
                validateModelProviderCapabilitiesResponse(result);
            case "experimentalFeature/enablement/set":
                validateFeatureEnablementResponse(result);
            case "mcpServer/oauth/login":
                validateMcpServerOauthLoginResponse(result);
            case "config/mcpServer/reload":
                validateEmptyObject(result, "$.message.result", "response:config/mcpServer/reload");
            case "mcpServer/resource/read":
                validateArrayOnlyResponse(result, "contents", "$.message.result.contents", "response:mcpServer/resource/read");
            case "mcpServer/tool/call":
                validateMcpServerToolCallResponse(result);
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
            case "thread/archived" | "thread/unarchived" | "thread/closed" | "thread/goal/cleared":
                validateThreadIdNotification(params, fixtureMethod);
            case "thread/name/updated":
                validateThreadNameUpdatedNotification(params);
            case "thread/goal/updated":
                validateThreadGoalUpdatedNotification(params);
            case "thread/settings/updated":
                validateThreadSettingsUpdatedNotification(params);
            case "thread/tokenUsage/updated":
                validateThreadTokenUsageUpdatedNotification(params);
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
        return method == "memory/reset" || method == "remoteControl/enable" || method == "remoteControl/disable" || method == "remoteControl/status/read" || method == "windowsSandbox/readiness" || method == "account/logout" || method == "account/rateLimits/read" || method == "account/usage/read" || method == "configRequirements/read" || method == "modelProvider/capabilities/read" || method == "plugin/share/list" || method == "config/mcpServer/reload";
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
            case "thread/resume" | "thread/fork":
                validateThreadOpenParams(params, method);
            case "thread/archive" | "thread/unarchive" | "thread/unsubscribe":
                validateThreadIdParams(params, method);
            case "thread/increment_elicitation" | "thread/decrement_elicitation" | "thread/goal/get" | "thread/goal/clear" | "thread/compact/start" | "thread/backgroundTerminals/clean":
                validateThreadIdParams(params, method);
            case "thread/name/set":
                validateThreadSetNameParams(params);
            case "thread/goal/set":
                validateThreadGoalSetParams(params);
            case "thread/metadata/update":
                validateThreadMetadataUpdateParams(params);
            case "thread/settings/update":
                validateThreadSettingsUpdateParams(params);
            case "thread/memoryMode/set":
                validateThreadMemoryModeSetParams(params);
            case "memory/reset":
                validateEmptyObject(params, "$.message.params", "params:memory/reset");
            case "thread/shellCommand":
                validateThreadShellCommandParams(params);
            case "thread/approveGuardianDeniedAction":
                validateThreadApproveGuardianDeniedActionParams(params);
            case "thread/rollback":
                validateThreadRollbackParams(params);
            case "thread/inject_items":
                validateThreadInjectItemsParams(params);
            case "thread/turns/list":
                validateThreadTurnsListParams(params);
            case "thread/turns/items/list":
                validateThreadTurnsItemsListParams(params);
            case "thread/list":
                validateThreadListParams(params);
            case "thread/search":
                validateThreadSearchParams(params);
            case "thread/loaded/list":
                validateThreadLoadedListParams(params);
            case "fuzzyFileSearch/sessionStart":
                validateFuzzyFileSearchSessionStartParams(params);
            case "fuzzyFileSearch/sessionUpdate":
                validateFuzzyFileSearchSessionUpdateParams(params);
            case "fuzzyFileSearch/sessionStop":
                validateFuzzyFileSearchSessionStopParams(params);
            case "thread/realtime/start":
                validateThreadRealtimeStartParams(params);
            case "thread/realtime/appendAudio":
                validateThreadRealtimeAppendAudioParams(params);
            case "thread/realtime/appendText":
                validateThreadRealtimeAppendTextParams(params);
            case "thread/realtime/stop":
                validateThreadRealtimeStopParams(params);
            case "thread/realtime/listVoices":
                validateEmptyObject(params, "$.message.params", "params:thread/realtime/listVoices");
            case "remoteControl/enable" | "remoteControl/disable" | "remoteControl/status/read":
                validateEmptyObject(params, "$.message.params", "params:" + method);
            case "remoteControl/pairing/start":
                validateRemoteControlPairingStartParams(params);
            case "remoteControl/pairing/status":
                validateRemoteControlPairingStatusParams(params);
            case "remoteControl/client/list":
                validateRemoteControlClientsListParams(params);
            case "remoteControl/client/revoke":
                validateRemoteControlClientsRevokeParams(params);
            case "turn/start":
                validateTurnInputParams(params, false);
            case "turn/steer":
                validateTurnInputParams(params, true);
            case "turn/interrupt":
                final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
                if (!threadId.ok) return threadId.toOutcome();
                final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
                if (!turnId.ok) return turnId.toOutcome();
                success("params:turn/interrupt");
            case "review/start":
                validateReviewStartParams(params);
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
            case "account/read":
                validateGetAccountParams(params);
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
            case "externalAgentConfig/detect":
                validateExternalAgentConfigDetectParams(params);
            case "externalAgentConfig/import":
                validateExternalAgentConfigImportParams(params);
            case "config/value/write":
                validateConfigValueWriteParams(params);
            case "config/batchWrite":
                validateConfigBatchWriteParams(params);
            case "configRequirements/read":
                success("params:configRequirements/read");
            case "environment/add":
                validateEnvironmentAddParams(params);
            case "collaborationMode/list":
                validateEmptyObject(params, "$.message.params", "params:collaborationMode/list");
            case "app/list":
                validateAppsListParams(params);
            case "skills/list":
                validateSkillsListParams(params);
            case "skills/extraRoots/set":
                validateRequiredStringArrayField(params, "extraRoots", "$.message.params.extraRoots", "params:skills/extraRoots/set");
            case "skills/config/write":
                validateSkillsConfigWriteParams(params);
            case "hooks/list":
                validateHooksListParams(params);
            case "marketplace/add":
                validateMarketplaceAddParams(params);
            case "marketplace/remove":
                validateSingleStringParams(params, "marketplaceName", "params:marketplace/remove");
            case "marketplace/upgrade":
                validateMarketplaceUpgradeParams(params);
            case "plugin/list":
                validatePluginListParams(params);
            case "plugin/installed":
                validatePluginInstalledParams(params);
            case "plugin/read":
                validatePluginReadParams(params);
            case "plugin/skill/read":
                validatePluginSkillReadParams(params);
            case "plugin/install":
                validatePluginInstallParams(params);
            case "plugin/uninstall":
                validateSingleStringParams(params, "pluginId", "params:plugin/uninstall");
            case "plugin/share/save":
                validatePluginShareSaveParams(params);
            case "plugin/share/updateTargets":
                validatePluginShareUpdateTargetsParams(params);
            case "plugin/share/list":
                validateEmptyObject(params, "$.message.params", "params:plugin/share/list");
            case "plugin/share/checkout" | "plugin/share/delete":
                validateSingleStringParams(params, "remotePluginId", "params:" + method);
            case "fs/readFile":
                validateSingleStringParams(params, "path", "params:fs/readFile");
            case "fs/writeFile":
                validateFsWriteFileParams(params);
            case "fs/createDirectory":
                validateFsCreateDirectoryParams(params);
            case "fs/getMetadata":
                validateSingleStringParams(params, "path", "params:fs/getMetadata");
            case "fs/readDirectory":
                validateSingleStringParams(params, "path", "params:fs/readDirectory");
            case "fs/remove":
                validateFsRemoveParams(params);
            case "fs/copy":
                validateFsCopyParams(params);
            case "fs/watch":
                validateFsWatchParams(params);
            case "fs/unwatch":
                validateSingleStringParams(params, "watchId", "params:fs/unwatch");
            case "model/list":
                validateModelListParams(params);
            case "modelProvider/capabilities/read":
                validateEmptyObject(params, "$.message.params", "params:modelProvider/capabilities/read");
            case "experimentalFeature/list":
                validateExperimentalFeatureListParams(params);
            case "experimentalFeature/enablement/set":
                validateFeatureEnablementParams(params);
            case "permissionProfile/list":
                validatePermissionProfileListParams(params);
            case "mcpServer/oauth/login":
                validateMcpServerOauthLoginParams(params);
            case "config/mcpServer/reload":
                validateEmptyObject(params, "$.message.params", "params:config/mcpServer/reload");
            case "mcpServerStatus/list":
                validateMcpServerStatusListParams(params);
            case "mcpServer/resource/read":
                validateMcpResourceReadParams(params);
            case "mcpServer/tool/call":
                validateMcpServerToolCallParams(params);
            case _:
                fail("unsupported_method", "$.method", "unsupported params method");
        }
    }

    static function validateAppsListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pagination = validateCursorLimitParams(params, "$.message.params");
        if (!pagination.ok) return pagination;
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        final forceRefetch = validateOptionalBool(params, "forceRefetch", "$.message.params.forceRefetch");
        if (!forceRefetch.ok) return forceRefetch;
        return success("params:app/list");
    }

    static function validateSkillsListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final cwds = validateOptionalStringArray(params, "cwds", "$.message.params.cwds", false);
        if (!cwds.ok) return cwds;
        final forceReload = validateOptionalBool(params, "forceReload", "$.message.params.forceReload");
        if (!forceReload.ok) return forceReload;
        return success("params:skills/list");
    }

    static function validateHooksListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final cwds = validateOptionalStringArray(params, "cwds", "$.message.params.cwds", false);
        if (!cwds.ok) return cwds;
        return success("params:hooks/list");
    }

    static function validateSkillsConfigWriteParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final path = validateOptionalNullableString(params, "path", "$.message.params.path");
        if (!path.ok) return path;
        final name = validateOptionalNullableString(params, "name", "$.message.params.name");
        if (!name.ok) return name;
        final enabled = requiredBool(params.keys, params.values, "enabled", "$.message.params.enabled");
        if (!enabled.ok) return enabled.toOutcome();
        return success("params:skills/config/write");
    }

    static function validateMarketplaceAddParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final source = requiredString(params.keys, params.values, "source", "$.message.params.source");
        if (!source.ok) return source.toOutcome();
        final refName = validateOptionalNullableString(params, "refName", "$.message.params.refName");
        if (!refName.ok) return refName;
        final sparsePaths = validateOptionalStringArray(params, "sparsePaths", "$.message.params.sparsePaths", true);
        if (!sparsePaths.ok) return sparsePaths;
        return success("params:marketplace/add");
    }

    static function validateMarketplaceUpgradeParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final marketplaceName = validateOptionalNullableString(params, "marketplaceName", "$.message.params.marketplaceName");
        if (!marketplaceName.ok) return marketplaceName;
        return success("params:marketplace/upgrade");
    }

    static function validatePluginListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final cwds = validateOptionalStringArray(params, "cwds", "$.message.params.cwds", true);
        if (!cwds.ok) return cwds;
        final kinds = validateOptionalStringArray(params, "marketplaceKinds", "$.message.params.marketplaceKinds", true);
        if (!kinds.ok) return kinds;
        return success("params:plugin/list");
    }

    static function validatePluginInstalledParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final cwds = validateOptionalStringArray(params, "cwds", "$.message.params.cwds", true);
        if (!cwds.ok) return cwds;
        final names = validateOptionalStringArray(params, "installSuggestionPluginNames", "$.message.params.installSuggestionPluginNames", true);
        if (!names.ok) return names;
        return success("params:plugin/installed");
    }

    static function validatePluginReadParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final marketplacePath = validateOptionalNullableString(params, "marketplacePath", "$.message.params.marketplacePath");
        if (!marketplacePath.ok) return marketplacePath;
        final remoteMarketplaceName = validateOptionalNullableString(params, "remoteMarketplaceName", "$.message.params.remoteMarketplaceName");
        if (!remoteMarketplaceName.ok) return remoteMarketplaceName;
        final pluginName = requiredString(params.keys, params.values, "pluginName", "$.message.params.pluginName");
        if (!pluginName.ok) return pluginName.toOutcome();
        return success("params:plugin/read");
    }

    static function validatePluginSkillReadParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["remoteMarketplaceName", "remotePluginId", "skillName"]) {
            final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("params:plugin/skill/read");
    }

    static function validatePluginInstallParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final marketplacePath = validateOptionalNullableString(params, "marketplacePath", "$.message.params.marketplacePath");
        if (!marketplacePath.ok) return marketplacePath;
        final remoteMarketplaceName = validateOptionalNullableString(params, "remoteMarketplaceName", "$.message.params.remoteMarketplaceName");
        if (!remoteMarketplaceName.ok) return remoteMarketplaceName;
        final pluginName = requiredString(params.keys, params.values, "pluginName", "$.message.params.pluginName");
        if (!pluginName.ok) return pluginName.toOutcome();
        return success("params:plugin/install");
    }

    static function validatePluginShareSaveParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pluginPath = requiredString(params.keys, params.values, "pluginPath", "$.message.params.pluginPath");
        if (!pluginPath.ok) return pluginPath.toOutcome();
        final remotePluginId = validateOptionalNullableString(params, "remotePluginId", "$.message.params.remotePluginId");
        if (!remotePluginId.ok) return remotePluginId;
        final discoverability = validateOptionalNullableString(params, "discoverability", "$.message.params.discoverability");
        if (!discoverability.ok) return discoverability;
        final targets = validateOptionalArrayOrNull(params, "shareTargets", "$.message.params.shareTargets");
        if (!targets.ok) return targets;
        return success("params:plugin/share/save");
    }

    static function validatePluginShareUpdateTargetsParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final remotePluginId = requiredString(params.keys, params.values, "remotePluginId", "$.message.params.remotePluginId");
        if (!remotePluginId.ok) return remotePluginId.toOutcome();
        final discoverability = requiredString(params.keys, params.values, "discoverability", "$.message.params.discoverability");
        if (!discoverability.ok) return discoverability.toOutcome();
        final targets = requiredArray(params.keys, params.values, "shareTargets", "$.message.params.shareTargets");
        if (!targets.ok) return targets.toOutcome();
        return success("params:plugin/share/updateTargets");
    }

    static function validateFsWriteFileParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final path = requiredString(params.keys, params.values, "path", "$.message.params.path");
        if (!path.ok) return path.toOutcome();
        final dataBase64 = requiredString(params.keys, params.values, "dataBase64", "$.message.params.dataBase64");
        if (!dataBase64.ok) return dataBase64.toOutcome();
        return success("params:fs/writeFile");
    }

    static function validateFsCreateDirectoryParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final path = requiredString(params.keys, params.values, "path", "$.message.params.path");
        if (!path.ok) return path.toOutcome();
        final recursive = validateOptionalNullableBool(params, "recursive", "$.message.params.recursive");
        if (!recursive.ok) return recursive;
        return success("params:fs/createDirectory");
    }

    static function validateFsRemoveParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final path = requiredString(params.keys, params.values, "path", "$.message.params.path");
        if (!path.ok) return path.toOutcome();
        for (field in ["recursive", "force"]) {
            final value = validateOptionalNullableBool(params, field, "$.message.params." + field);
            if (!value.ok) return value;
        }
        return success("params:fs/remove");
    }

    static function validateFsCopyParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["sourcePath", "destinationPath"]) {
            final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
            if (!value.ok) return value.toOutcome();
        }
        final recursive = validateOptionalBool(params, "recursive", "$.message.params.recursive");
        if (!recursive.ok) return recursive;
        return success("params:fs/copy");
    }

    static function validateFsWatchParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["watchId", "path"]) {
            final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("params:fs/watch");
    }

    static function validateModelListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pagination = validateCursorLimitParams(params, "$.message.params");
        if (!pagination.ok) return pagination;
        final includeHidden = validateOptionalNullableBool(params, "includeHidden", "$.message.params.includeHidden");
        if (!includeHidden.ok) return includeHidden;
        return success("params:model/list");
    }

    static function validateExperimentalFeatureListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pagination = validateCursorLimitParams(params, "$.message.params");
        if (!pagination.ok) return pagination;
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        return success("params:experimentalFeature/list");
    }

    static function validatePermissionProfileListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pagination = validateCursorLimitParams(params, "$.message.params");
        if (!pagination.ok) return pagination;
        final cwd = validateOptionalNullableString(params, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd;
        return success("params:permissionProfile/list");
    }

    static function validateFeatureEnablementParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final enablement = requiredObjectField(params.keys, params.values, "enablement", "$.message.params.enablement");
        if (!enablement.ok) return enablement.toOutcome();
        return validateBoolMap(enablement, "$.message.params.enablement", "params:experimentalFeature/enablement/set");
    }

    static function validateMcpServerOauthLoginParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final name = requiredString(params.keys, params.values, "name", "$.message.params.name");
        if (!name.ok) return name.toOutcome();
        final scopes = validateOptionalStringArray(params, "scopes", "$.message.params.scopes", true);
        if (!scopes.ok) return scopes;
        final timeout = validateOptionalNullableUInt(params, "timeoutSecs", "$.message.params.timeoutSecs");
        if (!timeout.ok) return timeout;
        return success("params:mcpServer/oauth/login");
    }

    static function validateMcpServerStatusListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pagination = validateCursorLimitParams(params, "$.message.params");
        if (!pagination.ok) return pagination;
        final detail = validateOptionalNullableString(params, "detail", "$.message.params.detail");
        if (!detail.ok) return detail;
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        return success("params:mcpServerStatus/list");
    }

    static function validateMcpResourceReadParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = validateOptionalNullableString(params, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId;
        for (field in ["server", "uri"]) {
            final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("params:mcpServer/resource/read");
    }

    static function validateMcpServerToolCallParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["threadId", "server", "tool"]) {
            final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
            if (!value.ok) return value.toOutcome();
        }
        final arguments = optionalValue(params.keys, params.values, "arguments");
        if (arguments.ok && !validJsonValue(arguments.value)) return fail("invalid_json_value", "$.message.params.arguments", "expected JSON value");
        final meta = optionalValue(params.keys, params.values, "_meta");
        if (meta.ok && !validJsonValue(meta.value)) return fail("invalid_json_value", "$.message.params._meta", "expected JSON value");
        return success("params:mcpServer/tool/call");
    }

    static function validateAppsListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final path = "$.message.result.data[" + Std.string(i) + "]";
            final app = requireObject(data.values[i], path);
            if (!app.ok) return app.toOutcome();
            final appResult = validateAppInfo(app, path);
            if (!appResult.ok) return appResult;
            i = i + 1;
        }
        return validateNextCursor(result, "$.message.result", "response:app/list");
    }

    static function validateObjectDataResponse(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", path + ".data");
        if (!data.ok) return data.toOutcome();
        return validateObjectArrayEntries(data.values, path + ".data", label);
    }

    static function validateObjectDataPaginatedResponse(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final dataResult = validateObjectDataResponse(result, path, label);
        if (!dataResult.ok) return dataResult;
        return validateNextCursor(result, path, label);
    }

    static function validateEnvironmentAddParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final environmentId = requiredString(params.keys, params.values, "environmentId", "$.message.params.environmentId");
        if (!environmentId.ok) return environmentId.toOutcome();
        if (environmentId.value.length == 0) return fail("empty_string", "$.message.params.environmentId", "expected non-empty JSON string");
        final execServerUrl = requiredString(params.keys, params.values, "execServerUrl", "$.message.params.execServerUrl");
        if (!execServerUrl.ok) return execServerUrl.toOutcome();
        if (execServerUrl.value.length == 0) return fail("empty_string", "$.message.params.execServerUrl", "expected non-empty JSON string");
        return success("params:environment/add");
    }

    static function validateCollaborationModeListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final path = "$.message.result.data[" + Std.string(i) + "]";
            final mask = requireObject(data.values[i], path);
            if (!mask.ok) return mask.toOutcome();
            final item = validateCollaborationModeMask(mask, path);
            if (!item.ok) return item;
            i = i + 1;
        }
        return success("response:collaborationMode/list");
    }

    static function validateCollaborationModeMask(mask:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final name = requiredString(mask.keys, mask.values, "name", path + ".name");
        if (!name.ok) return name.toOutcome();
        if (name.value.length == 0) return fail("empty_string", path + ".name", "expected non-empty JSON string");
        final mode = validateOptionalNullableStringEnum(mask, "mode", path + ".mode", ["default", "plan"], "invalid_collaboration_mode");
        if (!mode.ok) return mode;
        final model = validateOptionalNullableString(mask, "model", path + ".model");
        if (!model.ok) return model;
        final reasoningEffort = validateOptionalNullableNonEmptyString(mask, "reasoning_effort", path + ".reasoning_effort");
        if (!reasoningEffort.ok) return reasoningEffort;
        return success("collaboration-mode-mask");
    }

    static function validatePluginMarketplaceResponse(result:ProtocolObjectField, featured:Bool, label:String):AppProtocolParseOutcome {
        for (field in ["marketplaces", "marketplaceLoadErrors"]) {
            final items = requiredArray(result.keys, result.values, field, "$.message.result." + field);
            if (!items.ok) return items.toOutcome();
            final objectItems = validateObjectArrayEntries(items.values, "$.message.result." + field, label);
            if (!objectItems.ok) return objectItems;
        }
        if (featured) {
            final featuredPluginIds = requiredArray(result.keys, result.values, "featuredPluginIds", "$.message.result.featuredPluginIds");
            if (!featuredPluginIds.ok) return featuredPluginIds.toOutcome();
            final featuredResult = validateStringArrayEntries(featuredPluginIds.values, "$.message.result.featuredPluginIds");
            if (!featuredResult.ok) return featuredResult;
        }
        return success(label);
    }

    static function validateMarketplaceAddResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["marketplaceName", "installedRoot"]) {
            final value = requiredString(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        final alreadyAdded = requiredBool(result.keys, result.values, "alreadyAdded", "$.message.result.alreadyAdded");
        if (!alreadyAdded.ok) return alreadyAdded.toOutcome();
        return success("response:marketplace/add");
    }

    static function validateMarketplaceRemoveResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final marketplaceName = requiredString(result.keys, result.values, "marketplaceName", "$.message.result.marketplaceName");
        if (!marketplaceName.ok) return marketplaceName.toOutcome();
        final installedRoot = requiredNullableString(result.keys, result.values, "installedRoot", "$.message.result.installedRoot");
        if (!installedRoot.ok) return installedRoot.toOutcome();
        return success("response:marketplace/remove");
    }

    static function validateMarketplaceUpgradeResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["selectedMarketplaces", "upgradedRoots"]) {
            final entries = requiredArray(result.keys, result.values, field, "$.message.result." + field);
            if (!entries.ok) return entries.toOutcome();
            final strings = validateStringArrayEntries(entries.values, "$.message.result." + field);
            if (!strings.ok) return strings;
        }
        final errors = requiredArray(result.keys, result.values, "errors", "$.message.result.errors");
        if (!errors.ok) return errors.toOutcome();
        return validateObjectArrayEntries(errors.values, "$.message.result.errors", "response:marketplace/upgrade");
    }

    static function validateSkillsConfigWriteResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final effectiveEnabled = requiredBool(result.keys, result.values, "effectiveEnabled", "$.message.result.effectiveEnabled");
        if (!effectiveEnabled.ok) return effectiveEnabled.toOutcome();
        return success("response:skills/config/write");
    }

    static function validateRequiredObjectResponse(result:ProtocolObjectField, field:String, path:String, label:String):AppProtocolParseOutcome {
        final object = requiredObjectField(result.keys, result.values, field, path);
        if (!object.ok) return object.toOutcome();
        return success(label);
    }

    static function validatePluginSkillReadResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final contents = requiredNullableString(result.keys, result.values, "contents", "$.message.result.contents");
        if (!contents.ok) return contents.toOutcome();
        return success("response:plugin/skill/read");
    }

    static function validatePluginInstallResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final authPolicy = requiredValue(result.keys, result.values, "authPolicy", "$.message.result.authPolicy");
        if (!authPolicy.ok) return authPolicy.toOutcome();
        final apps = requiredArray(result.keys, result.values, "appsNeedingAuth", "$.message.result.appsNeedingAuth");
        if (!apps.ok) return apps.toOutcome();
        return validateObjectArrayEntries(apps.values, "$.message.result.appsNeedingAuth", "response:plugin/install");
    }

    static function validatePluginShareSaveResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["remotePluginId", "shareUrl"]) {
            final value = requiredString(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("response:plugin/share/save");
    }

    static function validatePluginShareUpdateTargetsResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final principals = requiredArray(result.keys, result.values, "principals", "$.message.result.principals");
        if (!principals.ok) return principals.toOutcome();
        final principalObjects = validateObjectArrayEntries(principals.values, "$.message.result.principals", "response:plugin/share/updateTargets");
        if (!principalObjects.ok) return principalObjects;
        final discoverability = requiredString(result.keys, result.values, "discoverability", "$.message.result.discoverability");
        if (!discoverability.ok) return discoverability.toOutcome();
        return success("response:plugin/share/updateTargets");
    }

    static function validatePluginShareCheckoutResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["remotePluginId", "pluginId", "pluginName", "pluginPath", "marketplaceName", "marketplacePath"]) {
            final value = requiredString(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        final remoteVersion = requiredNullableString(result.keys, result.values, "remoteVersion", "$.message.result.remoteVersion");
        if (!remoteVersion.ok) return remoteVersion.toOutcome();
        return success("response:plugin/share/checkout");
    }

    static function validateFsReadFileResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final dataBase64 = requiredString(result.keys, result.values, "dataBase64", "$.message.result.dataBase64");
        if (!dataBase64.ok) return dataBase64.toOutcome();
        return success("response:fs/readFile");
    }

    static function validateFsGetMetadataResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["isDirectory", "isFile", "isSymlink"]) {
            final value = requiredBool(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        for (field in ["createdAtMs", "modifiedAtMs"]) {
            final value = requiredNumber(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("response:fs/getMetadata");
    }

    static function validateFsReadDirectoryResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final entries = requiredArray(result.keys, result.values, "entries", "$.message.result.entries");
        if (!entries.ok) return entries.toOutcome();
        return validateObjectArrayEntries(entries.values, "$.message.result.entries", "response:fs/readDirectory");
    }

    static function validateFsWatchResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final path = requiredString(result.keys, result.values, "path", "$.message.result.path");
        if (!path.ok) return path.toOutcome();
        return success("response:fs/watch");
    }

    static function validateModelProviderCapabilitiesResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["namespaceTools", "imageGeneration", "webSearch"]) {
            final value = requiredBool(result.keys, result.values, field, "$.message.result." + field);
            if (!value.ok) return value.toOutcome();
        }
        return success("response:modelProvider/capabilities/read");
    }

    static function validateFeatureEnablementResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final enablement = requiredObjectField(result.keys, result.values, "enablement", "$.message.result.enablement");
        if (!enablement.ok) return enablement.toOutcome();
        return validateBoolMap(enablement, "$.message.result.enablement", "response:experimentalFeature/enablement/set");
    }

    static function validateMcpServerOauthLoginResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final authorizationUrl = requiredString(result.keys, result.values, "authorizationUrl", "$.message.result.authorizationUrl");
        if (!authorizationUrl.ok) return authorizationUrl.toOutcome();
        return success("response:mcpServer/oauth/login");
    }

    static function validateArrayOnlyResponse(result:ProtocolObjectField, field:String, path:String, label:String):AppProtocolParseOutcome {
        final array = requiredArray(result.keys, result.values, field, path);
        if (!array.ok) return array.toOutcome();
        return success(label);
    }

    static function validateMcpServerToolCallResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final content = requiredArray(result.keys, result.values, "content", "$.message.result.content");
        if (!content.ok) return content.toOutcome();
        final structured = optionalValue(result.keys, result.values, "structuredContent");
        if (structured.ok && !validJsonValue(structured.value)) return fail("invalid_json_value", "$.message.result.structuredContent", "expected JSON value");
        final meta = optionalValue(result.keys, result.values, "_meta");
        if (meta.ok && !validJsonValue(meta.value)) return fail("invalid_json_value", "$.message.result._meta", "expected JSON value");
        final isError = validateOptionalBool(result, "isError", "$.message.result.isError");
        if (!isError.ok) return isError;
        return success("response:mcpServer/tool/call");
    }

    static function validateServerRequestParams(method:String, params:ProtocolObjectField):AppProtocolParseOutcome {
        return switch method {
            case "item/commandExecution/requestApproval":
                validateCommandExecutionRequestApprovalParams(params);
            case "item/fileChange/requestApproval":
                validateFileChangeRequestApprovalParams(params);
            case "item/permissions/requestApproval":
                validatePermissionsRequestApprovalParams(params);
            case "item/tool/requestUserInput":
                validateToolRequestUserInputParams(params);
            case "mcpServer/elicitation/request":
                validateMcpServerElicitationRequestParams(params);
            case "item/tool/call":
                validateDynamicToolCallParams(params);
            case "account/chatgptAuthTokens/refresh":
                validateChatgptAuthTokensRefreshParams(params);
            case "attestation/generate":
                validateEmptyObject(params, "$.message.params", "server-request-params:attestation/generate");
            case _:
                fail("unsupported_method", "$.method", "unsupported server request params method");
        }
    }

    static function validateServerResponsePayload(method:String, response:ProtocolObjectField):AppProtocolParseOutcome {
        return switch method {
            case "item/commandExecution/requestApproval":
                final decision = requiredValue(response.keys, response.values, "decision", "$.message.response.decision");
                if (!decision.ok) return decision.toOutcome();
                validateCommandExecutionApprovalDecision(decision.value, "$.message.response.decision");
            case "item/fileChange/requestApproval":
                final decision = requiredString(response.keys, response.values, "decision", "$.message.response.decision");
                if (!decision.ok) return decision.toOutcome();
                if (!validFileChangeApprovalDecision(decision.value)) fail("invalid_file_change_approval_decision", "$.message.response.decision", "unsupported file change approval decision") else success("server-response:item/fileChange/requestApproval");
            case "item/permissions/requestApproval":
                validatePermissionsRequestApprovalResponse(response);
            case "item/tool/requestUserInput":
                validateToolRequestUserInputResponse(response);
            case "mcpServer/elicitation/request":
                validateMcpServerElicitationRequestResponse(response);
            case "item/tool/call":
                validateDynamicToolCallResponse(response);
            case "account/chatgptAuthTokens/refresh":
                validateChatgptAuthTokensRefreshResponse(response);
            case "attestation/generate":
                final token = requiredString(response.keys, response.values, "token", "$.message.response.token");
                if (!token.ok) return token.toOutcome();
                success("server-response:attestation/generate");
            case _:
                fail("unsupported_method", "$.method", "unsupported server response method");
        }
    }

    static function validateServerThreadTurnItemFields(params:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", path + ".threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", path + ".turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final itemId = requiredString(params.keys, params.values, "itemId", path + ".itemId");
        if (!itemId.ok) return itemId.toOutcome();
        return success("server-thread-turn-item-fields");
    }

    static function validateApprovalStartedAt(params:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final startedAtMs = requiredUInt(params.keys, params.values, "startedAtMs", path + ".startedAtMs");
        if (!startedAtMs.ok) return startedAtMs.toOutcome();
        return success("approval-started-at");
    }

    static function validateCommandExecutionRequestApprovalParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final identity = validateServerThreadTurnItemFields(params, "$.message.params");
        if (!identity.ok) return identity;
        final startedAt = validateApprovalStartedAt(params, "$.message.params");
        if (!startedAt.ok) return startedAt;
        for (field in ["approvalId", "reason", "command", "cwd"]) {
            final value = validateOptionalNullableString(params, field, "$.message.params." + field);
            if (!value.ok) return value;
        }
        for (field in ["networkApprovalContext", "additionalPermissions", "proposedExecpolicyAmendment"]) {
            final value = validateOptionalNullableObject(params, field, "$.message.params." + field);
            if (!value.ok) return value;
        }
        for (field in ["commandActions", "proposedNetworkPolicyAmendments"]) {
            final value = validateOptionalArrayOrNull(params, field, "$.message.params." + field);
            if (!value.ok) return value;
        }
        final available = validateOptionalCommandExecutionDecisionArray(params, "availableDecisions", "$.message.params.availableDecisions");
        if (!available.ok) return available;
        return success("server-request:item/commandExecution/requestApproval");
    }

    static function validateFileChangeRequestApprovalParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final identity = validateServerThreadTurnItemFields(params, "$.message.params");
        if (!identity.ok) return identity;
        final startedAt = validateApprovalStartedAt(params, "$.message.params");
        if (!startedAt.ok) return startedAt;
        for (field in ["reason", "grantRoot"]) {
            final value = validateOptionalNullableString(params, field, "$.message.params." + field);
            if (!value.ok) return value;
        }
        return success("server-request:item/fileChange/requestApproval");
    }

    static function validatePermissionsRequestApprovalParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final identity = validateServerThreadTurnItemFields(params, "$.message.params");
        if (!identity.ok) return identity;
        final environmentId = requiredNullableString(params.keys, params.values, "environmentId", "$.message.params.environmentId");
        if (!environmentId.ok) return environmentId.toOutcome();
        final startedAt = validateApprovalStartedAt(params, "$.message.params");
        if (!startedAt.ok) return startedAt;
        final cwd = requiredString(params.keys, params.values, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd.toOutcome();
        final reason = requiredNullableString(params.keys, params.values, "reason", "$.message.params.reason");
        if (!reason.ok) return reason.toOutcome();
        final permissions = requiredObjectField(params.keys, params.values, "permissions", "$.message.params.permissions");
        if (!permissions.ok) return permissions.toOutcome();
        return validateRequestPermissionProfile(permissions, "$.message.params.permissions", true, "server-request:item/permissions/requestApproval");
    }

    static function validateToolRequestUserInputParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final identity = validateServerThreadTurnItemFields(params, "$.message.params");
        if (!identity.ok) return identity;
        final questions = requiredArray(params.keys, params.values, "questions", "$.message.params.questions");
        if (!questions.ok) return questions.toOutcome();
        var i = 0;
        while (i < questions.values.length) {
            final path = "$.message.params.questions[" + Std.string(i) + "]";
            final question = requireObject(questions.values[i], path);
            if (!question.ok) return question.toOutcome();
            for (field in ["id", "header", "question"]) {
                final value = requiredString(question.keys, question.values, field, path + "." + field);
                if (!value.ok) return value.toOutcome();
            }
            for (field in ["isOther", "isSecret"]) {
                final value = requiredBool(question.keys, question.values, field, path + "." + field);
                if (!value.ok) return value.toOutcome();
            }
            final options = validateToolRequestUserInputOptions(question, "options", path + ".options");
            if (!options.ok) return options;
            i = i + 1;
        }
        return success("server-request:item/tool/requestUserInput");
    }

    static function validateMcpServerElicitationRequestParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredNullableString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final serverName = requiredString(params.keys, params.values, "serverName", "$.message.params.serverName");
        if (!serverName.ok) return serverName.toOutcome();
        final mode = requiredString(params.keys, params.values, "mode", "$.message.params.mode");
        if (!mode.ok) return mode.toOutcome();
        final meta = requiredValue(params.keys, params.values, "_meta", "$.message.params._meta");
        if (!meta.ok) return meta.toOutcome();
        final message = requiredString(params.keys, params.values, "message", "$.message.params.message");
        if (!message.ok) return message.toOutcome();
        if (mode.value == "form") {
            final requestedSchema = requiredObjectField(params.keys, params.values, "requestedSchema", "$.message.params.requestedSchema");
            if (!requestedSchema.ok) return requestedSchema.toOutcome();
            return success("server-request:mcpServer/elicitation/request:form");
        }
        if (mode.value == "url") {
            final url = requiredString(params.keys, params.values, "url", "$.message.params.url");
            if (!url.ok) return url.toOutcome();
            final elicitationId = requiredString(params.keys, params.values, "elicitationId", "$.message.params.elicitationId");
            if (!elicitationId.ok) return elicitationId.toOutcome();
            return success("server-request:mcpServer/elicitation/request:url");
        }
        return fail("invalid_mcp_elicitation_mode", "$.message.params.mode", "unsupported MCP elicitation mode");
    }

    static function validateDynamicToolCallParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final callId = requiredString(params.keys, params.values, "callId", "$.message.params.callId");
        if (!callId.ok) return callId.toOutcome();
        final namespace = requiredNullableString(params.keys, params.values, "namespace", "$.message.params.namespace");
        if (!namespace.ok) return namespace.toOutcome();
        final tool = requiredString(params.keys, params.values, "tool", "$.message.params.tool");
        if (!tool.ok) return tool.toOutcome();
        final arguments = requiredValue(params.keys, params.values, "arguments", "$.message.params.arguments");
        if (!arguments.ok) return arguments.toOutcome();
        return success("server-request:item/tool/call");
    }

    static function validateChatgptAuthTokensRefreshParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final reason = requiredString(params.keys, params.values, "reason", "$.message.params.reason");
        if (!reason.ok) return reason.toOutcome();
        if (reason.value != "unauthorized") return fail("invalid_chatgpt_auth_tokens_refresh_reason", "$.message.params.reason", "unsupported auth token refresh reason");
        final previousAccountId = validateOptionalNullableString(params, "previousAccountId", "$.message.params.previousAccountId");
        if (!previousAccountId.ok) return previousAccountId;
        return success("server-request:account/chatgptAuthTokens/refresh");
    }

    static function validatePermissionsRequestApprovalResponse(response:ProtocolObjectField):AppProtocolParseOutcome {
        final permissions = requiredObjectField(response.keys, response.values, "permissions", "$.message.response.permissions");
        if (!permissions.ok) return permissions.toOutcome();
        final permissionResult = validateRequestPermissionProfile(permissions, "$.message.response.permissions", false, "server-response-permissions");
        if (!permissionResult.ok) return permissionResult;
        final scope = requiredString(response.keys, response.values, "scope", "$.message.response.scope");
        if (!scope.ok) return scope.toOutcome();
        if (scope.value != "turn" && scope.value != "session") return fail("invalid_permission_grant_scope", "$.message.response.scope", "unsupported permission grant scope");
        final strictAutoReview = validateOptionalBool(response, "strictAutoReview", "$.message.response.strictAutoReview");
        if (!strictAutoReview.ok) return strictAutoReview;
        return success("server-response:item/permissions/requestApproval");
    }

    static function validateToolRequestUserInputResponse(response:ProtocolObjectField):AppProtocolParseOutcome {
        final answers = requiredObjectField(response.keys, response.values, "answers", "$.message.response.answers");
        if (!answers.ok) return answers.toOutcome();
        var i = 0;
        while (i < answers.values.length) {
            final path = "$.message.response.answers." + answers.keys[i];
            final answer = requireObject(answers.values[i], path);
            if (!answer.ok) return answer.toOutcome();
            final values = requiredArray(answer.keys, answer.values, "answers", path + ".answers");
            if (!values.ok) return values.toOutcome();
            final strings = validateStringArrayEntries(values.values, path + ".answers");
            if (!strings.ok) return strings;
            i = i + 1;
        }
        return success("server-response:item/tool/requestUserInput");
    }

    static function validateMcpServerElicitationRequestResponse(response:ProtocolObjectField):AppProtocolParseOutcome {
        final action = requiredString(response.keys, response.values, "action", "$.message.response.action");
        if (!action.ok) return action.toOutcome();
        if (action.value != "accept" && action.value != "decline" && action.value != "cancel") return fail("invalid_mcp_elicitation_action", "$.message.response.action", "unsupported MCP elicitation action");
        final content = requiredValue(response.keys, response.values, "content", "$.message.response.content");
        if (!content.ok) return content.toOutcome();
        final meta = requiredValue(response.keys, response.values, "_meta", "$.message.response._meta");
        if (!meta.ok) return meta.toOutcome();
        return success("server-response:mcpServer/elicitation/request");
    }

    static function validateDynamicToolCallResponse(response:ProtocolObjectField):AppProtocolParseOutcome {
        final contentItems = requiredArray(response.keys, response.values, "contentItems", "$.message.response.contentItems");
        if (!contentItems.ok) return contentItems.toOutcome();
        var i = 0;
        while (i < contentItems.values.length) {
            final itemPath = "$.message.response.contentItems[" + Std.string(i) + "]";
            final item = requireObject(contentItems.values[i], itemPath);
            if (!item.ok) return item.toOutcome();
            final itemResult = validateDynamicToolCallOutputContentItem(item, itemPath);
            if (!itemResult.ok) return itemResult;
            i = i + 1;
        }
        final successFlag = requiredBool(response.keys, response.values, "success", "$.message.response.success");
        if (!successFlag.ok) return successFlag.toOutcome();
        return success("server-response:item/tool/call");
    }

    static function validateChatgptAuthTokensRefreshResponse(response:ProtocolObjectField):AppProtocolParseOutcome {
        for (field in ["accessToken", "chatgptAccountId"]) {
            final value = requiredString(response.keys, response.values, field, "$.message.response." + field);
            if (!value.ok) return value.toOutcome();
        }
        final planType = requiredNullableString(response.keys, response.values, "chatgptPlanType", "$.message.response.chatgptPlanType");
        if (!planType.ok) return planType.toOutcome();
        return success("server-response:account/chatgptAuthTokens/refresh");
    }

    static function validateOptionalCommandExecutionDecisionArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("command-exec-decisions:missing");
        return switch object.values[i] {
            case JNull:
                success("command-exec-decisions:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final result = validateCommandExecutionApprovalDecision(entries[entryIndex], path + "[" + Std.string(entryIndex) + "]");
                    if (!result.ok) return result;
                    entryIndex = entryIndex + 1;
                }
                success("command-exec-decisions");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateCommandExecutionApprovalDecision(value:Value, path:String):AppProtocolParseOutcome {
        return switch value {
            case JString(decision):
                if (validCommandExecutionApprovalDecision(decision)) success("command-exec-decision:" + decision) else fail("invalid_command_execution_approval_decision", path, "unsupported command execution approval decision");
            case JObject(keys, values):
                if (hasField(keys, "acceptWithExecpolicyAmendment")) {
                    final amendment = requiredObjectField(keys, values, "acceptWithExecpolicyAmendment", path + ".acceptWithExecpolicyAmendment");
                    if (!amendment.ok) return amendment.toOutcome();
                    final execpolicy = requiredObjectField(amendment.keys, amendment.values, "execpolicy_amendment", path + ".acceptWithExecpolicyAmendment.execpolicy_amendment");
                    if (!execpolicy.ok) return execpolicy.toOutcome();
                    success("command-exec-decision:acceptWithExecpolicyAmendment");
                } else if (hasField(keys, "applyNetworkPolicyAmendment")) {
                    final amendment = requiredObjectField(keys, values, "applyNetworkPolicyAmendment", path + ".applyNetworkPolicyAmendment");
                    if (!amendment.ok) return amendment.toOutcome();
                    final policy = requiredObjectField(amendment.keys, amendment.values, "network_policy_amendment", path + ".applyNetworkPolicyAmendment.network_policy_amendment");
                    if (!policy.ok) return policy.toOutcome();
                    success("command-exec-decision:applyNetworkPolicyAmendment");
                } else {
                    fail("invalid_command_execution_approval_decision", path, "unsupported command execution approval decision object");
                }
            case _:
                fail("invalid_command_execution_approval_decision", path, "unsupported command execution approval decision");
        }
    }

    static function validateRequestPermissionProfile(profile:ProtocolObjectField, path:String, requireNullableKeys:Bool, label:String):AppProtocolParseOutcome {
        final network = if (requireNullableKeys) validateRequiredNullableObject(profile, "network", path + ".network") else validateOptionalNullableObject(profile, "network", path + ".network");
        if (!network.ok) return network;
        final fileSystem = if (requireNullableKeys) validateRequiredNullableObject(profile, "fileSystem", path + ".fileSystem") else validateOptionalNullableObject(profile, "fileSystem", path + ".fileSystem");
        if (!fileSystem.ok) return fileSystem;
        return success(label);
    }

    static function validateToolRequestUserInputOptions(question:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(question.keys, name);
        if (i < 0) return fail("missing_field", path, "required field is missing");
        return switch question.values[i] {
            case JNull:
                success("tool-user-input-options:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final optionPath = path + "[" + Std.string(entryIndex) + "]";
                    final option = requireObject(entries[entryIndex], optionPath);
                    if (!option.ok) return option.toOutcome();
                    for (field in ["label", "description"]) {
                        final value = requiredString(option.keys, option.values, field, optionPath + "." + field);
                        if (!value.ok) return value.toOutcome();
                    }
                    entryIndex = entryIndex + 1;
                }
                success("tool-user-input-options");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateDynamicToolCallOutputContentItem(item:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final itemType = requiredString(item.keys, item.values, "type", path + ".type");
        if (!itemType.ok) return itemType.toOutcome();
        if (itemType.value == "inputText") {
            final text = requiredString(item.keys, item.values, "text", path + ".text");
            if (!text.ok) return text.toOutcome();
            return success("dynamic-tool-output:inputText");
        }
        if (itemType.value == "inputImage") {
            final imageUrl = requiredString(item.keys, item.values, "imageUrl", path + ".imageUrl");
            if (!imageUrl.ok) return imageUrl.toOutcome();
            return success("dynamic-tool-output:inputImage");
        }
        return fail("invalid_dynamic_tool_output_type", path + ".type", "unsupported dynamic tool output content item type");
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

    static function validateThreadIdParams(params:ProtocolObjectField, method:String):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        return success("params:" + method);
    }

    static function validateThreadOpenParams(params:ProtocolObjectField, method:String):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        for (field in ["cwd", "model", "modelProvider", "baseInstructions", "developerInstructions", "serviceTier"]) {
            final result = validateOptionalNullableString(params, field, "$.message.params." + field);
            if (!result.ok) return result;
        }
        final approvalPolicy = validateOptionalAskForApproval(params, "approvalPolicy", "$.message.params.approvalPolicy");
        if (!approvalPolicy.ok) return approvalPolicy;
        final approvalsReviewer = validateOptionalNullableStringEnum(params, "approvalsReviewer", "$.message.params.approvalsReviewer", ["user", "auto_review", "guardian_subagent"], "invalid_approvals_reviewer");
        if (!approvalsReviewer.ok) return approvalsReviewer;
        final sandbox = validateOptionalNullableStringEnum(params, "sandbox", "$.message.params.sandbox", ["read-only", "workspace-write", "danger-full-access"], "invalid_sandbox_mode");
        if (!sandbox.ok) return sandbox;
        final personality = validateOptionalNullableStringEnum(params, "personality", "$.message.params.personality", ["none", "friendly", "pragmatic"], "invalid_personality");
        if (!personality.ok) return personality;
        final config = validateOptionalNullableObject(params, "config", "$.message.params.config");
        if (!config.ok) return config;
        final ephemeral = validateOptionalBool(params, "ephemeral", "$.message.params.ephemeral");
        if (!ephemeral.ok) return ephemeral;
        final threadSource = validateOptionalNullableString(params, "threadSource", "$.message.params.threadSource");
        if (!threadSource.ok) return threadSource;
        return success("params:" + method);
    }

    static function validateThreadOpenResponse(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final thread = requiredObjectField(result.keys, result.values, "thread", path + ".thread");
        if (!thread.ok) return thread.toOutcome();
        final threadResult = validateThread(thread, path + ".thread");
        if (!threadResult.ok) return threadResult;
        final approval = validateRequiredAskForApproval(result, "approvalPolicy", path + ".approvalPolicy");
        if (!approval.ok) return approval;
        final approvalsReviewer = validateRequiredStringEnum(result.keys, result.values, "approvalsReviewer", path + ".approvalsReviewer", ["user", "auto_review", "guardian_subagent"], "invalid_approvals_reviewer");
        if (!approvalsReviewer.ok) return approvalsReviewer;
        for (field in ["cwd", "model", "modelProvider"]) {
            final text = requiredString(result.keys, result.values, field, path + "." + field);
            if (!text.ok) return text.toOutcome();
        }
        final sandbox = validateRequiredSandboxPolicy(result, "sandbox", path + ".sandbox");
        if (!sandbox.ok) return sandbox;
        final instructionSources = validateOptionalStringArray(result, "instructionSources", path + ".instructionSources", false);
        if (!instructionSources.ok) return instructionSources;
        final reasoningEffort = validateOptionalNullableNonEmptyString(result, "reasoningEffort", path + ".reasoningEffort");
        if (!reasoningEffort.ok) return reasoningEffort;
        final serviceTier = validateOptionalNullableString(result, "serviceTier", path + ".serviceTier");
        if (!serviceTier.ok) return serviceTier;
        return success(label);
    }

    static function validateThreadUnsubscribeResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final status = requiredString(result.keys, result.values, "status", "$.message.result.status");
        if (!status.ok) return status.toOutcome();
        if (!contains(["notLoaded", "notSubscribed", "unsubscribed"], status.value)) return fail("invalid_thread_unsubscribe_status", "$.message.result.status", "unsupported unsubscribe status");
        return success("response:thread/unsubscribe");
    }

    static function validateThreadListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final archived = validateOptionalNullableBool(params, "archived", "$.message.params.archived");
        if (!archived.ok) return archived;
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        final searchTerm = validateOptionalNullableString(params, "searchTerm", "$.message.params.searchTerm");
        if (!searchTerm.ok) return searchTerm;
        final sortDirection = validateOptionalNullableStringEnum(params, "sortDirection", "$.message.params.sortDirection", ["asc", "desc"], "invalid_sort_direction");
        if (!sortDirection.ok) return sortDirection;
        final sortKey = validateOptionalNullableStringEnum(params, "sortKey", "$.message.params.sortKey", ["created_at", "updated_at"], "invalid_thread_sort_key");
        if (!sortKey.ok) return sortKey;
        final useStateDbOnly = validateOptionalBool(params, "useStateDbOnly", "$.message.params.useStateDbOnly");
        if (!useStateDbOnly.ok) return useStateDbOnly;
        final cwd = validateOptionalThreadListCwd(params, "cwd", "$.message.params.cwd");
        if (!cwd.ok) return cwd;
        final modelProviders = validateOptionalStringArray(params, "modelProviders", "$.message.params.modelProviders", true);
        if (!modelProviders.ok) return modelProviders;
        final sourceKinds = validateOptionalThreadSourceKindArray(params, "sourceKinds", "$.message.params.sourceKinds");
        if (!sourceKinds.ok) return sourceKinds;
        return success("params:thread/list");
    }

    static function validateThreadLoadedListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        return success("params:thread/loaded/list");
    }

    static function validateThreadSearchParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final searchTerm = requiredString(params.keys, params.values, "searchTerm", "$.message.params.searchTerm");
        if (!searchTerm.ok) return searchTerm.toOutcome();
        if (StringTools.trim(searchTerm.value).length == 0) return fail("empty_string", "$.message.params.searchTerm", "expected non-empty JSON string");
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        final sortDirection = validateOptionalNullableStringEnum(params, "sortDirection", "$.message.params.sortDirection", ["asc", "desc"], "invalid_sort_direction");
        if (!sortDirection.ok) return sortDirection;
        final sortKey = validateOptionalNullableStringEnum(params, "sortKey", "$.message.params.sortKey", ["created_at", "updated_at"], "invalid_thread_sort_key");
        if (!sortKey.ok) return sortKey;
        final sourceKinds = validateOptionalThreadSourceKindArray(params, "sourceKinds", "$.message.params.sourceKinds");
        if (!sourceKinds.ok) return sourceKinds;
        final archived = validateOptionalNullableBool(params, "archived", "$.message.params.archived");
        if (!archived.ok) return archived;
        return success("params:thread/search");
    }

    static function validateThreadListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final thread = requireObject(data.values[i], "$.message.result.data[" + Std.string(i) + "]");
            if (!thread.ok) return thread.toOutcome();
            final threadResult = validateThread(thread, "$.message.result.data[" + Std.string(i) + "]");
            if (!threadResult.ok) return threadResult;
            i = i + 1;
        }
        for (field in ["nextCursor", "backwardsCursor"]) {
            final cursor = validateOptionalNullableString(result, field, "$.message.result." + field);
            if (!cursor.ok) return cursor;
        }
        return success("response:thread/list");
    }

    static function validateThreadSearchResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final path = "$.message.result.data[" + Std.string(i) + "]";
            final entry = requireObject(data.values[i], path);
            if (!entry.ok) return entry.toOutcome();
            final thread = requiredObjectField(entry.keys, entry.values, "thread", path + ".thread");
            if (!thread.ok) return thread.toOutcome();
            final threadResult = validateThread(thread, path + ".thread");
            if (!threadResult.ok) return threadResult;
            final snippet = requiredString(entry.keys, entry.values, "snippet", path + ".snippet");
            if (!snippet.ok) return snippet.toOutcome();
            i = i + 1;
        }
        for (field in ["nextCursor", "backwardsCursor"]) {
            final cursor = validateOptionalNullableString(result, field, "$.message.result." + field);
            if (!cursor.ok) return cursor;
        }
        return success("response:thread/search");
    }

    static function validateFuzzyFileSearchSessionStartParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final sessionId = requiredNonEmptyString(params.keys, params.values, "sessionId", "$.message.params.sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        final roots = requiredArray(params.keys, params.values, "roots", "$.message.params.roots");
        if (!roots.ok) return roots.toOutcome();
        final rootResult = validateStringArrayEntries(roots.values, "$.message.params.roots");
        if (!rootResult.ok) return rootResult;
        return success("params:fuzzyFileSearch/sessionStart");
    }

    static function validateFuzzyFileSearchSessionUpdateParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final sessionId = requiredNonEmptyString(params.keys, params.values, "sessionId", "$.message.params.sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        final query = requiredString(params.keys, params.values, "query", "$.message.params.query");
        if (!query.ok) return query.toOutcome();
        return success("params:fuzzyFileSearch/sessionUpdate");
    }

    static function validateFuzzyFileSearchSessionStopParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final sessionId = requiredNonEmptyString(params.keys, params.values, "sessionId", "$.message.params.sessionId");
        if (!sessionId.ok) return sessionId.toOutcome();
        return success("params:fuzzyFileSearch/sessionStop");
    }

    static function validateThreadRealtimeStartParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final model = validateOptionalNullableString(params, "model", "$.message.params.model");
        if (!model.ok) return model;
        final outputModality = requiredString(params.keys, params.values, "outputModality", "$.message.params.outputModality");
        if (!outputModality.ok) return outputModality.toOutcome();
        if (!validRealtimeOutputModality(outputModality.value)) return fail("invalid_realtime_output_modality", "$.message.params.outputModality", "unsupported realtime output modality");
        final prompt = validateOptionalNullableString(params, "prompt", "$.message.params.prompt");
        if (!prompt.ok) return prompt;
        final realtimeSessionId = validateOptionalNullableString(params, "realtimeSessionId", "$.message.params.realtimeSessionId");
        if (!realtimeSessionId.ok) return realtimeSessionId;
        final transport = validateOptionalThreadRealtimeStartTransport(params, "transport", "$.message.params.transport");
        if (!transport.ok) return transport;
        final version = validateOptionalNullableStringEnum(params, "version", "$.message.params.version", ["v1", "v2"], "invalid_realtime_conversation_version");
        if (!version.ok) return version;
        final voice = validateOptionalNullableRealtimeVoice(params, "voice", "$.message.params.voice");
        if (!voice.ok) return voice;
        return success("params:thread/realtime/start");
    }

    static function validateOptionalThreadRealtimeStartTransport(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("thread-realtime-transport:missing");
        return switch object.values[i] {
            case JNull:
                success("thread-realtime-transport:null");
            case JObject(keys, values):
                final transportType = requiredString(keys, values, "type", path + ".type");
                if (!transportType.ok) transportType.toOutcome() else if (!validRealtimeTransportType(transportType.value)) fail("invalid_realtime_transport", path + ".type", "unsupported realtime transport") else if (transportType.value == "webrtc") {
                    final sdp = requiredString(keys, values, "sdp", path + ".sdp");
                    if (!sdp.ok) sdp.toOutcome() else success("thread-realtime-transport:webrtc");
                } else success("thread-realtime-transport:websocket");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateThreadRealtimeAppendAudioParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final audio = requiredObjectField(params.keys, params.values, "audio", "$.message.params.audio");
        if (!audio.ok) return audio.toOutcome();
        final audioResult = validateThreadRealtimeAudioChunk(audio, "$.message.params.audio");
        if (!audioResult.ok) return audioResult;
        return success("params:thread/realtime/appendAudio");
    }

    static function validateThreadRealtimeAppendTextParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final text = requiredString(params.keys, params.values, "text", "$.message.params.text");
        if (!text.ok) return text.toOutcome();
        return success("params:thread/realtime/appendText");
    }

    static function validateThreadRealtimeStopParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        return success("params:thread/realtime/stop");
    }

    static function validateThreadRealtimeListVoicesResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final voices = requiredObjectField(result.keys, result.values, "voices", "$.message.result.voices");
        if (!voices.ok) return voices.toOutcome();
        final v1 = requiredArray(voices.keys, voices.values, "v1", "$.message.result.voices.v1");
        if (!v1.ok) return v1.toOutcome();
        final v1Result = validateRealtimeVoiceArray(v1.values, "$.message.result.voices.v1");
        if (!v1Result.ok) return v1Result;
        final v2 = requiredArray(voices.keys, voices.values, "v2", "$.message.result.voices.v2");
        if (!v2.ok) return v2.toOutcome();
        final v2Result = validateRealtimeVoiceArray(v2.values, "$.message.result.voices.v2");
        if (!v2Result.ok) return v2Result;
        final defaultV1 = requiredString(voices.keys, voices.values, "defaultV1", "$.message.result.voices.defaultV1");
        if (!defaultV1.ok) return defaultV1.toOutcome();
        if (!validRealtimeVoice(defaultV1.value)) return fail("invalid_realtime_voice", "$.message.result.voices.defaultV1", "unsupported realtime voice");
        final defaultV2 = requiredString(voices.keys, voices.values, "defaultV2", "$.message.result.voices.defaultV2");
        if (!defaultV2.ok) return defaultV2.toOutcome();
        if (!validRealtimeVoice(defaultV2.value)) return fail("invalid_realtime_voice", "$.message.result.voices.defaultV2", "unsupported realtime voice");
        return success("response:thread/realtime/listVoices");
    }

    static function validateRealtimeVoiceArray(values:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < values.length) {
            switch values[i] {
                case JString(value):
                    if (!validRealtimeVoice(value)) return fail("invalid_realtime_voice", path + "[" + Std.string(i) + "]", "unsupported realtime voice");
                case _:
                    return fail("expected_string", path + "[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }
        return success("realtime-voice-array");
    }

    static function validateOptionalNullableRealtimeVoice(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("nullable-realtime-voice:missing");
        return switch object.values[i] {
            case JNull:
                success("nullable-realtime-voice:null");
            case JString(value):
                if (validRealtimeVoice(value)) success("nullable-realtime-voice") else fail("invalid_realtime_voice", path, "unsupported realtime voice");
            case _:
                fail("expected_nullable_string", path, "expected JSON string or null");
        }
    }

    static function validateRemoteControlStatusResponse(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final installationId = requiredString(result.keys, result.values, "installationId", path + ".installationId");
        if (!installationId.ok) return installationId.toOutcome();
        final serverName = requiredString(result.keys, result.values, "serverName", path + ".serverName");
        if (!serverName.ok) return serverName.toOutcome();
        final status = requiredString(result.keys, result.values, "status", path + ".status");
        if (!status.ok) return status.toOutcome();
        if (!validRemoteControlStatus(status.value)) return fail("invalid_remote_control_status", path + ".status", "unsupported remote control status");
        final environmentId = validateOptionalNullableString(result, "environmentId", path + ".environmentId");
        if (!environmentId.ok) return environmentId;
        return success(label);
    }

    static function validateRemoteControlPairingStartParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final manualCode = validateOptionalBool(params, "manualCode", "$.message.params.manualCode");
        if (!manualCode.ok) return manualCode;
        return success("params:remoteControl/pairing/start");
    }

    static function validateRemoteControlPairingStartResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final pairingCode = requiredString(result.keys, result.values, "pairingCode", "$.message.result.pairingCode");
        if (!pairingCode.ok) return pairingCode.toOutcome();
        final manualPairingCode = validateOptionalNullableString(result, "manualPairingCode", "$.message.result.manualPairingCode");
        if (!manualPairingCode.ok) return manualPairingCode;
        final environmentId = requiredString(result.keys, result.values, "environmentId", "$.message.result.environmentId");
        if (!environmentId.ok) return environmentId.toOutcome();
        final expiresAt = requiredInteger(result.keys, result.values, "expiresAt", "$.message.result.expiresAt");
        if (!expiresAt.ok) return expiresAt.toOutcome();
        return success("response:remoteControl/pairing/start");
    }

    static function validateRemoteControlPairingStatusParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final pairingCode = validateOptionalNullableString(params, "pairingCode", "$.message.params.pairingCode");
        if (!pairingCode.ok) return pairingCode;
        final manualPairingCode = validateOptionalNullableString(params, "manualPairingCode", "$.message.params.manualPairingCode");
        if (!manualPairingCode.ok) return manualPairingCode;
        final hasPairingCode = hasNonNullField(params, "pairingCode");
        final hasManualPairingCode = hasNonNullField(params, "manualPairingCode");
        if (hasPairingCode && hasManualPairingCode) return fail("remote_control_pairing_code_conflict", "$.message.params", "expected exactly one pairing code field");
        if (!hasPairingCode && !hasManualPairingCode) return fail("missing_remote_control_pairing_code", "$.message.params", "expected pairingCode or manualPairingCode");
        return success("params:remoteControl/pairing/status");
    }

    static function validateRemoteControlPairingStatusResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final claimed = requiredBool(result.keys, result.values, "claimed", "$.message.result.claimed");
        if (!claimed.ok) return claimed.toOutcome();
        return success("response:remoteControl/pairing/status");
    }

    static function validateRemoteControlClientsListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final environmentId = requiredString(params.keys, params.values, "environmentId", "$.message.params.environmentId");
        if (!environmentId.ok) return environmentId.toOutcome();
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        final order = validateOptionalNullableStringEnum(params, "order", "$.message.params.order", ["asc", "desc"], "invalid_remote_control_clients_list_order");
        if (!order.ok) return order;
        return success("params:remoteControl/client/list");
    }

    static function validateRemoteControlClientsListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            switch data.values[i] {
                case JObject(keys, values):
                    final clientResult = validateRemoteControlClient(ProtocolObjectField.success(keys, values), "$.message.result.data[" + Std.string(i) + "]");
                    if (!clientResult.ok) return clientResult;
                case _:
                    return fail("expected_object", "$.message.result.data[" + Std.string(i) + "]", "expected JSON object");
            }
            i = i + 1;
        }
        final nextCursor = validateOptionalNullableString(result, "nextCursor", "$.message.result.nextCursor");
        if (!nextCursor.ok) return nextCursor;
        return success("response:remoteControl/client/list");
    }

    static function validateRemoteControlClient(client:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final clientId = requiredString(client.keys, client.values, "clientId", path + ".clientId");
        if (!clientId.ok) return clientId.toOutcome();
        for (field in ["displayName", "deviceType", "platform", "osVersion", "deviceModel", "appVersion"]) {
            final value = validateOptionalNullableString(client, field, path + "." + field);
            if (!value.ok) return value;
        }
        final lastSeenAt = validateOptionalNullableInteger(client, "lastSeenAt", path + ".lastSeenAt");
        if (!lastSeenAt.ok) return lastSeenAt;
        return success("remote-control-client");
    }

    static function validateRemoteControlClientsRevokeParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final environmentId = requiredString(params.keys, params.values, "environmentId", "$.message.params.environmentId");
        if (!environmentId.ok) return environmentId.toOutcome();
        final clientId = requiredString(params.keys, params.values, "clientId", "$.message.params.clientId");
        if (!clientId.ok) return clientId.toOutcome();
        return success("params:remoteControl/client/revoke");
    }

    static function validateThreadLoadedListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            switch data.values[i] {
                case JString(_):
                case _:
                    return fail("expected_string", "$.message.result.data[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }
        final nextCursor = validateOptionalNullableString(result, "nextCursor", "$.message.result.nextCursor");
        if (!nextCursor.ok) return nextCursor;
        return success("response:thread/loaded/list");
    }

    static function validateThreadTurnsListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        final sortDirection = validateOptionalNullableStringEnum(params, "sortDirection", "$.message.params.sortDirection", ["asc", "desc"], "invalid_sort_direction");
        if (!sortDirection.ok) return sortDirection;
        final itemsView = validateOptionalNullableStringEnum(params, "itemsView", "$.message.params.itemsView", ["notLoaded", "summary", "full"], "invalid_turn_items_view");
        if (!itemsView.ok) return itemsView;
        return success("params:thread/turns/list");
    }

    static function validateThreadTurnsItemsListParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final cursor = validateOptionalNullableString(params, "cursor", "$.message.params.cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", "$.message.params.limit");
        if (!limit.ok) return limit;
        final sortDirection = validateOptionalNullableStringEnum(params, "sortDirection", "$.message.params.sortDirection", ["asc", "desc"], "invalid_sort_direction");
        if (!sortDirection.ok) return sortDirection;
        return success("params:thread/turns/items/list");
    }

    static function validateThreadTurnsListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final turn = requireObject(data.values[i], "$.message.result.data[" + Std.string(i) + "]");
            if (!turn.ok) return turn.toOutcome();
            final turnResult = validateTurn(turn, "$.message.result.data[" + Std.string(i) + "]");
            if (!turnResult.ok) return turnResult;
            i = i + 1;
        }
        for (field in ["nextCursor", "backwardsCursor"]) {
            final cursor = validateOptionalNullableString(result, field, "$.message.result." + field);
            if (!cursor.ok) return cursor;
        }
        return success("response:thread/turns/list");
    }

    static function validateThreadTurnsItemsListResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final data = requiredArray(result.keys, result.values, "data", "$.message.result.data");
        if (!data.ok) return data.toOutcome();
        var i = 0;
        while (i < data.values.length) {
            final item = requireObject(data.values[i], "$.message.result.data[" + Std.string(i) + "]");
            if (!item.ok) return item.toOutcome();
            final itemResult = validateTranscriptItem(item, "$.message.result.data[" + Std.string(i) + "]");
            if (!itemResult.ok) return itemResult;
            i = i + 1;
        }
        for (field in ["nextCursor", "backwardsCursor"]) {
            final cursor = validateOptionalNullableString(result, field, "$.message.result." + field);
            if (!cursor.ok) return cursor;
        }
        return success("response:thread/turns/items/list");
    }

    static function validateThreadIdNotification(params:ProtocolObjectField, method:String):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        return success("notification:" + method);
    }

    static function validateThreadElicitationResponse(result:ProtocolObjectField, method:String):AppProtocolParseOutcome {
        final count = requiredUInt(result.keys, result.values, "count", "$.message.result.count");
        if (!count.ok) return count.toOutcome();
        final paused = requiredBool(result.keys, result.values, "paused", "$.message.result.paused");
        if (!paused.ok) return paused.toOutcome();
        return success("response:" + method);
    }

    static function validateThreadSetNameParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final name = requiredString(params.keys, params.values, "name", "$.message.params.name");
        if (!name.ok) return name.toOutcome();
        return success("params:thread/name/set");
    }

    static function validateThreadGoalSetParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final objective = validateOptionalNullableString(params, "objective", "$.message.params.objective");
        if (!objective.ok) return objective;
        final status = validateOptionalNullableStringEnum(params, "status", "$.message.params.status", ["active", "paused", "blocked", "usageLimited", "budgetLimited", "complete"], "invalid_thread_goal_status");
        if (!status.ok) return status;
        final tokenBudget = validateOptionalNullableInteger(params, "tokenBudget", "$.message.params.tokenBudget");
        if (!tokenBudget.ok) return tokenBudget;
        return success("params:thread/goal/set");
    }

    static function validateThreadGoalResponse(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final goal = requiredObjectField(result.keys, result.values, "goal", path + ".goal");
        if (!goal.ok) return goal.toOutcome();
        final goalResult = validateThreadGoal(goal, path + ".goal");
        if (!goalResult.ok) return goalResult;
        return success(label);
    }

    static function validateThreadGoalGetResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final i = fieldIndex(result.keys, "goal");
        if (i < 0) return success("response:thread/goal/get");
        return switch result.values[i] {
            case JNull:
                success("response:thread/goal/get");
            case JObject(keys, values):
                final goalResult = validateThreadGoal(ProtocolObjectField.success(keys, values), "$.message.result.goal");
                if (!goalResult.ok) goalResult else success("response:thread/goal/get");
            case _:
                fail("expected_nullable_object", "$.message.result.goal", "expected JSON object or null");
        }
    }

    static function validateThreadGoalClearResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final cleared = requiredBool(result.keys, result.values, "cleared", "$.message.result.cleared");
        if (!cleared.ok) return cleared.toOutcome();
        return success("response:thread/goal/clear");
    }

    static function validateThreadGoal(goal:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        for (field in ["threadId", "objective"]) {
            final text = requiredString(goal.keys, goal.values, field, path + "." + field);
            if (!text.ok) return text.toOutcome();
        }
        final status = requiredString(goal.keys, goal.values, "status", path + ".status");
        if (!status.ok) return status.toOutcome();
        if (!validThreadGoalStatus(status.value)) return fail("invalid_thread_goal_status", path + ".status", "unsupported thread goal status");
        final tokenBudget = validateOptionalNullableInteger(goal, "tokenBudget", path + ".tokenBudget");
        if (!tokenBudget.ok) return tokenBudget;
        for (field in ["tokensUsed", "timeUsedSeconds", "createdAt", "updatedAt"]) {
            final number = requiredInteger(goal.keys, goal.values, field, path + "." + field);
            if (!number.ok) return number.toOutcome();
        }
        return success("thread-goal");
    }

    static function validateThreadMetadataUpdateParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final gitInfo = validateOptionalThreadMetadataGitInfo(params, "gitInfo", "$.message.params.gitInfo");
        if (!gitInfo.ok) return gitInfo;
        return success("params:thread/metadata/update");
    }

    static function validateOptionalThreadMetadataGitInfo(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("thread-metadata-git-info:missing");
        return switch object.values[i] {
            case JNull:
                success("thread-metadata-git-info:null");
            case JObject(keys, values):
                final gitInfo = ProtocolObjectField.success(keys, values);
                for (field in ["sha", "branch", "originUrl"]) {
                    final result = validateOptionalNullableString(gitInfo, field, path + "." + field);
                    if (!result.ok) return result;
                }
                success("thread-metadata-git-info");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateThreadSettingsUpdateParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        for (field in ["cwd", "permissions", "model", "serviceTier"]) {
            final result = validateOptionalNullableString(params, field, "$.message.params." + field);
            if (!result.ok) return result;
        }
        final approvalPolicy = validateOptionalAskForApproval(params, "approvalPolicy", "$.message.params.approvalPolicy");
        if (!approvalPolicy.ok) return approvalPolicy;
        final approvalsReviewer = validateOptionalNullableStringEnum(params, "approvalsReviewer", "$.message.params.approvalsReviewer", ["user", "auto_review", "guardian_subagent"], "invalid_approvals_reviewer");
        if (!approvalsReviewer.ok) return approvalsReviewer;
        final sandboxPolicy = validateOptionalCommandExecSandboxPolicy(params, "sandboxPolicy", "$.message.params.sandboxPolicy");
        if (!sandboxPolicy.ok) return sandboxPolicy;
        final effort = validateOptionalNullableNonEmptyString(params, "effort", "$.message.params.effort");
        if (!effort.ok) return effort;
        final summary = validateOptionalNullableStringEnum(params, "summary", "$.message.params.summary", ["auto", "concise", "detailed", "none"], "invalid_reasoning_summary");
        if (!summary.ok) return summary;
        final collaborationMode = validateOptionalNullableCollaborationMode(params, "collaborationMode", "$.message.params.collaborationMode");
        if (!collaborationMode.ok) return collaborationMode;
        final personality = validateOptionalNullableStringEnum(params, "personality", "$.message.params.personality", ["none", "friendly", "pragmatic"], "invalid_personality");
        if (!personality.ok) return personality;
        return success("params:thread/settings/update");
    }

    static function validateThreadMemoryModeSetParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final mode = validateRequiredStringEnum(params.keys, params.values, "mode", "$.message.params.mode", ["enabled", "disabled"], "invalid_thread_memory_mode");
        if (!mode.ok) return mode;
        return success("params:thread/memoryMode/set");
    }

    static function validateThreadShellCommandParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final command = requiredString(params.keys, params.values, "command", "$.message.params.command");
        if (!command.ok) return command.toOutcome();
        return success("params:thread/shellCommand");
    }

    static function validateThreadApproveGuardianDeniedActionParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final event = requiredValue(params.keys, params.values, "event", "$.message.params.event");
        if (!event.ok) return event.toOutcome();
        return success("params:thread/approveGuardianDeniedAction");
    }

    static function validateThreadRollbackParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final numTurns = requiredUInt(params.keys, params.values, "numTurns", "$.message.params.numTurns");
        if (!numTurns.ok) return numTurns.toOutcome();
        if (numTurns.value == 0) return fail("expected_positive_uint", "$.message.params.numTurns", "expected unsigned JSON integer greater than zero");
        return success("params:thread/rollback");
    }

    static function validateThreadInjectItemsParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final items = requiredArray(params.keys, params.values, "items", "$.message.params.items");
        if (!items.ok) return items.toOutcome();
        var i = 0;
        while (i < items.values.length) {
            final item = requireObject(items.values[i], "$.message.params.items[" + Std.string(i) + "]");
            if (!item.ok) return item.toOutcome();
            i = i + 1;
        }
        return success("params:thread/inject_items");
    }

    static function validateThreadNameUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final threadName = validateOptionalNullableString(params, "threadName", "$.message.params.threadName");
        if (!threadName.ok) return threadName;
        return success("notification:thread/name/updated");
    }

    static function validateThreadGoalUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = validateOptionalNullableString(params, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId;
        final goal = requiredObjectField(params.keys, params.values, "goal", "$.message.params.goal");
        if (!goal.ok) return goal.toOutcome();
        final goalResult = validateThreadGoal(goal, "$.message.params.goal");
        if (!goalResult.ok) return goalResult;
        return success("notification:thread/goal/updated");
    }

    static function validateThreadSettingsUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final settings = requiredObjectField(params.keys, params.values, "threadSettings", "$.message.params.threadSettings");
        if (!settings.ok) return settings.toOutcome();
        final settingsResult = validateThreadSettings(settings, "$.message.params.threadSettings");
        if (!settingsResult.ok) return settingsResult;
        return success("notification:thread/settings/updated");
    }

    static function validateThreadSettings(settings:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        for (field in ["cwd", "model", "modelProvider"]) {
            final text = requiredString(settings.keys, settings.values, field, path + "." + field);
            if (!text.ok) return text.toOutcome();
        }
        final approvalPolicy = validateRequiredAskForApproval(settings, "approvalPolicy", path + ".approvalPolicy");
        if (!approvalPolicy.ok) return approvalPolicy;
        final approvalsReviewer = validateRequiredStringEnum(settings.keys, settings.values, "approvalsReviewer", path + ".approvalsReviewer", ["user", "auto_review", "guardian_subagent"], "invalid_approvals_reviewer");
        if (!approvalsReviewer.ok) return approvalsReviewer;
        final sandboxPolicy = validateRequiredSandboxPolicy(settings, "sandboxPolicy", path + ".sandboxPolicy");
        if (!sandboxPolicy.ok) return sandboxPolicy;
        final activePermissionProfile = validateOptionalNullableActivePermissionProfile(settings, "activePermissionProfile", path + ".activePermissionProfile");
        if (!activePermissionProfile.ok) return activePermissionProfile;
        final serviceTier = validateOptionalNullableString(settings, "serviceTier", path + ".serviceTier");
        if (!serviceTier.ok) return serviceTier;
        final effort = validateOptionalNullableNonEmptyString(settings, "effort", path + ".effort");
        if (!effort.ok) return effort;
        final summary = validateOptionalNullableStringEnum(settings, "summary", path + ".summary", ["auto", "concise", "detailed", "none"], "invalid_reasoning_summary");
        if (!summary.ok) return summary;
        final collaborationMode = requiredObjectField(settings.keys, settings.values, "collaborationMode", path + ".collaborationMode");
        if (!collaborationMode.ok) return collaborationMode.toOutcome();
        final collaborationResult = validateCollaborationMode(collaborationMode, path + ".collaborationMode");
        if (!collaborationResult.ok) return collaborationResult;
        final personality = validateOptionalNullableStringEnum(settings, "personality", path + ".personality", ["none", "friendly", "pragmatic"], "invalid_personality");
        if (!personality.ok) return personality;
        return success("thread-settings");
    }

    static function validateOptionalNullableActivePermissionProfile(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("active-permission-profile:missing");
        return switch object.values[i] {
            case JNull:
                success("active-permission-profile:null");
            case JObject(keys, values):
                final id = requiredString(keys, values, "id", path + ".id");
                if (!id.ok) return id.toOutcome();
                final profile = ProtocolObjectField.success(keys, values);
                final parent = validateOptionalNullableString(profile, "extends", path + ".extends");
                if (!parent.ok) parent else success("active-permission-profile");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalNullableCollaborationMode(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("collaboration-mode:missing");
        return switch object.values[i] {
            case JNull:
                success("collaboration-mode:null");
            case JObject(keys, values):
                validateCollaborationMode(ProtocolObjectField.success(keys, values), path);
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateCollaborationMode(mode:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final modeKind = validateRequiredStringEnum(mode.keys, mode.values, "mode", path + ".mode", ["plan", "default"], "invalid_collaboration_mode");
        if (!modeKind.ok) return modeKind;
        final settings = requiredObjectField(mode.keys, mode.values, "settings", path + ".settings");
        if (!settings.ok) return settings.toOutcome();
        final model = requiredString(settings.keys, settings.values, "model", path + ".settings.model");
        if (!model.ok) return model.toOutcome();
        final developerInstructions = validateOptionalNullableString(settings, "developer_instructions", path + ".settings.developer_instructions");
        if (!developerInstructions.ok) return developerInstructions;
        final reasoningEffort = validateOptionalNullableNonEmptyString(settings, "reasoning_effort", path + ".settings.reasoning_effort");
        if (!reasoningEffort.ok) return reasoningEffort;
        return success("collaboration-mode");
    }

    static function validateThreadTokenUsageUpdatedNotification(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final turnId = requiredString(params.keys, params.values, "turnId", "$.message.params.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        final tokenUsage = requiredObjectField(params.keys, params.values, "tokenUsage", "$.message.params.tokenUsage");
        if (!tokenUsage.ok) return tokenUsage.toOutcome();
        final total = requiredObjectField(tokenUsage.keys, tokenUsage.values, "total", "$.message.params.tokenUsage.total");
        if (!total.ok) return total.toOutcome();
        final totalResult = validateTokenUsageBreakdown(total, "$.message.params.tokenUsage.total");
        if (!totalResult.ok) return totalResult;
        final last = requiredObjectField(tokenUsage.keys, tokenUsage.values, "last", "$.message.params.tokenUsage.last");
        if (!last.ok) return last.toOutcome();
        final lastResult = validateTokenUsageBreakdown(last, "$.message.params.tokenUsage.last");
        if (!lastResult.ok) return lastResult;
        final contextWindow = validateOptionalNullableInteger(tokenUsage, "modelContextWindow", "$.message.params.tokenUsage.modelContextWindow");
        if (!contextWindow.ok) return contextWindow;
        return success("notification:thread/tokenUsage/updated");
    }

    static function validateTokenUsageBreakdown(breakdown:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        for (field in ["totalTokens", "inputTokens", "cachedInputTokens", "outputTokens", "reasoningOutputTokens"]) {
            final number = requiredInteger(breakdown.keys, breakdown.values, field, path + "." + field);
            if (!number.ok) return number.toOutcome();
        }
        return success("token-usage-breakdown");
    }

    static function validateTurnInputParams(params:ProtocolObjectField, steer:Bool):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final input = requiredArray(params.keys, params.values, "input", "$.message.params.input");
        if (!input.ok) return input.toOutcome();
        final inputResult = validateUserInputArray(input.values, "$.message.params.input");
        if (!inputResult.ok) return inputResult;
        final clientUserMessageId = validateOptionalNullableString(params, "clientUserMessageId", "$.message.params.clientUserMessageId");
        if (!clientUserMessageId.ok) return clientUserMessageId;
        final metadata = validateOptionalStringMap(params, "responsesapiClientMetadata", "$.message.params.responsesapiClientMetadata");
        if (!metadata.ok) return metadata;
        final additionalContext = validateOptionalNullableObject(params, "additionalContext", "$.message.params.additionalContext");
        if (!additionalContext.ok) return additionalContext;
        if (steer) {
            final expectedTurnId = requiredString(params.keys, params.values, "expectedTurnId", "$.message.params.expectedTurnId");
            if (!expectedTurnId.ok) return expectedTurnId.toOutcome();
            return success("params:turn/steer");
        }
        return success("params:turn/start");
    }

    static function validateTurnSteerResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final turnId = requiredString(result.keys, result.values, "turnId", "$.message.result.turnId");
        if (!turnId.ok) return turnId.toOutcome();
        return success("response:turn/steer");
    }

    static function validateReviewStartParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final threadId = requiredString(params.keys, params.values, "threadId", "$.message.params.threadId");
        if (!threadId.ok) return threadId.toOutcome();
        final target = requiredObjectField(params.keys, params.values, "target", "$.message.params.target");
        if (!target.ok) return target.toOutcome();
        final targetResult = validateReviewTarget(target, "$.message.params.target");
        if (!targetResult.ok) return targetResult;
        final delivery = validateOptionalNullableStringEnum(params, "delivery", "$.message.params.delivery", ["inline", "detached"], "invalid_review_delivery");
        if (!delivery.ok) return delivery;
        return success("params:review/start");
    }

    static function validateReviewTarget(target:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final targetType = requiredString(target.keys, target.values, "type", path + ".type");
        if (!targetType.ok) return targetType.toOutcome();
        return switch targetType.value {
            case "uncommittedChanges":
                success("review-target:uncommittedChanges");
            case "baseBranch":
                final branch = requiredString(target.keys, target.values, "branch", path + ".branch");
                if (!branch.ok) return branch.toOutcome();
                success("review-target:baseBranch");
            case "commit":
                final sha = requiredString(target.keys, target.values, "sha", path + ".sha");
                if (!sha.ok) return sha.toOutcome();
                final title = validateOptionalNullableString(target, "title", path + ".title");
                if (!title.ok) return title;
                success("review-target:commit");
            case "custom":
                final instructions = requiredString(target.keys, target.values, "instructions", path + ".instructions");
                if (!instructions.ok) return instructions.toOutcome();
                success("review-target:custom");
            case _:
                fail("invalid_review_target", path + ".type", "unsupported review target type");
        }
    }

    static function validateReviewStartResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final turn = requiredObjectField(result.keys, result.values, "turn", "$.message.result.turn");
        if (!turn.ok) return turn.toOutcome();
        final turnResult = validateTurn(turn, "$.message.result.turn");
        if (!turnResult.ok) return turnResult;
        final reviewThreadId = requiredString(result.keys, result.values, "reviewThreadId", "$.message.result.reviewThreadId");
        if (!reviewThreadId.ok) return reviewThreadId.toOutcome();
        return success("response:review/start");
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

    static function validateGetAccountParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final refreshToken = validateOptionalBool(params, "refreshToken", "$.message.params.refreshToken");
        if (!refreshToken.ok) return refreshToken;
        return success("params:account/read");
    }

    static function validateGetAccountResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final requiresOpenaiAuth = requiredBool(result.keys, result.values, "requiresOpenaiAuth", "$.message.result.requiresOpenaiAuth");
        if (!requiresOpenaiAuth.ok) return requiresOpenaiAuth.toOutcome();
        final account = validateOptionalNullableAccount(result, "account", "$.message.result.account");
        if (!account.ok) return account;
        return success("response:account/read");
    }

    static function validateOptionalNullableAccount(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("account:missing");
        return switch object.values[i] {
            case JNull:
                success("account:null");
            case JObject(keys, values):
                validateAccountObject(ProtocolObjectField.success(keys, values), path);
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateAccountObject(account:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final typeField = requiredString(account.keys, account.values, "type", path + ".type");
        if (!typeField.ok) return typeField.toOutcome();
        return switch typeField.value {
            case "apiKey" | "amazonBedrock":
                success("account:" + typeField.value);
            case "chatgpt":
                final email = requiredString(account.keys, account.values, "email", path + ".email");
                if (!email.ok) return email.toOutcome();
                final planType = requiredString(account.keys, account.values, "planType", path + ".planType");
                if (!planType.ok) return planType.toOutcome();
                if (!validAccountPlanType(planType.value)) fail("invalid_account_plan_type", path + ".planType", "unsupported account plan type") else success("account:chatgpt");
            case _:
                fail("invalid_account_type", path + ".type", "unsupported account type");
        }
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

    static function validateConfigValueWriteParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final edit = validateConfigEdit(params, "$.message.params");
        if (!edit.ok) return edit;
        final filePath = validateOptionalNullableString(params, "filePath", "$.message.params.filePath");
        if (!filePath.ok) return filePath;
        final expectedVersion = validateOptionalNullableString(params, "expectedVersion", "$.message.params.expectedVersion");
        if (!expectedVersion.ok) return expectedVersion;
        return success("params:config/value/write");
    }

    static function validateConfigBatchWriteParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final edits = requiredArray(params.keys, params.values, "edits", "$.message.params.edits");
        if (!edits.ok) return edits.toOutcome();
        var i = 0;
        while (i < edits.values.length) {
            final editPath = "$.message.params.edits[" + Std.string(i) + "]";
            switch edits.values[i] {
                case JObject(keys, values):
                    final edit = validateConfigEdit(ProtocolObjectField.success(keys, values), editPath);
                    if (!edit.ok) return edit;
                case _:
                    return fail("expected_object", editPath, "expected config edit object");
            }
            i = i + 1;
        }
        final filePath = validateOptionalNullableString(params, "filePath", "$.message.params.filePath");
        if (!filePath.ok) return filePath;
        final expectedVersion = validateOptionalNullableString(params, "expectedVersion", "$.message.params.expectedVersion");
        if (!expectedVersion.ok) return expectedVersion;
        final reloadUserConfig = validateOptionalBool(params, "reloadUserConfig", "$.message.params.reloadUserConfig");
        if (!reloadUserConfig.ok) return reloadUserConfig;
        return success("params:config/batchWrite");
    }

    static function validateConfigEdit(edit:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final keyPath = requiredString(edit.keys, edit.values, "keyPath", path + ".keyPath");
        if (!keyPath.ok) return keyPath.toOutcome();
        final mergeStrategy = requiredString(edit.keys, edit.values, "mergeStrategy", path + ".mergeStrategy");
        if (!mergeStrategy.ok) return mergeStrategy.toOutcome();
        if (!validConfigMergeStrategy(mergeStrategy.value)) return fail("invalid_config_merge_strategy", path + ".mergeStrategy", "unsupported config merge strategy");
        final value = requiredValue(edit.keys, edit.values, "value", path + ".value");
        if (!value.ok) return value.toOutcome();
        return success("config-edit");
    }

    static function validateConfigWriteResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final status = requiredString(result.keys, result.values, "status", "$.message.result.status");
        if (!status.ok) return status.toOutcome();
        if (!validConfigWriteStatus(status.value)) return fail("invalid_config_write_status", "$.message.result.status", "unsupported config write status");
        final version = requiredString(result.keys, result.values, "version", "$.message.result.version");
        if (!version.ok) return version.toOutcome();
        final filePath = requiredString(result.keys, result.values, "filePath", "$.message.result.filePath");
        if (!filePath.ok) return filePath.toOutcome();
        final overridden = validateOptionalOverriddenMetadata(result, "overriddenMetadata", "$.message.result.overriddenMetadata");
        if (!overridden.ok) return overridden;
        return success("response:config/write");
    }

    static function validateOptionalOverriddenMetadata(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("overridden-metadata:missing");
        return switch object.values[i] {
            case JNull:
                success("overridden-metadata:null");
            case JObject(keys, values):
                final metadata = ProtocolObjectField.success(keys, values);
                final message = requiredString(keys, values, "message", path + ".message");
                if (!message.ok) return message.toOutcome();
                final overridingLayer = requiredObjectField(keys, values, "overridingLayer", path + ".overridingLayer");
                if (!overridingLayer.ok) return overridingLayer.toOutcome();
                final layer = validateConfigLayerMetadata(overridingLayer, path + ".overridingLayer");
                if (!layer.ok) return layer;
                final effectiveValue = requiredValue(metadata.keys, metadata.values, "effectiveValue", path + ".effectiveValue");
                if (!effectiveValue.ok) return effectiveValue.toOutcome();
                success("overridden-metadata");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateConfigRequirementsReadResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final i = fieldIndex(result.keys, "requirements");
        if (i < 0) return success("response:configRequirements/read");
        return switch result.values[i] {
            case JNull:
                success("response:configRequirements/read:null");
            case JObject(keys, values):
                validateConfigRequirements(ProtocolObjectField.success(keys, values), "$.message.result.requirements");
            case _:
                fail("expected_nullable_object", "$.message.result.requirements", "expected JSON object or null");
        }
    }

    static function validateConfigRequirements(requirements:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final approvalPolicies = validateOptionalNullableAskForApprovalArray(requirements, "allowedApprovalPolicies", path + ".allowedApprovalPolicies");
        if (!approvalPolicies.ok) return approvalPolicies;
        final sandboxModes = validateOptionalNullableStringEnumArray(requirements, "allowedSandboxModes", path + ".allowedSandboxModes", ["read-only", "workspace-write", "danger-full-access"], "invalid_sandbox_mode");
        if (!sandboxModes.ok) return sandboxModes;
        final windowsSandboxModes = validateOptionalNullableStringEnumArray(requirements, "allowedWindowsSandboxImplementations", path + ".allowedWindowsSandboxImplementations", ["elevated", "unelevated"], "invalid_windows_sandbox_setup_mode");
        if (!windowsSandboxModes.ok) return windowsSandboxModes;
        final webSearchModes = validateOptionalNullableStringEnumArray(requirements, "allowedWebSearchModes", path + ".allowedWebSearchModes", ["disabled", "cached", "live"], "invalid_web_search_mode");
        if (!webSearchModes.ok) return webSearchModes;
        final permissionProfiles = validateOptionalNullableBoolMap(requirements, "allowedPermissionProfiles", path + ".allowedPermissionProfiles");
        if (!permissionProfiles.ok) return permissionProfiles;
        final featureRequirements = validateOptionalNullableBoolMap(requirements, "featureRequirements", path + ".featureRequirements");
        if (!featureRequirements.ok) return featureRequirements;
        final defaultPermissions = validateOptionalNullableString(requirements, "defaultPermissions", path + ".defaultPermissions");
        if (!defaultPermissions.ok) return defaultPermissions;
        final allowManagedHooksOnly = validateOptionalNullableBool(requirements, "allowManagedHooksOnly", path + ".allowManagedHooksOnly");
        if (!allowManagedHooksOnly.ok) return allowManagedHooksOnly;
        final allowAppshots = validateOptionalNullableBool(requirements, "allowAppshots", path + ".allowAppshots");
        if (!allowAppshots.ok) return allowAppshots;
        final computerUse = validateOptionalComputerUseRequirements(requirements, "computerUse", path + ".computerUse");
        if (!computerUse.ok) return computerUse;
        final enforceResidency = validateOptionalNullableStringEnum(requirements, "enforceResidency", path + ".enforceResidency", ["us"], "invalid_residency_requirement");
        if (!enforceResidency.ok) return enforceResidency;
        return success("config-requirements");
    }

    static function validateOptionalNullableAskForApprovalArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("approval-array:missing");
        return switch object.values[i] {
            case JNull:
                success("approval-array:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    final entryObject = ProtocolObjectField.success(["approval"], [entries[entryIndex]]);
                    final approval = validateOptionalAskForApproval(entryObject, "approval", entryPath);
                    if (!approval.ok) return approval;
                    entryIndex = entryIndex + 1;
                }
                success("approval-array");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateOptionalNullableStringEnumArray(object:ProtocolObjectField, name:String, path:String, values:Array<String>, errorCode:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("enum-array:missing");
        return switch object.values[i] {
            case JNull:
                success("enum-array:null");
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    switch entries[entryIndex] {
                        case JString(value):
                            if (!contains(values, value)) return fail(errorCode, entryPath, "unsupported enum value");
                        case _:
                            return fail("expected_string", entryPath, "expected JSON string");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("enum-array");
            case _:
                fail("expected_nullable_array", path, "expected JSON array or null");
        }
    }

    static function validateOptionalNullableBoolMap(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("bool-map:missing");
        return switch object.values[i] {
            case JNull:
                success("bool-map:null");
            case JObject(keys, values):
                var entryIndex = 0;
                while (entryIndex < values.length) {
                    switch values[entryIndex] {
                        case JBool(_):
                        case _:
                            return fail("expected_bool", path + "." + keys[entryIndex], "expected JSON boolean");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("bool-map");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalComputerUseRequirements(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("computer-use:missing");
        return switch object.values[i] {
            case JNull:
                success("computer-use:null");
            case JObject(keys, values):
                final allowLocked = validateOptionalNullableBool(ProtocolObjectField.success(keys, values), "allowLockedComputerUse", path + ".allowLockedComputerUse");
                if (!allowLocked.ok) allowLocked else success("computer-use");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
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

    static function validateRequiredAskForApproval(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return fail("missing_field", path, "required field is missing");
        return switch object.values[i] {
            case JNull:
                fail("expected_approval_policy", path, "expected approval policy string or granular object");
            case _:
                validateOptionalAskForApproval(ProtocolObjectField.success([name], [object.values[i]]), name, path);
        }
    }

    static function validateRequiredStringEnum(keys:Array<String>, values:Array<Value>, name:String, path:String, options:Array<String>, errorCode:String):AppProtocolParseOutcome {
        final field = requiredString(keys, values, name, path);
        if (!field.ok) return field.toOutcome();
        if (!contains(options, field.value)) return fail(errorCode, path, "unsupported enum value");
        return success("required-string-enum");
    }

    static function validateRequiredSandboxPolicy(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return fail("missing_field", path, "required field is missing");
        return switch object.values[i] {
            case JObject(keys, values):
                validateOptionalCommandExecSandboxPolicy(ProtocolObjectField.success([name], [JObject(keys, values)]), name, path);
            case _:
                fail("expected_object", path, "expected JSON object");
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

    static function validateExternalAgentConfigDetectParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final includeHome = validateOptionalBool(params, "includeHome", "$.message.params.includeHome");
        if (!includeHome.ok) return includeHome;
        final cwds = validateOptionalStringArray(params, "cwds", "$.message.params.cwds", true);
        if (!cwds.ok) return cwds;
        return success("params:externalAgentConfig/detect");
    }

    static function validateExternalAgentConfigDetectResponse(result:ProtocolObjectField):AppProtocolParseOutcome {
        final items = requiredArray(result.keys, result.values, "items", "$.message.result.items");
        if (!items.ok) return items.toOutcome();
        return validateExternalAgentConfigMigrationItems(items.values, "$.message.result.items");
    }

    static function validateExternalAgentConfigImportParams(params:ProtocolObjectField):AppProtocolParseOutcome {
        final migrationItems = requiredArray(params.keys, params.values, "migrationItems", "$.message.params.migrationItems");
        if (!migrationItems.ok) return migrationItems.toOutcome();
        return validateExternalAgentConfigMigrationItems(migrationItems.values, "$.message.params.migrationItems");
    }

    static function validateExternalAgentConfigMigrationItems(items:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < items.length) {
            final itemPath = path + "[" + Std.string(i) + "]";
            switch items[i] {
                case JObject(keys, values):
                    final item = validateExternalAgentConfigMigrationItem(ProtocolObjectField.success(keys, values), itemPath);
                    if (!item.ok) return item;
                case _:
                    return fail("expected_object", itemPath, "expected migration item object");
            }
            i = i + 1;
        }
        return success("external-agent-config-migration-items");
    }

    static function validateExternalAgentConfigMigrationItem(item:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final description = requiredString(item.keys, item.values, "description", path + ".description");
        if (!description.ok) return description.toOutcome();
        final itemType = requiredString(item.keys, item.values, "itemType", path + ".itemType");
        if (!itemType.ok) return itemType.toOutcome();
        if (!validExternalAgentConfigMigrationItemType(itemType.value)) return fail("invalid_external_agent_config_item_type", path + ".itemType", "unsupported migration item type");
        final cwd = validateOptionalNullableString(item, "cwd", path + ".cwd");
        if (!cwd.ok) return cwd;
        final details = validateOptionalMigrationDetails(item, "details", path + ".details");
        if (!details.ok) return details;
        return success("external-agent-config-migration-item");
    }

    static function validateOptionalMigrationDetails(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("migration-details:missing");
        return switch object.values[i] {
            case JNull:
                success("migration-details:null");
            case JObject(keys, values):
                final details = ProtocolObjectField.success(keys, values);
                for (field in ["commands", "hooks", "mcpServers", "subagents"]) {
                    final list = validateOptionalNamedMigrationArray(details, field, path + "." + field);
                    if (!list.ok) return list;
                }
                final plugins = validateOptionalPluginsMigrationArray(details, "plugins", path + ".plugins");
                if (!plugins.ok) return plugins;
                final sessions = validateOptionalSessionMigrationArray(details, "sessions", path + ".sessions");
                if (!sessions.ok) return sessions;
                success("migration-details");
            case _:
                fail("expected_nullable_object", path, "expected JSON object or null");
        }
    }

    static function validateOptionalNamedMigrationArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("named-migration-array:missing");
        return switch object.values[i] {
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    switch entries[entryIndex] {
                        case JObject(keys, values):
                            final named = requiredString(keys, values, "name", entryPath + ".name");
                            if (!named.ok) return named.toOutcome();
                        case _:
                            return fail("expected_object", entryPath, "expected migration detail object");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("named-migration-array");
            case _:
                fail("expected_array", path, "expected JSON array");
        }
    }

    static function validateOptionalPluginsMigrationArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("plugins-migration-array:missing");
        return switch object.values[i] {
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    switch entries[entryIndex] {
                        case JObject(keys, values):
                            final marketplaceName = requiredString(keys, values, "marketplaceName", entryPath + ".marketplaceName");
                            if (!marketplaceName.ok) return marketplaceName.toOutcome();
                            final pluginNames = requiredArray(keys, values, "pluginNames", entryPath + ".pluginNames");
                            if (!pluginNames.ok) return pluginNames.toOutcome();
                            final pluginNamesResult = validateStringArrayEntries(pluginNames.values, entryPath + ".pluginNames");
                            if (!pluginNamesResult.ok) return pluginNamesResult;
                        case _:
                            return fail("expected_object", entryPath, "expected plugin migration object");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("plugins-migration-array");
            case _:
                fail("expected_array", path, "expected JSON array");
        }
    }

    static function validateOptionalSessionMigrationArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("session-migration-array:missing");
        return switch object.values[i] {
            case JArray(entries):
                var entryIndex = 0;
                while (entryIndex < entries.length) {
                    final entryPath = path + "[" + Std.string(entryIndex) + "]";
                    switch entries[entryIndex] {
                        case JObject(keys, values):
                            final cwd = requiredString(keys, values, "cwd", entryPath + ".cwd");
                            if (!cwd.ok) return cwd.toOutcome();
                            final pathValue = requiredString(keys, values, "path", entryPath + ".path");
                            if (!pathValue.ok) return pathValue.toOutcome();
                            final title = validateOptionalNullableString(ProtocolObjectField.success(keys, values), "title", entryPath + ".title");
                            if (!title.ok) return title;
                        case _:
                            return fail("expected_object", entryPath, "expected session migration object");
                    }
                    entryIndex = entryIndex + 1;
                }
                success("session-migration-array");
            case _:
                fail("expected_array", path, "expected JSON array");
        }
    }

    static function validateStringArrayEntries(entries:Array<Value>, path:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            switch entries[i] {
                case JString(_):
                case _:
                    return fail("expected_string", path + "[" + Std.string(i) + "]", "expected JSON string");
            }
            i = i + 1;
        }
        return success("string-array-entries");
    }

    static function validateRequiredStringArrayField(object:ProtocolObjectField, name:String, path:String, label:String):AppProtocolParseOutcome {
        final array = requiredArray(object.keys, object.values, name, path);
        if (!array.ok) return array.toOutcome();
        final strings = validateStringArrayEntries(array.values, path);
        if (!strings.ok) return strings;
        return success(label);
    }

    static function validateSingleStringParams(params:ProtocolObjectField, field:String, label:String):AppProtocolParseOutcome {
        final value = requiredString(params.keys, params.values, field, "$.message.params." + field);
        if (!value.ok) return value.toOutcome();
        return success(label);
    }

    static function validateCursorLimitParams(params:ProtocolObjectField, path:String):AppProtocolParseOutcome {
        final cursor = validateOptionalNullableString(params, "cursor", path + ".cursor");
        if (!cursor.ok) return cursor;
        final limit = validateOptionalNullableUInt(params, "limit", path + ".limit");
        if (!limit.ok) return limit;
        return success("cursor-limit-params");
    }

    static function validateNextCursor(result:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        final nextCursor = validateOptionalNullableString(result, "nextCursor", path + ".nextCursor");
        if (!nextCursor.ok) return nextCursor;
        return success(label);
    }

    static function validateObjectArrayEntries(entries:Array<Value>, path:String, label:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < entries.length) {
            final entry = requireObject(entries[i], path + "[" + Std.string(i) + "]");
            if (!entry.ok) return entry.toOutcome();
            i = i + 1;
        }
        return success(label);
    }

    static function validateBoolMap(object:ProtocolObjectField, path:String, label:String):AppProtocolParseOutcome {
        var i = 0;
        while (i < object.values.length) {
            switch object.values[i] {
                case JBool(_):
                case _:
                    return fail("expected_bool", path + "." + object.keys[i], "expected JSON boolean");
            }
            i = i + 1;
        }
        return success(label);
    }

    static function validJsonValue(_value:Value):Bool {
        return true;
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

    static function validThreadGoalStatus(value:String):Bool {
        return value == "active" || value == "paused" || value == "blocked" || value == "usageLimited" || value == "budgetLimited" || value == "complete";
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

    static function validRealtimeOutputModality(value:String):Bool {
        return value == "text" || value == "audio";
    }

    static function validRealtimeTransportType(value:String):Bool {
        return value == "websocket" || value == "webrtc";
    }

    static function validRealtimeVoice(value:String):Bool {
        return value == "alloy" || value == "arbor" || value == "ash" || value == "ballad" || value == "breeze" || value == "cedar" || value == "coral" || value == "cove" || value == "echo" || value == "ember" || value == "juniper" || value == "maple" || value == "marin" || value == "sage" || value == "shimmer" || value == "sol" || value == "spruce" || value == "vale" || value == "verse";
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

    static function validConfigMergeStrategy(value:String):Bool {
        return value == "replace" || value == "upsert";
    }

    static function validConfigWriteStatus(value:String):Bool {
        return value == "ok" || value == "okOverridden";
    }

    static function validExternalAgentConfigMigrationItemType(value:String):Bool {
        return value == "AGENTS_MD" || value == "CONFIG" || value == "SKILLS" || value == "PLUGINS" || value == "MCP_SERVER_CONFIG" || value == "SUBAGENTS" || value == "HOOKS" || value == "COMMANDS" || value == "SESSIONS";
    }

    static function validCommandExecutionApprovalDecision(value:String):Bool {
        return value == "accept" || value == "acceptForSession" || value == "decline" || value == "cancel";
    }

    static function validFileChangeApprovalDecision(value:String):Bool {
        return value == "accept" || value == "acceptForSession" || value == "decline" || value == "cancel";
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

    static function requiredNonEmptyString(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolStringField {
        final value = requiredString(keys, values, name, path);
        if (!value.ok) return value;
        if (value.value.length == 0) return ProtocolStringField.failure("empty_string", path, "expected non-empty JSON string");
        return value;
    }

    static function requiredNullableString(keys:Array<String>, values:Array<Value>, name:String, path:String):ProtocolStringField {
        final i = fieldIndex(keys, name);
        if (i < 0) return ProtocolStringField.failure("missing_field", path, "required field is missing");
        return switch values[i] {
            case JString(value): ProtocolStringField.success(value);
            case JNull: ProtocolStringField.success("");
            case _: ProtocolStringField.failure("expected_nullable_string", path, "expected JSON string or null");
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

    static function validateOptionalThreadListCwd(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return success("thread-list-cwd:missing");
        return switch object.values[i] {
            case JNull | JString(_):
                success("thread-list-cwd");
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
                success("thread-list-cwd:array");
            case _:
                fail("expected_nullable_string_or_array", path, "expected JSON string, string array, or null");
        }
    }

    static function validateOptionalThreadSourceKindArray(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        return validateOptionalNullableStringEnumArray(object, name, path, ["cli", "vscode", "exec", "appServer", "subAgent", "subAgentReview", "subAgentCompact", "subAgentThreadSpawn", "subAgentOther", "unknown"], "invalid_thread_source_kind");
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

    static function validateRequiredNullableObject(object:ProtocolObjectField, name:String, path:String):AppProtocolParseOutcome {
        final i = fieldIndex(object.keys, name);
        if (i < 0) return fail("missing_field", path, "required field is missing");
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
