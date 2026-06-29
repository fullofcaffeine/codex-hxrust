import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
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
		testAgentNavigationInputRoutesActiveThread();
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
		assertTrue(outcome.appServerEvents() >= 3, "fake app-server echo events");
		assertStringEquals("user> hi", outcome.finalFrameLineAt(3), "user row rendered");
		assertStringEquals("assistant> echo: hi", outcome.finalFrameLineAt(4), "assistant echo rendered");
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

	static function assertReasonEquals(expected:TerminalExitReason, actual:TerminalExitReason, label:String):Void {
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
