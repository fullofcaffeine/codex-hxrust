import codexhx.protocol.ItemId;
import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineNativeOpener;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.PersistentTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectStatus;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnectReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpointReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenIntentReport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachment;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachmentReport;
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
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnLateJsonlDrainStatus;
import codexhx.runtime.tui.appserver.TuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiPromptTransportOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTransportShutdownReport;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcNotification;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcRequest;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcResponse;
import codexhx.runtime.tui.appserver.TuiPromptThreadStatusChangedNotification;
import codexhx.runtime.tui.appserver.TuiPromptSubmittedTurnLateJsonlDrainResult;
import codexhx.runtime.tui.appserver.TuiPromptTurnAcceptanceMode;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptOutcome;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptRequest;
import codexhx.runtime.tui.appserver.TuiPromptTurnInterruptResponse;
import codexhx.runtime.tui.appserver.TuiPromptTurnStartResponse;
import codexhx.runtime.tui.appserver.TuiPromptTurnStatus;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.live.TuiLiveShellRunOutcome;
import codexhx.runtime.tui.live.TuiLiveShellRunPolicy;
import codexhx.runtime.tui.live.TuiLiveShellRunRequest;
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
