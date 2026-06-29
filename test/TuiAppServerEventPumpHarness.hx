import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerEventPump;
import codexhx.runtime.tui.appserver.TuiAppServerPumpOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;
import codexhx.runtime.tui.appserver.TuiAppServerShellEffect;
import codexhx.runtime.tui.appserver.TuiAppServerThreadStatus;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiAppServerEventPumpHarness {
	static function main():Void {
		testLosslessPumpUpdatesShellAndDrawsOnce();
		testBoundedDrainLeavesQueuedBackpressure();
		testCancelledDrainPreservesQueue();
		testLiveBackendPumpDrawsAttachedShell();
		Sys.println("tui-app-server-event-pump ok");
	}

	static function testLosslessPumpUpdatesShellAndDrawsOnce():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000001111");
		final facade = attachedFacade(shell, activeThread);
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "headless setup");
		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 12));
		final pump = new TuiAppServerEventPump(facade, scheduler, backend);

		facade.enqueue(TuiAppServerEvent.ThreadStatus(activeThread, TuiAppServerThreadStatus.Working("thinking")));
		facade.enqueue(TuiAppServerEvent.AssistantDelta(activeThread, "First delta."));
		facade.enqueue(TuiAppServerEvent.Disconnected("transport closed"));
		final outcome = pump.drain(TuiAppServerPumpPolicy.lossless());

		assertIntEquals(3, outcome.eventsDrained(), "lossless event count");
		assertFalse(outcome.backpressureApplied(), "lossless should not report backpressure");
		assertFalse(outcome.cancelled(), "lossless should not cancel");
		assertIntEquals(4, outcome.drawRequests(), "draw request count");
		assertIntEquals(1, outcome.schedulerEffectCount(), "scheduler coalesces draws");
		assertIntEquals(1, outcome.schedulerDrawFrameCount(), "draw frame effect count");
		assertIntEquals(1, outcome.terminalOperationCount(), "terminal operation count");
		assertDrawOperation(outcome, 0, "terminal draw operation");
		assertIntEquals(0, facade.queuedCount(), "queue drained");
		assertStatusKindEquals(ChatWidgetStatusKind.Error, shell.statusKind(), "disconnect status kind");
		assertStringEquals("transport closed", shell.statusText(), "disconnect status text");
		assertStringEquals("assistant> First delta.", shell.transcriptAt(1).renderText(), "assistant delta transcript");
		assertStringEquals("system> transport closed", shell.transcriptAt(2).renderText(), "disconnect transcript");
		assertStringEquals("Codex | model: gpt-live | status: transport closed", backend.currentFrame().lineAt(0), "drawn header");
		assertStringEquals("status: error | rows: 3 | rev: 7", backend.currentFrame().lineAt(6), "drawn footer");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testBoundedDrainLeavesQueuedBackpressure():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000002222");
		final facade = attachedFacade(shell, activeThread);
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "bounded setup");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		facade.enqueue(TuiAppServerEvent.AssistantDelta(activeThread, "one"));
		facade.enqueue(TuiAppServerEvent.AssistantDelta(activeThread, "two"));
		final first = pump.drain(TuiAppServerPumpPolicy.bounded(1));
		assertIntEquals(1, first.eventsDrained(), "bounded first event count");
		assertTrue(first.backpressureApplied(), "bounded drain reports backpressure");
		assertIntEquals(1, facade.queuedCount(), "bounded leaves one queued event");
		assertStringEquals("assistant> one", shell.transcriptAt(1).renderText(), "first delta applied");
		assertIntEquals(1, first.terminalOperationCount(), "bounded first draw count");

		final second = pump.drain(TuiAppServerPumpPolicy.lossless());
		assertIntEquals(1, second.eventsDrained(), "second drain event count");
		assertFalse(second.backpressureApplied(), "second drain clears backpressure");
		assertIntEquals(0, facade.queuedCount(), "queue empty after second drain");
		assertStringEquals("assistant> two", shell.transcriptAt(2).renderText(), "second delta applied");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testCancelledDrainPreservesQueue():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000003333");
		final facade = attachedFacade(shell, activeThread);
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "cancel setup");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);
		facade.enqueue(TuiAppServerEvent.ThreadStatus(activeThread, TuiAppServerThreadStatus.Working("should wait")));

		final outcome = pump.drain(TuiAppServerPumpPolicy.cancelled());
		assertTrue(outcome.cancelled(), "cancelled outcome");
		assertIntEquals(0, outcome.eventsDrained(), "cancelled drains no events");
		assertIntEquals(1, facade.queuedCount(), "cancelled preserves queue");
		assertIntEquals(0, backend.drawCount(), "cancelled does not draw");
		assertStatusKindEquals(ChatWidgetStatusKind.Idle, shell.statusKind(), "cancelled leaves status");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testLiveBackendPumpDrawsAttachedShell():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final activeThread = thread("00000000-0000-0000-0000-000000004444");
		final facade = attachedFacade(shell, activeThread);
		final backend = new LiveTerminalBackend();
		assertTrue(backend.setup(TerminalSetup.live(TerminalSize.of(80, 12))).ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(backend.lastReport().status, "live setup status");
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(80, 12)), backend);

		facade.enqueue(TuiAppServerEvent.ThreadStatus(activeThread, TuiAppServerThreadStatus.Working("streaming")));
		facade.enqueue(TuiAppServerEvent.AssistantDelta(activeThread, "Live pump delta."));
		final outcome = pump.drain(TuiAppServerPumpPolicy.lossless());

		assertIntEquals(2, outcome.eventsDrained(), "live pump event count");
		assertIntEquals(1, backend.drawCount(), "live pump draw count");
		assertStatusAccepted(backend.lastReport().status, "live draw status");
		assertStringEquals("Codex | model: gpt-live | status: streaming", backend.currentFrame().lineAt(0), "live header");
		assertStringEquals("assistant> Live pump delta.", backend.currentFrame().lineAt(3), "live assistant delta");
		assertTrue(backend.restore(TerminalRestoreReason.NormalExit).restored, "live restore");
	}

	static function attachedFacade(shell:ChatWidgetShellState, activeThread:ThreadId):FakeTuiAppServerFacade {
		final facade = new FakeTuiAppServerFacade(shell);
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

	static function assertDrawOperation(outcome:TuiAppServerPumpOutcome, index:Int, label:String):Void {
		final kind = outcome.terminalOperationKindAt(index);
		if (kind == null)
			fail(label + ": missing operation");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, kind, label);
		assertTrue(outcome.terminalOperationOkAt(index), label + " ok");
	}

	static function assertStatusAccepted(status:LiveTerminalProbeStatus, label:String):Void {
		if (!status.okForCi())
			throw label + ": " + status.text();
	}

	static function assertOperationKindEquals(expected:TerminalOperationKind, actual:TerminalOperationKind, label:String):Void {
		assertStringEquals(operationKindText(expected), operationKindText(actual), label);
	}

	static function operationKindText(kind:TerminalOperationKind):String {
		return kind;
	}

	static function assertStatusKindEquals(expected:ChatWidgetStatusKind, actual:ChatWidgetStatusKind, label:String):Void {
		assertStringEquals(ChatWidgetShellState.statusKindText(expected), ChatWidgetShellState.statusKindText(actual), label);
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

	static function fail(message:String):Void {
		throw message;
	}
}
