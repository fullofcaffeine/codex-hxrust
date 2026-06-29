import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
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
import codexhx.runtime.tui.appserver.TuiPromptRawResponseItemCompletedNotification;
import codexhx.runtime.tui.appserver.TuiPromptSubmitEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptSubmitInteraction;
import codexhx.runtime.tui.appserver.TuiPromptThreadStatusChangedNotification;
import codexhx.runtime.tui.appserver.TuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiPromptTransportOutcome;
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
		testJsonRpcNotificationsProjectToTransportEvents();
		testJsonRpcExchangeRejectedSubmitIsTypedRefusal();
		testJsonRpcMismatchedResponseIsTypedRefusal();
		testJsonRpcWrongThreadStreamIsTypedRefusal();
		testJsonRpcWrongTurnStreamIsTypedRefusal();
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

	static function testJsonRpcExchangeRejectedSubmitIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005557");
		final transport = new JsonRpcTuiPromptTransport(new RejectingPromptJsonRpcExchange("exchange_offline"));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(79), "json rpc blocked");
		assertFalse(result.acceptedPrompt(), "json-rpc exchange rejection refused");
		assertStringEquals("79", result.requestIdText(), "json-rpc exchange rejection request id");
		assertStringEquals("json rpc blocked", result.promptText(), "json-rpc exchange rejection prompt");

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
		assertStringEquals(request.messageJson() + "\n", transport.lastWireJsonLines(), "json-rpc rejected wire json lines");
		assertIntEquals(0, facade.queuedCount(), "json-rpc exchange rejection queues no fake events");
	}

	static function testJsonRpcMismatchedResponseIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005559");
		final transport = new JsonRpcTuiPromptTransport(new MismatchedResponsePromptJsonRpcExchange());
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(81), "json rpc stale response");
		assertFalse(result.acceptedPrompt(), "json-rpc mismatched response refused");
		assertStringEquals("81", result.requestIdText(), "json-rpc mismatched response request id");
		assertStringEquals("json rpc stale response", result.promptText(), "json-rpc mismatched response prompt");

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
		assertStringEquals(request.messageJson() + "\n" + responseFrame.messageJson() + "\n", transport.lastWireJsonLines(),
			"json-rpc mismatched wire json lines");
		assertIntEquals(0, facade.queuedCount(), "json-rpc mismatched response queues no fake events");
	}

	static function testJsonRpcWrongThreadStreamIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005560");
		final wrongThread = thread("00000000-0000-0000-0000-000000009560");
		final transport = new JsonRpcTuiPromptTransport(new WrongThreadStreamPromptJsonRpcExchange(wrongThread));
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(82), "json rpc wrong thread");
		assertFalse(result.acceptedPrompt(), "json-rpc wrong-thread stream refused");
		assertStringEquals("82", result.requestIdText(), "json-rpc wrong-thread request id");
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
		assertIntEquals(0, facade.queuedCount(), "json-rpc wrong-thread queues no fake events");
	}

	static function testJsonRpcWrongTurnStreamIsTypedRefusal():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000005561");
		final transport = new JsonRpcTuiPromptTransport(new WrongTurnStreamPromptJsonRpcExchange());
		final facade = attachedFacadeWithTransport(shell, activeThread, transport);
		final result = facade.submitPrompt(RequestId.fromInteger(83), "json rpc wrong turn");
		assertFalse(result.acceptedPrompt(), "json-rpc wrong-turn stream refused");
		assertStringEquals("83", result.requestIdText(), "json-rpc wrong-turn request id");
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
		assertIntEquals(0, facade.queuedCount(), "json-rpc wrong-turn queues no fake events");
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
