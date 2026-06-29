import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TuiAppServerEventPump;
import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;
import codexhx.runtime.tui.appserver.TuiPromptSubmitEnvelope;
import codexhx.runtime.tui.appserver.TuiPromptSubmitInteraction;
import codexhx.runtime.tui.appserver.TuiPromptTransport;
import codexhx.runtime.tui.appserver.TuiPromptTransportOutcome;
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
		assertStringEquals("user> hello", shell.transcriptAt(1).renderText(), "user row");
		assertStringEquals("assistant> echo: hello", shell.transcriptAt(2).renderText(), "echo row");
		assertStringEquals("Codex | model: gpt-live | status: ready", backend.currentFrame().lineAt(0), "drawn ready header");
		assertStringEquals("assistant> echo: hello", backend.currentFrame().lineAt(4), "drawn echo row");
		assertIntEquals(2, backend.drawCount(), "typing plus submit draw count");
		backend.restore(TerminalRestoreReason.NormalExit);
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
