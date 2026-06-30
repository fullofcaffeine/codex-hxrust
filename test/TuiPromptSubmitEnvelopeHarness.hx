import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineNativeOpener;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.FakeTuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.FakeTuiAppServerJsonRpcTransport;
import codexhx.runtime.tui.appserver.FakeTuiAppServerJsonRpcWireSession;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcTransportOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcTransportStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcTransportTranscript;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineAttachmentStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineCloseReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpointReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpointStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineNativeOpener;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenIntent;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenIntentKind;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenIntentReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenOutcomeStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTranscript;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttemptReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachment;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachmentReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportState;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcWireOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcWireSession;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessEnvVar;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessLaunchPlan;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerEventPump;
import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;
import codexhx.runtime.tui.appserver.TuiAppServerThreadStatus;
import codexhx.runtime.tui.appserver.TuiPromptAgentMessageCompletedNotification;
import codexhx.runtime.tui.appserver.TuiPromptAgentMessageDeltaNotification;
import codexhx.runtime.tui.appserver.TuiPromptAgentMessageStartedNotification;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcExchange;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcExchangeOutcome;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcCorrelationStatus;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrame;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrameCorrelation;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrameCodec;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrameDirection;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrameKind;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcFrameRecord;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcMethod;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcNotification;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcNotificationMethod;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcRequest;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcResponse;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcStreamScopeReport;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcStreamScopeStatus;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcStreamNotification;
import codexhx.runtime.tui.appserver.TuiPromptPendingRequestLifecycle;
import codexhx.runtime.tui.appserver.TuiPromptPendingRequestStatus;
import codexhx.runtime.tui.appserver.TuiPromptRawResponseItemCompletedNotification;
import codexhx.runtime.tui.appserver.TuiPromptSubmitEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptSubmitInteraction;
import codexhx.runtime.tui.appserver.TuiPromptThreadStatusChangedNotification;
import codexhx.runtime.tui.appserver.TuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiPromptTransportOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTurnLifecycleReport;
import codexhx.runtime.tui.appserver.TuiPromptTurnLifecycleStatus;
import codexhx.runtime.tui.appserver.TuiPromptTurnStartResponse;
import codexhx.runtime.tui.appserver.TuiPromptUserMessageCompletedNotification;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalInputEvent;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiPromptSubmitEnvelopeHarness {
	static function main():Void {
		testPromptSubmitEnvelopeEchoAndRedraw();
		testPromptSubmitBuildsJsonRpcTurnStartEnvelope();
		testFakeAppServerJsonRpcTransportOwnsTranscript();
		testFakeLineTransportEmitsInboundJsonLines();
		testFakeLineTransportTracksLifecycleAndRejectsAfterClose();
		testFakeLineTransportRejectsMismatchedOutboundLine();
		testFakeLineTransportRecordsOutboundOnlyPostWriteRejection();
		testLineEndpointPlansAreTyped();
		testLineEndpointOpenIntentsAreTyped();
		testLineNativeOpenOutcomesAreTyped();
		testLineTransportAttachesAfterOpen();
		testLineConnectorComposesEndpointOpenAndAttachment();
		testLineConnectorUsesInjectedNativeBoundaries();
		testLineConnectorPropagatesInjectedNativeOpenRefusal();
		testLineConnectorReturnsMissingInjectedAttachedTransport();
		testJsonRpcTransportCanUseLineConnector();
		testJsonRpcTransportUsesInjectedLineConnector();
		testJsonRpcLineConnectorTransportRejectsInvalidEndpoint();
		testJsonRpcLineConnectorTransportRejectsInjectedRefusal();
		testJsonRpcLineConnectorTransportRejectsMissingInjectedTransport();
		testJsonRpcLineConnectorTransportClosesAfterLineRejection();
		testFakeWireSessionSequencesInboundRecords();
		testFakeWireSessionRejectsMismatchedInboundLine();
		testFakeWireSessionRejectsMismatchedOutboundRecord();
		testFakeTransportWritesOutboundRecordThroughWireSession();
		testJsonRpcNotificationsProjectToTransportEvents();
		testJsonRpcExchangeRejectedSubmitIsTypedRefusal();
		testJsonRpcTransportDisconnectedSubmitIsTypedRefusal();
		testJsonRpcTransportMissingResponseIsTypedRefusal();
		testJsonRpcMismatchedResponseIsTypedRefusal();
		testJsonRpcWrongThreadStreamIsTypedRefusal();
		testJsonRpcWrongTurnStreamIsTypedRefusal();
		testJsonRpcMissingCompletedTurnLifecycleIsTypedRefusal();
		testJsonRpcMissingStartedTurnLifecycleIsTypedRefusal();
		testEmptySubmitIsTypedRefusal();
		testUnattachedSubmitIsTypedRefusal();
		testTransportRejectedSubmitIsTypedRefusal();
		testLiveBackendSubmitEchoDrawsShell();
		Sys.println("tui-prompt-submit-envelope ok");
	}

	static function testPromptSubmitEnvelopeEchoAndRedraw():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005555");
		final facade = attachedFacade(shell, activeThread);
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "headless setup");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		final textInput = pump.submitComposerInput(TerminalInputEvent.Text("hello"), RequestId.fromInteger(70), TuiAppServerPumpPolicy.lossless());
		assertFalse(textInput.hasSubmitResult(), "typing should not submit");
		assertStringEquals("hello", shell.composer().buffer(), "typed buffer");
		assertIntEquals(1, backend.drawCount(), "typing redraw count");

		final submit = pump.submitComposerInput(TerminalInputEvent.Submit, RequestId.fromInteger(71), TuiAppServerPumpPolicy.lossless());
		assertAcceptedSubmit(submit, "71", "hello", "accepted submit");
		assertIntEquals(3, submit.pumpOutcome().eventsDrained(), "echo event count");
		assertFalse(submit.pumpOutcome().backpressureApplied(), "submit should not backpressure");
		assertIntEquals(3, submit.pumpOutcome().drawRequests(), "app-server draw requests");
		assertIntEquals(1, submit.pumpOutcome().schedulerDrawFrameCount(), "coalesced submit draw");
		assertIntEquals(0, facade.queuedCount(), "echo queue drained");
		assertStringEquals("", shell.composer().buffer(), "composer cleared");
		assertStatusKindEquals(ChatWidgetStatusKind.Idle, shell.statusKind(), "ready status kind");
		assertStringEquals("ready", shell.statusText(), "ready status");
		assertIntEquals(3, shell.transcriptCount(), "submitted prompt plus assistant echo row count");
		assertStringEquals("user> hello", shell.transcriptAt(1).renderText(), "user row");
		assertStringEquals("assistant> echo: hello", shell.transcriptAt(2).renderText(), "echo row");
		assertStringEquals("Codex | model: gpt-live | status: ready", backend.currentFrame().lineAt(0), "drawn ready header");
		assertStringEquals("assistant> echo: hello", backend.currentFrame().lineAt(4), "drawn echo row");
		assertIntEquals(2, backend.drawCount(), "typing plus submit draw count");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testPromptSubmitBuildsJsonRpcTurnStartEnvelope():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005556");
		final transport = new JsonRpcTuiPromptTransport();
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(78), "json rpc ask");
		assertTrue(result.acceptedPrompt(), "json-rpc submit accepted");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Resolved, "78", 1, 0, "json-rpc accepted prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc accepted prompt leaves no pending request");

		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc request recorded");
		assertStringEquals("78", request.requestId.toString(), "json-rpc request id");
		assertStringEquals(TuiPromptJsonRpcMethod.TurnStart.text(), request.methodText(), "json-rpc method");
		assertStringEquals("{\"input\":[{\"text\":\"json rpc ask\",\"type\":\"text\"}],\"threadId\":\"00000000-0000-0000-0000-000000005556\"}",
			request.paramsJson(), "json-rpc params");
		assertStringEquals("{\"id\":78,\"jsonrpc\":\"2.0\",\"method\":\"turn/start\",\"params\":{\"input\":[{\"text\":\"json rpc ask\",\"type\":\"text\"}],\"threadId\":\"00000000-0000-0000-0000-000000005556\"}}",
			request.messageJson(), "json-rpc message");

		final parsed = expectJson(CodexJson.parse(request.fixtureJson("prompt-json-rpc")));
		final protocol = AppProtocol.parseFixtureItem(parsed);
		assertTrue(protocol.ok, "json-rpc request parses through app protocol: " + protocol.errorCode);
		assertStringEquals("request:turn/start", protocol.message.summary, "json-rpc protocol summary");

		final response = expectJsonRpcResponse(transport.lastResponse(), "json-rpc response recorded");
		assertStringEquals("78", response.requestId.toString(), "json-rpc response id");
		assertStringEquals(TuiPromptJsonRpcMethod.TurnStart.text(), response.methodText(), "json-rpc response method");
		assertStringEquals("{\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}", response.resultJson(),
			"json-rpc result");
		assertStringEquals("{\"id\":78,\"jsonrpc\":\"2.0\",\"result\":{\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}}",
			response.messageJson(), "json-rpc response message");
		final responseParsed = expectJson(CodexJson.parse(response.fixtureJson("prompt-json-rpc-response")));
		final responseProtocol = AppProtocol.parseFixtureItem(responseParsed);
		assertTrue(responseProtocol.ok, "json-rpc response parses through app protocol: " + responseProtocol.errorCode);
		assertStringEquals("turn", responseProtocol.message.summary, "json-rpc response summary");

		assertIntEquals(2, transport.lastNotificationCount(), "json-rpc notification count");
		final notification = expectJsonRpcNotification(transport.lastNotificationAt(0), "json-rpc turn-started notification recorded");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.TurnStarted.text(), notification.methodText(), "json-rpc notification method");
		assertStringEquals("{\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}",
			notification.paramsJson(), "json-rpc notification params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"turn/started\",\"params\":{\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"inProgress\"}}}",
			notification.messageJson(), "json-rpc notification message");
		final notificationParsed = expectJson(CodexJson.parse(notification.fixtureJson("prompt-json-rpc-turn-started")));
		final notificationProtocol = AppProtocol.parseFixtureItem(notificationParsed);
		assertTrue(notificationProtocol.ok, "json-rpc notification parses through app protocol: " + notificationProtocol.errorCode);
		assertStringEquals("turn", notificationProtocol.message.summary, "json-rpc notification summary");
		final completion = expectJsonRpcNotification(transport.lastNotificationAt(1), "json-rpc turn-completed notification recorded");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.TurnCompleted.text(), completion.methodText(), "json-rpc completion method");
		assertStringEquals("{\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"completed\"}}",
			completion.paramsJson(), "json-rpc completion params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turn\":{\"id\":\"turn-78\",\"items\":[],\"itemsView\":\"full\",\"status\":\"completed\"}}}",
			completion.messageJson(), "json-rpc completion message");
		final completionParsed = expectJson(CodexJson.parse(completion.fixtureJson("prompt-json-rpc-turn-completed")));
		final completionProtocol = AppProtocol.parseFixtureItem(completionParsed);
		assertTrue(completionProtocol.ok, "json-rpc completion parses through app protocol: " + completionProtocol.errorCode);
		assertStringEquals("turn", completionProtocol.message.summary, "json-rpc completion summary");
		assertIntEquals(9, transport.lastStreamNotificationCount(), "json-rpc stream notification count");
		final activeStatus = expectThreadStatusChangedStreamNotification(transport.lastStreamNotificationAt(0), "json-rpc stream active status");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text(), activeStatus.methodText(), "json-rpc active status method");
		assertStringEquals("{\"status\":{\"activeFlags\":[\"turnRunning\"],\"type\":\"active\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\"}",
			activeStatus.paramsJson(), "json-rpc active status params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"thread/status/changed\",\"params\":{\"status\":{\"activeFlags\":[\"turnRunning\"],\"type\":\"active\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\"}}",
			activeStatus.messageJson(), "json-rpc active status message");
		final activeStatusParsed = expectJson(CodexJson.parse(activeStatus.fixtureJson("prompt-json-rpc-thread-status-active")));
		final activeStatusProtocol = AppProtocol.parseFixtureItem(activeStatusParsed);
		assertTrue(activeStatusProtocol.ok, "json-rpc active status parses through app protocol: " + activeStatusProtocol.errorCode);
		assertStringEquals("status:active", activeStatusProtocol.message.summary, "json-rpc active status summary");
		assertTurnStreamNotification(expectStreamNotification(transport.lastStreamNotificationAt(1), "json-rpc stream started"), notification,
			"json-rpc stream started");
		final userCompleted = expectUserMessageCompletedStreamNotification(transport.lastStreamNotificationAt(2), "json-rpc stream user completed");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.ItemCompleted.text(), userCompleted.methodText(), "json-rpc user completed method");
		assertStringEquals("{\"completedAtMs\":500,\"item\":{\"content\":[{\"text\":\"json rpc ask\",\"type\":\"text\"}],\"id\":\"user-turn-78\",\"type\":\"userMessage\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}",
			userCompleted.paramsJson(), "json-rpc user completed params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"item/completed\",\"params\":{\"completedAtMs\":500,\"item\":{\"content\":[{\"text\":\"json rpc ask\",\"type\":\"text\"}],\"id\":\"user-turn-78\",\"type\":\"userMessage\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}}",
			userCompleted.messageJson(), "json-rpc user completed message");
		final userCompletedParsed = expectJson(CodexJson.parse(userCompleted.fixtureJson("prompt-json-rpc-user-message-completed")));
		final userCompletedProtocol = AppProtocol.parseFixtureItem(userCompletedParsed);
		assertTrue(userCompletedProtocol.ok, "json-rpc user completed parses through app protocol: " + userCompletedProtocol.errorCode);
		assertStringEquals("notification:item/completed", userCompletedProtocol.message.summary, "json-rpc user completed summary");
		final itemStarted = expectAgentMessageStartedStreamNotification(transport.lastStreamNotificationAt(3), "json-rpc stream item started");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.ItemStarted.text(), itemStarted.methodText(), "json-rpc item started method");
		assertStringEquals("{\"item\":{\"id\":\"item-78\",\"text\":\"echo: json rpc ask\",\"type\":\"agentMessage\"},\"startedAtMs\":1000,\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}",
			itemStarted.paramsJson(), "json-rpc item started params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"item/started\",\"params\":{\"item\":{\"id\":\"item-78\",\"text\":\"echo: json rpc ask\",\"type\":\"agentMessage\"},\"startedAtMs\":1000,\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}}",
			itemStarted.messageJson(), "json-rpc item started message");
		final itemStartedParsed = expectJson(CodexJson.parse(itemStarted.fixtureJson("prompt-json-rpc-agent-message-started")));
		final itemStartedProtocol = AppProtocol.parseFixtureItem(itemStartedParsed);
		assertTrue(itemStartedProtocol.ok, "json-rpc item started parses through app protocol: " + itemStartedProtocol.errorCode);
		assertStringEquals("notification:item/started", itemStartedProtocol.message.summary, "json-rpc item started summary");
		final delta = expectAgentMessageDeltaStreamNotification(transport.lastStreamNotificationAt(4), "json-rpc stream delta");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.AgentMessageDelta.text(), delta.methodText(), "json-rpc delta method");
		assertStringEquals("{\"delta\":\"echo: json rpc ask\",\"itemId\":\"item-78\",\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}",
			delta.paramsJson(), "json-rpc delta params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"item/agentMessage/delta\",\"params\":{\"delta\":\"echo: json rpc ask\",\"itemId\":\"item-78\",\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}}",
			delta.messageJson(), "json-rpc delta message");
		final deltaParsed = expectJson(CodexJson.parse(delta.fixtureJson("prompt-json-rpc-agent-message-delta")));
		final deltaProtocol = AppProtocol.parseFixtureItem(deltaParsed);
		assertTrue(deltaProtocol.ok, "json-rpc delta parses through app protocol: " + deltaProtocol.errorCode);
		assertStringEquals("notification:item/agentMessage/delta", deltaProtocol.message.summary, "json-rpc delta summary");
		final rawCompleted = expectRawResponseItemCompletedStreamNotification(transport.lastStreamNotificationAt(5),
			"json-rpc stream raw response item completed");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.RawResponseItemCompleted.text(), rawCompleted.methodText(), "json-rpc raw response item method");
		assertStringEquals("{\"item\":{\"content\":[{\"text\":\"echo: json rpc ask\",\"type\":\"output_text\"}],\"role\":\"assistant\",\"type\":\"message\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}",
			rawCompleted.paramsJson(), "json-rpc raw response item params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"rawResponseItem/completed\",\"params\":{\"item\":{\"content\":[{\"text\":\"echo: json rpc ask\",\"type\":\"output_text\"}],\"role\":\"assistant\",\"type\":\"message\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}}",
			rawCompleted.messageJson(), "json-rpc raw response item message");
		final rawCompletedParsed = expectJson(CodexJson.parse(rawCompleted.fixtureJson("prompt-json-rpc-raw-response-item-completed")));
		final rawCompletedProtocol = AppProtocol.parseFixtureItem(rawCompletedParsed);
		assertTrue(rawCompletedProtocol.ok, "json-rpc raw response item parses through app protocol: " + rawCompletedProtocol.errorCode);
		assertStringEquals("notification:rawResponseItem/completed", rawCompletedProtocol.message.summary, "json-rpc raw response item summary");
		final itemCompleted = expectAgentMessageCompletedStreamNotification(transport.lastStreamNotificationAt(6), "json-rpc stream item completed");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.ItemCompleted.text(), itemCompleted.methodText(), "json-rpc item completed method");
		assertStringEquals("{\"completedAtMs\":2000,\"item\":{\"id\":\"item-78\",\"text\":\"echo: json rpc ask\",\"type\":\"agentMessage\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}",
			itemCompleted.paramsJson(), "json-rpc item completed params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"item/completed\",\"params\":{\"completedAtMs\":2000,\"item\":{\"id\":\"item-78\",\"text\":\"echo: json rpc ask\",\"type\":\"agentMessage\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\",\"turnId\":\"turn-78\"}}",
			itemCompleted.messageJson(), "json-rpc item completed message");
		final itemCompletedParsed = expectJson(CodexJson.parse(itemCompleted.fixtureJson("prompt-json-rpc-agent-message-completed")));
		final itemCompletedProtocol = AppProtocol.parseFixtureItem(itemCompletedParsed);
		assertTrue(itemCompletedProtocol.ok, "json-rpc item completed parses through app protocol: " + itemCompletedProtocol.errorCode);
		assertStringEquals("notification:item/completed", itemCompletedProtocol.message.summary, "json-rpc item completed summary");
		assertTurnStreamNotification(expectStreamNotification(transport.lastStreamNotificationAt(7), "json-rpc stream completed"), completion,
			"json-rpc stream completed");
		final idleStatus = expectThreadStatusChangedStreamNotification(transport.lastStreamNotificationAt(8), "json-rpc stream idle status");
		assertStringEquals(TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text(), idleStatus.methodText(), "json-rpc idle status method");
		assertStringEquals("{\"status\":{\"type\":\"idle\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\"}", idleStatus.paramsJson(),
			"json-rpc idle status params");
		assertStringEquals("{\"jsonrpc\":\"2.0\",\"method\":\"thread/status/changed\",\"params\":{\"status\":{\"type\":\"idle\"},\"threadId\":\"00000000-0000-0000-0000-000000005556\"}}",
			idleStatus.messageJson(), "json-rpc idle status message");
		final idleStatusParsed = expectJson(CodexJson.parse(idleStatus.fixtureJson("prompt-json-rpc-thread-status-idle")));
		final idleStatusProtocol = AppProtocol.parseFixtureItem(idleStatusParsed);
		assertTrue(idleStatusProtocol.ok, "json-rpc idle status parses through app protocol: " + idleStatusProtocol.errorCode);
		assertStringEquals("status:idle", idleStatusProtocol.message.summary, "json-rpc idle status summary");
		assertIntEquals(11, transport.lastFrameCount(), "json-rpc ordered frame count");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc request frame");
		assertResponseFrame(transport.lastFrameAt(1), response, "json-rpc response frame");
		assertStreamFrame(transport.lastFrameAt(2), TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text(), activeStatus.messageJson(),
			"json-rpc active status frame");
		assertStreamFrame(transport.lastFrameAt(3), notification.methodText(), notification.messageJson(), "json-rpc turn started frame");
		assertStreamFrame(transport.lastFrameAt(4), userCompleted.methodText(), userCompleted.messageJson(), "json-rpc user completed frame");
		assertStreamFrame(transport.lastFrameAt(5), itemStarted.methodText(), itemStarted.messageJson(), "json-rpc item started frame");
		assertStreamFrame(transport.lastFrameAt(6), delta.methodText(), delta.messageJson(), "json-rpc delta frame");
		assertStreamFrame(transport.lastFrameAt(7), rawCompleted.methodText(), rawCompleted.messageJson(), "json-rpc raw response item frame");
		assertStreamFrame(transport.lastFrameAt(8), itemCompleted.methodText(), itemCompleted.messageJson(), "json-rpc item completed frame");
		assertStreamFrame(transport.lastFrameAt(9), completion.methodText(), completion.messageJson(), "json-rpc turn completed frame");
		assertStreamFrame(transport.lastFrameAt(10), TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text(), idleStatus.messageJson(),
			"json-rpc idle status frame");
		assertIntEquals(11, transport.lastWireRecordCount(), "json-rpc wire record count");
		assertWireRecord(transport.lastWireRecordAt(0), 0, TuiPromptJsonRpcFrameDirection.Outbound, TuiPromptJsonRpcFrameKind.Request, request.methodText(),
			request.messageJson(), "json-rpc request wire record");
		assertWireRecord(transport.lastWireRecordAt(1), 1, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Response, response.methodText(),
			response.messageJson(), "json-rpc response wire record");
		assertWireRecord(transport.lastWireRecordAt(2), 2, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Notification,
			activeStatus.methodText(), activeStatus.messageJson(), "json-rpc active status wire record");
		assertWireRecord(transport.lastWireRecordAt(10), 10, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Notification,
			idleStatus.methodText(), idleStatus.messageJson(), "json-rpc idle status wire record");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.Complete, "78", "78", 9, "json-rpc matched correlation");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Complete, "00000000-0000-0000-0000-000000005556", "turn-78",
			"00000000-0000-0000-0000-000000005556", "turn-78", 9, -1, "json-rpc matched stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.Complete, "turn-78", "turn-78", "turn-78", 9, 1, 1,
			"json-rpc matched turn lifecycle");
		final expectedWireLines = [
			request.messageJson(),
			response.messageJson(),
			activeStatus.messageJson(),
			notification.messageJson(),
			userCompleted.messageJson(),
			itemStarted.messageJson(),
			delta.messageJson(),
			rawCompleted.messageJson(),
			itemCompleted.messageJson(),
			completion.messageJson(),
			idleStatus.messageJson()
		].join("\n") + "\n";
		assertStringEquals(expectedWireLines, transport.lastWireJsonLines(), "json-rpc wire json lines");
		assertIntEquals(3, facade.queuedCount(), "json-rpc transport still queues fake echo events");
	}

	static function testJsonRpcNotificationsProjectToTransportEvents():Void {
		final transport = new JsonRpcTuiPromptTransport();
		final threadId = thread("00000000-0000-0000-0000-000000005558");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(80), session("00000000-0000-0000-0000-000000009998"), threadId, "projected ask");
		final outcome = transport.submitPrompt(envelope);
		assertTrue(outcome.isAccepted(), "projected transport accepted");
		assertIntEquals(2, transport.lastNotificationCount(), "projected notification count");
		assertIntEquals(3, outcome.eventCount(), "projected event count");
		assertThreadStatusEvent(expectAppServerEvent(outcome.eventAt(0), "projected start event"), threadId, TuiAppServerThreadStatus.Working("submitted"),
			"projected start status");
		assertAssistantDeltaEvent(expectAppServerEvent(outcome.eventAt(1), "projected assistant event"), threadId, "echo: projected ask",
			"projected assistant delta");
		assertThreadStatusEvent(expectAppServerEvent(outcome.eventAt(2), "projected completion event"), threadId, TuiAppServerThreadStatus.Ready("ready"),
			"projected completion status");
	}

	static function testFakeAppServerJsonRpcTransportOwnsTranscript():Void {
		final appServerTransport = new FakeTuiAppServerJsonRpcTransport();
		final threadId = thread("00000000-0000-0000-0000-000000005566");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(88), session("00000000-0000-0000-0000-000000009997"), threadId, "transcript ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = appServerTransport.sendPrompt(request, envelope);
		assertTrue(outcome.isAccepted(), "fake app-server transport accepted");
		assertStringEquals("accepted", outcome.code(), "fake app-server transport code");
		assertTransportTranscript(outcome.transcript(), request.messageJson(), 11, 10, "fake app-server transport transcript");
		assertResponseFrame(outcome.transcript().frameAt(1), expectJsonRpcResponse(outcome.response(), "fake app-server transport response"),
			"fake app-server transport response");
	}

	static function testFakeLineTransportEmitsInboundJsonLines():Void {
		final lineTransport = new FakeTuiAppServerJsonRpcLineTransport();
		final threadId = thread("00000000-0000-0000-0000-000000005570");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(93), session("00000000-0000-0000-0000-000000009993"), threadId, "line ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		assertTrue(lineTransport.isOpen(), "fake line transport starts open");
		assertStringEquals(TuiAppServerJsonRpcLineTransportState.Open.text(), lineTransport.stateText(), "fake line transport open state");
		final outcome = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertTrue(outcome.isAccepted(), "fake line transport accepted");
		assertStringEquals("accepted", outcome.statusText(), "fake line transport status");
		assertStringEquals("accepted", outcome.code(), "fake line transport code");
		assertIntEquals(10, outcome.inboundLineCount(), "fake line transport inbound line count");
		assertIntEquals(1, lineTransport.outboundLineCount(), "fake line transport outbound count");
		assertIntEquals(10, lineTransport.inboundLineCount(), "fake line transport inbound count");
		final response = expectJsonRpcResponse(outcome.response(), "fake line transport response");
		assertStringEquals(response.messageJson() + "\n", outcome.inboundLineAt(0), "fake line transport response line");
		assertLineTranscript(outcome.transcript(), request.messageJson() + "\n", 10, 11, "fake line transport transcript");
		assertStringEquals(response.messageJson() + "\n", outcome.transcript().lineAt(1), "fake line transport transcript response line");
		final idle = expectThreadStatusChangedStreamNotification(outcome.streamNotifications()[8], "fake line transport idle stream");
		assertStringEquals(idle.messageJson() + "\n", outcome.inboundLineAt(9), "fake line transport idle line");
		assertStringEquals(idle.messageJson() + "\n", outcome.transcript().inboundLineAt(9), "fake line transport transcript idle line");
	}

	static function testFakeLineTransportTracksLifecycleAndRejectsAfterClose():Void {
		final lineTransport = new FakeTuiAppServerJsonRpcLineTransport();
		final threadId = thread("00000000-0000-0000-0000-000000005573");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(96), session("00000000-0000-0000-0000-000000009990"), threadId,
			"line lifecycle ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final accepted = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertTrue(accepted.isAccepted(), "fake line transport lifecycle accepted");
		assertLineTranscript(accepted.transcript(), request.messageJson() + "\n", 10, 11, "fake line transport lifecycle transcript");
		final close = lineTransport.close("test_close");
		assertLineCloseReport(close, TuiAppServerJsonRpcLineTransportState.Closed, "test_close", 1, 10, "fake line transport close report");
		assertFalse(lineTransport.isOpen(), "fake line transport closed flag");
		assertStringEquals(TuiAppServerJsonRpcLineTransportState.Closed.text(), lineTransport.stateText(), "fake line transport closed state");
		final afterClose = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertFalse(afterClose.isAccepted(), "fake line transport rejects after close");
		assertStringEquals("disconnected", afterClose.statusText(), "fake line transport after close status");
		assertStringEquals("line_transport_closed", afterClose.code(), "fake line transport after close code");
		assertLineTranscript(afterClose.transcript(), "", 0, 0, "fake line transport after close transcript");
		assertIntEquals(1, lineTransport.outboundLineCount(), "fake line transport outbound count unchanged after close");
		assertIntEquals(10, lineTransport.inboundLineCount(), "fake line transport inbound count unchanged after close");
	}

	static function testFakeLineTransportRejectsMismatchedOutboundLine():Void {
		final lineTransport = new FakeTuiAppServerJsonRpcLineTransport();
		final threadId = thread("00000000-0000-0000-0000-000000005571");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(94), session("00000000-0000-0000-0000-000000009992"), threadId, "line mismatch ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = lineTransport.sendPromptLine(request, envelope, "{\"jsonrpc\":\"2.0\"}\n");
		assertFalse(outcome.isAccepted(), "fake line transport mismatched outbound rejected");
		assertStringEquals("rejected", outcome.statusText(), "fake line transport mismatched status");
		assertStringEquals("mismatched_outbound_line", outcome.code(), "fake line transport mismatched code");
		assertIntEquals(0, outcome.inboundLineCount(), "fake line transport mismatched inbound line count");
		assertLineTranscript(outcome.transcript(), "", 0, 0, "fake line transport mismatched transcript");
	}

	static function testFakeLineTransportRecordsOutboundOnlyPostWriteRejection():Void {
		final lineTransport = new FakeTuiAppServerJsonRpcLineTransport(new RejectingPromptJsonRpcExchange("exchange_offline"));
		final threadId = thread("00000000-0000-0000-0000-000000005574");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(97), session("00000000-0000-0000-0000-000000009989"), threadId, "line rejected ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = lineTransport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertFalse(outcome.isAccepted(), "fake line transport exchange rejection refused");
		assertStringEquals("exchange_offline", outcome.code(), "fake line transport exchange rejection code");
		assertLineTranscript(outcome.transcript(), request.messageJson() + "\n", 0, 1, "fake line transport exchange rejection transcript");
		assertIntEquals(1, lineTransport.outboundLineCount(), "fake line transport exchange rejection outbound count");
		assertIntEquals(0, lineTransport.inboundLineCount(), "fake line transport exchange rejection inbound count");
	}

	static function testLineEndpointPlansAreTyped():Void {
		final args = ["app-server", "--json-rpc"];
		final env = [
			new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home"),
			new TuiAppServerJsonRpcProcessEnvVar("RUST_LOG", "info")
		];
		final plan = TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex", args, "/workspace", env);
		args[0] = "mutated";
		env.push(new TuiAppServerJsonRpcProcessEnvVar("MUTATED", "yes"));
		final stdio = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.Stdio(plan));
		assertLineEndpoint(stdio, TuiAppServerJsonRpcLineEndpointStatus.StdioReady, "ready", true, "codex", 2, "/workspace", 2, "", 0, "stdio line endpoint");
		assertStringEquals("app-server", stdio.argAt(0), "stdio line endpoint first arg copy");
		assertStringEquals("--json-rpc", stdio.argAt(1), "stdio line endpoint second arg");
		assertEnvVar(stdio.envAt(0), "CODEX_HOME", "/tmp/codex-home", "stdio line endpoint first env");
		assertEnvVar(stdio.envAt(1), "RUST_LOG", "info", "stdio line endpoint second env");

		final socket = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 43817));
		assertLineEndpoint(socket, TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "ready", true, "", 0, "", 0, "127.0.0.1", 43817, "socket line endpoint");

		final missingCommand = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("",
			[], "", [])));
		assertLineEndpoint(missingCommand, TuiAppServerJsonRpcLineEndpointStatus.Invalid, "missing_command", false, "", 0, "", 0, "", 0,
			"missing command endpoint");

		final invalidEnv = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			[], "", [new TuiAppServerJsonRpcProcessEnvVar("", "value")])));
		assertLineEndpoint(invalidEnv, TuiAppServerJsonRpcLineEndpointStatus.Invalid, "invalid_env", false, "", 0, "", 0, "", 0, "invalid env endpoint");

		final invalidSocket = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 70000));
		assertLineEndpoint(invalidSocket, TuiAppServerJsonRpcLineEndpointStatus.Invalid, "invalid_socket_port", false, "", 0, "", 0, "", 0,
			"invalid socket endpoint");

		final unsupported = TuiAppServerJsonRpcLineEndpointReport.inspect(TuiAppServerJsonRpcLineEndpoint.Unsupported("named_pipe"));
		assertLineEndpoint(unsupported, TuiAppServerJsonRpcLineEndpointStatus.Unsupported, "named_pipe", false, "", 0, "", 0, "", 0,
			"unsupported line endpoint");
	}

	static function testLineEndpointOpenIntentsAreTyped():Void {
		final stdio = TuiAppServerJsonRpcLineOpenIntentReport.fromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")])));
		assertLineOpenIntent(stdio, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio, TuiAppServerJsonRpcLineEndpointStatus.StdioReady, "ready", true,
			"codex", "/workspace", "", 0, 2, 1, "stdio open intent");

		final socket = TuiAppServerJsonRpcLineOpenIntentReport.fromEndpoint(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 43817));
		assertLineOpenIntent(socket, TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp, TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "ready", true, "",
			"", "127.0.0.1", 43817, 0, 0, "socket open intent");

		final invalid = TuiAppServerJsonRpcLineOpenIntentReport.fromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("",
			[], "", [])));
		assertLineOpenIntent(invalid, TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineEndpointStatus.Invalid, "missing_command", false,
			"", "", "", 0, 0, 0, "invalid open intent");

		final unsupported = TuiAppServerJsonRpcLineOpenIntentReport.fromEndpoint(TuiAppServerJsonRpcLineEndpoint.Unsupported("named_pipe"));
		assertLineOpenIntent(unsupported, TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineEndpointStatus.Unsupported, "named_pipe",
			false, "", "", "", 0, 0, 0, "unsupported open intent");
	}

	static function testLineNativeOpenOutcomesAreTyped():Void {
		final opener = new DryRunTuiAppServerJsonRpcLineNativeOpener();
		final stdio = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")]))));
		assertLineOpenOutcome(stdio, TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, "opened", true, "stdio:codex", 1,
			TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio, TuiAppServerJsonRpcLineEndpointStatus.StdioReady, "stdio native open outcome");

		final socket = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 43817)));
		assertLineOpenOutcome(socket, TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, "opened", true, "tcp:127.0.0.1", 2,
			TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp, TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "socket native open outcome");

		final invalid = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("",
			[], "", []))));
		assertLineOpenOutcome(invalid, TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, "missing_command", false, "", 0,
			TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineEndpointStatus.Invalid, "invalid native open outcome");

		final unsupported = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Unsupported("named_pipe")));
		assertLineOpenOutcome(unsupported, TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, "named_pipe", false, "", 0,
			TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineEndpointStatus.Unsupported, "unsupported native open outcome");
		assertIntEquals(2, opener.openCount(), "dry-run native opener count");
	}

	static function testLineTransportAttachesAfterOpen():Void {
		final opener = new DryRunTuiAppServerJsonRpcLineNativeOpener();
		final attacher = new DryRunTuiAppServerJsonRpcLineTransportAttacher();
		final stdio = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")]))));
		final stdioAttachment = attacher.attach(stdio);
		assertLineTransportAttachment(TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(stdioAttachment),
			TuiAppServerJsonRpcLineAttachmentStatus.Ready, "opened", true, "stdio:codex", 1, true, 0, 0, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, "stdio line transport attachment");
		final transport = expectReadyLineTransport(attacher, stdioAttachment, "stdio line transport attachment");
		final threadId = thread("00000000-0000-0000-0000-000000005575");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(98), session("00000000-0000-0000-0000-000000009988"), threadId, "attached line ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = transport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertTrue(outcome.isAccepted(), "attached line transport accepted");
		assertIntEquals(1, transport.outboundLineCount(), "attached line transport outbound count");
		assertIntEquals(10, transport.inboundLineCount(), "attached line transport inbound count");

		final socket = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 43817)));
		assertLineTransportAttachment(TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attacher.attach(socket)),
			TuiAppServerJsonRpcLineAttachmentStatus.Ready, "opened", true, "tcp:127.0.0.1", 2, true, 0, 0, TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp,
			TuiAppServerJsonRpcLineEndpointStatus.SocketReady, "socket line transport attachment");

		final invalid = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("",
			[], "", []))));
		assertLineTransportAttachment(TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attacher.attach(invalid)),
			TuiAppServerJsonRpcLineAttachmentStatus.Refused, "missing_command", false, "", 0, false, 0, 0, TuiAppServerJsonRpcLineOpenIntentKind.Refuse,
			TuiAppServerJsonRpcLineEndpointStatus.Invalid, "invalid line transport attachment");

		final unsupported = opener.open(TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(TuiAppServerJsonRpcLineEndpoint.Unsupported("named_pipe")));
		assertLineTransportAttachment(TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attacher.attach(unsupported)),
			TuiAppServerJsonRpcLineAttachmentStatus.Refused, "named_pipe", false, "", 0, false, 0, 0, TuiAppServerJsonRpcLineOpenIntentKind.Refuse,
			TuiAppServerJsonRpcLineEndpointStatus.Unsupported, "unsupported line transport attachment");
	}

	static function testLineConnectorComposesEndpointOpenAndAttachment():Void {
		final connector = DryRunTuiAppServerJsonRpcLineConnector.dryRun();
		final stdio = connector.connect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")])));
		assertLineConnectReport(stdio, TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "stdio line connector");
		final transport = expectConnectorLineTransport(connector, stdio, "stdio line connector");
		final threadId = thread("00000000-0000-0000-0000-000000005576");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(99), session("00000000-0000-0000-0000-000000009987"), threadId,
			"connected line ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = transport.sendPromptLine(request, envelope, request.messageJson() + "\n");
		assertTrue(outcome.isAccepted(), "connector line transport accepted");
		assertIntEquals(1, transport.outboundLineCount(), "connector line transport outbound count");
		assertIntEquals(10, transport.inboundLineCount(), "connector line transport inbound count");

		final socket = connector.connect(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 43817));
		assertLineConnectReport(socket, TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "tcp:127.0.0.1", 2, true,
			TuiAppServerJsonRpcLineEndpointStatus.SocketReady, TuiAppServerJsonRpcLineOpenIntentKind.ConnectTcp,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "socket line connector");

		final invalid = connector.connect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("", [], "", [])));
		assertLineConnectReport(invalid, TuiAppServerJsonRpcLineConnectStatus.Refused, "missing_command", false, "", 0, false,
			TuiAppServerJsonRpcLineEndpointStatus.Invalid, TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused,
			TuiAppServerJsonRpcLineAttachmentStatus.Refused, "invalid line connector");

		final unsupported = connector.connect(TuiAppServerJsonRpcLineEndpoint.Unsupported("named_pipe"));
		assertLineConnectReport(unsupported, TuiAppServerJsonRpcLineConnectStatus.Refused, "named_pipe", false, "", 0, false,
			TuiAppServerJsonRpcLineEndpointStatus.Unsupported, TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused,
			TuiAppServerJsonRpcLineAttachmentStatus.Refused, "unsupported line connector");
	}

	static function testLineConnectorUsesInjectedNativeBoundaries():Void {
		final opener = RecordingLineNativeOpener.accepting();
		final attacher = RecordingLineTransportAttacher.accepting();
		final connector = new DryRunTuiAppServerJsonRpcLineConnector(opener, attacher);
		final report = connector.connect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])));
		final transport = expectConnectorLineTransport(connector, report, "injected line connector native boundaries");

		assertLineConnectReport(report, TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "injected line connector native boundaries");
		assertTrue(transport != null, "injected line connector materialized transport");
		assertIntEquals(1, opener.openCallCount(), "injected native opener call count");
		assertIntEquals(1, attacher.attachCallCount(), "injected attacher attach count");
		assertIntEquals(1, attacher.transportCallCount(), "injected attacher transport count");
	}

	static function testLineConnectorPropagatesInjectedNativeOpenRefusal():Void {
		final opener = RecordingLineNativeOpener.refusing("spawn_refused");
		final attacher = RecordingLineTransportAttacher.accepting();
		final connector = new DryRunTuiAppServerJsonRpcLineConnector(opener, attacher);
		final report = connector.connect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])));
		final transport = connector.transportFor(report);

		assertLineConnectReport(report, TuiAppServerJsonRpcLineConnectStatus.Refused, "spawn_refused", false, "", 0, false,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, TuiAppServerJsonRpcLineAttachmentStatus.Refused, "injected native opener refusal");
		assertTrue(transport == null, "injected native opener refusal transport missing");
		assertIntEquals(1, opener.openCallCount(), "injected native refusal opener call count");
		assertIntEquals(1, attacher.attachCallCount(), "injected native refusal attach count");
		assertIntEquals(0, attacher.transportCallCount(), "injected native refusal transport count");
	}

	static function testLineConnectorReturnsMissingInjectedAttachedTransport():Void {
		final opener = RecordingLineNativeOpener.accepting();
		final attacher = RecordingLineTransportAttacher.missingTransport();
		final connector = new DryRunTuiAppServerJsonRpcLineConnector(opener, attacher);
		final report = connector.connect(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])));
		final transport = connector.transportFor(report);

		assertLineConnectReport(report, TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "injected missing attached transport");
		assertTrue(transport == null, "injected missing attached transport missing");
		assertIntEquals(1, opener.openCallCount(), "injected missing transport opener call count");
		assertIntEquals(1, attacher.attachCallCount(), "injected missing transport attach count");
		assertIntEquals(1, attacher.transportCallCount(), "injected missing transport transport count");
	}

	static function testJsonRpcTransportCanUseLineConnector():Void {
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")]));
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005577");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(100), session("00000000-0000-0000-0000-000000009986"), threadId,
			"line connected ask");
		final outcome = transport.submitPrompt(envelope);
		assertTrue(outcome.isAccepted(), "line-connected json-rpc transport accepted");
		assertStringEquals("accepted", outcome.code(), "line-connected json-rpc transport code");
		assertIntEquals(3, outcome.eventCount(), "line-connected json-rpc event count");
		assertLineConnectReport(appServerTransport.lastConnectReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "line-connected transport report");
		final lineOutcome = appServerTransport.lastLineOutcome();
		assertTrue(lineOutcome != null && lineOutcome.isAccepted(), "line-connected transport line outcome accepted");
		assertIntEquals(10, lineOutcome.inboundLineCount(), "line-connected transport inbound line count");
		assertLineCloseReport(appServerTransport.lastCloseReport(), TuiAppServerJsonRpcLineTransportState.Closed, "line_connected_transport_done", 1, 10,
			"line-connected transport close report");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true,
			TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", TuiAppServerJsonRpcLineTransportState.Closed, "line_connected_transport_done", 1, 10,
			"line-connected transport attempt report");
		assertIntEquals(11, transport.lastFrameCount(), "line-connected json-rpc frame count");
		assertIntEquals(11, transport.lastWireRecordCount(), "line-connected json-rpc wire record count");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.Complete, "100", "100", 9, "line-connected json-rpc correlation");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.Complete, "turn-100", "turn-100", "turn-100", 9, 1, 1,
			"line-connected json-rpc turn lifecycle");
	}

	static function testJsonRpcTransportUsesInjectedLineConnector():Void {
		final connector = RecordingLineConnector.accepting();
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.withConnector(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])), "",
			connector);
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005580");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(103), session("00000000-0000-0000-0000-000000009983"), threadId,
			"injected line ask");
		final outcome = transport.submitPrompt(envelope);

		assertTrue(outcome.isAccepted(), "injected line connector accepted");
		assertIntEquals(1, connector.connectCallCount(), "injected line connector connect count");
		assertIntEquals(1, connector.transportCallCount(), "injected line connector transport count");
		assertLineConnectReport(appServerTransport.lastConnectReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "injected line connector report");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true,
			TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", TuiAppServerJsonRpcLineTransportState.Closed, "line_connected_transport_done", 1, 10,
			"injected line connector attempt report");
		assertIntEquals(11, transport.lastFrameCount(), "injected line connector frame count");
	}

	static function testJsonRpcLineConnectorTransportRejectsInvalidEndpoint():Void {
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("", [], "", []));
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005578");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(101), session("00000000-0000-0000-0000-000000009985"), threadId, "line invalid ask");
		final outcome = transport.submitPrompt(envelope);
		assertFalse(outcome.isAccepted(), "invalid line-connected transport refused");
		assertStringEquals("missing_command", outcome.code(), "invalid line-connected transport code");
		assertLineConnectReport(appServerTransport.lastConnectReport(), TuiAppServerJsonRpcLineConnectStatus.Refused, "missing_command", false, "", 0, false,
			TuiAppServerJsonRpcLineEndpointStatus.Invalid, TuiAppServerJsonRpcLineOpenIntentKind.Refuse, TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused,
			TuiAppServerJsonRpcLineAttachmentStatus.Refused, "invalid line-connected transport report");
		assertTrue(appServerTransport.lastLineOutcome() == null, "invalid line-connected transport no line send");
		assertTrue(appServerTransport.lastCloseReport() == null, "invalid line-connected transport no close");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Refused, "missing_command", false, null, "",
			null, "", 0, 0, "invalid line-connected transport attempt report");
		assertIntEquals(1, transport.lastFrameCount(), "invalid line-connected json-rpc frame count");
		assertIntEquals(1, transport.lastWireRecordCount(), "invalid line-connected json-rpc wire record count");
	}

	static function testJsonRpcLineConnectorTransportRejectsInjectedRefusal():Void {
		final connector = RecordingLineConnector.refusing("connector_offline");
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.withConnector(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])), "",
			connector);
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005581");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(104), session("00000000-0000-0000-0000-000000009982"), threadId,
			"injected refused ask");
		final outcome = transport.submitPrompt(envelope);
		final report = appServerTransport.lastConnectReport();

		assertFalse(outcome.isAccepted(), "injected refused connector rejected");
		assertStringEquals("connector_offline", outcome.code(), "injected refused connector code");
		assertIntEquals(1, connector.connectCallCount(), "injected refused connector connect count");
		assertIntEquals(0, connector.transportCallCount(), "injected refused connector transport count");
		assertTrue(report != null, "injected refused connector report");
		assertStringEquals(TuiAppServerJsonRpcLineConnectStatus.Refused.text(), report.statusText(), "injected refused connector report status");
		assertStringEquals("connector_offline", report.code, "injected refused connector report code");
		assertStringEquals(TuiAppServerJsonRpcLineEndpointStatus.StdioReady.text(), report.endpointStatusText(), "injected refused connector endpoint status");
		assertTrue(appServerTransport.lastLineOutcome() == null, "injected refused connector no line outcome");
		assertTrue(appServerTransport.lastCloseReport() == null, "injected refused connector no close");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Refused, "connector_offline", false, null, "",
			null, "", 0, 0, "injected refused connector attempt report");
		assertIntEquals(1, transport.lastWireRecordCount(), "injected refused connector wire count");
	}

	static function testJsonRpcLineConnectorTransportRejectsMissingInjectedTransport():Void {
		final connector = RecordingLineConnector.missingTransport();
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.withConnector(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [])), "",
			connector);
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005582");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(105), session("00000000-0000-0000-0000-000000009981"), threadId,
			"injected missing transport ask");
		final outcome = transport.submitPrompt(envelope);

		assertFalse(outcome.isAccepted(), "injected missing transport rejected");
		assertStringEquals("missing_line_transport", outcome.code(), "injected missing transport code");
		assertIntEquals(1, connector.connectCallCount(), "injected missing transport connect count");
		assertIntEquals(1, connector.transportCallCount(), "injected missing transport transport count");
		assertLineConnectReport(appServerTransport.lastConnectReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "injected missing transport report");
		assertTrue(appServerTransport.lastLineOutcome() == null, "injected missing transport no line outcome");
		assertTrue(appServerTransport.lastCloseReport() == null, "injected missing transport no close");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", false, null, "", null, "",
			0, 0, "injected missing transport attempt report");
		assertIntEquals(1, transport.lastWireRecordCount(), "injected missing transport wire count");
	}

	static function testJsonRpcLineConnectorTransportClosesAfterLineRejection():Void {
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.stdioWithRejection(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", [new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home")]),
			"exchange_offline");
		final transport = new JsonRpcTuiPromptTransport(appServerTransport);
		final threadId = thread("00000000-0000-0000-0000-000000005579");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(102), session("00000000-0000-0000-0000-000000009984"), threadId,
			"line rejected ask");
		final outcome = transport.submitPrompt(envelope);
		assertFalse(outcome.isAccepted(), "line-connected post-write rejection refused");
		assertStringEquals("exchange_offline", outcome.code(), "line-connected post-write rejection code");
		assertLineConnectReport(appServerTransport.lastConnectReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true, "stdio:codex", 1, true,
			TuiAppServerJsonRpcLineEndpointStatus.StdioReady, TuiAppServerJsonRpcLineOpenIntentKind.SpawnStdio,
			TuiAppServerJsonRpcLineOpenOutcomeStatus.Opened, TuiAppServerJsonRpcLineAttachmentStatus.Ready, "line-connected post-write rejection report");
		final lineOutcome = appServerTransport.lastLineOutcome();
		assertTrue(lineOutcome != null, "line-connected post-write rejection line outcome");
		assertFalse(lineOutcome.isAccepted(), "line-connected post-write rejection line refused");
		assertStringEquals("exchange_offline", lineOutcome.code(), "line-connected post-write rejection line code");
		assertLineTranscript(lineOutcome.transcript(), TuiPromptJsonRpcRequest.turnStart(envelope).messageJson() + "\n", 0, 1,
			"line-connected post-write rejection transcript");
		assertLineCloseReport(appServerTransport.lastCloseReport(), TuiAppServerJsonRpcLineTransportState.Closed, "line_connected_transport_done", 1, 0,
			"line-connected post-write rejection close report");
		assertLineTransportAttempt(appServerTransport.lastAttemptReport(), TuiAppServerJsonRpcLineConnectStatus.Ready, "connected", true,
			TuiAppServerJsonRpcTransportStatus.Rejected, "exchange_offline", TuiAppServerJsonRpcLineTransportState.Closed, "line_connected_transport_done", 1,
			0, "line-connected post-write rejection attempt report");
		assertIntEquals(1, transport.lastFrameCount(), "line-connected post-write rejection frame count");
		assertIntEquals(1, transport.lastWireRecordCount(), "line-connected post-write rejection wire record count");
	}

	static function testFakeWireSessionSequencesInboundRecords():Void {
		final wireSession = new FakeTuiAppServerJsonRpcWireSession();
		final threadId = thread("00000000-0000-0000-0000-000000005567");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(89), session("00000000-0000-0000-0000-000000009996"), threadId, "wire ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outbound = TuiPromptJsonRpcFrameCodec.record(0, TuiPromptJsonRpcFrame.Request(request));
		final outcome = wireSession.sendPrompt(request, envelope, outbound);
		assertTrue(outcome.isAccepted(), "fake wire session accepted");
		assertStringEquals("accepted", outcome.code(), "fake wire session code");
		assertStringEquals("accepted", outcome.statusText(), "fake wire session status");
		assertIntEquals(10, outcome.inboundRecordCount(), "fake wire session inbound record count");
		final response = expectJsonRpcResponse(outcome.response(), "fake wire session response");
		assertWireRecord(outcome.inboundRecordAt(0), 1, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Response, response.methodText(),
			response.messageJson(), "fake wire session response record");
		final idle = expectThreadStatusChangedStreamNotification(outcome.streamNotifications()[8], "fake wire session idle stream");
		assertWireRecord(outcome.inboundRecordAt(9), 10, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Notification, idle.methodText(),
			idle.messageJson(), "fake wire session idle record");
		assertResponseFrame(outcome.inboundFrames()[0], response, "fake wire session inbound response frame");
	}

	static function testFakeWireSessionRejectsMismatchedInboundLine():Void {
		final wireSession = new FakeTuiAppServerJsonRpcWireSession(null, new MismatchedInboundLineTransport(new FakeTuiAppServerJsonRpcLineTransport()));
		final threadId = thread("00000000-0000-0000-0000-000000005572");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(95), session("00000000-0000-0000-0000-000000009991"), threadId,
			"wire inbound mismatch ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outbound = TuiPromptJsonRpcFrameCodec.record(0, TuiPromptJsonRpcFrame.Request(request));
		final outcome = wireSession.sendPrompt(request, envelope, outbound);
		assertFalse(outcome.isAccepted(), "fake wire session inbound mismatch rejected");
		assertStringEquals("rejected", outcome.statusText(), "fake wire session inbound mismatch status");
		assertStringEquals("mismatched_inbound_line", outcome.code(), "fake wire session inbound mismatch code");
		assertIntEquals(10, outcome.inboundRecordCount(), "fake wire session inbound mismatch diagnostic records");
	}

	static function testFakeWireSessionRejectsMismatchedOutboundRecord():Void {
		final wireSession = new FakeTuiAppServerJsonRpcWireSession();
		final threadId = thread("00000000-0000-0000-0000-000000005568");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(90), session("00000000-0000-0000-0000-000000009995"), threadId, "wire mismatch ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final otherEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(91), envelope.sessionId, threadId, "other wire ask");
		final otherRequest = TuiPromptJsonRpcRequest.turnStart(otherEnvelope);
		final mismatchedOutbound = TuiPromptJsonRpcFrameCodec.record(0, TuiPromptJsonRpcFrame.Request(otherRequest));
		final outcome = wireSession.sendPrompt(request, envelope, mismatchedOutbound);
		assertFalse(outcome.isAccepted(), "fake wire session mismatched outbound rejected");
		assertStringEquals("rejected", outcome.statusText(), "fake wire session mismatched status");
		assertStringEquals("mismatched_outbound_request", outcome.code(), "fake wire session mismatched code");
		assertIntEquals(0, outcome.inboundRecordCount(), "fake wire session mismatched inbound record count");
	}

	static function testFakeTransportWritesOutboundRecordThroughWireSession():Void {
		final recordingWireSession = new RecordingWireSession(new FakeTuiAppServerJsonRpcWireSession());
		final appServerTransport = new FakeTuiAppServerJsonRpcTransport(null, recordingWireSession);
		final threadId = thread("00000000-0000-0000-0000-000000005569");
		final envelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(92), session("00000000-0000-0000-0000-000000009994"), threadId,
			"transport wire ask");
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = appServerTransport.sendPrompt(request, envelope);
		assertTrue(outcome.isAccepted(), "transport wire session accepted");
		assertIntEquals(1, recordingWireSession.callCount(), "transport wire session call count");
		assertWireRecord(recordingWireSession.lastOutboundRecord(), 0, TuiPromptJsonRpcFrameDirection.Outbound, TuiPromptJsonRpcFrameKind.Request,
			request.methodText(), request.messageJson(), "transport wire session outbound record");
		assertTransportTranscript(outcome.transcript(), request.messageJson(), 11, 10, "transport wire session transcript");
	}

	static function testJsonRpcExchangeRejectedSubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005557");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new RejectingPromptJsonRpcExchange("exchange_offline")));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(79), "json rpc blocked");
		assertFalse(result.acceptedPrompt(), "json-rpc exchange rejection refused");
		assertStringEquals("79", result.requestIdText(), "json-rpc exchange rejection request id");
		assertStringEquals("json rpc blocked", result.promptText(), "json-rpc exchange rejection prompt");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "79", 1, 0, "json-rpc rejected prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc rejected exchange leaves no pending request");

		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc rejected request recorded");
		assertStringEquals("79", request.requestId.toString(), "json-rpc rejected request id");
		if (transport.lastResponse() != null)
			throw "json-rpc rejected exchange should not record response";
		assertIntEquals(0, transport.lastNotificationCount(), "json-rpc rejected exchange should not record notifications");
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc rejected exchange should not record stream notifications");
		assertIntEquals(1, transport.lastFrameCount(), "json-rpc rejected exchange should record outbound frame only");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc rejected request frame");
		assertIntEquals(1, transport.lastWireRecordCount(), "json-rpc rejected exchange should record outbound wire record only");
		assertWireRecord(transport.lastWireRecordAt(0), 0, TuiPromptJsonRpcFrameDirection.Outbound, TuiPromptJsonRpcFrameKind.Request, request.methodText(),
			request.messageJson(), "json-rpc rejected request wire record");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.RequestOnly, "79", "", 0, "json-rpc rejected correlation");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Empty, "", "", "", "", 0, -1, "json-rpc rejected stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "", "", "", 0, 0, 0,
			"json-rpc rejected turn lifecycle");
		assertStringEquals(request.messageJson() + "\n", transport.lastWireJsonLines(), "json-rpc rejected wire json lines");
		assertIntEquals(0, facade.queuedCount(), "json-rpc exchange rejection queues no fake events");
	}

	static function testJsonRpcTransportDisconnectedSubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005564");
		final transport = new JsonRpcTuiPromptTransport(new DisconnectedAppServerJsonRpcTransport("socket_disconnected"));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(86), "json rpc disconnected");
		assertFalse(result.acceptedPrompt(), "json-rpc transport disconnect refused");
		assertStringEquals("86", result.requestIdText(), "json-rpc transport disconnect request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "86", 1, 0,
			"json-rpc transport disconnect prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc transport disconnect leaves no pending request");
		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc transport disconnect request recorded");
		if (transport.lastResponse() != null)
			throw "json-rpc transport disconnect should not record response";
		assertIntEquals(0, transport.lastNotificationCount(), "json-rpc transport disconnect should not record notifications");
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc transport disconnect should not record stream notifications");
		assertIntEquals(1, transport.lastFrameCount(), "json-rpc transport disconnect should record outbound frame only");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc transport disconnect request frame");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.RequestOnly, "86", "", 0, "json-rpc transport disconnect correlation");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Empty, "", "", "", "", 0, -1,
			"json-rpc transport disconnect stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "", "", "", 0, 0, 0,
			"json-rpc transport disconnect turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc transport disconnect queues no fake events");
	}

	static function testJsonRpcTransportMissingResponseIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005565");
		final transport = new JsonRpcTuiPromptTransport(new MissingResponseAppServerJsonRpcTransport());
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(87), "json rpc missing response");
		assertFalse(result.acceptedPrompt(), "json-rpc missing transport response refused");
		assertStringEquals("87", result.requestIdText(), "json-rpc missing transport response request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "87", 1, 0,
			"json-rpc missing transport response prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc missing transport response leaves no pending request");
		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc missing transport response request recorded");
		if (transport.lastResponse() != null)
			throw "json-rpc missing transport response should not record response";
		assertIntEquals(0, transport.lastNotificationCount(), "json-rpc missing transport response should not record notifications");
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc missing transport response should not record stream notifications");
		assertIntEquals(1, transport.lastFrameCount(), "json-rpc missing transport response should record outbound frame only");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc missing transport response request frame");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.RequestOnly, "87", "", 0,
			"json-rpc missing transport response correlation");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Empty, "", "", "", "", 0, -1,
			"json-rpc missing transport response stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "", "", "", 0, 0, 0,
			"json-rpc missing transport response turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc missing transport response queues no fake events");
	}

	static function testJsonRpcMismatchedResponseIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005559");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new MismatchedResponsePromptJsonRpcExchange()));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(81), "json rpc stale response");
		assertFalse(result.acceptedPrompt(), "json-rpc mismatched response refused");
		assertStringEquals("81", result.requestIdText(), "json-rpc mismatched response request id");
		assertStringEquals("json rpc stale response", result.promptText(), "json-rpc mismatched response prompt");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "81", 1, 0,
			"json-rpc mismatched response prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc mismatched response leaves no pending request");

		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc mismatched request recorded");
		if (transport.lastResponse() != null)
			throw "json-rpc mismatched response should not record accepted response";
		assertIntEquals(0, transport.lastNotificationCount(), "json-rpc mismatched response should not record notifications");
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc mismatched response should not record stream notifications");
		assertIntEquals(2, transport.lastFrameCount(), "json-rpc mismatched response should record request and response frames");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc mismatched request frame");
		assertStreamFrameIsAbsent(transport.lastFrameAt(2), "json-rpc mismatched response has no stream frame");
		assertIntEquals(2, transport.lastWireRecordCount(), "json-rpc mismatched response wire record count");
		assertWireRecord(transport.lastWireRecordAt(0), 0, TuiPromptJsonRpcFrameDirection.Outbound, TuiPromptJsonRpcFrameKind.Request, request.methodText(),
			request.messageJson(), "json-rpc mismatched request wire record");
		final responseFrame = expectResponseFrame(transport.lastFrameAt(1), "json-rpc mismatched response frame");
		assertStringEquals("9081", responseFrame.requestId.toString(), "json-rpc mismatched response id");
		assertWireRecord(transport.lastWireRecordAt(1), 1, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Response,
			responseFrame.methodText(), responseFrame.messageJson(), "json-rpc mismatched response wire record");
		assertCorrelation(transport.lastCorrelation(), TuiPromptJsonRpcCorrelationStatus.ResponseIdMismatch, "81", "9081", 0,
			"json-rpc mismatched response correlation");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Empty, "00000000-0000-0000-0000-000000005559", "turn-81", "", "", 0,
			-1, "json-rpc mismatched response stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "turn-81", "", "", 0, 0, 0,
			"json-rpc mismatched response turn lifecycle");
		assertStringEquals(request.messageJson() + "\n" + responseFrame.messageJson() + "\n", transport.lastWireJsonLines(),
			"json-rpc mismatched wire json lines");
		assertIntEquals(0, facade.queuedCount(), "json-rpc mismatched response queues no fake events");
	}

	static function testJsonRpcWrongThreadStreamIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005560");
		final wrongThread = thread("00000000-0000-0000-0000-000000009560");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new WrongThreadStreamPromptJsonRpcExchange(wrongThread)));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(82), "json rpc wrong thread");
		assertFalse(result.acceptedPrompt(), "json-rpc wrong-thread stream refused");
		assertStringEquals("82", result.requestIdText(), "json-rpc wrong-thread request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "82", 1, 0, "json-rpc wrong-thread prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc wrong-thread leaves no pending request");
		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc wrong-thread request recorded");
		if (transport.lastResponse() != null)
			throw "json-rpc wrong-thread stream should not record accepted response";
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc wrong-thread stream should not record accepted notifications");
		assertIntEquals(3, transport.lastFrameCount(), "json-rpc wrong-thread diagnostic frame count");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc wrong-thread request frame");
		final responseFrame = expectResponseFrame(transport.lastFrameAt(1), "json-rpc wrong-thread response frame");
		assertStringEquals("82", responseFrame.requestId.toString(), "json-rpc wrong-thread response id");
		final wrongStatus = expectThreadStatusChangedStreamNotification(expectStreamFrame(transport.lastFrameAt(2), "json-rpc wrong-thread stream frame"),
			"json-rpc wrong-thread diagnostic stream notification");
		assertStringEquals(wrongThread.toString(), wrongStatus.threadId.toString(), "json-rpc wrong-thread actual thread");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.ThreadMismatch, activeThread.toString(), "turn-82",
			wrongThread.toString(), "", 1, 0, "json-rpc wrong-thread stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "turn-82", "", "", 1, 0, 0,
			"json-rpc wrong-thread turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc wrong-thread queues no fake events");
	}

	static function testJsonRpcWrongTurnStreamIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005561");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new WrongTurnStreamPromptJsonRpcExchange()));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(83), "json rpc wrong turn");
		assertFalse(result.acceptedPrompt(), "json-rpc wrong-turn stream refused");
		assertStringEquals("83", result.requestIdText(), "json-rpc wrong-turn request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "83", 1, 0, "json-rpc wrong-turn prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc wrong-turn leaves no pending request");
		final request = expectJsonRpcRequest(transport.lastRequest(), "json-rpc wrong-turn request recorded");
		if (transport.lastResponse() != null)
			throw "json-rpc wrong-turn stream should not record accepted response";
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc wrong-turn stream should not record accepted notifications");
		assertIntEquals(3, transport.lastFrameCount(), "json-rpc wrong-turn diagnostic frame count");
		assertRequestFrame(transport.lastFrameAt(0), request, "json-rpc wrong-turn request frame");
		final wrongDelta = expectAgentMessageDeltaStreamNotification(expectStreamFrame(transport.lastFrameAt(2), "json-rpc wrong-turn stream frame"),
			"json-rpc wrong-turn diagnostic stream notification");
		assertStringEquals("turn-stale-83", wrongDelta.turnId.toString(), "json-rpc wrong-turn actual turn");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.TurnMismatch, activeThread.toString(), "turn-83",
			activeThread.toString(), "turn-stale-83", 1, 0, "json-rpc wrong-turn stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStartedAndCompleted, "turn-83", "", "", 1, 0, 0,
			"json-rpc wrong-turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc wrong-turn queues no fake events");
	}

	static function testJsonRpcMissingCompletedTurnLifecycleIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005562");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new IncompleteTurnLifecyclePromptJsonRpcExchange(true, false)));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(84), "json rpc missing completed");
		assertFalse(result.acceptedPrompt(), "json-rpc missing-completed lifecycle refused");
		assertStringEquals("84", result.requestIdText(), "json-rpc missing-completed request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "84", 1, 0, "json-rpc missing-completed prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc missing-completed leaves no pending request");
		if (transport.lastResponse() != null)
			throw "json-rpc missing-completed should not record accepted response";
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc missing-completed should not record accepted stream notifications");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Complete, activeThread.toString(), "turn-84",
			activeThread.toString(), "turn-84", 3, -1, "json-rpc missing-completed stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingCompleted, "turn-84", "turn-84", "", 3, 1, 0,
			"json-rpc missing-completed turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc missing-completed queues no fake events");
	}

	static function testJsonRpcMissingStartedTurnLifecycleIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005563");
		final transport = new JsonRpcTuiPromptTransport(new FakeTuiAppServerJsonRpcTransport(new IncompleteTurnLifecyclePromptJsonRpcExchange(false, true)));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(85), "json rpc missing started");
		assertFalse(result.acceptedPrompt(), "json-rpc missing-started lifecycle refused");
		assertStringEquals("85", result.requestIdText(), "json-rpc missing-started request id");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "85", 1, 0, "json-rpc missing-started prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "json-rpc missing-started leaves no pending request");
		if (transport.lastResponse() != null)
			throw "json-rpc missing-started should not record accepted response";
		assertIntEquals(0, transport.lastStreamNotificationCount(), "json-rpc missing-started should not record accepted stream notifications");
		assertStreamScope(transport.lastStreamScope(), TuiPromptJsonRpcStreamScopeStatus.Complete, activeThread.toString(), "turn-85",
			activeThread.toString(), "turn-85", 3, -1, "json-rpc missing-started stream scope");
		assertTurnLifecycle(transport.lastTurnLifecycle(), TuiPromptTurnLifecycleStatus.MissingStarted, "turn-85", "", "turn-85", 3, 0, 1,
			"json-rpc missing-started turn lifecycle");
		assertIntEquals(0, facade.queuedCount(), "json-rpc missing-started queues no fake events");
	}

	static function testEmptySubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000006666");
		final facade = attachedFacade(shell, activeThread);
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "empty setup");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		final submit = pump.submitComposerInput(TerminalInputEvent.Submit, RequestId.fromInteger(72), TuiAppServerPumpPolicy.lossless());
		assertFalse(submit.submitAccepted(), "empty submit refused");
		assertStringEquals("empty-prompt", submit.submitStatusText(), "empty status");
		assertIntEquals(0, submit.promptSubmittedCount(), "empty prompt should not emit shell submit");
		assertIntEquals(1, submit.shellDrawRequestCount(), "empty submit still redraws composer");
		assertIntEquals(0, submit.pumpOutcome().eventsDrained(), "empty submit queues no echo");
		assertIntEquals(0, facade.queuedCount(), "empty queue");
		assertIntEquals(1, backend.drawCount(), "empty submit redraw count");
		assertIntEquals(1, shell.transcriptCount(), "empty submit does not append user row");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testUnattachedSubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final facade = new FakeTuiAppServerFacade(shell);
		final result = facade.submitPrompt(RequestId.fromInteger(73), "orphan prompt");
		assertFalse(result.acceptedPrompt(), "unattached submit refused");
		assertStringEquals("missing-session", statusText(result.status()), "unattached status");
		assertIntEquals(0, result.effectCount(), "unattached effects");
		assertIntEquals(0, facade.queuedCount(), "unattached queue");
	}

	static function testTransportRejectedSubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000006777");
		final facade = attachedFacadeWithTransport(shell, activeThread, new RejectingPromptTransport("offline"));
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "reject setup");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		pump.submitComposerInput(TerminalInputEvent.Text("blocked"), RequestId.fromInteger(76), TuiAppServerPumpPolicy.lossless());
		final submit = pump.submitComposerInput(TerminalInputEvent.Submit, RequestId.fromInteger(77), TuiAppServerPumpPolicy.lossless());

		assertFalse(submit.submitAccepted(), "transport rejection refused");
		assertStringEquals("transport-rejected", submit.submitStatusText(), "transport status");
		assertStringEquals("77", submit.submitRequestIdText(), "transport request id preserved");
		assertStringEquals("blocked", submit.submitPromptText(), "transport prompt preserved");
		assertIntEquals(1, submit.registeredPromptRequestCount(), "transport registered prompt");
		assertIntEquals(0, submit.pumpOutcome().eventsDrained(), "transport rejection queues no fake events");
		assertIntEquals(0, facade.queuedCount(), "transport queue empty");
		assertPromptLifecycle(facade.lastPromptLifecycle(), TuiPromptPendingRequestStatus.Rejected, "77", 1, 0, "transport rejection prompt lifecycle");
		assertIntEquals(0, facade.pendingCount(), "transport rejection leaves no pending request");
		assertStringEquals("user> blocked", shell.transcriptAt(1).renderText(), "user row still records submitted prompt");
		assertStringEquals("Codex | model: gpt-live | status: session started", backend.currentFrame().lineAt(0), "status unchanged after rejection");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testLiveBackendSubmitEchoDrawsShell():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000007777");
		final facade = attachedFacade(shell, activeThread);
		final backend = new LiveTerminalBackend();
		assertTrue(backend.setup(TerminalSetup.live(TerminalSize.of(80, 12))).ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(backend.lastReport().status, "live setup status");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		pump.submitComposerInput(TerminalInputEvent.Text("live ask"), RequestId.fromInteger(74), TuiAppServerPumpPolicy.lossless());
		final submit = pump.submitComposerInput(TerminalInputEvent.Submit, RequestId.fromInteger(75), TuiAppServerPumpPolicy.lossless());
		assertAcceptedSubmit(submit, "75", "live ask", "live submit");
		assertStatusAccepted(backend.lastReport().status, "live draw status");
		assertStringEquals("Codex | model: gpt-live | status: ready", backend.currentFrame().lineAt(0), "live ready header");
		assertStringEquals("assistant> echo: live ask", backend.currentFrame().lineAt(4), "live echo row");
		assertTrue(backend.restore(TerminalRestoreReason.NormalExit).restored, "live restore");
	}

	static function attachedFacade(shell:ChatWidgetShellState, activeThread:ThreadId):FakeTuiAppServerFacade {
		return attachedFacadeWithTransport(shell, activeThread, null);
	}

	static function attachedFacadeWithTransport(shell:ChatWidgetShellState, activeThread:ThreadId, transport:Null<TuiPromptTransport>):FakeTuiAppServerFacade {
		final facade = new FakeTuiAppServerFacade(shell, transport);
		final request = RequestId.fromInteger(10);
		facade.startSessionAttach(request, session("00000000-0000-0000-0000-000000009999"), activeThread, "gpt-live");
		facade.completeSessionAttach(request);
		return facade;
	}

	static function session(value:String):SessionId {
		return SessionId.unsafeAssumeValid(value);
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function assertAcceptedSubmit(submit:TuiPromptSubmitInteraction, requestId:String, prompt:String, label:String):Void {
		assertTrue(submit.hasSubmitResult(), label + " has result");
		assertTrue(submit.submitAccepted(), label + " accepted");
		assertStringEquals("accepted", submit.submitStatusText(), label + " status");
		assertStringEquals(requestId, submit.submitRequestIdText(), label + " request id");
		assertStringEquals(prompt, submit.submitPromptText(), label + " prompt");
		assertIntEquals(1, submit.promptSubmittedCount(), label + " shell submitted");
		assertIntEquals(1, submit.shellDrawRequestCount(), label + " shell redraw");
		assertIntEquals(1, submit.registeredPromptRequestCount(), label + " registered prompt request");
	}

	static function assertStatusAccepted(status:LiveTerminalProbeStatus, label:String):Void {
		if (!status.okForCi())
			throw label + ": " + status.text();
	}

	static function statusText(status:codexhx.runtime.tui.appserver.TuiPromptSubmitStatus):String {
		return switch status {
			case Accepted:
				"accepted";
			case EmptyPrompt:
				"empty-prompt";
			case MissingSession:
				"missing-session";
			case MissingThread:
				"missing-thread";
			case TransportRejected:
				"transport-rejected";
		}
	}

	static function assertStatusKindEquals(expected:ChatWidgetStatusKind, actual:ChatWidgetStatusKind, label:String):Void {
		assertStringEquals(ChatWidgetShellState.statusKindText(expected), ChatWidgetShellState.statusKindText(actual), label);
	}

	static function expectJsonRpcRequest(request:Null<TuiPromptJsonRpcRequest>, label:String):TuiPromptJsonRpcRequest {
		if (request == null)
			throw label;
		return request;
	}

	static function expectJsonRpcResponse(response:Null<TuiPromptJsonRpcResponse>, label:String):TuiPromptJsonRpcResponse {
		if (response == null)
			throw label;
		return response;
	}

	static function expectJsonRpcNotification(notification:Null<TuiPromptJsonRpcNotification>, label:String):TuiPromptJsonRpcNotification {
		if (notification == null)
			throw label;
		return notification;
	}

	static function expectStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>, label:String):TuiPromptJsonRpcStreamNotification {
		if (notification == null)
			throw label;
		return notification;
	}

	static function assertRequestFrame(frame:Null<TuiPromptJsonRpcFrame>, expected:TuiPromptJsonRpcRequest, label:String):Void {
		final concrete = expectFrame(frame, label);
		switch concrete {
			case TuiPromptJsonRpcFrame.Request(actual):
				assertStringEquals(expected.methodText(), actual.methodText(), label + " method");
				assertStringEquals(expected.messageJson(), actual.messageJson(), label + " message");
			case _:
				throw label + ": expected request frame";
		}
	}

	static function assertResponseFrame(frame:Null<TuiPromptJsonRpcFrame>, expected:TuiPromptJsonRpcResponse, label:String):Void {
		final concrete = expectFrame(frame, label);
		switch concrete {
			case TuiPromptJsonRpcFrame.Response(actual):
				assertStringEquals(expected.methodText(), actual.methodText(), label + " method");
				assertStringEquals(expected.messageJson(), actual.messageJson(), label + " message");
			case _:
				throw label + ": expected response frame";
		}
	}

	static function assertTransportTranscript(transcript:TuiAppServerJsonRpcTransportTranscript, expectedRequestJson:String, expectedFrameCount:Int,
			expectedInboundFrameCount:Int, label:String):Void {
		if (transcript == null)
			throw label + ": missing transcript";
		final request = expectJsonRpcRequest(transcript.request(), label + " request");
		assertStringEquals(expectedRequestJson, request.messageJson(), label + " request json");
		assertIntEquals(expectedFrameCount, transcript.frameCount(), label + " frame count");
		assertIntEquals(expectedInboundFrameCount, transcript.inboundFrameCount(), label + " inbound frame count");
		assertRequestFrame(transcript.frameAt(0), request, label + " request frame");
	}

	static function assertLineCloseReport(report:TuiAppServerJsonRpcLineCloseReport, expectedState:TuiAppServerJsonRpcLineTransportState, expectedCode:String,
			expectedOutboundLineCount:Int, expectedInboundLineCount:Int, label:String):Void {
		if (report == null)
			throw label + ": missing close report";
		assertStringEquals(expectedState.text(), report.stateText(), label + " state");
		assertStringEquals(expectedCode, report.code, label + " code");
		assertIntEquals(expectedOutboundLineCount, report.outboundLineCount, label + " outbound count");
		assertIntEquals(expectedInboundLineCount, report.inboundLineCount, label + " inbound count");
	}

	static function assertLineTransportAttempt(report:TuiAppServerJsonRpcLineTransportAttemptReport,
			expectedConnectStatus:TuiAppServerJsonRpcLineConnectStatus, expectedConnectCode:String, expectedMaterialized:Bool,
			expectedLineStatus:Null<TuiAppServerJsonRpcTransportStatus>, expectedLineCode:String,
			expectedCloseState:Null<TuiAppServerJsonRpcLineTransportState>, expectedCloseCode:String, expectedOutboundLineCount:Int,
			expectedInboundLineCount:Int, label:String):Void {
		if (report == null)
			throw label + ": missing attempt report";
		assertStringEquals(expectedConnectStatus.text(), report.connectStatusText(), label + " connect status");
		assertStringEquals(expectedConnectCode, report.connectCode(), label + " connect code");
		if (expectedMaterialized)
			assertTrue(report.transportMaterialized, label + " materialized");
		else
			assertFalse(report.transportMaterialized, label + " not materialized");
		assertStringEquals(expectedLineStatus == null ? "false" : "true", report.hasLineOutcome() ? "true" : "false", label + " line recorded");
		assertStringEquals(expectedLineStatus == null ? "" : expectedLineStatus.text(), report.lineStatusText(), label + " line status");
		assertStringEquals(expectedLineCode, report.lineCode(), label + " line code");
		assertStringEquals(expectedCloseState == null ? "false" : "true", report.hasCloseReport() ? "true" : "false", label + " close recorded");
		assertStringEquals(expectedCloseState == null ? "" : expectedCloseState.text(), report.closeStateText(), label + " close state");
		assertStringEquals(expectedCloseCode, report.closeCode(), label + " close code");
		assertIntEquals(expectedOutboundLineCount, report.outboundLineCount(), label + " outbound count");
		assertIntEquals(expectedInboundLineCount, report.inboundLineCount(), label + " inbound count");
	}

	static function assertLineTranscript(transcript:TuiAppServerJsonRpcLineTranscript, expectedOutboundLine:String, expectedInboundLineCount:Int,
			expectedTotalLineCount:Int, label:String):Void {
		if (transcript == null)
			throw label + ": missing transcript";
		assertStringEquals(expectedOutboundLine.length > 0 ? "true" : "false", transcript.hasOutboundLine() ? "true" : "false", label + " outbound flag");
		assertStringEquals(expectedOutboundLine, transcript.outboundLine(), label + " outbound line");
		assertIntEquals(expectedInboundLineCount, transcript.inboundLineCount(), label + " inbound count");
		assertIntEquals(expectedTotalLineCount, transcript.totalLineCount(), label + " total count");
		if (expectedOutboundLine.length > 0)
			assertStringEquals(expectedOutboundLine, transcript.lineAt(0), label + " first line");
	}

	static function assertLineEndpoint(report:TuiAppServerJsonRpcLineEndpointReport, expectedStatus:TuiAppServerJsonRpcLineEndpointStatus,
			expectedCode:String, expectedReady:Bool, expectedCommand:String, expectedArgCount:Int, expectedCwd:String, expectedEnvCount:Int,
			expectedHost:String, expectedPort:Int, label:String):Void {
		if (report == null)
			throw label + ": missing report";
		assertStringEquals(expectedStatus.text(), report.statusText(), label + " status");
		assertStringEquals(expectedCode, report.code, label + " code");
		if (expectedReady)
			assertTrue(report.isReady(), label + " ready");
		else
			assertFalse(report.isReady(), label + " not ready");
		assertStringEquals(expectedCommand, report.command(), label + " command");
		assertIntEquals(expectedArgCount, report.argCount(), label + " arg count");
		assertStringEquals(expectedCwd, report.cwd(), label + " cwd");
		assertIntEquals(expectedEnvCount, report.envCount(), label + " env count");
		assertStringEquals(expectedHost, report.host, label + " host");
		assertIntEquals(expectedPort, report.port, label + " port");
	}

	static function assertEnvVar(env:Null<TuiAppServerJsonRpcProcessEnvVar>, expectedName:String, expectedValue:String, label:String):Void {
		if (env == null)
			throw label + ": missing env";
		assertStringEquals(expectedName, env.name, label + " name");
		assertStringEquals(expectedValue, env.value, label + " value");
	}

	static function assertLineOpenIntent(report:TuiAppServerJsonRpcLineOpenIntentReport, expectedKind:TuiAppServerJsonRpcLineOpenIntentKind,
			expectedEndpointStatus:TuiAppServerJsonRpcLineEndpointStatus, expectedCode:String, expectedActionable:Bool, expectedCommand:String,
			expectedCwd:String, expectedHost:String, expectedPort:Int, expectedArgCount:Int, expectedEnvCount:Int, label:String):Void {
		if (report == null)
			throw label + ": missing report";
		assertStringEquals(expectedKind.text(), report.kindText(), label + " kind");
		assertStringEquals(expectedEndpointStatus.text(), report.endpointStatusText(), label + " endpoint status");
		assertStringEquals(expectedCode, report.code, label + " code");
		if (expectedActionable)
			assertTrue(report.isActionable(), label + " actionable");
		else
			assertFalse(report.isActionable(), label + " not actionable");
		assertStringEquals(expectedCommand, report.command, label + " command");
		assertStringEquals(expectedCwd, report.cwd, label + " cwd");
		assertStringEquals(expectedHost, report.host, label + " host");
		assertIntEquals(expectedPort, report.port, label + " port");
		assertIntEquals(expectedArgCount, report.argCount, label + " arg count");
		assertIntEquals(expectedEnvCount, report.envCount, label + " env count");
	}

	static function assertLineOpenOutcome(outcome:TuiAppServerJsonRpcLineOpenOutcome, expectedStatus:TuiAppServerJsonRpcLineOpenOutcomeStatus,
			expectedCode:String, expectedOpened:Bool, expectedConnectionLabel:String, expectedConnectionIndex:Int,
			expectedIntentKind:TuiAppServerJsonRpcLineOpenIntentKind, expectedEndpointStatus:TuiAppServerJsonRpcLineEndpointStatus, label:String):Void {
		if (outcome == null)
			throw label + ": missing outcome";
		assertStringEquals(expectedStatus.text(), outcome.statusText(), label + " status");
		assertStringEquals(expectedCode, outcome.code, label + " code");
		if (expectedOpened)
			assertTrue(outcome.isOpened(), label + " opened");
		else
			assertFalse(outcome.isOpened(), label + " refused");
		assertStringEquals(expectedConnectionLabel, outcome.connectionLabel, label + " connection label");
		assertIntEquals(expectedConnectionIndex, outcome.connectionIndex, label + " connection index");
		assertStringEquals(expectedIntentKind.text(), outcome.intentKindText(), label + " intent kind");
		assertStringEquals(expectedEndpointStatus.text(), outcome.endpointStatusText(), label + " endpoint status");
	}

	static function assertLineTransportAttachment(report:TuiAppServerJsonRpcLineTransportAttachmentReport,
			expectedStatus:TuiAppServerJsonRpcLineAttachmentStatus, expectedCode:String, expectedReady:Bool, expectedConnectionLabel:String,
			expectedConnectionIndex:Int, expectedTransportOpen:Bool, expectedOutboundLineCount:Int, expectedInboundLineCount:Int,
			expectedIntentKind:TuiAppServerJsonRpcLineOpenIntentKind, expectedEndpointStatus:TuiAppServerJsonRpcLineEndpointStatus, label:String):Void {
		if (report == null)
			throw label + ": missing report";
		assertStringEquals(expectedStatus.text(), report.statusText(), label + " status");
		assertStringEquals(expectedCode, report.code, label + " code");
		if (expectedReady)
			assertTrue(report.isReady(), label + " ready");
		else
			assertFalse(report.isReady(), label + " refused");
		assertStringEquals(expectedConnectionLabel, report.connectionLabel, label + " connection label");
		assertIntEquals(expectedConnectionIndex, report.connectionIndex, label + " connection index");
		if (expectedTransportOpen)
			assertTrue(report.transportOpen, label + " transport open");
		else
			assertFalse(report.transportOpen, label + " transport closed");
		assertIntEquals(expectedOutboundLineCount, report.outboundLineCount, label + " outbound line count");
		assertIntEquals(expectedInboundLineCount, report.inboundLineCount, label + " inbound line count");
		assertStringEquals(expectedIntentKind.text(), report.intentKindText(), label + " intent kind");
		assertStringEquals(expectedEndpointStatus.text(), report.endpointStatusText(), label + " endpoint status");
	}

	static function assertLineConnectReport(report:TuiAppServerJsonRpcLineConnectReport, expectedStatus:TuiAppServerJsonRpcLineConnectStatus,
			expectedCode:String, expectedReady:Bool, expectedConnectionLabel:String, expectedConnectionIndex:Int, expectedTransportOpen:Bool,
			expectedEndpointStatus:TuiAppServerJsonRpcLineEndpointStatus, expectedIntentKind:TuiAppServerJsonRpcLineOpenIntentKind,
			expectedOpenStatus:TuiAppServerJsonRpcLineOpenOutcomeStatus, expectedAttachmentStatus:TuiAppServerJsonRpcLineAttachmentStatus, label:String):Void {
		if (report == null)
			throw label + ": missing report";
		assertStringEquals(expectedStatus.text(), report.statusText(), label + " status");
		assertStringEquals(expectedCode, report.code, label + " code");
		if (expectedReady)
			assertTrue(report.isReady(), label + " ready");
		else
			assertFalse(report.isReady(), label + " refused");
		assertStringEquals(expectedConnectionLabel, report.connectionLabel, label + " connection label");
		assertIntEquals(expectedConnectionIndex, report.connectionIndex, label + " connection index");
		if (expectedTransportOpen)
			assertTrue(report.transportOpen, label + " transport open");
		else
			assertFalse(report.transportOpen, label + " transport closed");
		assertStringEquals(expectedEndpointStatus.text(), report.endpointStatusText(), label + " endpoint status");
		assertStringEquals(expectedIntentKind.text(), report.intentKindText(), label + " intent kind");
		assertStringEquals(expectedOpenStatus.text(), report.openStatusText(), label + " open status");
		assertStringEquals(expectedAttachmentStatus.text(), report.attachmentStatusText(), label + " attachment status");
	}

	static function expectReadyLineTransport(attacher:DryRunTuiAppServerJsonRpcLineTransportAttacher, attachment:TuiAppServerJsonRpcLineTransportAttachment,
			label:String):TuiAppServerJsonRpcLineTransport {
		if (attachment == null)
			throw label + ": missing attachment";
		if (!attachment.isReady() || !attachment.hasTransport())
			throw label + ": expected ready attachment";
		final transport = attacher.transportFor(attachment);
		if (transport == null)
			throw label + ": missing transport";
		return transport;
	}

	static function expectConnectorLineTransport(connector:DryRunTuiAppServerJsonRpcLineConnector, report:TuiAppServerJsonRpcLineConnectReport,
			label:String):TuiAppServerJsonRpcLineTransport {
		if (connector == null)
			throw label + ": missing connector";
		final transport = connector.transportFor(report);
		if (transport == null)
			throw label + ": missing transport";
		return transport;
	}

	static function expectResponseFrame(frame:Null<TuiPromptJsonRpcFrame>, label:String):TuiPromptJsonRpcResponse {
		final concrete = expectFrame(frame, label);
		return switch concrete {
			case TuiPromptJsonRpcFrame.Response(response):
				response;
			case _:
				throw label + ": expected response frame";
		}
	}

	static function assertStreamFrame(frame:Null<TuiPromptJsonRpcFrame>, expectedMethod:String, expectedMessage:String, label:String):Void {
		final concrete = expectFrame(frame, label);
		switch concrete {
			case TuiPromptJsonRpcFrame.StreamNotification(notification):
				assertStringEquals(expectedMethod, streamNotificationMethodText(notification), label + " method");
				assertStringEquals(expectedMessage, streamNotificationMessageJson(notification), label + " message");
			case _:
				throw label + ": expected stream notification frame";
		}
	}

	static function expectStreamFrame(frame:Null<TuiPromptJsonRpcFrame>, label:String):TuiPromptJsonRpcStreamNotification {
		final concrete = expectFrame(frame, label);
		return switch concrete {
			case TuiPromptJsonRpcFrame.StreamNotification(notification):
				notification;
			case _:
				throw label + ": expected stream notification frame";
		}
	}

	static function expectFrame(frame:Null<TuiPromptJsonRpcFrame>, label:String):TuiPromptJsonRpcFrame {
		if (frame == null)
			throw label;
		return frame;
	}

	static function assertStreamFrameIsAbsent(frame:Null<TuiPromptJsonRpcFrame>, label:String):Void {
		if (frame != null)
			throw label;
	}

	static function assertWireRecord(record:Null<TuiPromptJsonRpcFrameRecord>, expectedSequence:Int, expectedDirection:TuiPromptJsonRpcFrameDirection,
			expectedKind:TuiPromptJsonRpcFrameKind, expectedMethod:String, expectedMessage:String, label:String):Void {
		final concrete = expectWireRecord(record, label);
		assertIntEquals(expectedSequence, concrete.sequence, label + " sequence");
		assertStringEquals(expectedDirection.text(), concrete.directionText(), label + " direction");
		assertStringEquals(expectedKind.text(), concrete.kindText(), label + " kind");
		assertStringEquals(expectedMethod, concrete.methodText(), label + " method");
		assertStringEquals(expectedMessage, concrete.messageJson(), label + " message");
		assertStringEquals(expectedMessage + "\n", concrete.lineText(), label + " line");
	}

	static function expectWireRecord(record:Null<TuiPromptJsonRpcFrameRecord>, label:String):TuiPromptJsonRpcFrameRecord {
		if (record == null)
			throw label;
		return record;
	}

	static function assertCorrelation(correlation:TuiPromptJsonRpcFrameCorrelation, expectedStatus:TuiPromptJsonRpcCorrelationStatus,
			expectedRequestId:String, expectedResponseId:String, expectedStreamCount:Int, label:String):Void {
		assertStringEquals(expectedStatus.text(), correlation.statusText(), label + " status");
		assertStringEquals(expectedRequestId, correlation.requestIdText, label + " request");
		assertStringEquals(expectedResponseId, correlation.responseIdText, label + " response");
		assertIntEquals(expectedStreamCount, correlation.streamNotificationCount, label + " stream count");
	}

	static function assertPromptLifecycle(lifecycle:TuiPromptPendingRequestLifecycle, expectedStatus:TuiPromptPendingRequestStatus, expectedRequestId:String,
			expectedPendingBefore:Int, expectedPendingAfter:Int, label:String):Void {
		assertStringEquals(expectedStatus.text(), lifecycle.statusText(), label + " status");
		assertStringEquals(expectedRequestId, lifecycle.requestIdText(), label + " request");
		assertStringEquals("prompt_submit", lifecycle.methodText(), label + " method");
		assertIntEquals(expectedPendingBefore, lifecycle.pendingBefore, label + " pending before");
		assertIntEquals(expectedPendingAfter, lifecycle.pendingAfter, label + " pending after");
	}

	static function assertStreamScope(scope:TuiPromptJsonRpcStreamScopeReport, expectedStatus:TuiPromptJsonRpcStreamScopeStatus, expectedThreadId:String,
			expectedTurnId:String, actualThreadId:String, actualTurnId:String, expectedCheckedCount:Int, expectedFirstMismatchIndex:Int, label:String):Void {
		assertStringEquals(expectedStatus.text(), scope.statusText(), label + " status");
		assertStringEquals(expectedThreadId, scope.expectedThreadIdText, label + " expected thread");
		assertStringEquals(expectedTurnId, scope.expectedTurnIdText, label + " expected turn");
		assertStringEquals(actualThreadId, scope.actualThreadIdText, label + " actual thread");
		assertStringEquals(actualTurnId, scope.actualTurnIdText, label + " actual turn");
		assertIntEquals(expectedCheckedCount, scope.checkedNotificationCount, label + " checked count");
		assertIntEquals(expectedFirstMismatchIndex, scope.firstMismatchIndex, label + " mismatch index");
	}

	static function assertTurnLifecycle(lifecycle:TuiPromptTurnLifecycleReport, expectedStatus:TuiPromptTurnLifecycleStatus, expectedTurnId:String,
			expectedStartedTurnId:String, expectedCompletedTurnId:String, expectedCheckedCount:Int, expectedStartedCount:Int, expectedCompletedCount:Int,
			label:String):Void {
		assertStringEquals(expectedStatus.text(), lifecycle.statusText(), label + " status");
		assertStringEquals(expectedTurnId, lifecycle.expectedTurnIdText, label + " expected turn");
		assertStringEquals(expectedStartedTurnId, lifecycle.startedTurnIdText, label + " started turn");
		assertStringEquals(expectedCompletedTurnId, lifecycle.completedTurnIdText, label + " completed turn");
		assertIntEquals(expectedCheckedCount, lifecycle.checkedNotificationCount, label + " checked count");
		assertIntEquals(expectedStartedCount, lifecycle.startedCount, label + " started count");
		assertIntEquals(expectedCompletedCount, lifecycle.completedCount, label + " completed count");
	}

	static function streamNotificationMethodText(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status.methodText();
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.methodText();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.methodText();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.methodText();
		}
	}

	static function streamNotificationMessageJson(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status.messageJson();
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.messageJson();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.messageJson();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.messageJson();
		}
	}

	static function expectAgentMessageDeltaStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptAgentMessageDeltaNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta;
			case _:
				throw label + ": expected agent message delta stream notification";
		}
	}

	static function expectThreadStatusChangedStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptThreadStatusChangedNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status;
			case _:
				throw label + ": expected thread status changed stream notification";
		}
	}

	static function expectAgentMessageStartedStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptAgentMessageStartedNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started;
			case _:
				throw label + ": expected agent message started stream notification";
		}
	}

	static function expectUserMessageCompletedStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptUserMessageCompletedNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed;
			case _:
				throw label + ": expected user message completed stream notification";
		}
	}

	static function expectRawResponseItemCompletedStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptRawResponseItemCompletedNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed;
			case _:
				throw label + ": expected raw response item completed stream notification";
		}
	}

	static function expectAgentMessageCompletedStreamNotification(notification:Null<TuiPromptJsonRpcStreamNotification>,
			label:String):TuiPromptAgentMessageCompletedNotification {
		final streamNotification = expectStreamNotification(notification, label);
		return switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed;
			case _:
				throw label + ": expected agent message completed stream notification";
		}
	}

	static function assertTurnStreamNotification(streamNotification:TuiPromptJsonRpcStreamNotification, expected:TuiPromptJsonRpcNotification,
			label:String):Void {
		switch streamNotification {
			case TuiPromptJsonRpcStreamNotification.Turn(actual):
				assertStringEquals(expected.methodText(), actual.methodText(), label + " method");
				assertStringEquals(expected.paramsJson(), actual.paramsJson(), label + " params");
			case _:
				throw label + ": expected turn stream notification";
		}
	}

	static function expectJson(outcome:JsonParseOutcome):haxe.json.Value {
		if (!outcome.ok)
			throw "json parse failed: " + outcome.errorCode + " " + outcome.errorPath;
		return outcome.value;
	}

	static function expectAppServerEvent(event:Null<TuiAppServerEvent>, label:String):TuiAppServerEvent {
		if (event == null)
			throw label;
		return event;
	}

	static function assertThreadStatusEvent(event:TuiAppServerEvent, expectedThread:ThreadId, expectedStatus:TuiAppServerThreadStatus, label:String):Void {
		switch event {
			case TuiAppServerEvent.ThreadStatus(threadId, status):
				assertTrue(threadId.equals(expectedThread), label + " thread");
				assertStringEquals(threadStatusText(expectedStatus), threadStatusText(status), label + " status");
			case _:
				throw label + ": expected thread status event";
		}
	}

	static function assertAssistantDeltaEvent(event:TuiAppServerEvent, expectedThread:ThreadId, expectedDelta:String, label:String):Void {
		switch event {
			case TuiAppServerEvent.AssistantDelta(threadId, delta):
				assertTrue(threadId.equals(expectedThread), label + " thread");
				assertStringEquals(expectedDelta, delta, label + " delta");
			case _:
				throw label + ": expected assistant delta event";
		}
	}

	static function threadStatusText(status:TuiAppServerThreadStatus):String {
		return switch status {
			case Ready(text):
				"ready:" + text;
			case Working(text):
				"working:" + text;
			case Failed(text):
				"failed:" + text;
		}
	}

	static function assertStringEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertIntEquals(expected:Int, actual:Int, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, label:String):Void {
		if (!value)
			throw label;
	}

	static function assertFalse(value:Bool, label:String):Void {
		if (value)
			throw label;
	}
}

class RecordingLineNativeOpener implements TuiAppServerJsonRpcLineNativeOpener {
	final delegate:DryRunTuiAppServerJsonRpcLineNativeOpener;
	final refusalCode:String;
	var openCalls:Int;

	public function new(refusalCode:String) {
		this.delegate = new DryRunTuiAppServerJsonRpcLineNativeOpener();
		this.refusalCode = refusalCode == null ? "" : refusalCode;
		this.openCalls = 0;
	}

	public static function accepting():RecordingLineNativeOpener {
		return new RecordingLineNativeOpener("");
	}

	public static function refusing(code:String):RecordingLineNativeOpener {
		return new RecordingLineNativeOpener(code);
	}

	public function open(intent:TuiAppServerJsonRpcLineOpenIntent):TuiAppServerJsonRpcLineOpenOutcome {
		openCalls = openCalls + 1;
		if (refusalCode.length == 0)
			return delegate.open(intent);
		return new TuiAppServerJsonRpcLineOpenOutcome(TuiAppServerJsonRpcLineOpenOutcomeStatus.Refused, refusalCode, "", 0,
			TuiAppServerJsonRpcLineOpenIntentReport.fromIntent(intent));
	}

	public function openCallCount():Int {
		return openCalls;
	}
}

class RecordingLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	final delegate:DryRunTuiAppServerJsonRpcLineTransportAttacher;
	final shouldMaterializeTransport:Bool;
	var attachCalls:Int;
	var transportCalls:Int;

	public function new(shouldMaterializeTransport:Bool) {
		this.delegate = new DryRunTuiAppServerJsonRpcLineTransportAttacher();
		this.shouldMaterializeTransport = shouldMaterializeTransport;
		this.attachCalls = 0;
		this.transportCalls = 0;
	}

	public static function accepting():RecordingLineTransportAttacher {
		return new RecordingLineTransportAttacher(true);
	}

	public static function missingTransport():RecordingLineTransportAttacher {
		return new RecordingLineTransportAttacher(false);
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		attachCalls = attachCalls + 1;
		return delegate.attach(outcome);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		transportCalls = transportCalls + 1;
		if (!shouldMaterializeTransport)
			return null;
		return delegate.transportFor(attachment);
	}

	public function attachCallCount():Int {
		return attachCalls;
	}

	public function transportCallCount():Int {
		return transportCalls;
	}
}

class RecordingLineConnector implements TuiAppServerJsonRpcLineConnector {
	final opener:DryRunTuiAppServerJsonRpcLineNativeOpener;
	final attacher:DryRunTuiAppServerJsonRpcLineTransportAttacher;
	final refusalCode:String;
	final shouldMaterializeTransport:Bool;
	var lastAttachmentValue:TuiAppServerJsonRpcLineTransportAttachment;
	var connectCalls:Int;
	var transportCalls:Int;

	public function new(refusalCode:String, shouldMaterializeTransport:Bool) {
		this.opener = new DryRunTuiAppServerJsonRpcLineNativeOpener();
		this.attacher = new DryRunTuiAppServerJsonRpcLineTransportAttacher();
		this.refusalCode = refusalCode == null ? "" : refusalCode;
		this.shouldMaterializeTransport = shouldMaterializeTransport;
		this.lastAttachmentValue = null;
		this.connectCalls = 0;
		this.transportCalls = 0;
	}

	public static function accepting():RecordingLineConnector {
		return new RecordingLineConnector("", true);
	}

	public static function missingTransport():RecordingLineConnector {
		return new RecordingLineConnector("", false);
	}

	public static function refusing(code:String):RecordingLineConnector {
		return new RecordingLineConnector(code, false);
	}

	public function connect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineConnectReport {
		connectCalls = connectCalls + 1;
		if (refusalCode.length > 0)
			return TuiAppServerJsonRpcLineConnectReport.refused(refusalCode, TuiAppServerJsonRpcLineEndpointReport.inspect(endpoint), null, null);
		final endpointReport = TuiAppServerJsonRpcLineEndpointReport.inspect(endpoint);
		final intent = TuiAppServerJsonRpcLineOpenIntentReport.intentFromEndpoint(endpoint);
		final openOutcome = opener.open(intent);
		final attachment = attacher.attach(openOutcome);
		lastAttachmentValue = attachment;
		return TuiAppServerJsonRpcLineConnectReport.fromParts(endpointReport, openOutcome,
			TuiAppServerJsonRpcLineTransportAttachmentReport.fromAttachment(attachment));
	}

	public function transportFor(report:TuiAppServerJsonRpcLineConnectReport):Null<TuiAppServerJsonRpcLineTransport> {
		transportCalls = transportCalls + 1;
		if (!shouldMaterializeTransport || report == null || !report.isReady())
			return null;
		return attacher.transportFor(lastAttachmentValue);
	}

	public function connectCallCount():Int {
		return connectCalls;
	}

	public function transportCallCount():Int {
		return transportCalls;
	}
}

class RejectingPromptTransport implements TuiPromptTransport {
	final code:String;

	public function new(code:String) {
		this.code = code;
	}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		return TuiPromptTransportOutcome.rejected(code);
	}
}

class DisconnectedAppServerJsonRpcTransport implements TuiAppServerJsonRpcTransport {
	final code:String;

	public function new(code:String) {
		this.code = code;
	}

	public function sendPrompt(_request:TuiPromptJsonRpcRequest, _envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		return TuiAppServerJsonRpcTransportOutcome.disconnected(code, TuiAppServerJsonRpcTransportTranscript.outbound(_request));
	}
}

class MissingResponseAppServerJsonRpcTransport implements TuiAppServerJsonRpcTransport {
	public function new() {}

	public function sendPrompt(_request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		return new TuiAppServerJsonRpcTransportOutcome(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", null, [], [],
			[TuiAppServerEvent.AssistantDelta(envelope.threadId, "should not queue")], TuiAppServerJsonRpcTransportTranscript.outbound(_request));
	}
}

class RecordingWireSession implements TuiAppServerJsonRpcWireSession {
	final delegate:TuiAppServerJsonRpcWireSession;
	var calls:Int;
	var lastOutboundRecordValue:Null<TuiPromptJsonRpcFrameRecord>;

	public function new(delegate:TuiAppServerJsonRpcWireSession) {
		this.delegate = delegate;
		this.calls = 0;
		this.lastOutboundRecordValue = null;
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope,
			outboundRecord:TuiPromptJsonRpcFrameRecord):TuiAppServerJsonRpcWireOutcome {
		calls = calls + 1;
		lastOutboundRecordValue = outboundRecord;
		return delegate.sendPrompt(request, envelope, outboundRecord);
	}

	public function callCount():Int {
		return calls;
	}

	public function lastOutboundRecord():Null<TuiPromptJsonRpcFrameRecord> {
		return lastOutboundRecordValue;
	}
}

class MismatchedInboundLineTransport implements TuiAppServerJsonRpcLineTransport {
	final delegate:TuiAppServerJsonRpcLineTransport;

	public function new(delegate:TuiAppServerJsonRpcLineTransport) {
		this.delegate = delegate;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		final outcome = delegate.sendPromptLine(request, envelope, outboundLine);
		if (!outcome.isAccepted())
			return outcome;
		final lines = outcome.inboundLines();
		if (lines.length > 0)
			lines[0] = "{\"jsonrpc\":\"2.0\",\"id\":0,\"result\":{}}\n";
		return TuiAppServerJsonRpcLineOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(), lines,
			TuiAppServerJsonRpcLineTranscript.accepted(outcome.transcript().outboundLine(), lines));
	}

	public function isOpen():Bool {
		return delegate.isOpen();
	}

	public function stateText():String {
		return delegate.stateText();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		return delegate.close(code);
	}

	public function outboundLineCount():Int {
		return delegate.outboundLineCount();
	}

	public function inboundLineCount():Int {
		return delegate.inboundLineCount();
	}
}

class RejectingPromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	final code:String;

	public function new(code:String) {
		this.code = code;
	}

	public function send(_request:TuiPromptJsonRpcRequest, _envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		return TuiPromptJsonRpcExchangeOutcome.rejected(code);
	}
}

class MismatchedResponsePromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	public function new() {}

	public function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		final turn = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		final staleRequest = new TuiPromptJsonRpcRequest(RequestId.fromInteger(9081), request.method, request.params);
		return TuiPromptJsonRpcExchangeOutcome.accepted(TuiPromptJsonRpcResponse.turnStart(staleRequest, turn), [], [],
			[TuiAppServerEvent.AssistantDelta(envelope.threadId, "should not queue")]);
	}
}

class WrongThreadStreamPromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	final wrongThread:codexhx.protocol.ThreadId;

	public function new(wrongThread:codexhx.protocol.ThreadId) {
		this.wrongThread = wrongThread;
	}

	public function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		final turn = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		final response = TuiPromptJsonRpcResponse.turnStart(request, turn);
		final wrongStatus = TuiPromptThreadStatusChangedNotification.active(wrongThread);
		return TuiPromptJsonRpcExchangeOutcome.accepted(response, [], [TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(wrongStatus)],
			[TuiAppServerEvent.AssistantDelta(wrongThread, "should not queue")]);
	}
}

class WrongTurnStreamPromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	public function new() {}

	public function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		final turn = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		final response = TuiPromptJsonRpcResponse.turnStart(request, turn);
		final staleTurn = codexhx.protocol.TurnId.fromString("turn-stale-" + envelope.requestId.toString());
		if (staleTurn == null)
			return TuiPromptJsonRpcExchangeOutcome.rejected("bad_stale_turn");
		final itemId = codexhx.protocol.ItemId.fromString("item-stale-" + envelope.requestId.toString());
		if (itemId == null)
			return TuiPromptJsonRpcExchangeOutcome.rejected("bad_stale_item");
		final wrongDelta = new TuiPromptAgentMessageDeltaNotification(envelope.threadId, staleTurn, itemId, "wrong turn delta");
		return TuiPromptJsonRpcExchangeOutcome.accepted(response, [], [TuiPromptJsonRpcStreamNotification.AgentMessageDelta(wrongDelta)],
			[TuiAppServerEvent.AssistantDelta(envelope.threadId, "should not queue")]);
	}
}

class IncompleteTurnLifecyclePromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	final includeStarted:Bool;
	final includeCompleted:Bool;

	public function new(includeStarted:Bool, includeCompleted:Bool) {
		this.includeStarted = includeStarted;
		this.includeCompleted = includeCompleted;
	}

	public function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		final turn = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		final response = TuiPromptJsonRpcResponse.turnStart(request, turn);
		final streams:Array<TuiPromptJsonRpcStreamNotification> = [
			TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(TuiPromptThreadStatusChangedNotification.active(envelope.threadId))
		];
		if (includeStarted)
			streams.push(TuiPromptJsonRpcStreamNotification.Turn(TuiPromptJsonRpcNotification.turnStarted(envelope, turn)));
		if (includeCompleted)
			streams.push(TuiPromptJsonRpcStreamNotification.Turn(TuiPromptJsonRpcNotification.turnCompleted(envelope, turn)));
		streams.push(TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(TuiPromptThreadStatusChangedNotification.idle(envelope.threadId)));
		return TuiPromptJsonRpcExchangeOutcome.accepted(response, [], streams, [TuiAppServerEvent.AssistantDelta(envelope.threadId, "should not queue")]);
	}
}
