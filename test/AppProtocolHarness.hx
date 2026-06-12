import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.app.AppProtocolMessage;
import codexhx.protocol.app.AppProtocolParseOutcome;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;
import sys.io.File;

class AppProtocolHarness {
    static function main():Void {
        emitsSchemaFingerprint();
        roundTripsFixture();
        mapsErrorsDeterministically();
        validatesPlanUpdates();
    }

    static function emitsSchemaFingerprint():Void {
        final fingerprintJson = AppProtocol.schemaFingerprintJson();
        assertContains(fingerprintJson, "\"schema\":\"codex-hxrust.app-protocol-fingerprint.v1\"");
        assertContains(fingerprintJson, "\"fingerprint\":\"" + AppProtocol.schemaFingerprint() + "\"");
        assertContains(fingerprintJson, "thread/start");
        assertContains(fingerprintJson, "turn/completed");
        assertContains(fingerprintJson, "turn/plan/updated");
        assertContains(fingerprintJson, "turn/moderationMetadata");
        assertContains(fingerprintJson, "thread/compacted");
        assertContains(fingerprintJson, "item/completed");
        assertContains(fingerprintJson, "item/agentMessage/delta");
        assertContains(fingerprintJson, "item/plan/delta");
        assertContains(fingerprintJson, "item/reasoning/summaryTextDelta");
        assertContains(fingerprintJson, "item/reasoning/summaryPartAdded");
        assertContains(fingerprintJson, "item/reasoning/textDelta");
        assertContains(fingerprintJson, "item/commandExecution/outputDelta");
        assertContains(fingerprintJson, "item/commandExecution/terminalInteraction");
        assertContains(fingerprintJson, "item/fileChange/outputDelta");
        assertContains(fingerprintJson, "item/fileChange/patchUpdated");
        assertContains(fingerprintJson, "item/mcpToolCall/progress");
        assertContains(fingerprintJson, "mcpServer/oauthLogin/completed");
        assertContains(fingerprintJson, "mcpServer/startupStatus/updated");
        assertContains(fingerprintJson, "account/updated");
        assertContains(fingerprintJson, "account/rateLimits/updated");
        assertContains(fingerprintJson, "app/list/updated");
        assertContains(fingerprintJson, "remoteControl/status/changed");
        assertContains(fingerprintJson, "model/rerouted");
        assertContains(fingerprintJson, "model/verification");
        assertContains(fingerprintJson, "warning");
        assertContains(fingerprintJson, "guardianWarning");
        assertContains(fingerprintJson, "deprecationNotice");
        assertContains(fingerprintJson, "configWarning");
        assertContains(fingerprintJson, "fuzzyFileSearch/sessionUpdated");
        assertContains(fingerprintJson, "fuzzyFileSearch/sessionCompleted");
        assertContains(fingerprintJson, "thread/realtime/started");
        assertContains(fingerprintJson, "thread/realtime/itemAdded");
        assertContains(fingerprintJson, "thread/realtime/transcript/delta");
        assertContains(fingerprintJson, "thread/realtime/transcript/done");
        assertContains(fingerprintJson, "thread/realtime/outputAudio/delta");
        assertContains(fingerprintJson, "thread/realtime/sdp");
        assertContains(fingerprintJson, "externalAgentConfig/import/completed");
        assertContains(fingerprintJson, "fs/changed");
        assertContains(fingerprintJson, "rawResponseItem/completed");
        assertContains(fingerprintJson, "serverRequest/resolved");
        assertContains(fingerprintJson, "command/exec/outputDelta");
        assertContains(fingerprintJson, "process/outputDelta");
        assertContains(fingerprintJson, "process/exited");
        assertContains(fingerprintJson, "items:agentMessage,plan,userMessage");
    }

    static function roundTripsFixture():Void {
        final root = expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/app-protocol-roundtrip.v1.json")));
        final items = fixtureItems(root);
        assertEquals("57", Std.string(items.length));

        var requests = 0;
        var responses = 0;
        var notifications = 0;
        var errors = 0;

        for (item in items) {
            final parsed = expectProtocol(AppProtocol.parseFixtureItem(item));
            final canonical = parsed.canonicalJson;
            final reparsed = expectParse(CodexJson.parse(canonical));
            final canonicalAgain = JsonValueCodec.encode(reparsed);
            assertEquals(canonical, canonicalAgain);
            assertEquals(AppProtocol.schemaFingerprint(), parsed.schemaFingerprint);

            if (parsed.kind == "request") requests = requests + 1;
            if (parsed.kind == "response") responses = responses + 1;
            if (parsed.kind == "notification") notifications = notifications + 1;
            if (parsed.kind == "error") errors = errors + 1;
        }

        assertEquals("4", Std.string(requests));
        assertEquals("4", Std.string(responses));
        assertEquals("48", Std.string(notifications));
        assertEquals("1", Std.string(errors));
    }

    static function mapsErrorsDeterministically():Void {
        final jsonrpcError = expectProtocol(AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"jsonrpc-error\",\"kind\":\"error\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":99,\"error\":{\"code\":-32602,\"message\":\"invalid params\",\"data\":{\"field\":\"threadId\"}}}}"))));
        assertEquals("{\"error\":{\"code\":-32602,\"data\":{\"field\":\"threadId\"},\"message\":\"invalid params\"},\"id\":99,\"jsonrpc\":\"2.0\"}", jsonrpcError.canonicalJson);

        assertFalse(AppProtocol.errorAffectsTurnStatus(JString("threadRollbackFailed")), "rollback errors should not mark the turn failed");
        assertTrue(AppProtocol.errorAffectsTurnStatus(JString("other")), "generic errors should affect the turn");
        assertFalse(AppProtocol.errorAffectsTurnStatus(expectParse(CodexJson.parse("{\"activeTurnNotSteerable\":{\"turnKind\":\"review\"}}"))), "non-steerable active turns should not mark the turn failed");

        final unsupported = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"bad-image-input\",\"kind\":\"request\",\"method\":\"turn/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":7,\"method\":\"turn/start\",\"params\":{\"threadId\":\"thread-1\",\"input\":[{\"type\":\"image\",\"url\":\"file:///tmp/a.png\"}]}}}")));
        assertFalse(unsupported.ok, "image input must fail in this text-only subset");
        assertEquals("unsupported_user_input", unsupported.errorCode);
        assertEquals("$.message.params.input[0].type", unsupported.errorPath);
    }

    static function validatesPlanUpdates():Void {
        final nullExplanation = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-null-explanation\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"explanation\":null,\"plan\":[{\"step\":\"one\",\"status\":\"pending\"}]}}}")));
        assertTrue(nullExplanation.ok, "plan update should allow null explanation");

        final missingExplanation = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-missing-explanation\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"plan\":[{\"step\":\"one\",\"status\":\"completed\"}]}}}")));
        assertTrue(missingExplanation.ok, "plan update should allow missing explanation");

        final invalidStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plan-invalid-status\",\"kind\":\"notification\",\"method\":\"turn/plan/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/plan/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"plan\":[{\"step\":\"one\",\"status\":\"blocked\"}]}}}")));
        assertFalse(invalidStatus.ok, "unknown plan status must fail");
        assertEquals("invalid_plan_step_status", invalidStatus.errorCode);
        assertEquals("$.message.params.plan[0].status", invalidStatus.errorPath);

        final invalidCommandStream = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-invalid-stream\",\"kind\":\"notification\",\"method\":\"command/exec/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"command/exec/outputDelta\",\"params\":{\"processId\":\"proc-1\",\"stream\":\"combined\",\"deltaBase64\":\"AQI=\",\"capReached\":false}}}")));
        assertFalse(invalidCommandStream.ok, "unknown command exec stream must fail");
        assertEquals("invalid_command_exec_stream", invalidCommandStream.errorCode);
        assertEquals("$.message.params.stream", invalidCommandStream.errorPath);

        final invalidProcessStream = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-invalid-stream\",\"kind\":\"notification\",\"method\":\"process/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"process/outputDelta\",\"params\":{\"processHandle\":\"proc-1\",\"stream\":\"combined\",\"deltaBase64\":\"AQI=\",\"capReached\":false}}}")));
        assertFalse(invalidProcessStream.ok, "unknown process output stream must fail");
        assertEquals("invalid_process_output_stream", invalidProcessStream.errorCode);
        assertEquals("$.message.params.stream", invalidProcessStream.errorPath);

        final invalidProcessExit = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-invalid-exit\",\"kind\":\"notification\",\"method\":\"process/exited\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"process/exited\",\"params\":{\"processHandle\":\"proc-1\",\"exitCode\":0,\"stdout\":\"out\",\"stdoutCapReached\":\"no\",\"stderr\":\"err\",\"stderrCapReached\":false}}}")));
        assertFalse(invalidProcessExit.ok, "process cap flags must be booleans");
        assertEquals("expected_bool", invalidProcessExit.errorCode);
        assertEquals("$.message.params.stdoutCapReached", invalidProcessExit.errorPath);

        final invalidCommandExecutionDelta = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-execution-invalid-delta\",\"kind\":\"notification\",\"method\":\"item/commandExecution/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/commandExecution/outputDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"delta\":7}}}")));
        assertFalse(invalidCommandExecutionDelta.ok, "command execution delta must be a string");
        assertEquals("expected_string", invalidCommandExecutionDelta.errorCode);
        assertEquals("$.message.params.delta", invalidCommandExecutionDelta.errorPath);

        final invalidReasoningSummaryIndex = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"reasoning-summary-invalid-index\",\"kind\":\"notification\",\"method\":\"item/reasoning/summaryTextDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/reasoning/summaryTextDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"summaryIndex\":1.5,\"delta\":\"text\"}}}")));
        assertFalse(invalidReasoningSummaryIndex.ok, "reasoning summary index must be an integer");
        assertEquals("expected_integer", invalidReasoningSummaryIndex.errorCode);
        assertEquals("$.message.params.summaryIndex", invalidReasoningSummaryIndex.errorPath);

        final invalidReasoningSummaryPartIndex = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"reasoning-summary-part-invalid-index\",\"kind\":\"notification\",\"method\":\"item/reasoning/summaryPartAdded\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/reasoning/summaryPartAdded\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"summaryIndex\":1.5}}}")));
        assertFalse(invalidReasoningSummaryPartIndex.ok, "reasoning summary part index must be an integer");
        assertEquals("expected_integer", invalidReasoningSummaryPartIndex.errorCode);
        assertEquals("$.message.params.summaryIndex", invalidReasoningSummaryPartIndex.errorPath);

        final invalidReasoningContentIndex = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"reasoning-text-invalid-index\",\"kind\":\"notification\",\"method\":\"item/reasoning/textDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/reasoning/textDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"contentIndex\":1.5,\"delta\":\"text\"}}}")));
        assertFalse(invalidReasoningContentIndex.ok, "reasoning text content index must be an integer");
        assertEquals("expected_integer", invalidReasoningContentIndex.errorCode);
        assertEquals("$.message.params.contentIndex", invalidReasoningContentIndex.errorPath);

        final invalidContextCompactedTurnId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"context-compacted-invalid-turn\",\"kind\":\"notification\",\"method\":\"thread/compacted\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/compacted\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":7}}}")));
        assertFalse(invalidContextCompactedTurnId.ok, "context compacted turn id must be a string");
        assertEquals("expected_string", invalidContextCompactedTurnId.errorCode);
        assertEquals("$.message.params.turnId", invalidContextCompactedTurnId.errorPath);

        final missingModerationMetadata = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"turn-moderation-missing-metadata\",\"kind\":\"notification\",\"method\":\"turn/moderationMetadata\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"turn/moderationMetadata\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\"}}}")));
        assertFalse(missingModerationMetadata.ok, "turn moderation metadata must be present");
        assertEquals("missing_field", missingModerationMetadata.errorCode);
        assertEquals("$.message.params.metadata", missingModerationMetadata.errorPath);

        final invalidTerminalInteraction = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-execution-invalid-terminal-stdin\",\"kind\":\"notification\",\"method\":\"item/commandExecution/terminalInteraction\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/commandExecution/terminalInteraction\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"processId\":\"proc-1\",\"stdin\":false}}}")));
        assertFalse(invalidTerminalInteraction.ok, "terminal interaction stdin must be a string");
        assertEquals("expected_string", invalidTerminalInteraction.errorCode);
        assertEquals("$.message.params.stdin", invalidTerminalInteraction.errorPath);

        final invalidFileChangeDelta = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-delta\",\"kind\":\"notification\",\"method\":\"item/fileChange/outputDelta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/outputDelta\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"delta\":false}}}")));
        assertFalse(invalidFileChangeDelta.ok, "file change delta must be a string");
        assertEquals("expected_string", invalidFileChangeDelta.errorCode);
        assertEquals("$.message.params.delta", invalidFileChangeDelta.errorPath);

        final invalidPatchChangeKind = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-kind\",\"kind\":\"notification\",\"method\":\"item/fileChange/patchUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/patchUpdated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"changes\":[{\"path\":\"a.txt\",\"kind\":{\"type\":\"rename\"},\"diff\":\"@@\"}]}}}")));
        assertFalse(invalidPatchChangeKind.ok, "patch change kind must be add, delete, or update");
        assertEquals("invalid_patch_change_kind", invalidPatchChangeKind.errorCode);
        assertEquals("$.message.params.changes[0].kind.type", invalidPatchChangeKind.errorPath);

        final invalidPatchMovePath = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"file-change-invalid-move-path\",\"kind\":\"notification\",\"method\":\"item/fileChange/patchUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/fileChange/patchUpdated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"changes\":[{\"path\":\"a.txt\",\"kind\":{\"type\":\"update\",\"move_path\":7},\"diff\":\"@@\"}]}}}")));
        assertFalse(invalidPatchMovePath.ok, "update move_path must be a string or null");
        assertEquals("expected_nullable_string", invalidPatchMovePath.errorCode);
        assertEquals("$.message.params.changes[0].kind.move_path", invalidPatchMovePath.errorPath);

        final invalidServerRequestId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-request-invalid-id\",\"kind\":\"notification\",\"method\":\"serverRequest/resolved\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"serverRequest/resolved\",\"params\":{\"threadId\":\"thread-1\",\"requestId\":false}}}")));
        assertFalse(invalidServerRequestId.ok, "server request id must be a string or number");
        assertEquals("expected_request_id", invalidServerRequestId.errorCode);
        assertEquals("$.message.params.requestId", invalidServerRequestId.errorPath);

        final invalidMcpProgressMessage = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-progress-invalid-message\",\"kind\":\"notification\",\"method\":\"item/mcpToolCall/progress\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"item/mcpToolCall/progress\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"message\":7}}}")));
        assertFalse(invalidMcpProgressMessage.ok, "MCP progress message must be a string");
        assertEquals("expected_string", invalidMcpProgressMessage.errorCode);
        assertEquals("$.message.params.message", invalidMcpProgressMessage.errorPath);

        final invalidMcpOauthError = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-oauth-invalid-error\",\"kind\":\"notification\",\"method\":\"mcpServer/oauthLogin/completed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"mcpServer/oauthLogin/completed\",\"params\":{\"name\":\"github\",\"success\":false,\"error\":7}}}")));
        assertFalse(invalidMcpOauthError.ok, "MCP OAuth error must be a string or null when present");
        assertEquals("expected_nullable_string", invalidMcpOauthError.errorCode);
        assertEquals("$.message.params.error", invalidMcpOauthError.errorPath);

        final invalidMcpServerStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-server-invalid-status\",\"kind\":\"notification\",\"method\":\"mcpServer/startupStatus/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"mcpServer/startupStatus/updated\",\"params\":{\"name\":\"github\",\"status\":\"paused\"}}}")));
        assertFalse(invalidMcpServerStatus.ok, "MCP server startup status must be a known enum value");
        assertEquals("invalid_mcp_server_startup_status", invalidMcpServerStatus.errorCode);
        assertEquals("$.message.params.status", invalidMcpServerStatus.errorPath);

        final invalidMcpServerThreadId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-server-invalid-thread\",\"kind\":\"notification\",\"method\":\"mcpServer/startupStatus/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"mcpServer/startupStatus/updated\",\"params\":{\"threadId\":7,\"name\":\"github\",\"status\":\"ready\"}}}")));
        assertFalse(invalidMcpServerThreadId.ok, "MCP server threadId must be a string or null when present");
        assertEquals("expected_nullable_string", invalidMcpServerThreadId.errorCode);
        assertEquals("$.message.params.threadId", invalidMcpServerThreadId.errorPath);

        final invalidAccountAuthMode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-invalid-auth-mode\",\"kind\":\"notification\",\"method\":\"account/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/updated\",\"params\":{\"authMode\":\"cookie\",\"planType\":\"pro\"}}}")));
        assertFalse(invalidAccountAuthMode.ok, "account auth mode must be a known enum value");
        assertEquals("invalid_account_auth_mode", invalidAccountAuthMode.errorCode);
        assertEquals("$.message.params.authMode", invalidAccountAuthMode.errorPath);

        final invalidAccountPlanType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-invalid-plan-type\",\"kind\":\"notification\",\"method\":\"account/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/updated\",\"params\":{\"authMode\":null,\"planType\":\"ultimate\"}}}")));
        assertFalse(invalidAccountPlanType.ok, "account plan type must be a known enum value");
        assertEquals("invalid_account_plan_type", invalidAccountPlanType.errorCode);
        assertEquals("$.message.params.planType", invalidAccountPlanType.errorPath);

        final invalidAccountPlanShape = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-invalid-plan-shape\",\"kind\":\"notification\",\"method\":\"account/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/updated\",\"params\":{\"planType\":7}}}")));
        assertFalse(invalidAccountPlanShape.ok, "account plan type must be a string or null when present");
        assertEquals("expected_nullable_string", invalidAccountPlanShape.errorCode);
        assertEquals("$.message.params.planType", invalidAccountPlanShape.errorPath);

        final missingRateLimitWindowUsed = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-rate-limits-missing-window-used\",\"kind\":\"notification\",\"method\":\"account/rateLimits/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/rateLimits/updated\",\"params\":{\"rateLimits\":{\"primary\":{}}}}}")));
        assertFalse(missingRateLimitWindowUsed.ok, "rate limit windows must include usedPercent");
        assertEquals("missing_field", missingRateLimitWindowUsed.errorCode);
        assertEquals("$.message.params.rateLimits.primary.usedPercent", missingRateLimitWindowUsed.errorPath);

        final invalidRateLimitReachedType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-rate-limits-invalid-reached\",\"kind\":\"notification\",\"method\":\"account/rateLimits/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/rateLimits/updated\",\"params\":{\"rateLimits\":{\"rateLimitReachedType\":\"soft_limit\"}}}}")));
        assertFalse(invalidRateLimitReachedType.ok, "rate limit reached type must be a known enum value");
        assertEquals("invalid_rate_limit_reached_type", invalidRateLimitReachedType.errorCode);
        assertEquals("$.message.params.rateLimits.rateLimitReachedType", invalidRateLimitReachedType.errorPath);

        final invalidRateLimitWindowReset = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-rate-limits-invalid-reset\",\"kind\":\"notification\",\"method\":\"account/rateLimits/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/rateLimits/updated\",\"params\":{\"rateLimits\":{\"primary\":{\"usedPercent\":50,\"resetsAt\":\"soon\"}}}}}")));
        assertFalse(invalidRateLimitWindowReset.ok, "rate limit resetsAt must be numeric or null when present");
        assertEquals("expected_nullable_number", invalidRateLimitWindowReset.errorCode);
        assertEquals("$.message.params.rateLimits.primary.resetsAt", invalidRateLimitWindowReset.errorPath);

        final missingAppName = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"app-list-missing-name\",\"kind\":\"notification\",\"method\":\"app/list/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"app/list/updated\",\"params\":{\"data\":[{\"id\":\"app-1\"}]}}}")));
        assertFalse(missingAppName.ok, "app list entries must include name");
        assertEquals("missing_field", missingAppName.errorCode);
        assertEquals("$.message.params.data[0].name", missingAppName.errorPath);

        final invalidPluginDisplayName = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"app-list-invalid-plugin-name\",\"kind\":\"notification\",\"method\":\"app/list/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"app/list/updated\",\"params\":{\"data\":[{\"id\":\"app-1\",\"name\":\"App\",\"pluginDisplayNames\":[7]}]}}}")));
        assertFalse(invalidPluginDisplayName.ok, "plugin display names must be strings");
        assertEquals("expected_string", invalidPluginDisplayName.errorCode);
        assertEquals("$.message.params.data[0].pluginDisplayNames[0]", invalidPluginDisplayName.errorPath);

        final invalidBranding = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"app-list-invalid-branding\",\"kind\":\"notification\",\"method\":\"app/list/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"app/list/updated\",\"params\":{\"data\":[{\"id\":\"app-1\",\"name\":\"App\",\"branding\":{}}]}}}")));
        assertFalse(invalidBranding.ok, "branding must include isDiscoverableApp when present");
        assertEquals("missing_field", invalidBranding.errorCode);
        assertEquals("$.message.params.data[0].branding.isDiscoverableApp", invalidBranding.errorPath);

        final invalidRemoteControlStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"remote-control-invalid-status\",\"kind\":\"notification\",\"method\":\"remoteControl/status/changed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"remoteControl/status/changed\",\"params\":{\"installationId\":\"install-1\",\"serverName\":\"desktop\",\"status\":\"sleeping\"}}}")));
        assertFalse(invalidRemoteControlStatus.ok, "remote control status must be a known enum value");
        assertEquals("invalid_remote_control_status", invalidRemoteControlStatus.errorCode);
        assertEquals("$.message.params.status", invalidRemoteControlStatus.errorPath);

        final invalidRemoteControlEnvironment = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"remote-control-invalid-environment\",\"kind\":\"notification\",\"method\":\"remoteControl/status/changed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"remoteControl/status/changed\",\"params\":{\"installationId\":\"install-1\",\"serverName\":\"desktop\",\"status\":\"connected\",\"environmentId\":7}}}")));
        assertFalse(invalidRemoteControlEnvironment.ok, "remote control environmentId must be a string or null when present");
        assertEquals("expected_nullable_string", invalidRemoteControlEnvironment.errorCode);
        assertEquals("$.message.params.environmentId", invalidRemoteControlEnvironment.errorPath);

        final invalidModelRerouteReason = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"model-rerouted-invalid-reason\",\"kind\":\"notification\",\"method\":\"model/rerouted\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"model/rerouted\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"fromModel\":\"gpt-5\",\"toModel\":\"gpt-5-safe\",\"reason\":\"policy\"}}}")));
        assertFalse(invalidModelRerouteReason.ok, "model reroute reason must be a known enum value");
        assertEquals("invalid_model_reroute_reason", invalidModelRerouteReason.errorCode);
        assertEquals("$.message.params.reason", invalidModelRerouteReason.errorPath);

        final invalidModelVerification = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"model-verification-invalid-value\",\"kind\":\"notification\",\"method\":\"model/verification\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"model/verification\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"verifications\":[\"unknown\"]}}}")));
        assertFalse(invalidModelVerification.ok, "model verifications must be known enum values");
        assertEquals("invalid_model_verification", invalidModelVerification.errorCode);
        assertEquals("$.message.params.verifications[0]", invalidModelVerification.errorPath);

        final invalidWarningThreadId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"warning-invalid-thread\",\"kind\":\"notification\",\"method\":\"warning\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"warning\",\"params\":{\"message\":\"warn\",\"threadId\":7}}}")));
        assertFalse(invalidWarningThreadId.ok, "warning threadId must be a string or null when present");
        assertEquals("expected_nullable_string", invalidWarningThreadId.errorCode);
        assertEquals("$.message.params.threadId", invalidWarningThreadId.errorPath);

        final missingGuardianWarningThreadId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"guardian-warning-missing-thread\",\"kind\":\"notification\",\"method\":\"guardianWarning\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"guardianWarning\",\"params\":{\"message\":\"warn\"}}}")));
        assertFalse(missingGuardianWarningThreadId.ok, "guardian warning threadId must be present");
        assertEquals("missing_field", missingGuardianWarningThreadId.errorCode);
        assertEquals("$.message.params.threadId", missingGuardianWarningThreadId.errorPath);

        final invalidDeprecationNoticeDetails = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"deprecation-notice-invalid-details\",\"kind\":\"notification\",\"method\":\"deprecationNotice\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"deprecationNotice\",\"params\":{\"summary\":\"deprecated\",\"details\":7}}}")));
        assertFalse(invalidDeprecationNoticeDetails.ok, "deprecation notice details must be a string or null when present");
        assertEquals("expected_nullable_string", invalidDeprecationNoticeDetails.errorCode);
        assertEquals("$.message.params.details", invalidDeprecationNoticeDetails.errorPath);

        final invalidConfigWarningPath = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-warning-invalid-path\",\"kind\":\"notification\",\"method\":\"configWarning\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"configWarning\",\"params\":{\"summary\":\"warn\",\"path\":7}}}")));
        assertFalse(invalidConfigWarningPath.ok, "config warning path must be a string or null when present");
        assertEquals("expected_nullable_string", invalidConfigWarningPath.errorCode);
        assertEquals("$.message.params.path", invalidConfigWarningPath.errorPath);

        final invalidConfigWarningRangeLine = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-warning-invalid-range-line\",\"kind\":\"notification\",\"method\":\"configWarning\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"configWarning\",\"params\":{\"summary\":\"warn\",\"range\":{\"start\":{\"line\":-1,\"column\":0},\"end\":{\"line\":1,\"column\":2}}}}}")));
        assertFalse(invalidConfigWarningRangeLine.ok, "config warning range positions must be unsigned integers");
        assertEquals("expected_uint", invalidConfigWarningRangeLine.errorCode);
        assertEquals("$.message.params.range.start.line", invalidConfigWarningRangeLine.errorPath);

        final invalidFuzzyMatchType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fuzzy-search-invalid-match\",\"kind\":\"notification\",\"method\":\"fuzzyFileSearch/sessionUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"fuzzyFileSearch/sessionUpdated\",\"params\":{\"sessionId\":\"fuzzy-1\",\"query\":\"p\",\"files\":[{\"file_name\":\"a\",\"match_type\":\"symlink\",\"path\":\"a\",\"root\":\"/tmp\",\"score\":1,\"indices\":null}]}}}")));
        assertFalse(invalidFuzzyMatchType.ok, "fuzzy file search match type must be file or directory");
        assertEquals("invalid_fuzzy_file_search_match_type", invalidFuzzyMatchType.errorCode);
        assertEquals("$.message.params.files[0].match_type", invalidFuzzyMatchType.errorPath);

        final invalidFuzzyIndex = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fuzzy-search-invalid-index\",\"kind\":\"notification\",\"method\":\"fuzzyFileSearch/sessionUpdated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"fuzzyFileSearch/sessionUpdated\",\"params\":{\"sessionId\":\"fuzzy-1\",\"query\":\"p\",\"files\":[{\"file_name\":\"a\",\"match_type\":\"file\",\"path\":\"a\",\"root\":\"/tmp\",\"score\":1,\"indices\":[0,-1]}]}}}")));
        assertFalse(invalidFuzzyIndex.ok, "fuzzy file search indices must be unsigned integers");
        assertEquals("expected_uint", invalidFuzzyIndex.errorCode);
        assertEquals("$.message.params.files[0].indices[1]", invalidFuzzyIndex.errorPath);

        final missingFuzzyCompletedSession = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fuzzy-search-completed-missing-session\",\"kind\":\"notification\",\"method\":\"fuzzyFileSearch/sessionCompleted\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"fuzzyFileSearch/sessionCompleted\",\"params\":{}}}")));
        assertFalse(missingFuzzyCompletedSession.ok, "fuzzy file search completion must include sessionId");
        assertEquals("missing_field", missingFuzzyCompletedSession.errorCode);
        assertEquals("$.message.params.sessionId", missingFuzzyCompletedSession.errorPath);

        final invalidRealtimeVersion = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-started-invalid-version\",\"kind\":\"notification\",\"method\":\"thread/realtime/started\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/started\",\"params\":{\"threadId\":\"thread-1\",\"version\":\"v3\",\"realtimeSessionId\":null}}}")));
        assertFalse(invalidRealtimeVersion.ok, "realtime started version must be v1 or v2");
        assertEquals("invalid_realtime_conversation_version", invalidRealtimeVersion.errorCode);
        assertEquals("$.message.params.version", invalidRealtimeVersion.errorPath);

        final missingRealtimeItem = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-item-missing-item\",\"kind\":\"notification\",\"method\":\"thread/realtime/itemAdded\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/itemAdded\",\"params\":{\"threadId\":\"thread-1\"}}}")));
        assertFalse(missingRealtimeItem.ok, "realtime itemAdded must include item");
        assertEquals("missing_field", missingRealtimeItem.errorCode);
        assertEquals("$.message.params.item", missingRealtimeItem.errorPath);

        final invalidRealtimeTranscriptDelta = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-transcript-invalid-delta\",\"kind\":\"notification\",\"method\":\"thread/realtime/transcript/delta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/transcript/delta\",\"params\":{\"threadId\":\"thread-1\",\"role\":\"assistant\",\"delta\":7}}}")));
        assertFalse(invalidRealtimeTranscriptDelta.ok, "realtime transcript delta must be a string");
        assertEquals("expected_string", invalidRealtimeTranscriptDelta.errorCode);
        assertEquals("$.message.params.delta", invalidRealtimeTranscriptDelta.errorPath);

        final invalidRealtimeTranscriptDoneText = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-transcript-done-invalid-text\",\"kind\":\"notification\",\"method\":\"thread/realtime/transcript/done\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/transcript/done\",\"params\":{\"threadId\":\"thread-1\",\"role\":\"assistant\",\"text\":7}}}")));
        assertFalse(invalidRealtimeTranscriptDoneText.ok, "realtime transcript done text must be a string");
        assertEquals("expected_string", invalidRealtimeTranscriptDoneText.errorCode);
        assertEquals("$.message.params.text", invalidRealtimeTranscriptDoneText.errorPath);

        final invalidRealtimeAudioChannels = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-audio-invalid-channels\",\"kind\":\"notification\",\"method\":\"thread/realtime/outputAudio/delta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/outputAudio/delta\",\"params\":{\"threadId\":\"thread-1\",\"audio\":{\"data\":\"AQ==\",\"itemId\":null,\"numChannels\":-1,\"sampleRate\":24000,\"samplesPerChannel\":128}}}}")));
        assertFalse(invalidRealtimeAudioChannels.ok, "realtime audio numChannels must be unsigned");
        assertEquals("expected_uint", invalidRealtimeAudioChannels.errorCode);
        assertEquals("$.message.params.audio.numChannels", invalidRealtimeAudioChannels.errorPath);

        final invalidRealtimeAudioSamples = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-audio-invalid-samples\",\"kind\":\"notification\",\"method\":\"thread/realtime/outputAudio/delta\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/outputAudio/delta\",\"params\":{\"threadId\":\"thread-1\",\"audio\":{\"data\":\"AQ==\",\"numChannels\":1,\"sampleRate\":24000,\"samplesPerChannel\":1.5}}}}")));
        assertFalse(invalidRealtimeAudioSamples.ok, "realtime audio samplesPerChannel must be an integer when present");
        assertEquals("expected_integer", invalidRealtimeAudioSamples.errorCode);
        assertEquals("$.message.params.audio.samplesPerChannel", invalidRealtimeAudioSamples.errorPath);

        final missingRealtimeSdp = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-sdp-missing-sdp\",\"kind\":\"notification\",\"method\":\"thread/realtime/sdp\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/sdp\",\"params\":{\"threadId\":\"thread-1\"}}}")));
        assertFalse(missingRealtimeSdp.ok, "realtime SDP notification must include sdp");
        assertEquals("missing_field", missingRealtimeSdp.errorCode);
        assertEquals("$.message.params.sdp", missingRealtimeSdp.errorPath);

        final invalidFsChangedPath = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fs-changed-invalid-path\",\"kind\":\"notification\",\"method\":\"fs/changed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"fs/changed\",\"params\":{\"watchId\":\"watch-1\",\"changedPaths\":[7]}}}")));
        assertFalse(invalidFsChangedPath.ok, "changed paths must be strings");
        assertEquals("expected_string", invalidFsChangedPath.errorCode);
        assertEquals("$.message.params.changedPaths[0]", invalidFsChangedPath.errorPath);
    }

    static function fixtureItems(root:Value):Array<Value> {
        return switch root {
            case JObject(keys, values):
                final i = fieldIndex(keys, "items");
                if (i < 0) throw "fixture is missing items";
                switch values[i] {
                    case JArray(entries):
                        entries;
                    case _:
                        throw "fixture items must be an array";
                }
            case _:
                throw "fixture root must be an object";
        }
    }

    static function expectParse(outcome:JsonParseOutcome):Value {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome.value;
    }

    static function expectProtocol(outcome:AppProtocolParseOutcome):AppProtocolMessage {
        if (!outcome.ok) {
            throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        }
        return outcome.message;
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected `" + haystack + "` to contain `" + needle + "`";
    }
}
