import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.DeterministicTuiAppServerStartupTransport;
import codexhx.runtime.tui.appserver.TuiAppServerStartupRequest;
import codexhx.runtime.tui.appserver.TuiAppServerThreadOpenMode;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.live.TuiLiveShellRunPolicy;
import codexhx.runtime.tui.live.TuiLiveShellRunRequest;
import codexhx.runtime.tui.live.TuiLiveShellRunner;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

/** Proves one upstream-shaped lifecycle through the real bounded TUI runner. */
class TuiAppServerVerticalTracerHarness {
	static function main():Void {
		testStartLifecycle();
		testResumeLifecycle();
		Sys.println("tui-app-server-vertical-tracer ok");
	}

	static function testStartLifecycle():Void {
		final sessionId = SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000129999");
		final threadId = ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001");
		final startup = new DeterministicTuiAppServerStartupTransport(sessionId, threadId);
		final startupRequest = new TuiAppServerStartupRequest({
			requestId: RequestId.fromInteger(1),
			mode: TuiAppServerThreadOpenMode.Start,
			modelLabel: "gpt-tracer",
			clientName: "codex-hxrust-test",
			clientVersion: "0.0.0"
		});
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("h")),
			TerminalEvent.Key(TerminalKey.Character("i")),
			TerminalEvent.Key(TerminalKey.Enter),
			TerminalEvent.NoEvent,
			TerminalEvent.NoEvent
		]);
		final request = new TuiLiveShellRunRequest(backend, TerminalSetup.headless(TerminalSize.of(96, 12)), sessionId, threadId,
			"unused").withShell(ChatWidgetShellState.initial("pending"))
			.withPolicy(TuiLiveShellRunPolicy.bounded(16, 2))
			.withStartupTransport(startup, startupRequest);
		final outcome = TuiLiveShellRunner.run(request);

		assertStrings(["initialize", "initialized", "thread/start"], startup.methods(), "startup method order");
		assertTrue(startup.outboundLines()[0].indexOf("\"method\":\"initialize\"") >= 0, "initialize JSON-RPC line");
		assertTrue(startup.outboundLines()[2].indexOf("\"method\":\"thread/start\"") >= 0, "thread/start JSON-RPC line");
		assertString(sessionId.toString(), request.session.activeSession().toString(), "session identity");
		assertString(threadId.toString(), request.session.activeThread().toString(), "thread identity");
		assertInt(1, outcome.submittedPrompts(), "turn/start submission");
		assertInt(1, outcome.completedTurns(), "turn completion");
		assertString("assistant> echo: hi", outcome.finalFrameLineAt(4), "assistant render");
		assertTrue(outcome.promptTransportClosed(), "session shutdown");
		assertTrue(outcome.restored(), "terminal restore");
	}

	static function testResumeLifecycle():Void {
		final sessionId = SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000129998");
		final resumedThreadId = ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120002");
		final transport = new DeterministicTuiAppServerStartupTransport(sessionId, ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120003"));
		final outcome = transport.open(new TuiAppServerStartupRequest({
			requestId: RequestId.fromInteger(10),
			mode: TuiAppServerThreadOpenMode.Resume,
			resumeThreadId: resumedThreadId,
			modelLabel: "gpt-tracer",
			clientName: "codex-hxrust-test",
			clientVersion: "0.0.0"
		}));
		assertTrue(outcome.isAccepted(), "resume accepted");
		assertString(resumedThreadId.toString(), outcome.threadId().toString(), "resumed thread identity");
		assertStrings(["initialize", "initialized", "thread/resume"], outcome.protocolMethods(), "resume method order");
		assertTrue(outcome.outboundLines()[2].indexOf("\"threadId\":\"" + resumedThreadId.toString() + "\"") >= 0, "resume thread JSON");
	}

	static function assertStrings(expected:Array<String>, actual:Array<String>, label:String):Void {
		assertInt(expected.length, actual.length, label + " count");
		for (index in 0...expected.length)
			assertString(expected[index], actual[index], label + " " + index);
	}

	static function assertString(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + ", got " + actual;
	}

	static function assertInt(expected:Int, actual:Int, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + ", got " + actual;
	}

	static function assertTrue(value:Bool, label:String):Void {
		if (!value)
			throw label;
	}
}
