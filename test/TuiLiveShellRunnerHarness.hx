import codexhx.protocol.ItemId;
import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineNativeOpener;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.PersistentTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineCloseReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpointReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenIntentReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLateJsonlBatch;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTranscript;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachment;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachmentReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportState;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessLaunchPlan;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcTransportStatus;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerPumpEvent;
import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;
import codexhx.runtime.tui.appserver.TuiAppServerReadinessEvent;
import codexhx.runtime.tui.appserver.TuiAppServerReadinessInteractionStatus;
import codexhx.runtime.tui.appserver.TuiAppServerThreadStatus;
import codexhx.runtime.tui.appserver.TuiPromptAgentMessageDeltaNotification;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcNotificationMethod;
import codexhx.runtime.tui.appserver.TuiPromptSubmitEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnCompletionStatus;
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnLateJsonlDrainStatus;
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnStreamDeliveryStatus;
import codexhx.runtime.tui.appserver.TuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiPromptTransportOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTransportShutdownReport;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcNotification;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcRequest;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcResponse;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcStreamNotification;
import codexhx.runtime.tui.appserver.TuiPromptThreadStatusChangedNotification;
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnLateJsonlDrainResult;
import codexhx.runtime.tui.appserver.TuiPromptTurnAcceptanceMode;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptLineOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptRequest;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptResponse;
import codexhx.runtime.tui.appserver.TuiPromptTurnStartResponse;
import codexhx.runtime.tui.appserver.TuiPromptTurnStatus;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.live.TuiLiveShellRunOutcome;
import codexhx.runtime.tui.live.TuiLiveShellRunPolicy;
import codexhx.runtime.tui.live.TuiLiveShellRunRequest;
import codexhx.runtime.tui.live.TuiLiveShellReadinessSource;
import codexhx.runtime.tui.live.TuiLiveShellRunner;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveShellRunnerHarness {
	static function main():Void {
		testInitialDrawAndIdleRestore();
		testTextSubmitEchoThroughPump();
		testCtrlCInterruptsActiveTurn();
		testPersistentSubmittedTurnCtrlCInterrupts();
		testTextSubmitThroughLineConnectedTransport();
		testTextSubmitThroughInjectedLineConnector();
		testAgentNavigationInputRoutesActiveThread();
		testPumpEventRoutesThroughRunner();
		testReadinessEventRoutesThroughRunner();
		testReadinessSourceFeedsSubmittedTurnReadinessThroughRunner();
		testReadinessBackpressureRecoveryRoutesThroughRunner();
		testReadinessSourceBackpressureRecoveryRoutesThroughRunner();
		testReadinessNoDataRetryRoutesThroughRunner();
		testReadinessSourceNoDataRetryRoutesThroughRunner();
		testDuplicatePostCompletionReadinessNoopsThroughRunner();
		testReadinessSourceDuplicatePostCompletionNoopsThroughRunner();
		testReadinessMaxBatchStopRoutesThroughRunner();
		testReadinessSourceMaxBatchStopRoutesThroughRunner();
		testReadinessPrefixAppliedRejectionRoutesThroughRunner();
		testReadinessSourcePrefixAppliedRejectionRoutesThroughRunner();
		testReadinessLineReadRejectionRoutesThroughRunner();
		testReadinessSourceLineReadRejectionRoutesThroughRunner();
		testReadinessUnsupportedNotificationRejectionRoutesThroughRunner();
		testReadinessSourceUnsupportedNotificationRejectionRoutesThroughRunner();
		testReadinessDecodeRejectionRoutesThroughRunner();
		testReadinessSourceDecodeRejectionRoutesThroughRunner();
		testReadinessMalformedJsonRejectionRoutesThroughRunner();
		testReadinessSourceMalformedJsonRejectionRoutesThroughRunner();
		testReadinessSchemaRejectionRoutesThroughRunner();
		testReadinessSourceSchemaRejectionRoutesThroughRunner();
		testReadinessPrefixThenSchemaRejectionRoutesThroughRunner();
		testReadinessSourcePrefixThenSchemaRejectionRoutesThroughRunner();
		testReadinessPrefixThenDecodeRejectionRoutesThroughRunner();
		testReadinessSourcePrefixThenDecodeRejectionRoutesThroughRunner();
		testReadinessPrefixThenMalformedJsonRejectionRoutesThroughRunner();
		testReadinessPrefixThenUnsupportedNotificationRejectionRoutesThroughRunner();
		testReadinessPrefixThenLineReadRejectionRoutesThroughRunner();
		testReadinessPrefixThenStaleInterruptedRejectionRoutesThroughRunner();
		testReadinessPrefixThenStaleInterruptedCompletionRejectionRoutesThroughRunner();
		testReadinessStaleInterruptedRejectionRoutesThroughRunner();
		testReadinessStaleInterruptedCompletionRejectionRoutesThroughRunner();
		testEscapeCtrlCAndQExit();
		testLiveBackendNoTtyRunPath();
		Sys.println("tui-live-shell-runner ok");
	}

	static function testInitialDrawAndIdleRestore():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([TerminalEvent.NoEvent, TerminalEvent.NoEvent]);
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [], TuiLiveShellRunPolicy.bounded(8, 2)));

		assertTrue(outcome.setupAccepted(), "setup accepted");
		assertTrue(outcome.restored(), "restore");
		assertTrue(outcome.promptTransportShutdownRecorded(), "prompt transport shutdown recorded");
		assertTrue(outcome.promptTransportClosed(), "prompt transport closed");
		assertTrue(!outcome.promptTransportLineCloseRecorded(), "fake prompt transport has no line close");
		assertTrue(outcome.drawFrames() >= 1, "initial frame drawn");
		assertStringEquals("Codex | model: gpt-live | status: session started", outcome.finalFrameLineAt(0), "initial header");
		assertIntEquals(2, outcome.noEvents(), "idle no-event count");
	}

	static function testTextSubmitEchoThroughPump():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [], TuiLiveShellRunPolicy.bounded(16, 2)));

		assertIntEquals(1, outcome.submittedPrompts(), "submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "accepted prompts");
		assertStringEquals("turn-4", outcome.lastStartedTurnIdText(), "last started turn");
		assertStringEquals("turn-4", outcome.lastCompletedTurnIdText(), "last completed turn");
		assertStringEquals("", outcome.activeTurnIdText(), "active turn cleared");
		assertIntEquals(1, outcome.completedTurns(), "completed turn count");
		assertTrue(outcome.appServerEvents() >= 3, "fake app-server echo events");
		assertStringEquals("user> hi", outcome.finalFrameLineAt(3), "user row rendered");
		assertStringEquals("assistant> echo: hi", outcome.finalFrameLineAt(4), "assistant echo rendered");
	}

	static function testCtrlCInterruptsActiveTurn():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final facade = new FakeTuiAppServerFacade(shell, new RunnerLongRunningPromptTransport());
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [], TuiLiveShellRunPolicy.bounded(16, 2)).withFacade(facade));

		assertIntEquals(1, outcome.submittedPrompts(), "interrupt submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "interrupt accepted prompts");
		assertStringEquals("turn-5", outcome.lastStartedTurnIdText(), "interrupt last started turn");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "interrupt last completed turn");
		assertStringEquals("turn-5", outcome.lastInterruptedTurnIdText(), "interrupt last interrupted turn");
		assertStringEquals("", outcome.activeTurnIdText(), "interrupt active turn cleared");
		assertIntEquals(0, outcome.completedTurns(), "interrupt does not count completion");
		assertIntEquals(1, outcome.interruptedTurns(), "interrupt count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "interrupt code");
		assertStringEquals("Codex | model: gpt-live | status: interrupted", outcome.finalFrameLineAt(0), "interrupt status rendered");
		assertTrue(!outcome.exitRequested(), "active turn ctrl-c should not exit");
	}

	static function testPersistentSubmittedTurnCtrlCInterrupts():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("v")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final sessionId = session("00000000-0000-0000-0000-000000119999");
		final threadId = thread("00000000-0000-0000-0000-000000110001");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(6), sessionId, threadId, "live");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final interruptEnvelope = new TuiPromptTurnInterruptEnvelope(RequestId.fromInteger(7), sessionId, threadId,
			TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId);
		final interruptRequest = TuiPromptTurnInterruptRequest.fromEnvelope(interruptEnvelope);
		final interruptLines = interruptReadyThenResponseLines(interruptRequest, threadId);
		final inbound = promptLines.copy();
		for (line in interruptLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [], TuiLiveShellRunPolicy.bounded(20, 2)).withJsonRpcPromptTransport(promptTransport));

		assertIntEquals(1, outcome.submittedPrompts(), "persistent submitted interrupt submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "persistent submitted interrupt accepted prompts");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "persistent submitted interrupt last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "persistent submitted interrupt last completed");
		assertStringEquals("turn-6", outcome.lastInterruptedTurnIdText(), "persistent submitted interrupt last interrupted");
		assertStringEquals("", outcome.activeTurnIdText(), "persistent submitted interrupt active cleared");
		assertIntEquals(0, outcome.completedTurns(), "persistent submitted interrupt completed count");
		assertIntEquals(1, outcome.interruptedTurns(), "persistent submitted interrupt count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "persistent submitted interrupt code");
		assertTrue(!outcome.exitRequested(), "persistent submitted ctrl-c should not exit");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "persistent submitted interrupt close recorded");
		assertIntEquals(2, outcome.promptTransportOutboundLineCount(), "persistent submitted interrupt outbound lines");
		assertIntEquals(promptLines.length + interruptLines.length, outcome.promptTransportInboundLineCount(), "persistent submitted interrupt inbound lines");
	}

	static function testTextSubmitThroughLineConnectedTransport():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final appServerTransport = DryRunTuiAppServerJsonRpcLineConnectedTransport.stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
			["app-server", "--json-rpc"], "/workspace", []));
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(20, 2)).withJsonRpcPromptTransport(new JsonRpcTuiPromptTransport(appServerTransport));
		final outcome = TuiLiveShellRunner.run(requestValue);
		final attempt = appServerTransport.lastAttemptReport();
		final close = appServerTransport.lastCloseReport();

		assertIntEquals(1, outcome.submittedPrompts(), "line-connected submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "line-connected accepted prompts");
		assertTrue(outcome.promptTransportClosed(), "line-connected prompt transport shutdown");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "line-connected prompt transport line close");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "line-connected shutdown outbound lines");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "line-connected last started turn");
		assertStringEquals("turn-6", outcome.lastCompletedTurnIdText(), "line-connected last completed turn");
		assertStringEquals("", outcome.activeTurnIdText(), "line-connected active turn cleared");
		assertIntEquals(1, outcome.completedTurns(), "line-connected completed turn count");
		assertStringEquals("assistant> echo: line", outcome.finalFrameLineAt(4), "line-connected assistant echo");
		assertTrue(attempt != null, "line-connected attempt report");
		assertStatusEquals(TuiAppServerJsonRpcLineConnectStatus.Ready, attempt.connectStatus, "line-connected connect status");
		assertTrue(attempt.transportMaterialized, "line-connected materialized transport");
		assertTrue(attempt.hasLineOutcome(), "line-connected line outcome");
		assertTransportStatusEquals(TuiAppServerJsonRpcTransportStatus.Accepted, attempt.lineStatus, "line-connected line status");
		assertTrue(attempt.hasCloseReport(), "line-connected close report recorded");
		assertLineTransportStateEquals(TuiAppServerJsonRpcLineTransportState.Closed, attempt.closeState, "line-connected close state");
		assertIntEquals(1, attempt.outboundLineCount(), "line-connected outbound line count");
		assertTrue(attempt.inboundLineCount() > 0, "line-connected inbound line count");
		assertTrue(close != null && close.code == "line_connected_transport_done", "line-connected close code");

		final directShell = ChatWidgetShellState.initial("pending");
		final directBackend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final directOutcome = TuiLiveShellRunner.run(request(directShell, directBackend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withLineConnectedPromptTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
				["app-server", "--json-rpc"], "/workspace", []))));
		assertIntEquals(1, directOutcome.acceptedPrompts(), "direct line-connected accepted prompts");
		assertStringEquals("assistant> echo: direct", directOutcome.finalFrameLineAt(4), "direct line-connected assistant echo");
	}

	static function testTextSubmitThroughInjectedLineConnector():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Character("j")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final connector = new RunnerRecordingLineConnector();
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withLineConnectedPromptTransportUsingConnector(TuiAppServerJsonRpcLineEndpoint.Stdio(TuiAppServerJsonRpcProcessLaunchPlan.stdio("codex",
				["app-server", "--json-rpc"], "/workspace", [])),
				"", connector));

		assertIntEquals(1, outcome.acceptedPrompts(), "injected line connector accepted prompts");
		assertStringEquals("assistant> echo: inject", outcome.finalFrameLineAt(4), "injected line connector assistant echo");
		assertIntEquals(1, connector.connectCallCount(), "injected line connector connect count");
		assertIntEquals(1, connector.transportCallCount(), "injected line connector transport count");
	}

	static function testAgentNavigationInputRoutesActiveThread():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final child = thread("00000000-0000-0000-0000-000000110002");
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.AgentNext),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final outcome = TuiLiveShellRunner.run(request(shell, backend, [TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "worker", false)],
			TuiLiveShellRunPolicy.bounded(24, 2)));

		assertIntEquals(1, outcome.acceptedPrompts(), "side prompt accepted");
		assertStringEquals("Robie [worker]", shell.activeAgentLabel(), "agent label");
		assertStringEquals("Codex | model: gpt-live | status: ready | agent: Robie [worker]", outcome.finalFrameLineAt(0), "agent header");
		assertStringEquals("assistant> echo: side", outcome.finalFrameLineAt(4), "side echo rendered");
	}

	static function testPumpEventRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final backend = new HeadlessTerminalBackend([TerminalEvent.NoEvent, TerminalEvent.NoEvent, TerminalEvent.NoEvent]);
		final requestValue = request(shell, backend, [
			TuiAppServerEvent.AssistantDelta(activeThread, "runner pump one"),
			TuiAppServerEvent.AssistantDelta(activeThread, "runner pump two"),
			TuiAppServerEvent.AssistantDelta(activeThread, "runner pump three")
		],
			new TuiLiveShellRunPolicy(8, 3, TuiAppServerPumpPolicy.bounded(1))).withPumpEvents([TuiAppServerPumpEvent.DrainQueuedEvents]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.appServerPumpEvents(), "runner pump event count");
		assertIntEquals(3, outcome.appServerEvents(), "runner pump drained queued events");
		assertTrue(outcome.appServerBackpressureCount() >= 1, "runner pump backpressure recorded");
		assertStringEquals("assistant> runner pump one", shell.transcriptAt(1).renderText(), "runner pump first row");
		assertStringEquals("assistant> runner pump two", shell.transcriptAt(2).renderText(), "runner pump second row");
		assertStringEquals("assistant> runner pump three", shell.transcriptAt(3).renderText(), "runner pump third row");
		assertStringEquals("assistant> runner pump three", outcome.finalFrameLineAt(5), "runner pump final frame");
	}

	static function testReadinessEventRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(7), activeSession, activeThread, "ready");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-ready-7"), "runner readiness delta").messageJson() + "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("y")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withJsonRpcPromptTransport(promptTransport).withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner readiness no pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner readiness late jsonl drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner readiness late jsonl drain code");
		assertTrue(outcome.appServerEvents() >= 3, "runner readiness pumped app-server events");
		assertStringEquals("turn-7", outcome.lastStartedTurnIdText(), "runner readiness last started");
		assertStringEquals("turn-7", outcome.lastCompletedTurnIdText(), "runner readiness last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner readiness active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner readiness completed count");
		assertStringEquals("user> ready", shell.transcriptAt(1).renderText(), "runner readiness user row");
		assertStringEquals("assistant> runner readiness delta", shell.transcriptAt(2).renderText(), "runner readiness assistant row");
		assertStringEquals("assistant> runner readiness delta", outcome.finalFrameLineAt(4), "runner readiness final frame");
	}

	static function testReadinessSourceFeedsSubmittedTurnReadinessThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(8), activeSession, activeThread, "source");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-8"), "runner readiness source delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner readiness source submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner readiness source accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner readiness source event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner readiness source drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner readiness source no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner readiness source no-data count");
		assertStringEquals("turn-8", outcome.latestNoDataReadinessActiveTurnIdText(), "runner readiness source no-data active retained");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner readiness source final drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner readiness source final drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner readiness source line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner readiness source line code");
		assertIntEquals(2, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner readiness source applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner readiness source assistant delta count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlCompletionCount(), "runner readiness source completion count");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner readiness source applied thread evidence");
		assertStringEquals("turn-8", outcome.latestReadinessLateJsonlTurnIdText(), "runner readiness source applied turn evidence");
		assertStringEquals("runner readiness source delta", outcome.latestReadinessLateJsonlDeltaText(), "runner readiness source applied delta evidence");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner readiness source last started");
		assertStringEquals("turn-8", outcome.lastCompletedTurnIdText(), "runner readiness source last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner readiness source active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner readiness source completed exactly once");
		assertStringEquals("user> source", shell.transcriptAt(1).renderText(), "runner readiness source user row");
		assertStringEquals("assistant> runner readiness source delta", shell.transcriptAt(2).renderText(), "runner readiness source assistant row");
		assertStringEquals("assistant> runner readiness source delta", outcome.finalFrameLineAt(4), "runner readiness source final frame");
	}

	static function testReadinessBackpressureRecoveryRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(9), activeSession, activeThread, "recover");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-recover-9"), "runner recovery delta").messageJson() + "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("v")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			new TuiLiveShellRunPolicy(32, 3,
				TuiAppServerPumpPolicy.bounded(1))).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)])
			.withPumpEvents([TuiAppServerPumpEvent.DrainQueuedEvents]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner recovery submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner recovery accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner recovery readiness event count");
		assertIntEquals(1, outcome.appServerReadinessBackpressureCount(), "runner recovery readiness backpressure count");
		assertStringEquals("turn-9", outcome.latestReadinessActiveTurnIdText(), "runner recovery active turn preserved after readiness");
		assertIntEquals(1, outcome.appServerPumpEvents(), "runner recovery pump event count");
		assertIntEquals(1, outcome.appServerPumpEventBackpressureCount(), "runner recovery pump event backpressure count");
		assertIntEquals(2, outcome.appServerBackpressureCount(), "runner recovery total backpressure count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner recovery readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner recovery late jsonl drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner recovery late jsonl drain code");
		assertStringEquals("turn-9", outcome.lastStartedTurnIdText(), "runner recovery last started");
		assertStringEquals("turn-9", outcome.lastCompletedTurnIdText(), "runner recovery last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner recovery active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner recovery completed exactly once");
		assertStringEquals("assistant> runner recovery delta", shell.transcriptAt(2).renderText(), "runner recovery assistant row");
		assertStringEquals("assistant> runner recovery delta", outcome.finalFrameLineAt(4), "runner recovery final frame");
	}

	static function testReadinessSourceBackpressureRecoveryRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(15), activeSession, activeThread, "sourcerecover");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-recover-15"),
				"runner source recovery delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("v")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			new TuiLiveShellRunPolicy(80, 3,
				TuiAppServerPumpPolicy.bounded(1))).withJsonRpcPromptTransport(promptTransport)
			.withReadinessSource(TuiLiveShellReadinessSource.queued([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)]))
			.withPumpEvents([TuiAppServerPumpEvent.DrainQueuedEvents]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source recovery submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source recovery accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner source recovery readiness event count");
		assertIntEquals(1, outcome.appServerReadinessBackpressureCount(), "runner source recovery readiness backpressure count");
		assertStringEquals("turn-15", outcome.latestReadinessActiveTurnIdText(), "runner source recovery active turn preserved after readiness");
		assertIntEquals(1, outcome.appServerPumpEvents(), "runner source recovery pump event count");
		assertIntEquals(1, outcome.appServerPumpEventBackpressureCount(), "runner source recovery pump event backpressure count");
		assertIntEquals(2, outcome.appServerBackpressureCount(), "runner source recovery total backpressure count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source recovery readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source recovery late jsonl drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner source recovery late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source recovery line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source recovery line code");
		assertIntEquals(2, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source recovery applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source recovery assistant delta count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlCompletionCount(), "runner source recovery completion count");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner source recovery applied thread evidence");
		assertStringEquals("turn-15", outcome.latestReadinessLateJsonlTurnIdText(), "runner source recovery applied turn evidence");
		assertStringEquals("runner source recovery delta", outcome.latestReadinessLateJsonlDeltaText(), "runner source recovery applied delta evidence");
		assertStringEquals("turn-15", outcome.lastStartedTurnIdText(), "runner source recovery last started");
		assertStringEquals("turn-15", outcome.lastCompletedTurnIdText(), "runner source recovery last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner source recovery active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner source recovery completed exactly once");
		assertStringEquals("user> sourcerecover", shell.transcriptAt(1).renderText(), "runner source recovery user row");
		assertStringEquals("assistant> runner source recovery delta", shell.transcriptAt(2).renderText(), "runner source recovery assistant row");
		assertStringEquals("assistant> runner source recovery delta", outcome.finalFrameLineAt(4), "runner source recovery final frame");
	}

	static function testReadinessNoDataRetryRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(6), activeSession, activeThread, "wait");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-wait-10"), "runner no data retry delta").messageJson() + "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("w")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(32, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner no-data submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner no-data accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner no-data readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner no-data readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner no-data readiness no-data count");
		assertStringEquals("turn-6", outcome.latestNoDataReadinessActiveTurnIdText(), "runner no-data active turn retained after first readiness");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner no-data retry final drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner no-data retry final drain code");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner no-data last started");
		assertStringEquals("turn-6", outcome.lastCompletedTurnIdText(), "runner no-data last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner no-data active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner no-data completed exactly once");
		assertStringEquals("user> wait", shell.transcriptAt(1).renderText(), "runner no-data user row");
		assertStringEquals("assistant> runner no data retry delta", shell.transcriptAt(2).renderText(), "runner no-data assistant row");
		assertStringEquals("assistant> runner no data retry delta", outcome.finalFrameLineAt(4), "runner no-data final frame");
	}

	static function testReadinessSourceNoDataRetryRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(12), activeSession, activeThread, "sourcewait");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-wait-12"),
				"runner source no data retry delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("w")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(64, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source no-data submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source no-data accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source no-data readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source no-data readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source no-data readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source no-data readiness no-data count");
		assertStringEquals("turn-12", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source no-data active turn retained after first readiness");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source no-data final drain status");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner source no-data final drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source no-data line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source no-data line code");
		assertIntEquals(2, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source no-data applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source no-data assistant delta count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlCompletionCount(), "runner source no-data completion count");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner source no-data applied thread evidence");
		assertStringEquals("turn-12", outcome.latestReadinessLateJsonlTurnIdText(), "runner source no-data applied turn evidence");
		assertStringEquals("runner source no data retry delta", outcome.latestReadinessLateJsonlDeltaText(), "runner source no-data applied delta evidence");
		assertStringEquals("turn-12", outcome.lastStartedTurnIdText(), "runner source no-data last started");
		assertStringEquals("turn-12", outcome.lastCompletedTurnIdText(), "runner source no-data last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner source no-data active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner source no-data completed exactly once");
		assertStringEquals("user> sourcewait", shell.transcriptAt(1).renderText(), "runner source no-data user row");
		assertStringEquals("assistant> runner source no data retry delta", shell.transcriptAt(2).renderText(), "runner source no-data assistant row");
		assertStringEquals("assistant> runner source no data retry delta", outcome.finalFrameLineAt(4), "runner source no-data final frame");
	}

	static function testDuplicatePostCompletionReadinessNoopsThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(7), activeSession, activeThread, "again");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-again-10"), "runner duplicate readiness delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId),
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-again-extra-10"),
				"runner duplicate should not read").messageJson()
				+ "\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("g")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner duplicate readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner duplicate readiness accepted prompts");
		assertIntEquals(3, outcome.appServerReadinessEvents(), "runner duplicate readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner duplicate readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoPending(), "runner duplicate readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner duplicate readiness no-data count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.NoPendingSubmittedTurn.text(), outcome.latestReadinessStatusText(),
			"runner duplicate readiness latest status");
		assertStringEquals("turn-7", outcome.lastStartedTurnIdText(), "runner duplicate readiness last started");
		assertStringEquals("turn-7", outcome.lastCompletedTurnIdText(), "runner duplicate readiness last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner duplicate readiness active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner duplicate readiness completed exactly once");
		assertIntEquals(3, shell.transcriptCount(), "runner duplicate readiness transcript count");
		assertStringEquals("assistant> runner duplicate readiness delta", shell.transcriptAt(2).renderText(), "runner duplicate readiness assistant row");
		assertStringEquals("assistant> runner duplicate readiness delta", outcome.finalFrameLineAt(4), "runner duplicate readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner duplicate readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner duplicate readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner duplicate readiness duplicate did not read extra late line");
	}

	static function testReadinessSourceDuplicatePostCompletionNoopsThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(13), activeSession, activeThread, "sourceagain");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-again-13"),
				"runner source duplicate readiness delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId),
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-again-extra-13"),
				"runner source duplicate should not read").messageJson()
				+ "\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("g")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(72, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source duplicate readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source duplicate readiness accepted prompts");
		assertIntEquals(3, outcome.appServerReadinessEvents(), "runner source duplicate readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source duplicate readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoPending(), "runner source duplicate readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source duplicate readiness no-data count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.NoPendingSubmittedTurn.text(), outcome.latestReadinessStatusText(),
			"runner source duplicate readiness latest status");
		assertStringEquals("turn-13", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source duplicate no-data active retained");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.Completed.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source duplicate final drain status retained");
		assertStringEquals("completed", outcome.latestReadinessLateJsonlDrainCode(), "runner source duplicate final drain code retained");
		assertIntEquals(2, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source duplicate applied notification count retained");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source duplicate assistant delta count retained");
		assertIntEquals(1, outcome.latestReadinessLateJsonlCompletionCount(), "runner source duplicate completion count retained");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner source duplicate applied thread evidence");
		assertStringEquals("turn-13", outcome.latestReadinessLateJsonlTurnIdText(), "runner source duplicate applied turn evidence");
		assertStringEquals("runner source duplicate readiness delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner source duplicate applied delta evidence");
		assertStringEquals("turn-13", outcome.lastStartedTurnIdText(), "runner source duplicate readiness last started");
		assertStringEquals("turn-13", outcome.lastCompletedTurnIdText(), "runner source duplicate readiness last completed");
		assertStringEquals("", outcome.activeTurnIdText(), "runner source duplicate readiness active cleared");
		assertIntEquals(1, outcome.completedTurns(), "runner source duplicate readiness completed exactly once");
		assertIntEquals(3, shell.transcriptCount(), "runner source duplicate readiness transcript count");
		assertStringEquals("user> sourceagain", shell.transcriptAt(1).renderText(), "runner source duplicate readiness user row");
		assertStringEquals("assistant> runner source duplicate readiness delta", shell.transcriptAt(2).renderText(),
			"runner source duplicate readiness assistant row");
		assertStringEquals("assistant> runner source duplicate readiness delta", outcome.finalFrameLineAt(4), "runner source duplicate readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source duplicate readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source duplicate readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner source duplicate readiness duplicate did not read extra late line");
	}

	static function testReadinessMaxBatchStopRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(5), activeSession, activeThread, "max");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-max-5"), "runner max batch delta").messageJson() + "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withJsonRpcPromptTransport(promptTransport).withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 1)]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner max-batch readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner max-batch readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner max-batch readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner max-batch readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner max-batch readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner max-batch readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.MaxBatchesReached.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner max-batch readiness late jsonl drain status");
		assertStringEquals("max_batches_reached", outcome.latestReadinessLateJsonlDrainCode(), "runner max-batch readiness late jsonl drain code");
		assertStringEquals("turn-5", outcome.latestReadinessActiveTurnIdText(), "runner max-batch readiness active retained after readiness");
		assertStringEquals("turn-5", outcome.lastStartedTurnIdText(), "runner max-batch readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner max-batch readiness no completion");
		assertStringEquals("turn-5", outcome.activeTurnIdText(), "runner max-batch readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner max-batch readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner max-batch readiness transcript count");
		assertStringEquals("user> max", shell.transcriptAt(1).renderText(), "runner max-batch readiness user row");
		assertStringEquals("assistant> runner max batch delta", shell.transcriptAt(2).renderText(), "runner max-batch readiness assistant row");
		assertStringEquals("assistant> runner max batch delta", outcome.finalFrameLineAt(4), "runner max-batch readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner max-batch readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner max-batch readiness outbound lines");
		assertIntEquals(promptLines.length + 1, outcome.promptTransportInboundLineCount(), "runner max-batch readiness completion line remains unread");
	}

	static function testReadinessSourceMaxBatchStopRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(11), activeSession, activeThread, "sourcemax");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-max-11"), "runner source max batch delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(56,
				2)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessSource(TuiLiveShellReadinessSource.queued([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 1)]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source max-batch readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source max-batch readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner source max-batch readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner source max-batch readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source max-batch readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source max-batch readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.MaxBatchesReached.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source max-batch readiness late jsonl drain status");
		assertStringEquals("max_batches_reached", outcome.latestReadinessLateJsonlDrainCode(), "runner source max-batch readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source max-batch readiness line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source max-batch readiness line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source max-batch applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source max-batch assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source max-batch completion count");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner source max-batch applied thread evidence");
		assertStringEquals("turn-11", outcome.latestReadinessLateJsonlTurnIdText(), "runner source max-batch applied turn evidence");
		assertStringEquals("runner source max batch delta", outcome.latestReadinessLateJsonlDeltaText(), "runner source max-batch applied delta evidence");
		assertStringEquals("turn-11", outcome.latestReadinessActiveTurnIdText(), "runner source max-batch readiness active retained after readiness");
		assertStringEquals("turn-11", outcome.lastStartedTurnIdText(), "runner source max-batch readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source max-batch readiness no completion");
		assertStringEquals("turn-11", outcome.activeTurnIdText(), "runner source max-batch readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source max-batch readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner source max-batch readiness transcript count");
		assertStringEquals("user> sourcemax", shell.transcriptAt(1).renderText(), "runner source max-batch readiness user row");
		assertStringEquals("assistant> runner source max batch delta", shell.transcriptAt(2).renderText(), "runner source max-batch readiness assistant row");
		assertStringEquals("assistant> runner source max batch delta", outcome.finalFrameLineAt(4), "runner source max-batch readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source max-batch readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source max-batch readiness outbound lines");
		assertIntEquals(promptLines.length + 1, outcome.promptTransportInboundLineCount(), "runner source max-batch readiness completion line remains unread");
	}

	static function testReadinessPrefixAppliedRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(8), activeSession, activeThread, "prefix");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-8"), "runner prefix rejection delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turn("turn-stale-8"))
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(30,
				2)).withJsonRpcPromptTransport(promptTransport).withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner prefix readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner prefix readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner prefix readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnCompletionStatus.WrongTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner prefix readiness late jsonl drain code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner prefix readiness applied thread evidence");
		assertStringEquals("turn-stale-8", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix readiness rejected turn evidence");
		assertStringEquals("runner prefix rejection delta", outcome.latestReadinessLateJsonlDeltaText(), "runner prefix readiness applied delta evidence");
		assertStringEquals("turn-8", outcome.latestReadinessActiveTurnIdText(), "runner prefix readiness active retained after rejection");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner prefix readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix readiness no completion");
		assertStringEquals("turn-8", outcome.activeTurnIdText(), "runner prefix readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix readiness transcript count");
		assertStringEquals("user> prefix", shell.transcriptAt(1).renderText(), "runner prefix readiness user row");
		assertStringEquals("assistant> runner prefix rejection delta", shell.transcriptAt(2).renderText(), "runner prefix readiness assistant row");
		assertStringEquals("assistant> runner prefix rejection delta", outcome.finalFrameLineAt(4), "runner prefix readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix readiness outbound lines");
		assertIntEquals(promptLines.length + lateLines.length, outcome.promptTransportInboundLineCount(),
			"runner prefix readiness rejected completion was read");
	}

	static function testReadinessSourcePrefixAppliedRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(14), activeSession, activeThread, "sourceprefix");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-prefix-14"),
				"runner source prefix rejection delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turn("turn-source-stale-14"))
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(72,
				2)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessSource(TuiLiveShellReadinessSource.queued([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source prefix readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source prefix readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner source prefix readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner source prefix readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source prefix readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner source prefix readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source prefix readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnCompletionStatus.WrongTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner source prefix readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source prefix readiness line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source prefix readiness line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source prefix readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source prefix readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source prefix readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner source prefix readiness applied thread evidence");
		assertStringEquals("turn-source-stale-14", outcome.latestReadinessLateJsonlTurnIdText(), "runner source prefix readiness rejected turn evidence");
		assertStringEquals("runner source prefix rejection delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner source prefix readiness applied delta evidence");
		assertStringEquals("turn-14", outcome.latestReadinessActiveTurnIdText(), "runner source prefix readiness active retained after rejection");
		assertStringEquals("turn-14", outcome.lastStartedTurnIdText(), "runner source prefix readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source prefix readiness no completion");
		assertStringEquals("turn-14", outcome.activeTurnIdText(), "runner source prefix readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source prefix readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner source prefix readiness transcript count");
		assertStringEquals("user> sourceprefix", shell.transcriptAt(1).renderText(), "runner source prefix readiness user row");
		assertStringEquals("assistant> runner source prefix rejection delta", shell.transcriptAt(2).renderText(),
			"runner source prefix readiness assistant row");
		assertStringEquals("assistant> runner source prefix rejection delta", outcome.finalFrameLineAt(4), "runner source prefix readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source prefix readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source prefix readiness outbound lines");
		assertIntEquals(promptLines.length + lateLines.length, outcome.promptTransportInboundLineCount(),
			"runner source prefix readiness rejected completion was read");
	}

	static function testReadinessLineReadRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerRejectedLateJsonlLineTransportAttacher("runner_late_jsonl_read_failed")));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withJsonRpcPromptTransport(promptTransport).withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner line-read readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner line-read readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner line-read readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner line-read readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner line-read readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner line-read readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.LineReadRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner line-read readiness late jsonl drain status");
		assertStringEquals("runner_late_jsonl_read_failed", outcome.latestReadinessLateJsonlDrainCode(), "runner line-read readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Disconnected.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner line-read readiness late jsonl line status");
		assertStringEquals("runner_late_jsonl_read_failed", outcome.latestReadinessLateJsonlLineCode(), "runner line-read readiness late jsonl line code");
		assertStringEquals("turn-6", outcome.latestReadinessActiveTurnIdText(), "runner line-read readiness active retained after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner line-read readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner line-read readiness no completion");
		assertStringEquals("turn-6", outcome.activeTurnIdText(), "runner line-read readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner line-read readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner line-read readiness transcript count");
		assertStringEquals("user> fail", shell.transcriptAt(1).renderText(), "runner line-read readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner line-read readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner line-read readiness outbound lines");
		assertIntEquals(2, outcome.promptTransportInboundLineCount(), "runner line-read readiness no late inbound lines");
	}

	static function testReadinessSourceLineReadRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerRejectedLateJsonlLineTransportAttacher("runner_source_late_jsonl_read_failed")));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(64,
				2)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessSource(TuiLiveShellReadinessSource.queued([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source line-read readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source line-read readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner source line-read readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner source line-read readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source line-read readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source line-read readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.LineReadRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source line-read readiness late jsonl drain status");
		assertStringEquals("runner_source_late_jsonl_read_failed", outcome.latestReadinessLateJsonlDrainCode(),
			"runner source line-read readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Disconnected.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source line-read readiness late jsonl line status");
		assertStringEquals("runner_source_late_jsonl_read_failed", outcome.latestReadinessLateJsonlLineCode(),
			"runner source line-read readiness late jsonl line code");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source line-read readiness applied notification count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source line-read readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source line-read readiness completion count evidence");
		assertStringEquals("turn-12", outcome.latestReadinessActiveTurnIdText(), "runner source line-read readiness active retained after rejection");
		assertStringEquals("turn-12", outcome.lastStartedTurnIdText(), "runner source line-read readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source line-read readiness no completion");
		assertStringEquals("turn-12", outcome.activeTurnIdText(), "runner source line-read readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source line-read readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner source line-read readiness transcript count");
		assertStringEquals("user> sourcefail", shell.transcriptAt(1).renderText(), "runner source line-read readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source line-read readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source line-read readiness outbound lines");
		assertIntEquals(2, outcome.promptTransportInboundLineCount(), "runner source line-read readiness no late inbound lines");
	}

	static function testReadinessUnsupportedNotificationRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(6), activeSession, activeThread, "oops");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final lateLines = [
			TuiPromptThreadStatusChangedNotification.active(activeThread).messageJson() + "\n"
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(24,
				2)).withJsonRpcPromptTransport(promptTransport).withReadinessEvents([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner unsupported readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner unsupported readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner unsupported readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner unsupported readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner unsupported readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner unsupported readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner unsupported readiness late jsonl drain status");
		assertStringEquals("unsupported_stream_notification", outcome.latestReadinessLateJsonlDrainCode(),
			"runner unsupported readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner unsupported readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner unsupported readiness late jsonl line code");
		assertStringEquals("turn-6", outcome.latestReadinessActiveTurnIdText(), "runner unsupported readiness active retained after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner unsupported readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner unsupported readiness no completion");
		assertStringEquals("turn-6", outcome.activeTurnIdText(), "runner unsupported readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner unsupported readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner unsupported readiness transcript count");
		assertStringEquals("user> oops", shell.transcriptAt(1).renderText(), "runner unsupported readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner unsupported readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner unsupported readiness outbound lines");
		assertIntEquals(promptLines.length + lateLines.length, outcome.promptTransportInboundLineCount(), "runner unsupported readiness inbound lines");
	}

	static function testReadinessSourceUnsupportedNotificationRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(12), activeSession, activeThread, "sourceoops");
		final promptRequest = TuiPromptJsonRpcRequest.turnStart(promptEnvelope);
		final promptLines = submittedTurnInboundLines(promptRequest, promptEnvelope);
		final lateLines = [
			TuiPromptThreadStatusChangedNotification.active(activeThread).messageJson() + "\n"
		];
		final inbound = promptLines.copy();
		for (line in lateLines)
			inbound.push(line);
		final appServerTransport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan(inbound)),
			promptLines.length);
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(64,
				2)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessSource(TuiLiveShellReadinessSource.queued([TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source unsupported readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source unsupported readiness accepted prompts");
		assertIntEquals(1, outcome.appServerReadinessEvents(), "runner source unsupported readiness event count");
		assertIntEquals(1, outcome.appServerReadinessDrained(), "runner source unsupported readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source unsupported readiness no-pending count");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source unsupported readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source unsupported readiness late jsonl drain status");
		assertStringEquals("unsupported_stream_notification", outcome.latestReadinessLateJsonlDrainCode(),
			"runner source unsupported readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source unsupported readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source unsupported readiness late jsonl line code");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source unsupported readiness applied notification count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source unsupported readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source unsupported readiness completion count evidence");
		assertStringEquals("turn-12", outcome.latestReadinessActiveTurnIdText(), "runner source unsupported readiness active retained after rejection");
		assertStringEquals("turn-12", outcome.lastStartedTurnIdText(), "runner source unsupported readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source unsupported readiness no completion");
		assertStringEquals("turn-12", outcome.activeTurnIdText(), "runner source unsupported readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source unsupported readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner source unsupported readiness transcript count");
		assertStringEquals("user> sourceoops", shell.transcriptAt(1).renderText(), "runner source unsupported readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source unsupported readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source unsupported readiness outbound lines");
		assertIntEquals(promptLines.length + lateLines.length, outcome.promptTransportInboundLineCount(), "runner source unsupported readiness inbound lines");
	}

	static function testReadinessDecodeRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"unknown/event\",\"params\":{}}\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(32, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner decode readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner decode readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner decode readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner decode readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner decode readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner decode readiness no-data count");
		assertStringEquals("turn-8", outcome.latestNoDataReadinessActiveTurnIdText(), "runner decode readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner decode readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner decode readiness late jsonl drain status");
		assertStringEquals("unknown_inbound_method", outcome.latestReadinessLateJsonlDrainCode(), "runner decode readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner decode readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner decode readiness late jsonl line code");
		assertStringEquals("turn-8", outcome.latestReadinessActiveTurnIdText(), "runner decode readiness active retained after rejection");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner decode readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner decode readiness no completion");
		assertStringEquals("turn-8", outcome.activeTurnIdText(), "runner decode readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner decode readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner decode readiness transcript count");
		assertStringEquals("user> decode", shell.transcriptAt(1).renderText(), "runner decode readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner decode readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner decode readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner decode readiness inbound lines");
	}

	static function testReadinessSourceDecodeRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"unknown/event\",\"params\":{}}\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(72, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source decode readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source decode readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source decode readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source decode readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source decode readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source decode readiness no-data count");
		assertStringEquals("turn-14", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source decode readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner source decode readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source decode readiness late jsonl drain status");
		assertStringEquals("unknown_inbound_method", outcome.latestReadinessLateJsonlDrainCode(), "runner source decode readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source decode readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source decode readiness late jsonl line code");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source decode readiness applied notification count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source decode readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source decode readiness completion count evidence");
		assertStringEquals("turn-14", outcome.latestReadinessActiveTurnIdText(), "runner source decode readiness active retained after rejection");
		assertStringEquals("turn-14", outcome.lastStartedTurnIdText(), "runner source decode readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source decode readiness no completion");
		assertStringEquals("turn-14", outcome.activeTurnIdText(), "runner source decode readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source decode readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner source decode readiness transcript count");
		assertStringEquals("user> sourcedecode", shell.transcriptAt(1).renderText(), "runner source decode readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source decode readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source decode readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner source decode readiness inbound lines");
	}

	static function testReadinessMalformedJsonRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(34, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner malformed readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner malformed readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner malformed readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner malformed readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner malformed readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner malformed readiness no-data count");
		assertStringEquals("turn-9", outcome.latestNoDataReadinessActiveTurnIdText(), "runner malformed readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner malformed readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner malformed readiness late jsonl drain status");
		assertStringEquals("invalid_json_line", outcome.latestReadinessLateJsonlDrainCode(), "runner malformed readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner malformed readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner malformed readiness late jsonl line code");
		assertStringEquals("turn-9", outcome.latestReadinessActiveTurnIdText(), "runner malformed readiness active retained after rejection");
		assertStringEquals("turn-9", outcome.lastStartedTurnIdText(), "runner malformed readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner malformed readiness no completion");
		assertStringEquals("turn-9", outcome.activeTurnIdText(), "runner malformed readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner malformed readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner malformed readiness transcript count");
		assertStringEquals("user> malform", shell.transcriptAt(1).renderText(), "runner malformed readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner malformed readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner malformed readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner malformed readiness inbound lines");
	}

	static function testReadinessSourceMalformedJsonRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(80, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source malformed readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source malformed readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source malformed readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source malformed readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source malformed readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source malformed readiness no-data count");
		assertStringEquals("turn-15", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source malformed readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source malformed readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source malformed readiness late jsonl drain status");
		assertStringEquals("invalid_json_line", outcome.latestReadinessLateJsonlDrainCode(), "runner source malformed readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source malformed readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source malformed readiness late jsonl line code");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source malformed readiness applied notification count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source malformed readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source malformed readiness completion count evidence");
		assertStringEquals("turn-15", outcome.latestReadinessActiveTurnIdText(), "runner source malformed readiness active retained after rejection");
		assertStringEquals("turn-15", outcome.lastStartedTurnIdText(), "runner source malformed readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source malformed readiness no completion");
		assertStringEquals("turn-15", outcome.activeTurnIdText(), "runner source malformed readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source malformed readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner source malformed readiness transcript count");
		assertStringEquals("user> sourcemalform", shell.transcriptAt(1).renderText(), "runner source malformed readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source malformed readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source malformed readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner source malformed readiness inbound lines");
	}

	static function testReadinessSchemaRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{}}\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(34, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner schema readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner schema readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner schema readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner schema readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner schema readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner schema readiness no-data count");
		assertStringEquals("turn-8", outcome.latestNoDataReadinessActiveTurnIdText(), "runner schema readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner schema readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner schema readiness late jsonl drain status");
		assertStringEquals("missing_field", outcome.latestReadinessLateJsonlDrainCode(), "runner schema readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner schema readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner schema readiness late jsonl line code");
		assertStringEquals("turn-8", outcome.latestReadinessActiveTurnIdText(), "runner schema readiness active retained after rejection");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner schema readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner schema readiness no completion");
		assertStringEquals("turn-8", outcome.activeTurnIdText(), "runner schema readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner schema readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner schema readiness transcript count");
		assertStringEquals("user> schema", shell.transcriptAt(1).renderText(), "runner schema readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner schema readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner schema readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner schema readiness inbound lines");
	}

	static function testReadinessSourceSchemaRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final lateLines = ["{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{}}\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(80, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source schema readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source schema readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source schema readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source schema readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source schema readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source schema readiness no-data count");
		assertStringEquals("turn-14", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source schema readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner source schema readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source schema readiness late jsonl drain status");
		assertStringEquals("missing_field", outcome.latestReadinessLateJsonlDrainCode(), "runner source schema readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source schema readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source schema readiness late jsonl line code");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source schema readiness applied notification count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source schema readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source schema readiness completion count evidence");
		assertStringEquals("turn-14", outcome.latestReadinessActiveTurnIdText(), "runner source schema readiness active retained after rejection");
		assertStringEquals("turn-14", outcome.lastStartedTurnIdText(), "runner source schema readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source schema readiness no completion");
		assertStringEquals("turn-14", outcome.activeTurnIdText(), "runner source schema readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source schema readiness completed count");
		assertIntEquals(2, shell.transcriptCount(), "runner source schema readiness transcript count");
		assertStringEquals("user> sourceschema", shell.transcriptAt(1).renderText(), "runner source schema readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source schema readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source schema readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner source schema readiness inbound lines");
	}

	static function testReadinessPrefixThenSchemaRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-8");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-schema-8"), "runner prefix schema delta").messageJson()
				+ "\n",
			"{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{}}\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-schema readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-schema readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner prefix-schema readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner prefix-schema readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix-schema readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-schema readiness no-data count");
		assertStringEquals("turn-8", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-schema readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner prefix-schema readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-schema readiness late jsonl drain status");
		assertStringEquals("missing_field", outcome.latestReadinessLateJsonlDrainCode(), "runner prefix-schema readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-schema readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-schema readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix-schema readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix-schema readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix-schema readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner prefix-schema readiness applied thread evidence");
		assertStringEquals("turn-8", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix-schema readiness applied turn evidence");
		assertStringEquals("runner prefix schema delta", outcome.latestReadinessLateJsonlDeltaText(), "runner prefix-schema readiness applied delta evidence");
		assertStringEquals("turn-8", outcome.latestReadinessActiveTurnIdText(), "runner prefix-schema readiness active retained after rejection");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner prefix-schema readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-schema readiness no completion");
		assertStringEquals("turn-8", outcome.activeTurnIdText(), "runner prefix-schema readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-schema readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-schema readiness transcript count");
		assertStringEquals("user> schema", shell.transcriptAt(1).renderText(), "runner prefix-schema readiness user row");
		assertStringEquals("assistant> runner prefix schema delta", shell.transcriptAt(2).renderText(), "runner prefix-schema readiness assistant row");
		assertStringEquals("assistant> runner prefix schema delta", outcome.finalFrameLineAt(4), "runner prefix-schema readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-schema readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix-schema readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner prefix-schema readiness inbound lines");
	}

	static function testReadinessSourcePrefixThenSchemaRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-20");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-prefix-schema-20"),
				"runner source prefix schema delta").messageJson()
				+ "\n",
			"{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":{}}\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(96, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source prefix-schema readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source prefix-schema readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source prefix-schema readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source prefix-schema readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source prefix-schema readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source prefix-schema readiness no-data count");
		assertStringEquals("turn-20", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source prefix-schema readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source prefix-schema readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source prefix-schema readiness late jsonl drain status");
		assertStringEquals("missing_field", outcome.latestReadinessLateJsonlDrainCode(), "runner source prefix-schema readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source prefix-schema readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source prefix-schema readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source prefix-schema readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source prefix-schema readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source prefix-schema readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(),
			"runner source prefix-schema readiness applied thread evidence");
		assertStringEquals("turn-20", outcome.latestReadinessLateJsonlTurnIdText(), "runner source prefix-schema readiness applied turn evidence");
		assertStringEquals("runner source prefix schema delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner source prefix-schema readiness applied delta evidence");
		assertStringEquals("turn-20", outcome.latestReadinessActiveTurnIdText(), "runner source prefix-schema readiness active retained after rejection");
		assertStringEquals("turn-20", outcome.lastStartedTurnIdText(), "runner source prefix-schema readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source prefix-schema readiness no completion");
		assertStringEquals("turn-20", outcome.activeTurnIdText(), "runner source prefix-schema readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source prefix-schema readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner source prefix-schema readiness transcript count");
		assertStringEquals("user> sourceprefixschema", shell.transcriptAt(1).renderText(), "runner source prefix-schema readiness user row");
		assertStringEquals("assistant> runner source prefix schema delta", shell.transcriptAt(2).renderText(),
			"runner source prefix-schema readiness assistant row");
		assertStringEquals("assistant> runner source prefix schema delta", outcome.finalFrameLineAt(4), "runner source prefix-schema readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source prefix-schema readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source prefix-schema readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner source prefix-schema readiness inbound lines");
	}

	static function testReadinessPrefixThenDecodeRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-8");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-decode-8"), "runner prefix decode delta").messageJson()
				+ "\n",
			"{\"jsonrpc\":\"2.0\",\"method\":\"unknown/event\",\"params\":{}}\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-decode readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-decode readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner prefix-decode readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner prefix-decode readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix-decode readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-decode readiness no-data count");
		assertStringEquals("turn-8", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-decode readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner prefix-decode readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-decode readiness late jsonl drain status");
		assertStringEquals("unknown_inbound_method", outcome.latestReadinessLateJsonlDrainCode(), "runner prefix-decode readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-decode readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-decode readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix-decode readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix-decode readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix-decode readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(), "runner prefix-decode readiness applied thread evidence");
		assertStringEquals("turn-8", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix-decode readiness applied turn evidence");
		assertStringEquals("runner prefix decode delta", outcome.latestReadinessLateJsonlDeltaText(), "runner prefix-decode readiness applied delta evidence");
		assertStringEquals("turn-8", outcome.latestReadinessActiveTurnIdText(), "runner prefix-decode readiness active retained after rejection");
		assertStringEquals("turn-8", outcome.lastStartedTurnIdText(), "runner prefix-decode readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-decode readiness no completion");
		assertStringEquals("turn-8", outcome.activeTurnIdText(), "runner prefix-decode readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-decode readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-decode readiness transcript count");
		assertStringEquals("user> decode", shell.transcriptAt(1).renderText(), "runner prefix-decode readiness user row");
		assertStringEquals("assistant> runner prefix decode delta", shell.transcriptAt(2).renderText(), "runner prefix-decode readiness assistant row");
		assertStringEquals("assistant> runner prefix decode delta", outcome.finalFrameLineAt(4), "runner prefix-decode readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-decode readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix-decode readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner prefix-decode readiness inbound lines");
	}

	static function testReadinessSourcePrefixThenDecodeRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-20");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-source-prefix-decode-20"),
				"runner source prefix decode delta").messageJson()
				+ "\n",
			"{\"jsonrpc\":\"2.0\",\"method\":\"unknown/event\",\"params\":{}}\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("u")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [],
			TuiLiveShellRunPolicy.bounded(96, 3)).withJsonRpcPromptTransport(promptTransport).withReadinessSource(TuiLiveShellReadinessSource.queued([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]));
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner source prefix-decode readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner source prefix-decode readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner source prefix-decode readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner source prefix-decode readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner source prefix-decode readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner source prefix-decode readiness no-data count");
		assertStringEquals("turn-20", outcome.latestNoDataReadinessActiveTurnIdText(), "runner source prefix-decode readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner source prefix-decode readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner source prefix-decode readiness late jsonl drain status");
		assertStringEquals("unknown_inbound_method", outcome.latestReadinessLateJsonlDrainCode(),
			"runner source prefix-decode readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner source prefix-decode readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner source prefix-decode readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner source prefix-decode readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner source prefix-decode readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner source prefix-decode readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(),
			"runner source prefix-decode readiness applied thread evidence");
		assertStringEquals("turn-20", outcome.latestReadinessLateJsonlTurnIdText(), "runner source prefix-decode readiness applied turn evidence");
		assertStringEquals("runner source prefix decode delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner source prefix-decode readiness applied delta evidence");
		assertStringEquals("turn-20", outcome.latestReadinessActiveTurnIdText(), "runner source prefix-decode readiness active retained after rejection");
		assertStringEquals("turn-20", outcome.lastStartedTurnIdText(), "runner source prefix-decode readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner source prefix-decode readiness no completion");
		assertStringEquals("turn-20", outcome.activeTurnIdText(), "runner source prefix-decode readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner source prefix-decode readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner source prefix-decode readiness transcript count");
		assertStringEquals("user> sourceprefixdecode", shell.transcriptAt(1).renderText(), "runner source prefix-decode readiness user row");
		assertStringEquals("assistant> runner source prefix decode delta", shell.transcriptAt(2).renderText(),
			"runner source prefix-decode readiness assistant row");
		assertStringEquals("assistant> runner source prefix decode delta", outcome.finalFrameLineAt(4), "runner source prefix-decode readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner source prefix-decode readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner source prefix-decode readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner source prefix-decode readiness inbound lines");
	}

	static function testReadinessPrefixThenMalformedJsonRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-9");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-malformed-9"),
				"runner prefix malformed delta").messageJson()
				+ "\n",
			"{\"jsonrpc\":\"2.0\",\"method\":\"turn/completed\",\"params\":\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("r")),
			TerminalEvent.Key(TerminalKey.Character("m")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-malformed readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-malformed readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner prefix-malformed readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner prefix-malformed readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix-malformed readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-malformed readiness no-data count");
		assertStringEquals("turn-9", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-malformed readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner prefix-malformed readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-malformed readiness late jsonl drain status");
		assertStringEquals("invalid_json_line", outcome.latestReadinessLateJsonlDrainCode(), "runner prefix-malformed readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-malformed readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-malformed readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix-malformed readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix-malformed readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix-malformed readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(),
			"runner prefix-malformed readiness applied thread evidence");
		assertStringEquals("turn-9", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix-malformed readiness applied turn evidence");
		assertStringEquals("runner prefix malformed delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner prefix-malformed readiness applied delta evidence");
		assertStringEquals("turn-9", outcome.latestReadinessActiveTurnIdText(), "runner prefix-malformed readiness active retained after rejection");
		assertStringEquals("turn-9", outcome.lastStartedTurnIdText(), "runner prefix-malformed readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-malformed readiness no completion");
		assertStringEquals("turn-9", outcome.activeTurnIdText(), "runner prefix-malformed readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-malformed readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-malformed readiness transcript count");
		assertStringEquals("user> malform", shell.transcriptAt(1).renderText(), "runner prefix-malformed readiness user row");
		assertStringEquals("assistant> runner prefix malformed delta", shell.transcriptAt(2).renderText(), "runner prefix-malformed readiness assistant row");
		assertStringEquals("assistant> runner prefix malformed delta", outcome.finalFrameLineAt(4), "runner prefix-malformed readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-malformed readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix-malformed readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner prefix-malformed readiness inbound lines");
	}

	static function testReadinessPrefixThenUnsupportedNotificationRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-6");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-unsupported-6"),
				"runner prefix unsupported delta").messageJson()
				+ "\n",
			TuiPromptThreadStatusChangedNotification.active(activeThread).messageJson() + "\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("p")),
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(34, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-unsupported readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-unsupported readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner prefix-unsupported readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner prefix-unsupported readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix-unsupported readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-unsupported readiness no-data count");
		assertStringEquals("turn-6", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-unsupported readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner prefix-unsupported readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-unsupported readiness late jsonl drain status");
		assertStringEquals("unsupported_stream_notification", outcome.latestReadinessLateJsonlDrainCode(),
			"runner prefix-unsupported readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-unsupported readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-unsupported readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix-unsupported readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix-unsupported readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix-unsupported readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(),
			"runner prefix-unsupported readiness applied thread evidence");
		assertStringEquals("turn-6", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix-unsupported readiness applied turn evidence");
		assertStringEquals("runner prefix unsupported delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner prefix-unsupported readiness applied delta evidence");
		assertStringEquals("turn-6", outcome.latestReadinessActiveTurnIdText(), "runner prefix-unsupported readiness active retained after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner prefix-unsupported readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-unsupported readiness no completion");
		assertStringEquals("turn-6", outcome.activeTurnIdText(), "runner prefix-unsupported readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-unsupported readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-unsupported readiness transcript count");
		assertStringEquals("user> oops", shell.transcriptAt(1).renderText(), "runner prefix-unsupported readiness user row");
		assertStringEquals("assistant> runner prefix unsupported delta", shell.transcriptAt(2).renderText(),
			"runner prefix-unsupported readiness assistant row");
		assertStringEquals("assistant> runner prefix unsupported delta", outcome.finalFrameLineAt(4), "runner prefix-unsupported readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-unsupported readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix-unsupported readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner prefix-unsupported readiness inbound lines");
	}

	static function testReadinessPrefixThenLineReadRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-6");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-line-read-6"),
				"runner prefix line-read delta").messageJson()
				+ "\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataThenRejectedLateJsonlLineTransportAttacher(lateLines, "runner_late_jsonl_read_failed")));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("f")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(34, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 3)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-line-read readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-line-read readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner prefix-line-read readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner prefix-line-read readiness drained count");
		assertIntEquals(0, outcome.appServerReadinessNoPending(), "runner prefix-line-read readiness no-pending count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-line-read readiness no-data count");
		assertStringEquals("turn-6", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-line-read readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner prefix-line-read readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.LineReadRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-line-read readiness late jsonl drain status");
		assertStringEquals("runner_late_jsonl_read_failed", outcome.latestReadinessLateJsonlDrainCode(),
			"runner prefix-line-read readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Disconnected.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-line-read readiness late jsonl line status");
		assertStringEquals("runner_late_jsonl_read_failed", outcome.latestReadinessLateJsonlLineCode(),
			"runner prefix-line-read readiness late jsonl line code");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAppliedNotificationCount(), "runner prefix-line-read readiness applied notification count");
		assertIntEquals(1, outcome.latestReadinessLateJsonlAssistantDeltaCount(), "runner prefix-line-read readiness assistant delta count");
		assertIntEquals(0, outcome.latestReadinessLateJsonlCompletionCount(), "runner prefix-line-read readiness completion count evidence");
		assertStringEquals(activeThread.toString(), outcome.latestReadinessLateJsonlThreadIdText(),
			"runner prefix-line-read readiness applied thread evidence");
		assertStringEquals("turn-6", outcome.latestReadinessLateJsonlTurnIdText(), "runner prefix-line-read readiness applied turn evidence");
		assertStringEquals("runner prefix line-read delta", outcome.latestReadinessLateJsonlDeltaText(),
			"runner prefix-line-read readiness applied delta evidence");
		assertStringEquals("turn-6", outcome.latestReadinessActiveTurnIdText(), "runner prefix-line-read readiness active retained after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner prefix-line-read readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-line-read readiness no completion");
		assertStringEquals("turn-6", outcome.activeTurnIdText(), "runner prefix-line-read readiness active retained");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-line-read readiness completed count");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-line-read readiness transcript count");
		assertStringEquals("user> fail", shell.transcriptAt(1).renderText(), "runner prefix-line-read readiness user row");
		assertStringEquals("assistant> runner prefix line-read delta", shell.transcriptAt(2).renderText(), "runner prefix-line-read readiness assistant row");
		assertStringEquals("assistant> runner prefix line-read delta", outcome.finalFrameLineAt(4), "runner prefix-line-read readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-line-read readiness close recorded");
		assertIntEquals(1, outcome.promptTransportOutboundLineCount(), "runner prefix-line-read readiness outbound lines");
		assertIntEquals(3, outcome.promptTransportInboundLineCount(), "runner prefix-line-read readiness inbound lines");
	}

	static function testReadinessPrefixThenStaleInterruptedRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-7");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-stale-7"), "runner prefix stale delta").messageJson()
				+ "\n",
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-stale-late-7"), "runner stale after prefix")
				.messageJson() + "\n"];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(42, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 1),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-stale readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-stale readiness accepted prompts");
		assertIntEquals(3, outcome.appServerReadinessEvents(), "runner prefix-stale readiness event count");
		assertIntEquals(3, outcome.appServerReadinessDrained(), "runner prefix-stale readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-stale readiness no-data count");
		assertStringEquals("turn-7", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-stale readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner prefix-stale readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-stale readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnStreamDeliveryStatus.StaleInterruptedTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner prefix-stale readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-stale readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-stale readiness late jsonl line code");
		assertStringEquals("", outcome.latestReadinessActiveTurnIdText(), "runner prefix-stale readiness active remains cleared after rejection");
		assertStringEquals("turn-7", outcome.lastStartedTurnIdText(), "runner prefix-stale readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-stale readiness no completion");
		assertStringEquals("turn-7", outcome.lastInterruptedTurnIdText(), "runner prefix-stale readiness last interrupted");
		assertStringEquals("", outcome.activeTurnIdText(), "runner prefix-stale readiness active cleared by interrupt");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-stale readiness completed count");
		assertIntEquals(1, outcome.interruptedTurns(), "runner prefix-stale readiness interrupted count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "runner prefix-stale readiness interrupt code");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-stale readiness transcript count");
		assertStringEquals("user> stale", shell.transcriptAt(1).renderText(), "runner prefix-stale readiness user row");
		assertStringEquals("assistant> runner prefix stale delta", shell.transcriptAt(2).renderText(), "runner prefix-stale readiness assistant row");
		assertStringEquals("assistant> runner prefix stale delta", outcome.finalFrameLineAt(4), "runner prefix-stale readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-stale readiness close recorded");
		assertIntEquals(2, outcome.promptTransportOutboundLineCount(), "runner prefix-stale readiness outbound lines");
		assertIntEquals(5, outcome.promptTransportInboundLineCount(), "runner prefix-stale readiness inbound lines");
	}

	static function testReadinessPrefixThenStaleInterruptedCompletionRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final turnId = turn("turn-6");
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-prefix-stale-completion-6"),
				"runner prefix stale completion delta").messageJson()
				+ "\n",
			turnCompletedLine(activeThread, turnId)
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(40, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 1),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner prefix-stale-completion readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner prefix-stale-completion readiness accepted prompts");
		assertIntEquals(3, outcome.appServerReadinessEvents(), "runner prefix-stale-completion readiness event count");
		assertIntEquals(3, outcome.appServerReadinessDrained(), "runner prefix-stale-completion readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner prefix-stale-completion readiness no-data count");
		assertStringEquals("turn-6", outcome.latestNoDataReadinessActiveTurnIdText(), "runner prefix-stale-completion readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner prefix-stale-completion readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner prefix-stale-completion readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnCompletionStatus.StaleInterruptedTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner prefix-stale-completion readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner prefix-stale-completion readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner prefix-stale-completion readiness late jsonl line code");
		assertStringEquals("", outcome.latestReadinessActiveTurnIdText(), "runner prefix-stale-completion readiness active remains cleared after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner prefix-stale-completion readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner prefix-stale-completion readiness no completion");
		assertStringEquals("turn-6", outcome.lastInterruptedTurnIdText(), "runner prefix-stale-completion readiness last interrupted");
		assertStringEquals("", outcome.activeTurnIdText(), "runner prefix-stale-completion readiness active cleared by interrupt");
		assertIntEquals(0, outcome.completedTurns(), "runner prefix-stale-completion readiness completed count");
		assertIntEquals(1, outcome.interruptedTurns(), "runner prefix-stale-completion readiness interrupted count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "runner prefix-stale-completion readiness interrupt code");
		assertIntEquals(3, shell.transcriptCount(), "runner prefix-stale-completion readiness transcript count");
		assertStringEquals("user> done", shell.transcriptAt(1).renderText(), "runner prefix-stale-completion readiness user row");
		assertStringEquals("assistant> runner prefix stale completion delta", shell.transcriptAt(2).renderText(),
			"runner prefix-stale-completion readiness assistant row");
		assertStringEquals("assistant> runner prefix stale completion delta", outcome.finalFrameLineAt(4),
			"runner prefix-stale-completion readiness final frame");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner prefix-stale-completion readiness close recorded");
		assertIntEquals(2, outcome.promptTransportOutboundLineCount(), "runner prefix-stale-completion readiness outbound lines");
		assertIntEquals(5, outcome.promptTransportInboundLineCount(), "runner prefix-stale-completion readiness inbound lines");
	}

	static function testReadinessStaleInterruptedRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(7), activeSession, activeThread, "stale");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [
			new TuiPromptAgentMessageDeltaNotification(activeThread, turnId, item("item-runner-stale-7"), "runner stale delta").messageJson() + "\n"
		];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("s")),
			TerminalEvent.Key(TerminalKey.Character("t")),
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("l")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(36, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner stale readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner stale readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner stale readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner stale readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner stale readiness no-data count");
		assertStringEquals("turn-7", outcome.latestNoDataReadinessActiveTurnIdText(), "runner stale readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(), "runner stale readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner stale readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnStreamDeliveryStatus.StaleInterruptedTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner stale readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner stale readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner stale readiness late jsonl line code");
		assertStringEquals("", outcome.latestReadinessActiveTurnIdText(), "runner stale readiness active remains cleared after rejection");
		assertStringEquals("turn-7", outcome.lastStartedTurnIdText(), "runner stale readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner stale readiness no completion");
		assertStringEquals("turn-7", outcome.lastInterruptedTurnIdText(), "runner stale readiness last interrupted");
		assertStringEquals("", outcome.activeTurnIdText(), "runner stale readiness active cleared by interrupt");
		assertIntEquals(0, outcome.completedTurns(), "runner stale readiness completed count");
		assertIntEquals(1, outcome.interruptedTurns(), "runner stale readiness interrupted count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "runner stale readiness interrupt code");
		assertIntEquals(2, shell.transcriptCount(), "runner stale readiness transcript count");
		assertStringEquals("user> stale", shell.transcriptAt(1).renderText(), "runner stale readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner stale readiness close recorded");
		assertIntEquals(2, outcome.promptTransportOutboundLineCount(), "runner stale readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner stale readiness inbound lines");
	}

	static function testReadinessStaleInterruptedCompletionRejectionRoutesThroughRunner():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000110001");
		final activeSession = session("00000000-0000-0000-0000-000000119999");
		final promptEnvelope = new TuiPromptSubmitEnvelope(RequestId.fromInteger(6), activeSession, activeThread, "done");
		final turnId = TuiPromptTurnStartResponse.fromEnvelope(promptEnvelope).turnId;
		final lateLines = [turnCompletedLine(activeThread, turnId)];
		final appServerTransport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(stdioPersistentPlan([])),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(),
				new RunnerNoDataLateJsonlLineTransportAttacher(lateLines)));
		final promptTransport = new JsonRpcTuiPromptTransport(appServerTransport, TuiPromptTurnAcceptanceMode.Submitted);
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("d")),
			TerminalEvent.Key(TerminalKey.Character("o")),
			TerminalEvent.Key(TerminalKey.Character("n")),
			TerminalEvent.Key(TerminalKey.Character("e")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.Key(TerminalKey.CtrlC),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final requestValue = request(shell, backend, [], TuiLiveShellRunPolicy.bounded(34, 3)).withJsonRpcPromptTransport(promptTransport)
			.withReadinessEvents([
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2),
				TuiAppServerReadinessEvent.SubmittedTurnLateJsonlReady(1, 2)
			]);
		final outcome = TuiLiveShellRunner.run(requestValue);

		assertIntEquals(1, outcome.submittedPrompts(), "runner stale completion readiness submitted prompts");
		assertIntEquals(1, outcome.acceptedPrompts(), "runner stale completion readiness accepted prompts");
		assertIntEquals(2, outcome.appServerReadinessEvents(), "runner stale completion readiness event count");
		assertIntEquals(2, outcome.appServerReadinessDrained(), "runner stale completion readiness drained count");
		assertIntEquals(1, outcome.appServerReadinessNoDataCount(), "runner stale completion readiness no-data count");
		assertStringEquals("turn-6", outcome.latestNoDataReadinessActiveTurnIdText(), "runner stale completion readiness no-data active retained");
		assertStringEquals(TuiAppServerReadinessInteractionStatus.Drained.text(), outcome.latestReadinessStatusText(),
			"runner stale completion readiness status");
		assertStringEquals(TuiPromptSubmittedTurnLateJsonlDrainStatus.BatchRejected.text(), outcome.latestReadinessLateJsonlDrainStatusText(),
			"runner stale completion readiness late jsonl drain status");
		assertStringEquals(TuiPromptSubmittedTurnCompletionStatus.StaleInterruptedTurn.text(), outcome.latestReadinessLateJsonlDrainCode(),
			"runner stale completion readiness late jsonl drain code");
		assertStringEquals(TuiAppServerJsonRpcTransportStatus.Accepted.text(), outcome.latestReadinessLateJsonlLineStatusText(),
			"runner stale completion readiness late jsonl line status");
		assertStringEquals("accepted", outcome.latestReadinessLateJsonlLineCode(), "runner stale completion readiness late jsonl line code");
		assertStringEquals("", outcome.latestReadinessActiveTurnIdText(), "runner stale completion readiness active remains cleared after rejection");
		assertStringEquals("turn-6", outcome.lastStartedTurnIdText(), "runner stale completion readiness last started");
		assertStringEquals("", outcome.lastCompletedTurnIdText(), "runner stale completion readiness no completion");
		assertStringEquals("turn-6", outcome.lastInterruptedTurnIdText(), "runner stale completion readiness last interrupted");
		assertStringEquals("", outcome.activeTurnIdText(), "runner stale completion readiness active cleared by interrupt");
		assertIntEquals(0, outcome.completedTurns(), "runner stale completion readiness completed count");
		assertIntEquals(1, outcome.interruptedTurns(), "runner stale completion readiness interrupted count");
		assertStringEquals("accepted", outcome.lastInterruptCode(), "runner stale completion readiness interrupt code");
		assertIntEquals(2, shell.transcriptCount(), "runner stale completion readiness transcript count");
		assertStringEquals("user> done", shell.transcriptAt(1).renderText(), "runner stale completion readiness user row");
		assertTrue(outcome.promptTransportLineCloseRecorded(), "runner stale completion readiness close recorded");
		assertIntEquals(2, outcome.promptTransportOutboundLineCount(), "runner stale completion readiness outbound lines");
		assertIntEquals(4, outcome.promptTransportInboundLineCount(), "runner stale completion readiness inbound lines");
	}

	static function testEscapeCtrlCAndQExit():Void {
		final escapeBackend = new HeadlessTerminalBackend([TerminalEvent.Key(TerminalKey.Escape)]);
		final escapeOutcome = TuiLiveShellRunner.run(request(ChatWidgetShellState.initial("pending"), escapeBackend, [], TuiLiveShellRunPolicy.bounded(4, 2)));
		assertTrue(escapeOutcome.exitRequested(), "escape exit requested");
		assertReasonEquals(TerminalExitReason.Escape, escapeOutcome.exitReason(), "escape reason");
		assertTrue(escapeOutcome.terminalOperations() >= 2, "escape backend exit operation recorded");

		final ctrlBackend = new HeadlessTerminalBackend([TerminalEvent.Key(TerminalKey.CtrlC)]);
		final ctrlOutcome = TuiLiveShellRunner.run(request(ChatWidgetShellState.initial("pending"), ctrlBackend, [], TuiLiveShellRunPolicy.bounded(4, 2)));
		assertTrue(ctrlOutcome.exitRequested(), "ctrl-c exit requested");
		assertReasonEquals(TerminalExitReason.CtrlC, ctrlOutcome.exitReason(), "ctrl-c reason");
		assertTrue(ctrlOutcome.terminalOperations() >= 2, "ctrl-c backend exit operation recorded");

		final qBackend = new HeadlessTerminalBackend([TerminalEvent.Key(TerminalKey.Character("q"))]);
		final qOutcome = TuiLiveShellRunner.run(request(ChatWidgetShellState.initial("pending"), qBackend, [], TuiLiveShellRunPolicy.bounded(4, 2)));
		assertTrue(qOutcome.exitRequested(), "q exit requested");
		assertReasonEquals(TerminalExitReason.Requested, qOutcome.exitReason(), "q reason");
		assertTrue(qOutcome.terminalOperations() >= 2, "q backend exit operation recorded");
	}

	static function testLiveBackendNoTtyRunPath():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final backend = new LiveTerminalBackend();
		final outcome = TuiLiveShellRunner.run(new TuiLiveShellRunRequest(backend, TerminalSetup.live(TerminalSize.of(88, 10)),
			session("00000000-0000-0000-0000-000000119999"), thread("00000000-0000-0000-0000-000000110001"),
			"gpt-live").withShell(shell).withPolicy(TuiLiveShellRunPolicy.bounded(2, 1)));

		assertTrue(outcome.setupAccepted(), "live setup accepted or no-tty skipped");
		assertTrue(outcome.restored(), "live restore");
		assertTrue(outcome.drawFrames() >= 1, "live draw attempted");
	}

	static function request(shell:ChatWidgetShellState, backend:HeadlessTerminalBackend, initialEvents:Array<TuiAppServerEvent>,
			policy:TuiLiveShellRunPolicy):TuiLiveShellRunRequest {
		return new TuiLiveShellRunRequest(backend, TerminalSetup.headless(TerminalSize.of(96, 12)), session("00000000-0000-0000-0000-000000119999"),
			thread("00000000-0000-0000-0000-000000110001"), "gpt-live").withShell(shell).withPolicy(policy).withInitialEvents(initialEvents);
	}

	static function session(value:String):SessionId {
		return SessionId.unsafeAssumeValid(value);
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function item(value:String):ItemId {
		final parsed = ItemId.fromString(value);
		if (parsed == null)
			throw "invalid item id " + value;
		return parsed;
	}

	static function turn(value:String):TurnId {
		final parsed = TurnId.fromString(value);
		if (parsed == null)
			throw "invalid turn id " + value;
		return parsed;
	}

	static function stdioPersistentPlan(lines:Array<String>):TuiAppServerJsonRpcProcessLaunchPlan {
		final args = [
			"-c",
			"printf '%s\\n' \"$@\"; while IFS= read -r _line; do :; done",
			"codex-hxrust-runner-session"
		];
		for (line in lines)
			args.push(withoutTrailingNewline(line));
		return TuiAppServerJsonRpcProcessLaunchPlan.stdio("sh", args, "", []);
	}

	static function submittedTurnInboundLines(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):Array<String> {
		final response = TuiPromptJsonRpcResponse.turnStart(request, TuiPromptTurnStartResponse.fromEnvelope(envelope));
		return [
			response.messageJson() + "\n",
			TuiPromptThreadStatusChangedNotification.active(envelope.threadId).messageJson() + "\n",
			TuiPromptJsonRpcNotification.turnStarted(envelope, response.result).messageJson() + "\n"
		];
	}

	static function turnCompletedLine(threadId:ThreadId, turnId:TurnId):String {
		return new TuiPromptJsonRpcNotification(TuiPromptJsonRpcNotificationMethod.TurnCompleted, threadId,
			new TuiPromptTurnStartResponse(turnId, TuiPromptTurnStatus.Completed)).messageJson()
			+ "\n";
	}

	static function interruptReadyThenResponseLines(request:TuiPromptTurnInterruptRequest, threadId:ThreadId):Array<String> {
		return [
			TuiPromptThreadStatusChangedNotification.idle(threadId).messageJson() + "\n",
			TuiPromptTurnInterruptResponse.fromRequest(request).messageJson() + "\n"
		];
	}

	static function withoutTrailingNewline(line:String):String {
		if (line == null || line.length == 0)
			return "";
		if (StringTools.endsWith(line, "\n"))
			return line.substr(0, line.length - 1);
		return line;
	}

	static function assertReasonEquals(expected:TerminalExitReason, actual:TerminalExitReason, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertStatusEquals(expected:TuiAppServerJsonRpcLineConnectStatus, actual:TuiAppServerJsonRpcLineConnectStatus, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertTransportStatusEquals(expected:TuiAppServerJsonRpcTransportStatus, actual:TuiAppServerJsonRpcTransportStatus, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertLineTransportStateEquals(expected:TuiAppServerJsonRpcLineTransportState, actual:TuiAppServerJsonRpcLineTransportState,
			label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
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
}

class RunnerRecordingLineConnector implements TuiAppServerJsonRpcLineConnector {
	final opener:DryRunTuiAppServerJsonRpcLineNativeOpener;
	final attacher:DryRunTuiAppServerJsonRpcLineTransportAttacher;
	var lastAttachmentValue:TuiAppServerJsonRpcLineTransportAttachment;
	var connectCalls:Int;
	var transportCalls:Int;

	public function new() {
		this.opener = new DryRunTuiAppServerJsonRpcLineNativeOpener();
		this.attacher = new DryRunTuiAppServerJsonRpcLineTransportAttacher();
		this.lastAttachmentValue = null;
		this.connectCalls = 0;
		this.transportCalls = 0;
	}

	public function connect(endpoint:TuiAppServerJsonRpcLineEndpoint):TuiAppServerJsonRpcLineConnectReport {
		connectCalls = connectCalls + 1;
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
		if (report == null || !report.isReady())
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

class RunnerNoDataLateJsonlLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	final transport:RunnerNoDataLateJsonlLineTransport;

	public function new(lateLines:Array<String>) {
		this.transport = new RunnerNoDataLateJsonlLineTransport(lateLines);
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		if (!concrete.isOpened())
			return TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
		return TuiAppServerJsonRpcLineTransportAttachment.ready(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		if (attachment == null || !attachment.isReady())
			return null;
		return transport;
	}
}

class RunnerRejectedLateJsonlLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	final transport:RunnerRejectedLateJsonlLineTransport;

	public function new(readRejectCode:String) {
		this.transport = new RunnerRejectedLateJsonlLineTransport(readRejectCode);
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		if (!concrete.isOpened())
			return TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
		return TuiAppServerJsonRpcLineTransportAttachment.ready(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		if (attachment == null || !attachment.isReady())
			return null;
		return transport;
	}
}

class RunnerNoDataThenRejectedLateJsonlLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	final transport:RunnerNoDataThenRejectedLateJsonlLineTransport;

	public function new(lateLines:Array<String>, readRejectCode:String) {
		this.transport = new RunnerNoDataThenRejectedLateJsonlLineTransport(lateLines, readRejectCode);
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		if (!concrete.isOpened())
			return TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
		return TuiAppServerJsonRpcLineTransportAttachment.ready(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		if (attachment == null || !attachment.isReady())
			return null;
		return transport;
	}
}

class RunnerRejectedLateJsonlLineTransport implements TuiAppServerJsonRpcLineTransport {
	var state:TuiAppServerJsonRpcLineTransportState;
	var outboundLinesValue:Int;
	var inboundLinesValue:Int;
	final readRejectCodeValue:String;

	public function new(readRejectCode:String) {
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.outboundLinesValue = 0;
		this.inboundLinesValue = 0;
		this.readRejectCodeValue = readRejectCode == null || readRejectCode.length == 0 ? "runner_late_jsonl_read_failed" : readRejectCode;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (!isOpen())
			return TuiAppServerJsonRpcLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		outboundLinesValue = outboundLinesValue + 1;
		final response = TuiPromptJsonRpcResponse.turnStart(request, TuiPromptTurnStartResponse.fromEnvelope(envelope));
		final turnStarted = TuiPromptJsonRpcNotification.turnStarted(envelope, response.result);
		final inbound = [response.messageJson() + "\n", turnStarted.messageJson() + "\n"];
		inboundLinesValue = inboundLinesValue + inbound.length;
		return TuiAppServerJsonRpcLineOutcome.accepted(response, [turnStarted], [TuiPromptJsonRpcStreamNotification.Turn(turnStarted)], [], inbound,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
	}

	public function sendInterruptLine(_request:TuiPromptTurnInterruptRequest, _envelope:TuiPromptTurnInterruptEnvelope,
			_outboundLine:String):TuiPromptTurnInterruptLineOutcome {
		return TuiPromptTurnInterruptLineOutcome.rejected("runner_rejected_read_transport_interrupt_unsupported");
	}

	public function readLateJsonlBatchLines(_maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch {
		if (!isOpen())
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_transport_closed", []);
		return TuiAppServerJsonRpcLateJsonlBatch.disconnected(readRejectCodeValue, []);
	}

	public function isOpen():Bool {
		return state == TuiAppServerJsonRpcLineTransportState.Open;
	}

	public function stateText():String {
		return state.text();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		state = TuiAppServerJsonRpcLineTransportState.Closed;
		return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLinesValue, inboundLinesValue);
	}

	public function outboundLineCount():Int {
		return outboundLinesValue;
	}

	public function inboundLineCount():Int {
		return inboundLinesValue;
	}
}

class RunnerNoDataThenRejectedLateJsonlLineTransport implements TuiAppServerJsonRpcLineTransport {
	var state:TuiAppServerJsonRpcLineTransportState;
	var outboundLinesValue:Int;
	var inboundLinesValue:Int;
	final lateLinesValue:Array<String>;
	final readRejectCodeValue:String;
	var lateLineIndex:Int;
	var notReadyReadCount:Int;

	public function new(lateLines:Array<String>, readRejectCode:String) {
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.outboundLinesValue = 0;
		this.inboundLinesValue = 0;
		this.lateLinesValue = lateLines == null ? [] : lateLines.copy();
		this.readRejectCodeValue = readRejectCode == null || readRejectCode.length == 0 ? "runner_late_jsonl_read_failed" : readRejectCode;
		this.lateLineIndex = 0;
		this.notReadyReadCount = 0;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (!isOpen())
			return TuiAppServerJsonRpcLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		outboundLinesValue = outboundLinesValue + 1;
		final response = TuiPromptJsonRpcResponse.turnStart(request, TuiPromptTurnStartResponse.fromEnvelope(envelope));
		final turnStarted = TuiPromptJsonRpcNotification.turnStarted(envelope, response.result);
		final inbound = [response.messageJson() + "\n", turnStarted.messageJson() + "\n"];
		inboundLinesValue = inboundLinesValue + inbound.length;
		return TuiAppServerJsonRpcLineOutcome.accepted(response, [turnStarted], [TuiPromptJsonRpcStreamNotification.Turn(turnStarted)], [], inbound,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
	}

	public function sendInterruptLine(_request:TuiPromptTurnInterruptRequest, _envelope:TuiPromptTurnInterruptEnvelope,
			_outboundLine:String):TuiPromptTurnInterruptLineOutcome {
		return TuiPromptTurnInterruptLineOutcome.rejected("runner_rejected_read_transport_interrupt_unsupported");
	}

	public function readLateJsonlBatchLines(maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch {
		if (!isOpen())
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_transport_closed", []);
		if (notReadyReadCount == 0) {
			notReadyReadCount = notReadyReadCount + 1;
			return TuiAppServerJsonRpcLateJsonlBatch.notReady("late_jsonl_not_ready");
		}
		if (lateLineIndex >= lateLinesValue.length)
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected(readRejectCodeValue, []);
		final limit = maxLines <= 0 ? 0 : maxLines;
		final lines:Array<String> = [];
		while (lines.length < limit && lateLineIndex < lateLinesValue.length) {
			lines.push(lateLinesValue[lateLineIndex]);
			lateLineIndex = lateLineIndex + 1;
		}
		inboundLinesValue = inboundLinesValue + lines.length;
		return TuiAppServerJsonRpcLateJsonlBatch.accepted(lines);
	}

	public function isOpen():Bool {
		return state == TuiAppServerJsonRpcLineTransportState.Open;
	}

	public function stateText():String {
		return state.text();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		state = TuiAppServerJsonRpcLineTransportState.Closed;
		return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLinesValue, inboundLinesValue);
	}

	public function outboundLineCount():Int {
		return outboundLinesValue;
	}

	public function inboundLineCount():Int {
		return inboundLinesValue;
	}
}

class RunnerNoDataLateJsonlLineTransport implements TuiAppServerJsonRpcLineTransport {
	var state:TuiAppServerJsonRpcLineTransportState;
	var outboundLinesValue:Int;
	var inboundLinesValue:Int;
	final lateLinesValue:Array<String>;
	var lateLineIndex:Int;
	var notReadyReadCount:Int;

	public function new(lateLines:Array<String>) {
		this.state = TuiAppServerJsonRpcLineTransportState.Open;
		this.outboundLinesValue = 0;
		this.inboundLinesValue = 0;
		this.lateLinesValue = lateLines == null ? [] : lateLines.copy();
		this.lateLineIndex = 0;
		this.notReadyReadCount = 0;
	}

	public function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome {
		if (!isOpen())
			return TuiAppServerJsonRpcLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (request == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (envelope == null)
			return TuiAppServerJsonRpcLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(outboundLine));
		if (outboundLine != request.messageJson() + "\n")
			return TuiAppServerJsonRpcLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		outboundLinesValue = outboundLinesValue + 1;
		final response = TuiPromptJsonRpcResponse.turnStart(request, TuiPromptTurnStartResponse.fromEnvelope(envelope));
		final turnStarted = TuiPromptJsonRpcNotification.turnStarted(envelope, response.result);
		final inbound = [response.messageJson() + "\n", turnStarted.messageJson() + "\n"];
		inboundLinesValue = inboundLinesValue + inbound.length;
		return TuiAppServerJsonRpcLineOutcome.accepted(response, [turnStarted], [TuiPromptJsonRpcStreamNotification.Turn(turnStarted)], [], inbound,
			TuiAppServerJsonRpcLineTranscript.accepted(outboundLine, inbound));
	}

	public function sendInterruptLine(_request:TuiPromptTurnInterruptRequest, _envelope:TuiPromptTurnInterruptEnvelope,
			_outboundLine:String):TuiPromptTurnInterruptLineOutcome {
		if (!isOpen())
			return TuiPromptTurnInterruptLineOutcome.disconnected("line_transport_closed", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (_request == null)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_request", [], TuiAppServerJsonRpcLineTranscript.empty());
		if (_envelope == null)
			return TuiPromptTurnInterruptLineOutcome.rejected("missing_envelope", [], TuiAppServerJsonRpcLineTranscript.outbound(_outboundLine));
		if (_outboundLine != _request.messageJson() + "\n")
			return TuiPromptTurnInterruptLineOutcome.rejected("mismatched_outbound_line", [], TuiAppServerJsonRpcLineTranscript.empty());
		outboundLinesValue = outboundLinesValue + 1;
		final response = TuiPromptTurnInterruptResponse.fromRequest(_request);
		final inbound = [response.messageJson() + "\n"];
		inboundLinesValue = inboundLinesValue + inbound.length;
		return TuiPromptTurnInterruptLineOutcome.accepted(response, [
			TuiAppServerEvent.ThreadStatus(_envelope.threadId, TuiAppServerThreadStatus.Ready("interrupted"))
		], inbound, TuiAppServerJsonRpcLineTranscript.accepted(_outboundLine, inbound));
	}

	public function readLateJsonlBatchLines(maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch {
		if (!isOpen())
			return TuiAppServerJsonRpcLateJsonlBatch.disconnected("line_transport_closed", []);
		if (notReadyReadCount == 0) {
			notReadyReadCount = notReadyReadCount + 1;
			return TuiAppServerJsonRpcLateJsonlBatch.notReady("late_jsonl_not_ready");
		}
		if (lateLineIndex >= lateLinesValue.length)
			return TuiAppServerJsonRpcLateJsonlBatch.notReady("late_jsonl_not_ready");
		final limit = maxLines <= 0 ? 0 : maxLines;
		final lines:Array<String> = [];
		while (lines.length < limit && lateLineIndex < lateLinesValue.length) {
			lines.push(lateLinesValue[lateLineIndex]);
			lateLineIndex = lateLineIndex + 1;
		}
		inboundLinesValue = inboundLinesValue + lines.length;
		return TuiAppServerJsonRpcLateJsonlBatch.accepted(lines);
	}

	public function isOpen():Bool {
		return state == TuiAppServerJsonRpcLineTransportState.Open;
	}

	public function stateText():String {
		return state.text();
	}

	public function close(code:String):TuiAppServerJsonRpcLineCloseReport {
		state = TuiAppServerJsonRpcLineTransportState.Closed;
		return TuiAppServerJsonRpcLineCloseReport.closed(code, outboundLinesValue, inboundLinesValue);
	}

	public function outboundLineCount():Int {
		return outboundLinesValue;
	}

	public function inboundLineCount():Int {
		return inboundLinesValue;
	}
}

class RunnerLongRunningPromptTransport implements TuiPromptTransport {
	public function new() {}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		final response = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		return TuiPromptTransportOutcome.acceptedWithResponse(response, [
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Working("submitted"))
		]);
	}

	public function interruptTurn(envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome {
		if (envelope == null)
			return TuiPromptTurnInterruptOutcome.rejected("missing_envelope");
		return TuiPromptTurnInterruptOutcome.accepted(new TuiPromptTurnInterruptResponse(envelope.requestId), [
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Ready("interrupted"))
		]);
	}

	public function drainSubmittedTurnLateJsonl(_facade:FakeTuiAppServerFacade, _maxLinesPerBatch:Int,
			_maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult {
		return TuiPromptSubmittedTurnLateJsonlDrainResult.unsupported("prompt_transport_late_jsonl_drain_unsupported");
	}

	public function shutdown(code:String):TuiPromptTransportShutdownReport {
		return TuiPromptTransportShutdownReport.noLineClose(code);
	}
}
