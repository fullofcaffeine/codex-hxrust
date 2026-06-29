import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalComposerEffect;
import codexhx.runtime.tui.terminal.TerminalComposerState;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalInputEvent;
import codexhx.runtime.tui.terminal.TerminalInputMapper;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveInputBackendHarness {
	static function main():Void {
		testNativePollCodeMapping();
		testComposerTextAndCursorMutations();
		testComposerHistoryAndExitMutations();
		testHeadlessQueuedKeysDriveComposer();
		testLiveBackendPollIsTypedAndRestores();
		Sys.println("tui-live-input-backend ok");
	}

	static function testNativePollCodeMapping():Void {
		assertTerminalKey(TerminalKey.Character("x"), TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollCharacter, "x"),
			"character native poll");
		assertTerminalKey(TerminalKey.Enter, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollEnter, ""), "enter native poll");
		assertTerminalKey(TerminalKey.Escape, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollEscape, ""), "escape native poll");
		assertTerminalKey(TerminalKey.CtrlC, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollCtrlC, ""), "ctrl-c native poll");
		assertTerminalKey(TerminalKey.Backspace, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollBackspace, ""),
			"backspace native poll");
		assertTerminalKey(TerminalKey.ArrowUp, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollArrowUp, ""), "up native poll");
		assertTerminalKey(TerminalKey.ArrowDown, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollArrowDown, ""), "down native poll");
		assertTerminalKey(TerminalKey.ArrowLeft, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollArrowLeft, ""), "left native poll");
		assertTerminalKey(TerminalKey.ArrowRight, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollArrowRight, ""), "right native poll");
		assertTerminalKey(TerminalKey.AgentPrevious, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollAgentPrevious, ""),
			"agent previous native poll");
		assertTerminalKey(TerminalKey.AgentNext, TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollAgentNext, ""),
			"agent next native poll");
		switch TerminalInputMapper.terminalEventFromNativePoll(TerminalInputMapper.PollNone, "") {
			case TerminalEvent.NoEvent:
			case _:
				fail("none native poll should map to NoEvent");
		}
	}

	static function testComposerTextAndCursorMutations():Void {
		final composer = new TerminalComposerState();
		assertDrawOnly(composer.apply(TerminalInputEvent.Text("H")), "insert H");
		assertDrawOnly(composer.apply(TerminalInputEvent.Text("i")), "insert i");
		assertStringEquals("Hi", composer.buffer(), "initial buffer");
		assertIntEquals(2, composer.cursor(), "initial cursor");
		assertDrawOnly(composer.apply(TerminalInputEvent.MoveLeft), "move left");
		assertDrawOnly(composer.apply(TerminalInputEvent.Text("!")), "insert middle");
		assertStringEquals("H!i", composer.buffer(), "middle insert buffer");
		assertIntEquals(2, composer.cursor(), "middle insert cursor");
		assertDrawOnly(composer.apply(TerminalInputEvent.DeleteBackward), "delete middle");
		assertStringEquals("Hi", composer.buffer(), "delete buffer");
		assertIntEquals(1, composer.cursor(), "delete cursor");
		assertDrawOnly(composer.apply(TerminalInputEvent.MoveRight), "move right");

		final submit = composer.apply(TerminalInputEvent.Submit);
		assertSubmitted("Hi", submit, "submit effect");
		assertStringEquals("", composer.buffer(), "buffer after submit");
		assertIntEquals(0, composer.cursor(), "cursor after submit");
		assertIntEquals(1, composer.submittedCount(), "submitted count");
		assertStringEquals("Hi", composer.submittedAt(0), "submitted text");
	}

	static function testComposerHistoryAndExitMutations():Void {
		final composer = new TerminalComposerState();
		composer.apply(TerminalInputEvent.Text("first"));
		composer.apply(TerminalInputEvent.Submit);
		composer.apply(TerminalInputEvent.Text("second"));
		composer.apply(TerminalInputEvent.Submit);

		assertDrawOnly(composer.apply(TerminalInputEvent.HistoryPrevious), "history previous latest");
		assertStringEquals("second", composer.buffer(), "latest history buffer");
		assertIntEquals(1, composer.historyIndex(), "latest history index");
		assertDrawOnly(composer.apply(TerminalInputEvent.HistoryPrevious), "history previous older");
		assertStringEquals("first", composer.buffer(), "older history buffer");
		assertIntEquals(0, composer.historyIndex(), "older history index");
		assertDrawOnly(composer.apply(TerminalInputEvent.HistoryNext), "history next newer");
		assertStringEquals("second", composer.buffer(), "newer history buffer");
		assertDrawOnly(composer.apply(TerminalInputEvent.HistoryNext), "history next clears");
		assertStringEquals("", composer.buffer(), "history clear buffer");
		assertIntEquals(-1, composer.historyIndex(), "history clear index");

		final cancel = composer.apply(TerminalInputEvent.Cancel);
		assertExitRequested(TerminalExitReason.Escape, cancel, "cancel exit");
		assertTrue(composer.exitRequested(), "cancel should request exit");
		assertExitReasonEquals(TerminalExitReason.Escape, composer.exitReason(), "cancel exit reason");
	}

	static function testHeadlessQueuedKeysDriveComposer():Void {
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("a")),
			TerminalEvent.Key(TerminalKey.Character("b")),
			TerminalEvent.Key(TerminalKey.ArrowLeft),
			TerminalEvent.Key(TerminalKey.Backspace),
			TerminalEvent.Key(TerminalKey.Character("c")),
			TerminalEvent.Key(TerminalKey.Enter)
		]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24))).ok, "headless input setup");
		final composer = new TerminalComposerState();
		applyPolledKey(backend.pollEvent(), composer);
		applyPolledKey(backend.pollEvent(), composer);
		applyPolledKey(backend.pollEvent(), composer);
		applyPolledKey(backend.pollEvent(), composer);
		applyPolledKey(backend.pollEvent(), composer);
		applyPolledKey(backend.pollEvent(), composer);

		assertIntEquals(1, composer.submittedCount(), "headless submitted count");
		assertStringEquals("cb", composer.submittedAt(0), "headless submitted text");
		assertStringEquals("", composer.buffer(), "headless buffer after submit");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testLiveBackendPollIsTypedAndRestores():Void {
		final backend = new LiveTerminalBackend();
		assertTrue(backend.setup(TerminalSetup.live(TerminalSize.of(80, 24))).ok, "live input setup should be accepted or CI-skipped");
		assertStatusAccepted(backend.lastReport().status, "live input setup status");
		assertTrue(backend.draw(new TerminalFrame(TerminalSize.of(80, 24), "Codex Input", ["input>"], 1, 6)).ok, "live input draw");

		final event = backend.pollEvent();
		switch event {
			case TerminalEvent.NoEvent:
			case TerminalEvent.Key(key):
				assertKnownKey(key);
			case TerminalEvent.Resize(_):
			case _:
				fail("unexpected live input event: " + Std.string(event));
		}
		final restore = backend.restore(TerminalRestoreReason.NormalExit);
		assertTrue(restore.restored, "live input path should restore");
	}

	static function applyPolledKey(event:TerminalEvent, composer:TerminalComposerState):Void {
		switch event {
			case TerminalEvent.Key(key):
				composer.apply(TerminalInputMapper.inputFromTerminalKey(key));
			case _:
				fail("expected queued key event");
		}
	}

	static function assertKnownKey(key:TerminalKey):Void {
		switch key {
			case TerminalKey.Character(_):
			case TerminalKey.Enter:
			case TerminalKey.Escape:
			case TerminalKey.CtrlC:
			case TerminalKey.Backspace:
			case TerminalKey.ArrowUp:
			case TerminalKey.ArrowDown:
			case TerminalKey.ArrowLeft:
			case TerminalKey.ArrowRight:
			case TerminalKey.AgentPrevious:
			case TerminalKey.AgentNext:
			case _:
				fail("unknown terminal key");
		}
	}

	static function assertTerminalKey(expected:TerminalKey, actualEvent:TerminalEvent, label:String):Void {
		switch actualEvent {
			case TerminalEvent.Key(actual):
				assertTerminalKeyEquals(expected, actual, label);
			case _:
				fail(label + ": expected key event");
		}
	}

	static function assertDrawOnly(effects:Array<TerminalComposerEffect>, label:String):Void {
		assertIntEquals(1, effects.length, label + " effect count");
		switch effects[0] {
			case TerminalComposerEffect.DrawRequested:
			case _:
				fail(label + ": expected draw request");
		}
	}

	static function assertSubmitted(expected:String, effects:Array<TerminalComposerEffect>, label:String):Void {
		assertIntEquals(2, effects.length, label + " effect count");
		switch effects[0] {
			case TerminalComposerEffect.Submitted(text):
				assertStringEquals(expected, text, label + " text");
			case _:
				fail(label + ": expected submitted effect");
		}
		switch effects[1] {
			case TerminalComposerEffect.DrawRequested:
			case _:
				fail(label + ": expected draw request");
		}
	}

	static function assertExitRequested(expected:TerminalExitReason, effects:Array<TerminalComposerEffect>, label:String):Void {
		assertIntEquals(2, effects.length, label + " effect count");
		switch effects[0] {
			case TerminalComposerEffect.ExitRequested(reason):
				assertExitReasonEquals(expected, reason, label + " reason");
			case _:
				fail(label + ": expected exit effect");
		}
		switch effects[1] {
			case TerminalComposerEffect.DrawRequested:
			case _:
				fail(label + ": expected draw request");
		}
	}

	static function assertTerminalKeyEquals(expected:TerminalKey, actual:TerminalKey, label:String):Void {
		assertStringEquals(terminalKeyText(expected), terminalKeyText(actual), label);
	}

	static function terminalKeyText(key:TerminalKey):String {
		return switch key {
			case Character(value):
				"Character(" + value + ")";
			case Enter:
				"Enter";
			case Escape:
				"Escape";
			case CtrlC:
				"CtrlC";
			case Backspace:
				"Backspace";
			case ArrowUp:
				"ArrowUp";
			case ArrowDown:
				"ArrowDown";
			case ArrowLeft:
				"ArrowLeft";
			case ArrowRight:
				"ArrowRight";
			case AgentPrevious:
				"AgentPrevious";
			case AgentNext:
				"AgentNext";
		}
	}

	static function assertStatusAccepted(status:LiveTerminalProbeStatus, label:String):Void {
		if (!status.okForCi())
			throw label + ": " + status.text();
	}

	static function assertExitReasonEquals(expected:TerminalExitReason, actual:TerminalExitReason, label:String):Void {
		assertStringEquals(exitReasonText(expected), exitReasonText(actual), label);
	}

	static function exitReasonText(reason:TerminalExitReason):String {
		return reason;
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
