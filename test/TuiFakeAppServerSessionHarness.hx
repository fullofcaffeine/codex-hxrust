import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerRequestMethod;
import codexhx.runtime.tui.appserver.TuiAppServerShellEffect;
import codexhx.runtime.tui.appserver.TuiAppServerThreadStatus;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiFakeAppServerSessionHarness {
	static function main():Void {
		testAttachRejectsStaleResponse();
		testQueuedEventsUpdateShell();
		testBackendDrawsAttachedShell();
		Sys.println("tui-fake-app-server-session ok");
	}

	static function testAttachRejectsStaleResponse():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final facade = new FakeTuiAppServerFacade(shell);
		final requestOne = RequestId.fromInteger(1);
		final requestTwo = RequestId.fromInteger(2);
		final sessionOne = session("00000000-0000-0000-0000-000000000101");
		final sessionTwo = session("00000000-0000-0000-0000-000000000202");
		final threadOne = thread("00000000-0000-0000-0000-000000000111");
		final threadTwo = thread("00000000-0000-0000-0000-000000000222");

		assertRegistered(requestOne, facade.startSessionAttach(requestOne, sessionOne, threadOne, "gpt-stale"), "request one registered");
		assertRegistered(requestTwo, facade.startSessionAttach(requestTwo, sessionTwo, threadTwo, "gpt-live"), "request two registered");
		assertIntEquals(2, facade.pendingCount(), "pending before responses");

		assertStale(requestOne, facade.completeSessionAttach(requestOne), "stale request rejected");
		assertIntEquals(1, facade.pendingCount(), "pending after stale response");
		assertNullSession(facade.activeSession(), "stale response must not attach session");
		assertStringEquals("pending", shell.modelLabel(), "stale response must not set model");
		assertIntEquals(0, shell.transcriptCount(), "stale response must not append transcript");

		final attachEffects = facade.completeSessionAttach(requestTwo);
		assertContainsSessionAttached(sessionTwo, threadTwo, attachEffects, "fresh attach accepted");
		assertContainsAppliedSessionStarted(attachEffects, "session started applied");
		assertIntEquals(0, facade.pendingCount(), "pending after fresh response");
		assertSessionEquals(sessionTwo, facade.activeSession(), "active session");
		assertThreadEquals(threadTwo, facade.activeThread(), "active thread");
		assertStringEquals("gpt-live", shell.modelLabel(), "attached model");
		assertStatusKindEquals(ChatWidgetStatusKind.Idle, shell.statusKind(), "attached status kind");
		assertStringEquals("session started", shell.statusText(), "attached status");
		assertStringEquals("system> session " + sessionTwo.toString() + " attached to thread " + threadTwo.toString(), shell.transcriptAt(0).renderText(),
			"attached transcript row");

		assertStale(RequestId.fromInteger(404), facade.completeSessionAttach(RequestId.fromInteger(404)), "missing request rejected as stale");
	}

	static function testQueuedEventsUpdateShell():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final facade = new FakeTuiAppServerFacade(shell);
		final request = RequestId.fromInteger(7);
		final activeSession = session("00000000-0000-0000-0000-000000000707");
		final activeThread = thread("00000000-0000-0000-0000-000000000777");
		final staleThread = thread("00000000-0000-0000-0000-000000000888");
		facade.startSessionAttach(request, activeSession, activeThread, "gpt-live");
		facade.completeSessionAttach(request);

		facade.enqueue(TuiAppServerEvent.ThreadStatus(staleThread, TuiAppServerThreadStatus.Working("ignored")));
		facade.enqueue(TuiAppServerEvent.ThreadStatus(activeThread, TuiAppServerThreadStatus.Working("thinking")));
		facade.enqueue(TuiAppServerEvent.AssistantDelta(activeThread, "Hello from fake app-server."));
		facade.enqueue(TuiAppServerEvent.Disconnected("transport closed"));
		assertIntEquals(4, facade.queuedCount(), "queued events");

		final effects = facade.drainQueued();
		assertIntEquals(0, facade.queuedCount(), "queue drained");
		assertContainsIgnoredThreadStatus(effects, "stale thread status ignored");
		assertContainsAppliedThreadStatus(effects, "active thread status applied");
		assertContainsAppliedAssistantDelta(effects, "assistant delta applied");
		assertContainsDisconnected("transport closed", effects, "disconnect effect");
		assertStatusKindEquals(ChatWidgetStatusKind.Error, shell.statusKind(), "final status kind");
		assertStringEquals("transport closed", shell.statusText(), "final status text");
		assertStringEquals("assistant> Hello from fake app-server.", shell.transcriptAt(1).renderText(), "assistant transcript");
		assertStringEquals("system> transport closed", shell.transcriptAt(2).renderText(), "disconnect transcript");
	}

	static function testBackendDrawsAttachedShell():Void {
		final shell = ChatWidgetShellState.initial("pending");
		final facade = new FakeTuiAppServerFacade(shell);
		final request = RequestId.fromInteger(9);
		final activeSession = session("00000000-0000-0000-0000-000000000909");
		final activeThread = thread("00000000-0000-0000-0000-000000000999");
		facade.startSessionAttach(request, activeSession, activeThread, "gpt-live");
		facade.completeSessionAttach(request);
		facade.receive(TuiAppServerEvent.ThreadStatus(activeThread, TuiAppServerThreadStatus.Working("streaming")));
		facade.receive(TuiAppServerEvent.AssistantDelta(activeThread, "Rendered through the shell."));

		final frame = ChatWidgetShellRenderer.render(shell, TerminalSize.of(80, 12));
		assertStringEquals("Codex | model: gpt-live | status: streaming", frame.lineAt(0), "rendered header");
		assertStringEquals("assistant> Rendered through the shell.", frame.lineAt(3), "rendered assistant row");

		final headless = new HeadlessTerminalBackend([]);
		assertTrue(headless.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "headless setup");
		final headlessDraw = headless.draw(frame);
		assertTrue(headlessDraw.ok, "headless draw");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, headlessDraw.kind, "headless draw operation");
		assertStringEquals("status: working | rows: 2 | rev: 5", headless.currentFrame().lineAt(5), "headless footer");
		headless.restore(TerminalRestoreReason.NormalExit);

		final live = new LiveTerminalBackend();
		assertTrue(live.setup(TerminalSetup.live(TerminalSize.of(80, 12))).ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(live.lastReport().status, "live setup status");
		final liveDraw = live.draw(frame);
		assertTrue(liveDraw.ok, "live draw should be accepted or CI-skipped");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, liveDraw.kind, "live draw operation");
		assertStatusAccepted(live.lastReport().status, "live draw status");
		assertStringEquals("assistant> Rendered through the shell.", live.currentFrame().lineAt(3), "live assistant row");
		assertTrue(live.restore(TerminalRestoreReason.NormalExit).restored, "live restore");
	}

	static function session(value:String):SessionId {
		return SessionId.unsafeAssumeValid(value);
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function assertRegistered(expected:RequestId, effects:Array<TuiAppServerShellEffect>, label:String):Void {
		assertIntEquals(1, effects.length, label + " count");
		switch effects[0] {
			case TuiAppServerShellEffect.RequestRegistered(requestId, method):
				assertStringEquals(expected.toString(), requestId.toString(), label + " request id");
				assertMethodEquals(TuiAppServerRequestMethod.AttachSession, method, label + " method");
			case _:
				fail(label + ": expected request registration");
		}
	}

	static function assertStale(expected:RequestId, effects:Array<TuiAppServerShellEffect>, label:String):Void {
		assertIntEquals(1, effects.length, label + " count");
		switch effects[0] {
			case TuiAppServerShellEffect.StaleResponseRejected(requestId, method):
				assertStringEquals(expected.toString(), requestId.toString(), label + " request id");
				assertMethodEquals(TuiAppServerRequestMethod.AttachSession, method, label + " method");
			case _:
				fail(label + ": expected stale rejection");
		}
	}

	static function assertContainsSessionAttached(expectedSession:SessionId, expectedThread:ThreadId, effects:Array<TuiAppServerShellEffect>,
			label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.SessionAttached(sessionId, threadId):
					assertSessionEquals(expectedSession, sessionId, label + " session");
					assertThreadEquals(expectedThread, threadId, label + " thread");
					return;
				case _:
			}
		}
		fail(label + ": missing session attached effect");
	}

	static function assertContainsAppliedSessionStarted(effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.AppServerEventApplied(TuiAppServerEvent.SessionStarted(_, _, _)):
					return;
				case _:
			}
		}
		fail(label + ": missing applied session started event");
	}

	static function assertContainsIgnoredThreadStatus(effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.AppServerEventIgnored(TuiAppServerEvent.ThreadStatus(_, _)):
					return;
				case _:
			}
		}
		fail(label + ": missing ignored thread status");
	}

	static function assertContainsAppliedThreadStatus(effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.AppServerEventApplied(TuiAppServerEvent.ThreadStatus(_, _)):
					return;
				case _:
			}
		}
		fail(label + ": missing applied thread status");
	}

	static function assertContainsAppliedAssistantDelta(effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.AppServerEventApplied(TuiAppServerEvent.AssistantDelta(_, _)):
					return;
				case _:
			}
		}
		fail(label + ": missing applied assistant delta");
	}

	static function assertContainsDisconnected(expected:String, effects:Array<TuiAppServerShellEffect>, label:String):Void {
		for (effect in effects) {
			switch effect {
				case TuiAppServerShellEffect.Disconnected(message):
					assertStringEquals(expected, message, label + " message");
					return;
				case _:
			}
		}
		fail(label + ": missing disconnected effect");
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

	static function assertMethodEquals(expected:TuiAppServerRequestMethod, actual:TuiAppServerRequestMethod, label:String):Void {
		assertStringEquals(methodText(expected), methodText(actual), label);
	}

	static function methodText(method:TuiAppServerRequestMethod):String {
		return Std.string(method);
	}

	static function assertStatusKindEquals(expected:ChatWidgetStatusKind, actual:ChatWidgetStatusKind, label:String):Void {
		assertStringEquals(ChatWidgetShellState.statusKindText(expected), ChatWidgetShellState.statusKindText(actual), label);
	}

	static function assertSessionEquals(expected:SessionId, actual:Null<SessionId>, label:String):Void {
		if (actual == null || !expected.equals(actual))
			fail(label + ": expected " + expected.toString() + " but got " + nullSessionText(actual));
	}

	static function assertThreadEquals(expected:ThreadId, actual:Null<ThreadId>, label:String):Void {
		if (actual == null || !expected.equals(actual))
			fail(label + ": expected " + expected.toString() + " but got " + nullThreadText(actual));
	}

	static function assertNullSession(actual:Null<SessionId>, label:String):Void {
		if (actual != null)
			fail(label + ": expected null session but got " + actual.toString());
	}

	static function nullSessionText(value:Null<SessionId>):String {
		return value == null ? "null" : value.toString();
	}

	static function nullThreadText(value:Null<ThreadId>):String {
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

	static function fail(message:String):Void {
		throw message;
	}
}
