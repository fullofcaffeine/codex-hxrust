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
        assertContains(fingerprintJson, "thread/resume");
        assertContains(fingerprintJson, "thread/fork");
        assertContains(fingerprintJson, "thread/archive");
        assertContains(fingerprintJson, "thread/unarchive");
        assertContains(fingerprintJson, "thread/unsubscribe");
        assertContains(fingerprintJson, "thread/increment_elicitation");
        assertContains(fingerprintJson, "thread/decrement_elicitation");
        assertContains(fingerprintJson, "thread/name/set");
        assertContains(fingerprintJson, "thread/goal/set");
        assertContains(fingerprintJson, "thread/goal/get");
        assertContains(fingerprintJson, "thread/goal/clear");
        assertContains(fingerprintJson, "thread/metadata/update");
        assertContains(fingerprintJson, "thread/settings/update");
        assertContains(fingerprintJson, "thread/memoryMode/set");
        assertContains(fingerprintJson, "memory/reset");
        assertContains(fingerprintJson, "thread/compact/start");
        assertContains(fingerprintJson, "thread/shellCommand");
        assertContains(fingerprintJson, "thread/approveGuardianDeniedAction");
        assertContains(fingerprintJson, "thread/backgroundTerminals/clean");
        assertContains(fingerprintJson, "thread/rollback");
        assertContains(fingerprintJson, "thread/inject_items");
        assertContains(fingerprintJson, "thread/turns/list");
        assertContains(fingerprintJson, "thread/turns/items/list");
        assertContains(fingerprintJson, "thread/list");
        assertContains(fingerprintJson, "thread/loaded/list");
        assertContains(fingerprintJson, "turn/steer");
        assertContains(fingerprintJson, "review/start");
        assertContains(fingerprintJson, "windowsSandbox/setupStart");
        assertContains(fingerprintJson, "windowsSandbox/readiness");
        assertContains(fingerprintJson, "account/login/start");
        assertContains(fingerprintJson, "account/login/cancel");
        assertContains(fingerprintJson, "account/logout");
        assertContains(fingerprintJson, "account/read");
        assertContains(fingerprintJson, "account/rateLimits/read");
        assertContains(fingerprintJson, "account/usage/read");
        assertContains(fingerprintJson, "account/sendAddCreditsNudgeEmail");
        assertContains(fingerprintJson, "feedback/upload");
        assertContains(fingerprintJson, "command/exec");
        assertContains(fingerprintJson, "command/exec/write");
        assertContains(fingerprintJson, "command/exec/terminate");
        assertContains(fingerprintJson, "command/exec/resize");
        assertContains(fingerprintJson, "process/spawn");
        assertContains(fingerprintJson, "process/writeStdin");
        assertContains(fingerprintJson, "process/kill");
        assertContains(fingerprintJson, "process/resizePty");
        assertContains(fingerprintJson, "config/read");
        assertContains(fingerprintJson, "externalAgentConfig/detect");
        assertContains(fingerprintJson, "externalAgentConfig/import");
        assertContains(fingerprintJson, "config/value/write");
        assertContains(fingerprintJson, "config/batchWrite");
        assertContains(fingerprintJson, "configRequirements/read");
        assertContains(fingerprintJson, "app/list");
        assertContains(fingerprintJson, "skills/list");
        assertContains(fingerprintJson, "skills/extraRoots/set");
        assertContains(fingerprintJson, "skills/config/write");
        assertContains(fingerprintJson, "hooks/list");
        assertContains(fingerprintJson, "marketplace/add");
        assertContains(fingerprintJson, "marketplace/remove");
        assertContains(fingerprintJson, "marketplace/upgrade");
        assertContains(fingerprintJson, "plugin/list");
        assertContains(fingerprintJson, "plugin/installed");
        assertContains(fingerprintJson, "plugin/read");
        assertContains(fingerprintJson, "plugin/skill/read");
        assertContains(fingerprintJson, "plugin/install");
        assertContains(fingerprintJson, "plugin/uninstall");
        assertContains(fingerprintJson, "plugin/share/save");
        assertContains(fingerprintJson, "plugin/share/updateTargets");
        assertContains(fingerprintJson, "plugin/share/list");
        assertContains(fingerprintJson, "plugin/share/checkout");
        assertContains(fingerprintJson, "plugin/share/delete");
        assertContains(fingerprintJson, "fs/readFile");
        assertContains(fingerprintJson, "fs/writeFile");
        assertContains(fingerprintJson, "fs/createDirectory");
        assertContains(fingerprintJson, "fs/getMetadata");
        assertContains(fingerprintJson, "fs/readDirectory");
        assertContains(fingerprintJson, "fs/remove");
        assertContains(fingerprintJson, "fs/copy");
        assertContains(fingerprintJson, "fs/watch");
        assertContains(fingerprintJson, "fs/unwatch");
        assertContains(fingerprintJson, "model/list");
        assertContains(fingerprintJson, "modelProvider/capabilities/read");
        assertContains(fingerprintJson, "experimentalFeature/list");
        assertContains(fingerprintJson, "experimentalFeature/enablement/set");
        assertContains(fingerprintJson, "permissionProfile/list");
        assertContains(fingerprintJson, "mcpServer/oauth/login");
        assertContains(fingerprintJson, "config/mcpServer/reload");
        assertContains(fingerprintJson, "mcpServerStatus/list");
        assertContains(fingerprintJson, "mcpServer/resource/read");
        assertContains(fingerprintJson, "mcpServer/tool/call");
        assertContains(fingerprintJson, "serverRequests:account/chatgptAuthTokens/refresh");
        assertContains(fingerprintJson, "attestation/generate");
        assertContains(fingerprintJson, "item/commandExecution/requestApproval");
        assertContains(fingerprintJson, "item/fileChange/requestApproval");
        assertContains(fingerprintJson, "item/permissions/requestApproval");
        assertContains(fingerprintJson, "item/tool/call");
        assertContains(fingerprintJson, "item/tool/requestUserInput");
        assertContains(fingerprintJson, "mcpServer/elicitation/request");
        assertContains(fingerprintJson, "turn/completed");
        assertContains(fingerprintJson, "turn/plan/updated");
        assertContains(fingerprintJson, "turn/moderationMetadata");
        assertContains(fingerprintJson, "thread/archived");
        assertContains(fingerprintJson, "thread/unarchived");
        assertContains(fingerprintJson, "thread/closed");
        assertContains(fingerprintJson, "thread/name/updated");
        assertContains(fingerprintJson, "thread/goal/updated");
        assertContains(fingerprintJson, "thread/goal/cleared");
        assertContains(fingerprintJson, "thread/settings/updated");
        assertContains(fingerprintJson, "thread/tokenUsage/updated");
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
        assertContains(fingerprintJson, "thread/realtime/error");
        assertContains(fingerprintJson, "thread/realtime/closed");
        assertContains(fingerprintJson, "windows/worldWritableWarning");
        assertContains(fingerprintJson, "windowsSandbox/setupCompleted");
        assertContains(fingerprintJson, "account/login/completed");
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
        assertEquals("264", Std.string(items.length));

        var requests = 0;
        var responses = 0;
        var serverRequests = 0;
        var serverResponses = 0;
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
            if (parsed.kind == "serverRequest") serverRequests = serverRequests + 1;
            if (parsed.kind == "serverResponse") serverResponses = serverResponses + 1;
            if (parsed.kind == "notification") notifications = notifications + 1;
            if (parsed.kind == "error") errors = errors + 1;
        }

        assertEquals("93", Std.string(requests));
        assertEquals("93", Std.string(responses));
        assertEquals("8", Std.string(serverRequests));
        assertEquals("8", Std.string(serverResponses));
        assertEquals("61", Std.string(notifications));
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

        final missingThreadResumeId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-resume-missing-thread-id\",\"kind\":\"request\",\"method\":\"thread/resume\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"resume-1\",\"method\":\"thread/resume\",\"params\":{\"cwd\":\"/tmp/codex-hxrust\"}}}")));
        assertFalse(missingThreadResumeId.ok, "thread/resume must include threadId");
        assertEquals("missing_field", missingThreadResumeId.errorCode);
        assertEquals("$.message.params.threadId", missingThreadResumeId.errorPath);

        final invalidThreadUnsubscribeStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-unsubscribe-invalid-status\",\"kind\":\"response\",\"method\":\"thread/unsubscribe\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"unsubscribe-1\",\"result\":{\"status\":\"gone\"}}}")));
        assertFalse(invalidThreadUnsubscribeStatus.ok, "thread/unsubscribe status must use upstream enum values");
        assertEquals("invalid_thread_unsubscribe_status", invalidThreadUnsubscribeStatus.errorCode);
        assertEquals("$.message.result.status", invalidThreadUnsubscribeStatus.errorPath);

        final invalidThreadListLimit = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-list-invalid-limit\",\"kind\":\"request\",\"method\":\"thread/list\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"thread-list-1\",\"method\":\"thread/list\",\"params\":{\"limit\":-1}}}")));
        assertFalse(invalidThreadListLimit.ok, "thread/list limit must be unsigned when present");
        assertEquals("expected_uint", invalidThreadListLimit.errorCode);
        assertEquals("$.message.params.limit", invalidThreadListLimit.errorPath);

        final invalidThreadLoadedListData = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-loaded-list-invalid-data\",\"kind\":\"response\",\"method\":\"thread/loaded/list\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"thread-loaded-list-1\",\"result\":{\"data\":[7]}}}")));
        assertFalse(invalidThreadLoadedListData.ok, "thread/loaded/list data entries must be thread id strings");
        assertEquals("expected_string", invalidThreadLoadedListData.errorCode);
        assertEquals("$.message.result.data[0]", invalidThreadLoadedListData.errorPath);

        final missingThreadArchivedId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-archived-missing-thread-id\",\"kind\":\"notification\",\"method\":\"thread/archived\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/archived\",\"params\":{}}}")));
        assertFalse(missingThreadArchivedId.ok, "thread/archived must include threadId");
        assertEquals("missing_field", missingThreadArchivedId.errorCode);
        assertEquals("$.message.params.threadId", missingThreadArchivedId.errorPath);

        final invalidThreadGoalStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-goal-invalid-status\",\"kind\":\"request\",\"method\":\"thread/goal/set\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"goal-1\",\"method\":\"thread/goal/set\",\"params\":{\"threadId\":\"thread-1\",\"status\":\"sleeping\"}}}")));
        assertFalse(invalidThreadGoalStatus.ok, "thread goals must use upstream status values");
        assertEquals("invalid_thread_goal_status", invalidThreadGoalStatus.errorCode);
        assertEquals("$.message.params.status", invalidThreadGoalStatus.errorPath);

        final invalidThreadMemoryMode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-memory-invalid-mode\",\"kind\":\"request\",\"method\":\"thread/memoryMode/set\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"memory-mode-1\",\"method\":\"thread/memoryMode/set\",\"params\":{\"threadId\":\"thread-1\",\"mode\":\"auto\"}}}")));
        assertFalse(invalidThreadMemoryMode.ok, "thread memory mode must be enabled or disabled");
        assertEquals("invalid_thread_memory_mode", invalidThreadMemoryMode.errorCode);
        assertEquals("$.message.params.mode", invalidThreadMemoryMode.errorPath);

        final invalidThreadRollbackTurns = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-rollback-invalid-turns\",\"kind\":\"request\",\"method\":\"thread/rollback\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"rollback-1\",\"method\":\"thread/rollback\",\"params\":{\"threadId\":\"thread-1\",\"numTurns\":0}}}")));
        assertFalse(invalidThreadRollbackTurns.ok, "thread rollback must drop at least one turn");
        assertEquals("expected_positive_uint", invalidThreadRollbackTurns.errorCode);
        assertEquals("$.message.params.numTurns", invalidThreadRollbackTurns.errorPath);

        final invalidThreadInjectItem = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-inject-invalid-item\",\"kind\":\"request\",\"method\":\"thread/inject_items\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"inject-1\",\"method\":\"thread/inject_items\",\"params\":{\"threadId\":\"thread-1\",\"items\":[7]}}}")));
        assertFalse(invalidThreadInjectItem.ok, "thread/inject_items entries must be JSON objects in this subset");
        assertEquals("expected_object", invalidThreadInjectItem.errorCode);
        assertEquals("$.message.params.items[0]", invalidThreadInjectItem.errorPath);

        final missingThreadSettings = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-settings-missing\",\"kind\":\"notification\",\"method\":\"thread/settings/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/settings/updated\",\"params\":{\"threadId\":\"thread-1\"}}}")));
        assertFalse(missingThreadSettings.ok, "thread/settings/updated must include threadSettings");
        assertEquals("missing_field", missingThreadSettings.errorCode);
        assertEquals("$.message.params.threadSettings", missingThreadSettings.errorPath);

        final missingTokenUsageTotalTokens = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-token-usage-missing-total\",\"kind\":\"notification\",\"method\":\"thread/tokenUsage/updated\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/tokenUsage/updated\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"tokenUsage\":{\"total\":{\"inputTokens\":1,\"cachedInputTokens\":0,\"outputTokens\":1,\"reasoningOutputTokens\":0},\"last\":{\"totalTokens\":2,\"inputTokens\":1,\"cachedInputTokens\":0,\"outputTokens\":1,\"reasoningOutputTokens\":0},\"modelContextWindow\":null}}}}")));
        assertFalse(missingTokenUsageTotalTokens.ok, "token usage breakdowns must include totalTokens");
        assertEquals("missing_field", missingTokenUsageTotalTokens.errorCode);
        assertEquals("$.message.params.tokenUsage.total.totalTokens", missingTokenUsageTotalTokens.errorPath);

        final missingTurnSteerExpectedTurn = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"turn-steer-missing-expected\",\"kind\":\"request\",\"method\":\"turn/steer\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"steer-1\",\"method\":\"turn/steer\",\"params\":{\"threadId\":\"thread-1\",\"input\":[{\"type\":\"text\",\"text\":\"continue\"}]}}}")));
        assertFalse(missingTurnSteerExpectedTurn.ok, "turn/steer must include expectedTurnId");
        assertEquals("missing_field", missingTurnSteerExpectedTurn.errorCode);
        assertEquals("$.message.params.expectedTurnId", missingTurnSteerExpectedTurn.errorPath);

        final invalidReviewTarget = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"review-invalid-target\",\"kind\":\"request\",\"method\":\"review/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"review-1\",\"method\":\"review/start\",\"params\":{\"threadId\":\"thread-1\",\"target\":{\"type\":\"branch\"}}}}")));
        assertFalse(invalidReviewTarget.ok, "review target must use upstream tagged variants");
        assertEquals("invalid_review_target", invalidReviewTarget.errorCode);
        assertEquals("$.message.params.target.type", invalidReviewTarget.errorPath);

        final invalidReviewDelivery = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"review-invalid-delivery\",\"kind\":\"request\",\"method\":\"review/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"review-1\",\"method\":\"review/start\",\"params\":{\"threadId\":\"thread-1\",\"target\":{\"type\":\"uncommittedChanges\"},\"delivery\":\"background\"}}}")));
        assertFalse(invalidReviewDelivery.ok, "review delivery must be inline or detached");
        assertEquals("invalid_review_delivery", invalidReviewDelivery.errorCode);
        assertEquals("$.message.params.delivery", invalidReviewDelivery.errorPath);

        final invalidThreadTurnsItemsView = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-turns-invalid-items-view\",\"kind\":\"request\",\"method\":\"thread/turns/list\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"turns-list-1\",\"method\":\"thread/turns/list\",\"params\":{\"threadId\":\"thread-1\",\"itemsView\":\"everything\"}}}")));
        assertFalse(invalidThreadTurnsItemsView.ok, "thread/turns/list itemsView must use upstream values");
        assertEquals("invalid_turn_items_view", invalidThreadTurnsItemsView.errorCode);
        assertEquals("$.message.params.itemsView", invalidThreadTurnsItemsView.errorPath);

        final invalidThreadTurnsItem = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"thread-turns-items-invalid-item\",\"kind\":\"response\",\"method\":\"thread/turns/items/list\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"turns-items-1\",\"result\":{\"data\":[7],\"nextCursor\":null,\"backwardsCursor\":null}}}")));
        assertFalse(invalidThreadTurnsItem.ok, "thread/turns/items/list data entries must be item objects");
        assertEquals("expected_object", invalidThreadTurnsItem.errorCode);
        assertEquals("$.message.result.data[0]", invalidThreadTurnsItem.errorPath);
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

        final invalidRealtimeErrorMessage = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-error-invalid-message\",\"kind\":\"notification\",\"method\":\"thread/realtime/error\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/error\",\"params\":{\"threadId\":\"thread-1\",\"message\":7}}}")));
        assertFalse(invalidRealtimeErrorMessage.ok, "realtime error message must be a string");
        assertEquals("expected_string", invalidRealtimeErrorMessage.errorCode);
        assertEquals("$.message.params.message", invalidRealtimeErrorMessage.errorPath);

        final invalidRealtimeClosedReason = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"realtime-closed-invalid-reason\",\"kind\":\"notification\",\"method\":\"thread/realtime/closed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"thread/realtime/closed\",\"params\":{\"threadId\":\"thread-1\",\"reason\":7}}}")));
        assertFalse(invalidRealtimeClosedReason.ok, "realtime closed reason must be a string or null when present");
        assertEquals("expected_nullable_string", invalidRealtimeClosedReason.errorCode);
        assertEquals("$.message.params.reason", invalidRealtimeClosedReason.errorPath);

        final invalidWindowsSetupMode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"windows-setup-invalid-mode\",\"kind\":\"request\",\"method\":\"windowsSandbox/setupStart\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"windows-1\",\"method\":\"windowsSandbox/setupStart\",\"params\":{\"mode\":\"admin\",\"cwd\":null}}}")));
        assertFalse(invalidWindowsSetupMode.ok, "Windows sandbox setup mode must be an upstream enum value");
        assertEquals("invalid_windows_sandbox_setup_mode", invalidWindowsSetupMode.errorCode);
        assertEquals("$.message.params.mode", invalidWindowsSetupMode.errorPath);

        final invalidWindowsReadiness = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"windows-readiness-invalid-status\",\"kind\":\"response\",\"method\":\"windowsSandbox/readiness\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"windows-readiness-1\",\"result\":{\"status\":\"unknown\"}}}")));
        assertFalse(invalidWindowsReadiness.ok, "Windows sandbox readiness status must be an upstream enum value");
        assertEquals("invalid_windows_sandbox_readiness", invalidWindowsReadiness.errorCode);
        assertEquals("$.message.result.status", invalidWindowsReadiness.errorPath);

        final invalidWindowsWarningExtraCount = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"windows-warning-invalid-extra-count\",\"kind\":\"notification\",\"method\":\"windows/worldWritableWarning\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"windows/worldWritableWarning\",\"params\":{\"samplePaths\":[\"C:\\\\\\\\codex\\\\\\\\tmp\"],\"extraCount\":-1,\"failedScan\":false}}}")));
        assertFalse(invalidWindowsWarningExtraCount.ok, "Windows world-writable warning extraCount must be unsigned");
        assertEquals("expected_uint", invalidWindowsWarningExtraCount.errorCode);
        assertEquals("$.message.params.extraCount", invalidWindowsWarningExtraCount.errorPath);

        final invalidWindowsSetupCompletedError = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"windows-setup-completed-invalid-error\",\"kind\":\"notification\",\"method\":\"windowsSandbox/setupCompleted\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"windowsSandbox/setupCompleted\",\"params\":{\"mode\":\"elevated\",\"success\":false,\"error\":7}}}")));
        assertFalse(invalidWindowsSetupCompletedError.ok, "Windows sandbox setup completed error must be a string or null when present");
        assertEquals("expected_nullable_string", invalidWindowsSetupCompletedError.errorCode);
        assertEquals("$.message.params.error", invalidWindowsSetupCompletedError.errorPath);

        final invalidLoginType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-login-invalid-type\",\"kind\":\"request\",\"method\":\"account/login/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"login-1\",\"method\":\"account/login/start\",\"params\":{\"type\":\"password\"}}}")));
        assertFalse(invalidLoginType.ok, "account login type must be an upstream variant");
        assertEquals("invalid_login_account_type", invalidLoginType.errorCode);
        assertEquals("$.message.params.type", invalidLoginType.errorPath);

        final missingDeviceCodeUserCode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-login-missing-user-code\",\"kind\":\"response\",\"method\":\"account/login/start\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"login-1\",\"result\":{\"type\":\"chatgptDeviceCode\",\"loginId\":\"login-1\",\"verificationUrl\":\"https://example.invalid/device\"}}}")));
        assertFalse(missingDeviceCodeUserCode.ok, "device code login responses must include userCode");
        assertEquals("missing_field", missingDeviceCodeUserCode.errorCode);
        assertEquals("$.message.result.userCode", missingDeviceCodeUserCode.errorPath);

        final invalidCancelLoginStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-login-cancel-invalid-status\",\"kind\":\"response\",\"method\":\"account/login/cancel\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cancel-1\",\"result\":{\"status\":\"expired\"}}}")));
        assertFalse(invalidCancelLoginStatus.ok, "cancel login status must be an upstream enum value");
        assertEquals("invalid_cancel_login_account_status", invalidCancelLoginStatus.errorCode);
        assertEquals("$.message.result.status", invalidCancelLoginStatus.errorPath);

        final invalidLoginCompletedError = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-login-completed-invalid-error\",\"kind\":\"notification\",\"method\":\"account/login/completed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"account/login/completed\",\"params\":{\"success\":false,\"loginId\":null,\"error\":7}}}")));
        assertFalse(invalidLoginCompletedError.ok, "account login completion error must be a string or null when present");
        assertEquals("expected_nullable_string", invalidLoginCompletedError.errorCode);
        assertEquals("$.message.params.error", invalidLoginCompletedError.errorPath);

        final invalidLogoutParams = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-logout-invalid-params\",\"kind\":\"request\",\"method\":\"account/logout\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"logout-1\",\"method\":\"account/logout\",\"params\":7}}")));
        assertFalse(invalidLogoutParams.ok, "logout params must be missing, null, or object-shaped");
        assertEquals("expected_nullable_object", invalidLogoutParams.errorCode);
        assertEquals("$.message.params", invalidLogoutParams.errorPath);

        final invalidLogoutExtraResult = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-logout-extra-result\",\"kind\":\"response\",\"method\":\"account/logout\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"logout-1\",\"result\":{\"ok\":true}}}")));
        assertFalse(invalidLogoutExtraResult.ok, "logout response must be an empty object");
        assertEquals("unexpected_field", invalidLogoutExtraResult.errorCode);
        assertEquals("$.message.result.ok", invalidLogoutExtraResult.errorPath);

        final invalidAccountReadRefresh = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-read-invalid-refresh\",\"kind\":\"request\",\"method\":\"account/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"account-read-1\",\"method\":\"account/read\",\"params\":{\"refreshToken\":\"yes\"}}}")));
        assertFalse(invalidAccountReadRefresh.ok, "account/read refreshToken must be a boolean");
        assertEquals("expected_bool", invalidAccountReadRefresh.errorCode);
        assertEquals("$.message.params.refreshToken", invalidAccountReadRefresh.errorPath);

        final missingAccountReadAuth = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-read-missing-auth\",\"kind\":\"response\",\"method\":\"account/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"account-read-1\",\"result\":{\"account\":null}}}")));
        assertFalse(missingAccountReadAuth.ok, "account/read requires requiresOpenaiAuth");
        assertEquals("missing_field", missingAccountReadAuth.errorCode);
        assertEquals("$.message.result.requiresOpenaiAuth", missingAccountReadAuth.errorPath);

        final invalidAccountReadPlan = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-read-invalid-plan\",\"kind\":\"response\",\"method\":\"account/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"account-read-1\",\"result\":{\"requiresOpenaiAuth\":false,\"account\":{\"type\":\"chatgpt\",\"email\":\"fixture@example.com\",\"planType\":\"gold\"}}}}")));
        assertFalse(invalidAccountReadPlan.ok, "account/read chatgpt account validates planType");
        assertEquals("invalid_account_plan_type", invalidAccountReadPlan.errorCode);
        assertEquals("$.message.result.account.planType", invalidAccountReadPlan.errorPath);

        final invalidAccountReadType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-read-invalid-type\",\"kind\":\"response\",\"method\":\"account/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"account-read-1\",\"result\":{\"requiresOpenaiAuth\":false,\"account\":{\"type\":\"oauth\"}}}}")));
        assertFalse(invalidAccountReadType.ok, "account/read account type must use upstream variants");
        assertEquals("invalid_account_type", invalidAccountReadType.errorCode);
        assertEquals("$.message.result.account.type", invalidAccountReadType.errorPath);

        final missingReadRateLimits = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-rate-limits-missing-rate-limits\",\"kind\":\"response\",\"method\":\"account/rateLimits/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"rates-1\",\"result\":{}}}")));
        assertFalse(missingReadRateLimits.ok, "account rate limit read responses must include rateLimits");
        assertEquals("missing_field", missingReadRateLimits.errorCode);
        assertEquals("$.message.result.rateLimits", missingReadRateLimits.errorPath);

        final invalidUsageSummaryInteger = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-usage-invalid-summary-integer\",\"kind\":\"response\",\"method\":\"account/usage/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"usage-1\",\"result\":{\"summary\":{\"lifetimeTokens\":1.5},\"dailyUsageBuckets\":null}}}")));
        assertFalse(invalidUsageSummaryInteger.ok, "account usage summary integer fields must be integers or null");
        assertEquals("expected_integer", invalidUsageSummaryInteger.errorCode);
        assertEquals("$.message.result.summary.lifetimeTokens", invalidUsageSummaryInteger.errorPath);

        final invalidUsageBucketTokens = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-usage-invalid-bucket-tokens\",\"kind\":\"response\",\"method\":\"account/usage/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"usage-1\",\"result\":{\"summary\":{},\"dailyUsageBuckets\":[{\"startDate\":\"2026-06-12\",\"tokens\":\"many\"}]}}}")));
        assertFalse(invalidUsageBucketTokens.ok, "account usage bucket tokens must be an integer");
        assertEquals("expected_number", invalidUsageBucketTokens.errorCode);
        assertEquals("$.message.result.dailyUsageBuckets[0].tokens", invalidUsageBucketTokens.errorPath);

        final invalidAddCreditsNudgeType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-add-credits-nudge-invalid-type\",\"kind\":\"request\",\"method\":\"account/sendAddCreditsNudgeEmail\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"nudge-1\",\"method\":\"account/sendAddCreditsNudgeEmail\",\"params\":{\"creditType\":\"tokens\"}}}")));
        assertFalse(invalidAddCreditsNudgeType.ok, "add-credits nudge creditType must be a known enum value");
        assertEquals("invalid_add_credits_nudge_credit_type", invalidAddCreditsNudgeType.errorCode);
        assertEquals("$.message.params.creditType", invalidAddCreditsNudgeType.errorPath);

        final invalidAddCreditsNudgeStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"account-add-credits-nudge-invalid-status\",\"kind\":\"response\",\"method\":\"account/sendAddCreditsNudgeEmail\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"nudge-1\",\"result\":{\"status\":\"queued\"}}}")));
        assertFalse(invalidAddCreditsNudgeStatus.ok, "add-credits nudge response status must be a known enum value");
        assertEquals("invalid_add_credits_nudge_email_status", invalidAddCreditsNudgeStatus.errorCode);
        assertEquals("$.message.result.status", invalidAddCreditsNudgeStatus.errorPath);

        final missingFeedbackClassification = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"feedback-upload-missing-classification\",\"kind\":\"request\",\"method\":\"feedback/upload\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"feedback-1\",\"method\":\"feedback/upload\",\"params\":{\"includeLogs\":false}}}")));
        assertFalse(missingFeedbackClassification.ok, "feedback upload must include classification");
        assertEquals("missing_field", missingFeedbackClassification.errorCode);
        assertEquals("$.message.params.classification", missingFeedbackClassification.errorPath);

        final invalidFeedbackExtraLogFile = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"feedback-upload-invalid-extra-log-file\",\"kind\":\"request\",\"method\":\"feedback/upload\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"feedback-1\",\"method\":\"feedback/upload\",\"params\":{\"classification\":\"bug\",\"extraLogFiles\":[7]}}}")));
        assertFalse(invalidFeedbackExtraLogFile.ok, "feedback upload extraLogFiles entries must be strings");
        assertEquals("expected_string", invalidFeedbackExtraLogFile.errorCode);
        assertEquals("$.message.params.extraLogFiles[0]", invalidFeedbackExtraLogFile.errorPath);

        final invalidFeedbackTagValue = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"feedback-upload-invalid-tag-value\",\"kind\":\"request\",\"method\":\"feedback/upload\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"feedback-1\",\"method\":\"feedback/upload\",\"params\":{\"classification\":\"bug\",\"tags\":{\"source\":7}}}}")));
        assertFalse(invalidFeedbackTagValue.ok, "feedback upload tag values must be strings");
        assertEquals("expected_string", invalidFeedbackTagValue.errorCode);
        assertEquals("$.message.params.tags.source", invalidFeedbackTagValue.errorPath);

        final missingFeedbackResponseThread = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"feedback-upload-missing-response-thread\",\"kind\":\"response\",\"method\":\"feedback/upload\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"feedback-1\",\"result\":{}}}")));
        assertFalse(missingFeedbackResponseThread.ok, "feedback upload response must include threadId");
        assertEquals("missing_field", missingFeedbackResponseThread.errorCode);
        assertEquals("$.message.result.threadId", missingFeedbackResponseThread.errorPath);

        final emptyCommandExecCommand = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-empty-command\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[]}}}")));
        assertFalse(emptyCommandExecCommand.ok, "command/exec command argv must be non-empty");
        assertEquals("empty_array", emptyCommandExecCommand.errorCode);
        assertEquals("$.message.params.command", emptyCommandExecCommand.errorPath);

        final missingStreamingProcessId = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-missing-stream-process\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"streamStdoutStderr\":true}}}")));
        assertFalse(missingStreamingProcessId.ok, "command/exec streaming modes require processId");
        assertEquals("missing_process_id", missingStreamingProcessId.errorCode);
        assertEquals("$.message.params.processId", missingStreamingProcessId.errorPath);

        final incompatibleOutputCap = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-incompatible-output-cap\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"outputBytesCap\":1,\"disableOutputCap\":true}}}")));
        assertFalse(incompatibleOutputCap.ok, "command/exec outputBytesCap cannot combine with disableOutputCap");
        assertEquals("incompatible_output_cap", incompatibleOutputCap.errorCode);
        assertEquals("$.message.params.outputBytesCap", incompatibleOutputCap.errorPath);

        final incompatibleTimeout = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-incompatible-timeout\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"timeoutMs\":1,\"disableTimeout\":true}}}")));
        assertFalse(incompatibleTimeout.ok, "command/exec timeoutMs cannot combine with disableTimeout");
        assertEquals("incompatible_timeout", incompatibleTimeout.errorCode);
        assertEquals("$.message.params.timeoutMs", incompatibleTimeout.errorPath);

        final terminalSizeWithoutTty = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-size-without-tty\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"size\":{\"rows\":24,\"cols\":80}}}}")));
        assertFalse(terminalSizeWithoutTty.ok, "command/exec size is only valid with tty");
        assertEquals("terminal_size_without_tty", terminalSizeWithoutTty.errorCode);
        assertEquals("$.message.params.size", terminalSizeWithoutTty.errorPath);

        final invalidCommandEnv = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-invalid-env\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"env\":{\"BAD\":7}}}}")));
        assertFalse(invalidCommandEnv.ok, "command/exec env values must be strings or null");
        assertEquals("expected_nullable_string", invalidCommandEnv.errorCode);
        assertEquals("$.message.params.env.BAD", invalidCommandEnv.errorPath);

        final invalidSandboxPolicy = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-invalid-sandbox\",\"kind\":\"request\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"method\":\"command/exec\",\"params\":{\"command\":[\"echo\"],\"sandboxPolicy\":{\"type\":\"moonBase\"}}}}")));
        assertFalse(invalidSandboxPolicy.ok, "command/exec sandboxPolicy type must be known");
        assertEquals("invalid_sandbox_policy_type", invalidSandboxPolicy.errorCode);
        assertEquals("$.message.params.sandboxPolicy.type", invalidSandboxPolicy.errorPath);

        final missingCommandExit = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-missing-exit\",\"kind\":\"response\",\"method\":\"command/exec\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-1\",\"result\":{\"stdout\":\"\",\"stderr\":\"\"}}}")));
        assertFalse(missingCommandExit.ok, "command/exec response must include exitCode");
        assertEquals("missing_field", missingCommandExit.errorCode);
        assertEquals("$.message.result.exitCode", missingCommandExit.errorPath);

        final missingCommandWriteProcess = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-write-missing-process\",\"kind\":\"request\",\"method\":\"command/exec/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-write-1\",\"method\":\"command/exec/write\",\"params\":{\"deltaBase64\":\"AA==\"}}}")));
        assertFalse(missingCommandWriteProcess.ok, "command/exec/write requires processId");
        assertEquals("missing_field", missingCommandWriteProcess.errorCode);
        assertEquals("$.message.params.processId", missingCommandWriteProcess.errorPath);

        final invalidCommandWriteClose = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-write-invalid-close\",\"kind\":\"request\",\"method\":\"command/exec/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-write-1\",\"method\":\"command/exec/write\",\"params\":{\"processId\":\"proc-1\",\"closeStdin\":\"yes\"}}}")));
        assertFalse(invalidCommandWriteClose.ok, "command/exec/write closeStdin must be a boolean");
        assertEquals("expected_bool", invalidCommandWriteClose.errorCode);
        assertEquals("$.message.params.closeStdin", invalidCommandWriteClose.errorPath);

        final missingCommandTerminateProcess = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-terminate-missing-process\",\"kind\":\"request\",\"method\":\"command/exec/terminate\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-term-1\",\"method\":\"command/exec/terminate\",\"params\":{}}}")));
        assertFalse(missingCommandTerminateProcess.ok, "command/exec/terminate requires processId");
        assertEquals("missing_field", missingCommandTerminateProcess.errorCode);
        assertEquals("$.message.params.processId", missingCommandTerminateProcess.errorPath);

        final invalidCommandResizeRows = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-resize-invalid-rows\",\"kind\":\"request\",\"method\":\"command/exec/resize\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-resize-1\",\"method\":\"command/exec/resize\",\"params\":{\"processId\":\"proc-1\",\"size\":{\"rows\":70000,\"cols\":80}}}}")));
        assertFalse(invalidCommandResizeRows.ok, "command/exec/resize rows must fit uint16");
        assertEquals("expected_uint16", invalidCommandResizeRows.errorCode);
        assertEquals("$.message.params.size.rows", invalidCommandResizeRows.errorPath);

        final invalidCommandResizeResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"command-exec-resize-extra-response\",\"kind\":\"response\",\"method\":\"command/exec/resize\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"cmd-resize-1\",\"result\":{\"ok\":true}}}")));
        assertFalse(invalidCommandResizeResponse.ok, "command/exec/resize response must be empty");
        assertEquals("unexpected_field", invalidCommandResizeResponse.errorCode);
        assertEquals("$.message.result.ok", invalidCommandResizeResponse.errorPath);

        final missingProcessHandle = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-spawn-missing-handle\",\"kind\":\"request\",\"method\":\"process/spawn\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-1\",\"method\":\"process/spawn\",\"params\":{\"command\":[\"echo\"],\"cwd\":\"/tmp/codex-hxrust\"}}}")));
        assertFalse(missingProcessHandle.ok, "process/spawn requires processHandle");
        assertEquals("missing_field", missingProcessHandle.errorCode);
        assertEquals("$.message.params.processHandle", missingProcessHandle.errorPath);

        final emptyProcessCommand = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-spawn-empty-command\",\"kind\":\"request\",\"method\":\"process/spawn\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-1\",\"method\":\"process/spawn\",\"params\":{\"command\":[],\"processHandle\":\"proc-1\",\"cwd\":\"/tmp/codex-hxrust\"}}}")));
        assertFalse(emptyProcessCommand.ok, "process/spawn command must be non-empty");
        assertEquals("empty_array", emptyProcessCommand.errorCode);
        assertEquals("$.message.params.command", emptyProcessCommand.errorPath);

        final invalidProcessCap = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-spawn-invalid-cap\",\"kind\":\"request\",\"method\":\"process/spawn\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-1\",\"method\":\"process/spawn\",\"params\":{\"command\":[\"echo\"],\"processHandle\":\"proc-1\",\"cwd\":\"/tmp/codex-hxrust\",\"outputBytesCap\":-1}}}")));
        assertFalse(invalidProcessCap.ok, "process/spawn outputBytesCap must be unsigned or null");
        assertEquals("expected_uint", invalidProcessCap.errorCode);
        assertEquals("$.message.params.outputBytesCap", invalidProcessCap.errorPath);

        final processSizeWithoutTty = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-spawn-size-without-tty\",\"kind\":\"request\",\"method\":\"process/spawn\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-1\",\"method\":\"process/spawn\",\"params\":{\"command\":[\"echo\"],\"processHandle\":\"proc-1\",\"cwd\":\"/tmp/codex-hxrust\",\"size\":{\"rows\":24,\"cols\":80}}}}")));
        assertFalse(processSizeWithoutTty.ok, "process/spawn size is only valid with tty");
        assertEquals("terminal_size_without_tty", processSizeWithoutTty.errorCode);
        assertEquals("$.message.params.size", processSizeWithoutTty.errorPath);

        final invalidProcessResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-spawn-extra-response\",\"kind\":\"response\",\"method\":\"process/spawn\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-1\",\"result\":{\"ok\":true}}}")));
        assertFalse(invalidProcessResponse.ok, "process/spawn response must be empty");
        assertEquals("unexpected_field", invalidProcessResponse.errorCode);
        assertEquals("$.message.result.ok", invalidProcessResponse.errorPath);

        final missingProcessWriteHandle = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-write-missing-handle\",\"kind\":\"request\",\"method\":\"process/writeStdin\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-write-1\",\"method\":\"process/writeStdin\",\"params\":{\"deltaBase64\":\"AA==\"}}}")));
        assertFalse(missingProcessWriteHandle.ok, "process/writeStdin requires processHandle");
        assertEquals("missing_field", missingProcessWriteHandle.errorCode);
        assertEquals("$.message.params.processHandle", missingProcessWriteHandle.errorPath);

        final invalidProcessWriteClose = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-write-invalid-close\",\"kind\":\"request\",\"method\":\"process/writeStdin\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-write-1\",\"method\":\"process/writeStdin\",\"params\":{\"processHandle\":\"proc-1\",\"closeStdin\":\"yes\"}}}")));
        assertFalse(invalidProcessWriteClose.ok, "process/writeStdin closeStdin must be a boolean");
        assertEquals("expected_bool", invalidProcessWriteClose.errorCode);
        assertEquals("$.message.params.closeStdin", invalidProcessWriteClose.errorPath);

        final missingProcessKillHandle = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-kill-missing-handle\",\"kind\":\"request\",\"method\":\"process/kill\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-kill-1\",\"method\":\"process/kill\",\"params\":{}}}")));
        assertFalse(missingProcessKillHandle.ok, "process/kill requires processHandle");
        assertEquals("missing_field", missingProcessKillHandle.errorCode);
        assertEquals("$.message.params.processHandle", missingProcessKillHandle.errorPath);

        final invalidProcessResizeRows = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-resize-invalid-rows\",\"kind\":\"request\",\"method\":\"process/resizePty\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-resize-1\",\"method\":\"process/resizePty\",\"params\":{\"processHandle\":\"proc-1\",\"size\":{\"rows\":70000,\"cols\":80}}}}")));
        assertFalse(invalidProcessResizeRows.ok, "process/resizePty rows must fit uint16");
        assertEquals("expected_uint16", invalidProcessResizeRows.errorCode);
        assertEquals("$.message.params.size.rows", invalidProcessResizeRows.errorPath);

        final invalidProcessResizeResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"process-resize-extra-response\",\"kind\":\"response\",\"method\":\"process/resizePty\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"proc-resize-1\",\"result\":{\"ok\":true}}}")));
        assertFalse(invalidProcessResizeResponse.ok, "process/resizePty response must be empty");
        assertEquals("unexpected_field", invalidProcessResizeResponse.errorCode);
        assertEquals("$.message.result.ok", invalidProcessResizeResponse.errorPath);

        final invalidConfigReadIncludeLayers = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-read-invalid-include-layers\",\"kind\":\"request\",\"method\":\"config/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-read-1\",\"method\":\"config/read\",\"params\":{\"includeLayers\":\"yes\"}}}")));
        assertFalse(invalidConfigReadIncludeLayers.ok, "config/read includeLayers must be a boolean");
        assertEquals("expected_bool", invalidConfigReadIncludeLayers.errorCode);
        assertEquals("$.message.params.includeLayers", invalidConfigReadIncludeLayers.errorPath);

        final invalidConfigReadSandboxMode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-read-invalid-sandbox-mode\",\"kind\":\"response\",\"method\":\"config/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-read-1\",\"result\":{\"config\":{\"sandbox_mode\":\"root\"},\"origins\":{}}}}")));
        assertFalse(invalidConfigReadSandboxMode.ok, "config/read sandbox_mode must use upstream enum values");
        assertEquals("invalid_sandbox_mode", invalidConfigReadSandboxMode.errorCode);
        assertEquals("$.message.result.config.sandbox_mode", invalidConfigReadSandboxMode.errorPath);

        final invalidConfigReadOrigin = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-read-invalid-origin\",\"kind\":\"response\",\"method\":\"config/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-read-1\",\"result\":{\"config\":{},\"origins\":{\"model\":{\"name\":{\"type\":\"user\"},\"version\":\"1\"}}}}}")));
        assertFalse(invalidConfigReadOrigin.ok, "config/read user origins require file");
        assertEquals("missing_field", invalidConfigReadOrigin.errorCode);
        assertEquals("$.message.result.origins.model.name.file", invalidConfigReadOrigin.errorPath);

        final invalidConfigReadLayerConfig = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-read-invalid-layer-config\",\"kind\":\"response\",\"method\":\"config/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-read-1\",\"result\":{\"config\":{},\"origins\":{},\"layers\":[{\"name\":{\"type\":\"sessionFlags\"},\"version\":\"1\"}]}}}")));
        assertFalse(invalidConfigReadLayerConfig.ok, "config/read layers require raw config value");
        assertEquals("missing_field", invalidConfigReadLayerConfig.errorCode);
        assertEquals("$.message.result.layers[0].config", invalidConfigReadLayerConfig.errorPath);

        final invalidExternalAgentDetectCwd = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-detect-invalid-cwd\",\"kind\":\"request\",\"method\":\"externalAgentConfig/detect\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-detect-1\",\"method\":\"externalAgentConfig/detect\",\"params\":{\"cwds\":[7]}}}")));
        assertFalse(invalidExternalAgentDetectCwd.ok, "externalAgentConfig/detect cwds must be strings");
        assertEquals("expected_string", invalidExternalAgentDetectCwd.errorCode);
        assertEquals("$.message.params.cwds[0]", invalidExternalAgentDetectCwd.errorPath);

        final invalidExternalAgentDetectItemType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-detect-invalid-item-type\",\"kind\":\"response\",\"method\":\"externalAgentConfig/detect\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-detect-1\",\"result\":{\"items\":[{\"itemType\":\"UNKNOWN\",\"description\":\"bad\"}]}}}")));
        assertFalse(invalidExternalAgentDetectItemType.ok, "externalAgentConfig/detect itemType must use upstream enum values");
        assertEquals("invalid_external_agent_config_item_type", invalidExternalAgentDetectItemType.errorCode);
        assertEquals("$.message.result.items[0].itemType", invalidExternalAgentDetectItemType.errorPath);

        final invalidExternalAgentDetectPluginName = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-detect-invalid-plugin-name\",\"kind\":\"response\",\"method\":\"externalAgentConfig/detect\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-detect-1\",\"result\":{\"items\":[{\"itemType\":\"PLUGINS\",\"description\":\"bad\",\"details\":{\"plugins\":[{\"marketplaceName\":\"fixture\",\"pluginNames\":[1]}]}}]}}}")));
        assertFalse(invalidExternalAgentDetectPluginName.ok, "externalAgentConfig/detect pluginNames must be strings");
        assertEquals("expected_string", invalidExternalAgentDetectPluginName.errorCode);
        assertEquals("$.message.result.items[0].details.plugins[0].pluginNames[0]", invalidExternalAgentDetectPluginName.errorPath);

        final missingExternalAgentImportItems = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-import-missing-items\",\"kind\":\"request\",\"method\":\"externalAgentConfig/import\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-import-1\",\"method\":\"externalAgentConfig/import\",\"params\":{}}}")));
        assertFalse(missingExternalAgentImportItems.ok, "externalAgentConfig/import requires migrationItems");
        assertEquals("missing_field", missingExternalAgentImportItems.errorCode);
        assertEquals("$.message.params.migrationItems", missingExternalAgentImportItems.errorPath);

        final invalidExternalAgentImportItemType = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-import-invalid-item-type\",\"kind\":\"request\",\"method\":\"externalAgentConfig/import\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-import-1\",\"method\":\"externalAgentConfig/import\",\"params\":{\"migrationItems\":[{\"itemType\":\"UNKNOWN\",\"description\":\"bad\"}]}}}")));
        assertFalse(invalidExternalAgentImportItemType.ok, "externalAgentConfig/import reuses migration item type validation");
        assertEquals("invalid_external_agent_config_item_type", invalidExternalAgentImportItemType.errorCode);
        assertEquals("$.message.params.migrationItems[0].itemType", invalidExternalAgentImportItemType.errorPath);

        final invalidExternalAgentImportResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"external-agent-config-import-extra-response\",\"kind\":\"response\",\"method\":\"externalAgentConfig/import\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"external-import-1\",\"result\":{\"ok\":true}}}")));
        assertFalse(invalidExternalAgentImportResponse.ok, "externalAgentConfig/import response must be empty");
        assertEquals("unexpected_field", invalidExternalAgentImportResponse.errorCode);
        assertEquals("$.message.result.ok", invalidExternalAgentImportResponse.errorPath);

        final missingConfigValueWriteValue = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-value-write-missing-value\",\"kind\":\"request\",\"method\":\"config/value/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-write-1\",\"method\":\"config/value/write\",\"params\":{\"keyPath\":\"model\",\"mergeStrategy\":\"replace\"}}}")));
        assertFalse(missingConfigValueWriteValue.ok, "config/value/write requires arbitrary JSON value");
        assertEquals("missing_field", missingConfigValueWriteValue.errorCode);
        assertEquals("$.message.params.value", missingConfigValueWriteValue.errorPath);

        final invalidConfigValueWriteMerge = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-value-write-invalid-merge\",\"kind\":\"request\",\"method\":\"config/value/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-write-1\",\"method\":\"config/value/write\",\"params\":{\"keyPath\":\"model\",\"mergeStrategy\":\"merge\",\"value\":\"gpt-5\"}}}")));
        assertFalse(invalidConfigValueWriteMerge.ok, "config/value/write mergeStrategy must use upstream enum values");
        assertEquals("invalid_config_merge_strategy", invalidConfigValueWriteMerge.errorCode);
        assertEquals("$.message.params.mergeStrategy", invalidConfigValueWriteMerge.errorPath);

        final invalidConfigWriteStatus = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-value-write-invalid-status\",\"kind\":\"response\",\"method\":\"config/value/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-write-1\",\"result\":{\"status\":\"done\",\"version\":\"2\",\"filePath\":\"/tmp/config.toml\"}}}")));
        assertFalse(invalidConfigWriteStatus.ok, "config/value/write response status must use upstream enum values");
        assertEquals("invalid_config_write_status", invalidConfigWriteStatus.errorCode);
        assertEquals("$.message.result.status", invalidConfigWriteStatus.errorPath);

        final invalidConfigWriteOverridingLayer = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-value-write-invalid-overriding-layer\",\"kind\":\"response\",\"method\":\"config/value/write\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-write-1\",\"result\":{\"status\":\"okOverridden\",\"version\":\"2\",\"filePath\":\"/tmp/config.toml\",\"overriddenMetadata\":{\"message\":\"overridden\",\"overridingLayer\":{\"name\":{\"type\":\"project\"},\"version\":\"1\"},\"effectiveValue\":true}}}}")));
        assertFalse(invalidConfigWriteOverridingLayer.ok, "config/value/write overriddenMetadata validates layer metadata");
        assertEquals("missing_field", invalidConfigWriteOverridingLayer.errorCode);
        assertEquals("$.message.result.overriddenMetadata.overridingLayer.name.dotCodexFolder", invalidConfigWriteOverridingLayer.errorPath);

        final missingConfigBatchWriteEdits = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-batch-write-missing-edits\",\"kind\":\"request\",\"method\":\"config/batchWrite\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-batch-1\",\"method\":\"config/batchWrite\",\"params\":{}}}")));
        assertFalse(missingConfigBatchWriteEdits.ok, "config/batchWrite requires edits");
        assertEquals("missing_field", missingConfigBatchWriteEdits.errorCode);
        assertEquals("$.message.params.edits", missingConfigBatchWriteEdits.errorPath);

        final invalidConfigBatchWriteEditMerge = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-batch-write-invalid-merge\",\"kind\":\"request\",\"method\":\"config/batchWrite\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-batch-1\",\"method\":\"config/batchWrite\",\"params\":{\"edits\":[{\"keyPath\":\"model\",\"mergeStrategy\":\"merge\",\"value\":\"gpt-5\"}]}}}")));
        assertFalse(invalidConfigBatchWriteEditMerge.ok, "config/batchWrite edits validate mergeStrategy");
        assertEquals("invalid_config_merge_strategy", invalidConfigBatchWriteEditMerge.errorCode);
        assertEquals("$.message.params.edits[0].mergeStrategy", invalidConfigBatchWriteEditMerge.errorPath);

        final invalidConfigBatchWriteReload = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-batch-write-invalid-reload\",\"kind\":\"request\",\"method\":\"config/batchWrite\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-batch-1\",\"method\":\"config/batchWrite\",\"params\":{\"edits\":[],\"reloadUserConfig\":\"yes\"}}}")));
        assertFalse(invalidConfigBatchWriteReload.ok, "config/batchWrite reloadUserConfig must be a boolean");
        assertEquals("expected_bool", invalidConfigBatchWriteReload.errorCode);
        assertEquals("$.message.params.reloadUserConfig", invalidConfigBatchWriteReload.errorPath);

        final invalidConfigBatchWriteResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-batch-write-invalid-response\",\"kind\":\"response\",\"method\":\"config/batchWrite\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-batch-1\",\"result\":{\"status\":\"ok\",\"version\":\"3\"}}}")));
        assertFalse(invalidConfigBatchWriteResponse.ok, "config/batchWrite response requires filePath");
        assertEquals("missing_field", invalidConfigBatchWriteResponse.errorCode);
        assertEquals("$.message.result.filePath", invalidConfigBatchWriteResponse.errorPath);

        final invalidConfigRequirementsSandbox = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-requirements-invalid-sandbox\",\"kind\":\"response\",\"method\":\"configRequirements/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-req-1\",\"result\":{\"requirements\":{\"allowedSandboxModes\":[\"root\"]}}}}")));
        assertFalse(invalidConfigRequirementsSandbox.ok, "configRequirements/read validates sandbox mode enum values");
        assertEquals("invalid_sandbox_mode", invalidConfigRequirementsSandbox.errorCode);
        assertEquals("$.message.result.requirements.allowedSandboxModes[0]", invalidConfigRequirementsSandbox.errorPath);

        final invalidConfigRequirementsProfileMap = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-requirements-invalid-profile-map\",\"kind\":\"response\",\"method\":\"configRequirements/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-req-1\",\"result\":{\"requirements\":{\"allowedPermissionProfiles\":{\"default\":\"yes\"}}}}}")));
        assertFalse(invalidConfigRequirementsProfileMap.ok, "configRequirements/read allowedPermissionProfiles values must be boolean");
        assertEquals("expected_bool", invalidConfigRequirementsProfileMap.errorCode);
        assertEquals("$.message.result.requirements.allowedPermissionProfiles.default", invalidConfigRequirementsProfileMap.errorPath);

        final invalidConfigRequirementsComputerUse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-requirements-invalid-computer-use\",\"kind\":\"response\",\"method\":\"configRequirements/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-req-1\",\"result\":{\"requirements\":{\"computerUse\":{\"allowLockedComputerUse\":\"no\"}}}}}")));
        assertFalse(invalidConfigRequirementsComputerUse.ok, "configRequirements/read computerUse booleans may be bool/null only");
        assertEquals("expected_nullable_bool", invalidConfigRequirementsComputerUse.errorCode);
        assertEquals("$.message.result.requirements.computerUse.allowLockedComputerUse", invalidConfigRequirementsComputerUse.errorPath);

        final invalidConfigRequirementsParams = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"config-requirements-invalid-params\",\"kind\":\"request\",\"method\":\"configRequirements/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"config-req-1\",\"method\":\"configRequirements/read\",\"params\":7}}")));
        assertFalse(invalidConfigRequirementsParams.ok, "configRequirements/read params must be missing, null, or object");
        assertEquals("expected_nullable_object", invalidConfigRequirementsParams.errorCode);
        assertEquals("$.message.params", invalidConfigRequirementsParams.errorPath);

        final invalidServerCommandDecision = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-command-invalid-decision\",\"kind\":\"serverResponse\",\"method\":\"item/commandExecution/requestApproval\",\"message\":{\"id\":\"srv-approval-1\",\"method\":\"item/commandExecution/requestApproval\",\"response\":{\"decision\":\"later\"}}}")));
        assertFalse(invalidServerCommandDecision.ok, "command approval decision must use upstream variants");
        assertEquals("invalid_command_execution_approval_decision", invalidServerCommandDecision.errorCode);
        assertEquals("$.message.response.decision", invalidServerCommandDecision.errorPath);

        final invalidServerPermissionsScope = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-permissions-invalid-scope\",\"kind\":\"serverResponse\",\"method\":\"item/permissions/requestApproval\",\"message\":{\"id\":\"srv-permissions-1\",\"method\":\"item/permissions/requestApproval\",\"response\":{\"permissions\":{},\"scope\":\"forever\"}}}")));
        assertFalse(invalidServerPermissionsScope.ok, "permission grants are turn or session scoped");
        assertEquals("invalid_permission_grant_scope", invalidServerPermissionsScope.errorCode);
        assertEquals("$.message.response.scope", invalidServerPermissionsScope.errorPath);

        final invalidServerUserInputQuestion = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-user-input-invalid-options\",\"kind\":\"serverRequest\",\"method\":\"item/tool/requestUserInput\",\"message\":{\"id\":\"srv-user-input-1\",\"method\":\"item/tool/requestUserInput\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":\"turn-1\",\"itemId\":\"item-1\",\"questions\":[{\"id\":\"choice\",\"header\":\"Mode\",\"question\":\"Choose\",\"isOther\":false,\"isSecret\":false,\"options\":[{\"label\":\"Only\"}]}]}}}")));
        assertFalse(invalidServerUserInputQuestion.ok, "tool user input options require labels and descriptions");
        assertEquals("missing_field", invalidServerUserInputQuestion.errorCode);
        assertEquals("$.message.params.questions[0].options[0].description", invalidServerUserInputQuestion.errorPath);

        final invalidServerMcpMode = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-mcp-invalid-mode\",\"kind\":\"serverRequest\",\"method\":\"mcpServer/elicitation/request\",\"message\":{\"id\":\"srv-mcp-1\",\"method\":\"mcpServer/elicitation/request\",\"params\":{\"threadId\":\"thread-1\",\"turnId\":null,\"serverName\":\"apps\",\"mode\":\"modal\",\"_meta\":null,\"message\":\"Allow?\"}}}")));
        assertFalse(invalidServerMcpMode.ok, "MCP elicitation mode must be form or url");
        assertEquals("invalid_mcp_elicitation_mode", invalidServerMcpMode.errorCode);
        assertEquals("$.message.params.mode", invalidServerMcpMode.errorPath);

        final invalidServerDynamicOutput = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-dynamic-invalid-output\",\"kind\":\"serverResponse\",\"method\":\"item/tool/call\",\"message\":{\"id\":\"srv-dynamic-1\",\"method\":\"item/tool/call\",\"response\":{\"contentItems\":[{\"type\":\"audio\",\"text\":\"x\"}],\"success\":true}}}")));
        assertFalse(invalidServerDynamicOutput.ok, "dynamic tool outputs use upstream content item variants");
        assertEquals("invalid_dynamic_tool_output_type", invalidServerDynamicOutput.errorCode);
        assertEquals("$.message.response.contentItems[0].type", invalidServerDynamicOutput.errorPath);

        final invalidServerAuthRefreshReason = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-auth-refresh-invalid-reason\",\"kind\":\"serverRequest\",\"method\":\"account/chatgptAuthTokens/refresh\",\"message\":{\"id\":\"srv-auth-1\",\"method\":\"account/chatgptAuthTokens/refresh\",\"params\":{\"reason\":\"proactive\"}}}")));
        assertFalse(invalidServerAuthRefreshReason.ok, "ChatGPT auth token refresh currently uses unauthorized reason");
        assertEquals("invalid_chatgpt_auth_tokens_refresh_reason", invalidServerAuthRefreshReason.errorCode);
        assertEquals("$.message.params.reason", invalidServerAuthRefreshReason.errorPath);

        final invalidServerAttestationResponse = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"server-attestation-missing-token\",\"kind\":\"serverResponse\",\"method\":\"attestation/generate\",\"message\":{\"id\":\"srv-attestation-1\",\"method\":\"attestation/generate\",\"response\":{}}}")));
        assertFalse(invalidServerAttestationResponse.ok, "attestation response requires an opaque token");
        assertEquals("missing_field", invalidServerAttestationResponse.errorCode);
        assertEquals("$.message.response.token", invalidServerAttestationResponse.errorPath);

        final invalidFsChangedPath = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fs-changed-invalid-path\",\"kind\":\"notification\",\"method\":\"fs/changed\",\"message\":{\"jsonrpc\":\"2.0\",\"method\":\"fs/changed\",\"params\":{\"watchId\":\"watch-1\",\"changedPaths\":[7]}}}")));
        assertFalse(invalidFsChangedPath.ok, "changed paths must be strings");
        assertEquals("expected_string", invalidFsChangedPath.errorCode);
        assertEquals("$.message.params.changedPaths[0]", invalidFsChangedPath.errorPath);

        final invalidAppListLimit = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"app-list-invalid-limit\",\"kind\":\"request\",\"method\":\"app/list\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"app-list-1\",\"method\":\"app/list\",\"params\":{\"limit\":-1}}}")));
        assertFalse(invalidAppListLimit.ok, "app/list limit must be unsigned when present");
        assertEquals("expected_uint", invalidAppListLimit.errorCode);
        assertEquals("$.message.params.limit", invalidAppListLimit.errorPath);

        final invalidSkillsExtraRoot = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"skills-extra-root-invalid\",\"kind\":\"request\",\"method\":\"skills/extraRoots/set\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"skills-extra-1\",\"method\":\"skills/extraRoots/set\",\"params\":{\"extraRoots\":[7]}}}")));
        assertFalse(invalidSkillsExtraRoot.ok, "skills extra roots must be strings");
        assertEquals("expected_string", invalidSkillsExtraRoot.errorCode);
        assertEquals("$.message.params.extraRoots[0]", invalidSkillsExtraRoot.errorPath);

        final missingPluginName = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"plugin-read-missing-name\",\"kind\":\"request\",\"method\":\"plugin/read\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"plugin-read-1\",\"method\":\"plugin/read\",\"params\":{\"remoteMarketplaceName\":\"fixture\"}}}")));
        assertFalse(missingPluginName.ok, "plugin/read requires pluginName");
        assertEquals("missing_field", missingPluginName.errorCode);
        assertEquals("$.message.params.pluginName", missingPluginName.errorPath);

        final invalidFsMetadataFileFlag = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"fs-metadata-invalid-file\",\"kind\":\"response\",\"method\":\"fs/getMetadata\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"fs-meta-1\",\"result\":{\"isDirectory\":false,\"isFile\":\"yes\",\"isSymlink\":false,\"createdAtMs\":1,\"modifiedAtMs\":2}}}")));
        assertFalse(invalidFsMetadataFileFlag.ok, "fs/getMetadata file flags must be booleans");
        assertEquals("expected_bool", invalidFsMetadataFileFlag.errorCode);
        assertEquals("$.message.result.isFile", invalidFsMetadataFileFlag.errorPath);

        final invalidFeatureEnablement = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"feature-enable-invalid\",\"kind\":\"request\",\"method\":\"experimentalFeature/enablement/set\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"feature-1\",\"method\":\"experimentalFeature/enablement/set\",\"params\":{\"enablement\":{\"fixture\":\"yes\"}}}}")));
        assertFalse(invalidFeatureEnablement.ok, "feature enablement values must be booleans");
        assertEquals("expected_bool", invalidFeatureEnablement.errorCode);
        assertEquals("$.message.params.enablement.fixture", invalidFeatureEnablement.errorPath);

        final invalidMcpOauthTimeout = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-oauth-invalid-timeout\",\"kind\":\"request\",\"method\":\"mcpServer/oauth/login\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"mcp-oauth-1\",\"method\":\"mcpServer/oauth/login\",\"params\":{\"name\":\"github\",\"timeoutSecs\":-1}}}")));
        assertFalse(invalidMcpOauthTimeout.ok, "MCP OAuth timeout must be unsigned when present");
        assertEquals("expected_uint", invalidMcpOauthTimeout.errorCode);
        assertEquals("$.message.params.timeoutSecs", invalidMcpOauthTimeout.errorPath);

        final missingMcpToolServer = AppProtocol.parseFixtureItem(expectParse(CodexJson.parse("{\"id\":\"mcp-tool-missing-server\",\"kind\":\"request\",\"method\":\"mcpServer/tool/call\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"mcp-tool-1\",\"method\":\"mcpServer/tool/call\",\"params\":{\"threadId\":\"thread-1\",\"tool\":\"search\"}}}")));
        assertFalse(missingMcpToolServer.ok, "MCP tool calls require server");
        assertEquals("missing_field", missingMcpToolServer.errorCode);
        assertEquals("$.message.params.server", missingMcpToolServer.errorPath);
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
