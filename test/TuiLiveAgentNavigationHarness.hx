import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerEventPump;
import codexhx.runtime.tui.appserver.TuiAppServerPumpPolicy;
import codexhx.runtime.tui.appserver.TuiAppServerShellEffect;
import codexhx.runtime.tui.appserver.TuiAppServerThreadStatus;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalInputEvent;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveAgentNavigationHarness {
	static function main():Void {
		testAgentEventsRenderActiveLabel();
		testActiveThreadSwitchTargetsPromptSubmission();
		testSemanticInputCyclesAgents();
		testSemanticInputNoopsForSingleton();
		testComposerInputStillOwnsPlainArrows();
		testRemovalReturnsToPrimaryThread();
		testLiveBackendRendersAgentLabel();
		Sys.println("tui-live-agent-navigation ok");
	}

	static function testAgentEventsRenderActiveLabel():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000010001");
		final child = thread("00000000-0000-0000-0000-000000010002");
		final facade = attachedFacade(shell, primary);
		final backend = setupHeadless();
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(96, 12)), backend);

		facade.enqueue(TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "explorer", false));
		facade.enqueue(TuiAppServerEvent.AgentThreadActivity(child, "agents/robie/side.md", true));
		facade.enqueue(TuiAppServerEvent.ActiveThreadChanged(child));
		facade.enqueue(TuiAppServerEvent.ThreadStatus(child, TuiAppServerThreadStatus.Working("watching agent")));
		final outcome = pump.drain(TuiAppServerPumpPolicy.lossless());

		assertIntEquals(4, outcome.eventsDrained(), "agent events drained");
		assertThreadEquals(child, facade.activeThread(), "active child thread");
		assertStringEquals("`agents/robie/side.md`", shell.activeAgentLabel(), "active path label");
		assertStringEquals("Codex | model: gpt-live | status: watching agent | agent: `agents/robie/side.md`", backend.currentFrame().lineAt(0),
			"rendered agent header");
		assertStringEquals("system> session 00000000-0000-0000-0000-000000019999 attached to thread " + primary.toString(), backend.currentFrame().lineAt(2),
			"primary session row preserved");
		assertTrue(outcome.drawRequests() > 0, "agent events request redraw");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testActiveThreadSwitchTargetsPromptSubmission():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000020001");
		final child = thread("00000000-0000-0000-0000-000000020002");
		final facade = attachedFacade(shell, primary);
		final backend = setupHeadless();
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(96, 12)), backend);

		facade.receive(TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "worker", false));
		facade.receive(TuiAppServerEvent.ActiveThreadChanged(child));
		pump.submitComposerInput(TerminalInputEvent.Text("side task"), RequestId.fromInteger(22), TuiAppServerPumpPolicy.lossless());
		final submit = pump.submitComposerInput(TerminalInputEvent.Submit, RequestId.fromInteger(23), TuiAppServerPumpPolicy.lossless());

		assertTrue(submit.submitAccepted(), "side prompt accepted");
		assertStringEquals(child.toString(), submit.submitThreadIdText(), "prompt targets active child");
		assertStringEquals("Robie [worker]", shell.activeAgentLabel(), "metadata label after active switch");
		assertStringEquals("assistant> echo: side task", backend.currentFrame().lineAt(4), "side prompt echo rendered");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testSemanticInputCyclesAgents():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000050001");
		final first = thread("00000000-0000-0000-0000-000000050002");
		final second = thread("00000000-0000-0000-0000-000000050003");
		final facade = attachedFacade(shell, primary);
		final backend = setupHeadless();
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(96, 12)), backend);
		facade.receive(TuiAppServerEvent.AgentThreadUpsert(first, "Robie", "worker", false));
		facade.receive(TuiAppServerEvent.AgentThreadUpsert(second, "Ari", "reviewer", false));

		final next = pump.submitComposerInput(TerminalInputEvent.AgentNext, RequestId.fromInteger(50), TuiAppServerPumpPolicy.lossless());
		assertFalse(next.hasSubmitResult(), "agent next should not submit prompt");
		assertThreadEquals(first, facade.activeThread(), "agent next moves to first child");
		assertStringEquals("Robie [worker]", shell.activeAgentLabel(), "agent next label");
		assertStringEquals("Codex | model: gpt-live | status: session started | agent: Robie [worker]", backend.currentFrame().lineAt(0),
			"agent next rendered header");

		pump.submitComposerInput(TerminalInputEvent.AgentNext, RequestId.fromInteger(51), TuiAppServerPumpPolicy.lossless());
		assertThreadEquals(second, facade.activeThread(), "agent next moves to second child");
		assertStringEquals("Ari [reviewer]", shell.activeAgentLabel(), "second child label");

		pump.submitComposerInput(TerminalInputEvent.AgentNext, RequestId.fromInteger(52), TuiAppServerPumpPolicy.lossless());
		assertThreadEquals(primary, facade.activeThread(), "agent next wraps to primary");
		assertStringEquals("Main [default]", shell.activeAgentLabel(), "primary label with multiple threads");

		pump.submitComposerInput(TerminalInputEvent.AgentPrevious, RequestId.fromInteger(53), TuiAppServerPumpPolicy.lossless());
		assertThreadEquals(second, facade.activeThread(), "agent previous wraps to second child");
		assertStringEquals("Ari [reviewer]", shell.activeAgentLabel(), "previous label");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testSemanticInputNoopsForSingleton():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000060001");
		final facade = attachedFacade(shell, primary);
		final backend = setupHeadless();
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(96, 12)), backend);

		final interaction = pump.submitComposerInput(TerminalInputEvent.AgentNext, RequestId.fromInteger(60), TuiAppServerPumpPolicy.lossless());
		assertFalse(interaction.hasSubmitResult(), "singleton navigation should not submit");
		assertIntEquals(0, interaction.pumpOutcome().drawRequests(), "singleton navigation no redraw");
		assertThreadEquals(primary, facade.activeThread(), "singleton stays primary");
		assertStringEquals("", shell.activeAgentLabel(), "singleton label remains hidden");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testComposerInputStillOwnsPlainArrows():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000070001");
		final child = thread("00000000-0000-0000-0000-000000070002");
		final facade = attachedFacade(shell, primary);
		final backend = setupHeadless();
		final pump = new TuiAppServerEventPump(facade, new TerminalRedrawScheduler(TerminalSize.of(96, 12)), backend);
		facade.receive(TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "worker", false));

		pump.submitComposerInput(TerminalInputEvent.Text("ab"), RequestId.fromInteger(70), TuiAppServerPumpPolicy.lossless());
		pump.submitComposerInput(TerminalInputEvent.MoveLeft, RequestId.fromInteger(71), TuiAppServerPumpPolicy.lossless());
		pump.submitComposerInput(TerminalInputEvent.Text("c"), RequestId.fromInteger(72), TuiAppServerPumpPolicy.lossless());

		assertThreadEquals(primary, facade.activeThread(), "plain left does not switch agents");
		assertStringEquals("acb", shell.composer().buffer(), "plain left remains composer movement");
		assertStringEquals("Main [default]", shell.activeAgentLabel(), "plain arrow keeps primary agent label");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testRemovalReturnsToPrimaryThread():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000030001");
		final child = thread("00000000-0000-0000-0000-000000030002");
		final facade = attachedFacade(shell, primary);

		facade.receive(TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "worker", false));
		facade.receive(TuiAppServerEvent.ActiveThreadChanged(child));
		final effects = facade.receive(TuiAppServerEvent.AgentThreadRemoved(child));

		assertContainsActiveThreadChanged(primary, effects, "removed active child returns to primary");
		assertThreadEquals(primary, facade.activeThread(), "active primary after removal");
		assertStringEquals("", shell.activeAgentLabel(), "label clears after returning to single primary");
		assertIntEquals(1, facade.agentNavigation().entryCount(), "only primary remains");
	}

	static function testLiveBackendRendersAgentLabel():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final primary = thread("00000000-0000-0000-0000-000000040001");
		final child = thread("00000000-0000-0000-0000-000000040002");
		final facade = attachedFacade(shell, primary);
		final live = new LiveTerminalBackend();
		assertTrue(live.setup(TerminalSetup.live(TerminalSize.of(96, 12))).ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(live.lastReport().status, "live setup status");

		facade.receive(TuiAppServerEvent.AgentThreadUpsert(child, "Robie", "reviewer", false));
		facade.receive(TuiAppServerEvent.ActiveThreadChanged(child));
		final frame = ChatWidgetShellRenderer.render(shell, TerminalSize.of(96, 12));
		assertTrue(live.draw(frame).ok, "live draw");
		assertStatusAccepted(live.lastReport().status, "live draw status");
		assertStringEquals("Codex | model: gpt-live | status: session started | agent: Robie [reviewer]", live.currentFrame().lineAt(0), "live agent header");
		assertTrue(live.restore(TerminalRestoreReason.NormalExit).restored, "live restore");
	}

	static function attachedFacade(shell:ChatWidgetShellState, primary:ThreadId):FakeTuiAppServerFacade {
		final facade = new FakeTuiAppServerFacade(shell);
		final request = RequestId.fromInteger(11);
		facade.startSessionAttach(request, session("00000000-0000-0000-0000-000000019999"), primary, "gpt-live");
		facade.completeSessionAttach(request);
		return facade;
	}

	static function setupHeadless():HeadlessTerminalBackend {
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(96, 12))).ok, "headless setup");
		return backend;
	}

	static function session(value:String):SessionId {
		return SessionId.unsafeAssumeValid(value);
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function assertContainsActiveThreadChanged(expected:ThreadId, effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.ActiveThreadChanged(threadId):
					assertThreadEquals(expected, threadId, label);
					return;
				case _:
			}
		}
		throw label + ": missing active thread change";
	}

	static function assertStatusAccepted(status:LiveTerminalProbeStatus, label:String):Void {
		if (!status.okForCi())
			throw label + ": " + status.text();
	}

	static function assertThreadEquals(expected:ThreadId, actual:Null<ThreadId>, label:String):Void {
		if (actual == null || !expected.equals(actual))
			throw label + ": expected " + expected.toString() + " but got " + threadText(actual);
	}

	static function threadText(value:Null<ThreadId>):String {
		return value == null ? "null" : value.toString();
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
