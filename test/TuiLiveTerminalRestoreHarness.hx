import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveTerminalRestoreHarness {
	static function main():Void {
		testNormalRestorePath();
		testErrorRestorePath();
		testPollEventIsTypedAndNonBlocking();
		Sys.println("tui-live-terminal-restore ok");
	}

	static function testNormalRestorePath():Void {
		final backend = new LiveTerminalBackend();
		final setup = backend.setup(TerminalSetup.live(TerminalSize.of(80, 24)));
		assertTrue(setup.ok, "live setup should be accepted or CI-skipped");
		assertOperationKindEquals(TerminalOperationKind.SetupComplete, setup.kind, "setup kind");
		assertTrue(backend.isActive(), "backend should become active after accepted setup");
		assertStatusAccepted(backend.lastReport().status, "setup status");

		final draw = backend.draw(new TerminalFrame(TerminalSize.of(80, 24), "Codex", ["status: live probe", "input> q"], 2, 8));
		assertTrue(draw.ok, "live draw should be accepted or CI-skipped");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, draw.kind, "draw kind");
		assertTrue(backend.lastReport().drawAttempted, "draw should be attempted");

		final exit = backend.requestExit(TerminalExitReason.Requested);
		assertTrue(exit.ok, "exit request should be accepted");
		assertTrue(backend.exitWasRequested(), "exit should be recorded");

		final restore = backend.restore(TerminalRestoreReason.NormalExit);
		assertTrue(restore.restored, "normal path should restore or prove no terminal was taken");
		assertTrue(restore.wasActive, "normal restore should report active backend");
		assertFalse(backend.isActive(), "backend should be inactive after restore");
		assertTrue(backend.wasRestored(), "backend should remember restore");
		assertTrue(backend.lastReport().restoreAttempted, "restore should be attempted");
		assertStatusAccepted(backend.lastReport().status, "restore status");
		assertIntEquals(1, backend.setupCount(), "setup count");
		assertIntEquals(1, backend.drawCount(), "draw count");
		assertIntEquals(1, backend.exitCount(), "exit count");
		assertIntEquals(1, backend.restoreCount(), "restore count");
	}

	static function testErrorRestorePath():Void {
		final backend = new LiveTerminalBackend();
		var restored = false;
		try {
			final setup = backend.setup(TerminalSetup.live(TerminalSize.of(80, 24)));
			assertTrue(setup.ok, "error-path setup should be accepted or CI-skipped");
			final draw = backend.draw(new TerminalFrame(TerminalSize.of(80, 24), "Codex Error Path", ["about to throw"], 1, 1));
			assertTrue(draw.ok, "error-path draw should be accepted or CI-skipped");
			throw "forced live terminal error path";
		} catch (e:String) {
			final report = backend.restore(TerminalRestoreReason.ErrorExit);
			restored = report.restored;
			assertTrue(report.wasActive, "error restore should observe active backend");
			assertTrue(backend.lastReport().restoreAttempted, "error restore should be attempted");
			assertStatusAccepted(backend.lastReport().status, "error restore status");
		}
		assertTrue(restored, "error path should restore or prove no terminal was taken");
		assertFalse(backend.isActive(), "error path should leave backend inactive");
	}

	static function testPollEventIsTypedAndNonBlocking():Void {
		final backend = new LiveTerminalBackend();
		assertTrue(backend.setup(TerminalSetup.live(TerminalSize.of(80, 24))).ok, "poll setup should be accepted");
		final event = backend.pollEvent();
		switch event {
			case TerminalEvent.NoEvent:
			case TerminalEvent.Key(key):
				assertKnownKey(key);
			case TerminalEvent.Exit(reason):
				assertTrue(reason == TerminalExitReason.Requested
					|| reason == TerminalExitReason.Escape
					|| reason == TerminalExitReason.CtrlC,
					"legacy exit event should preserve q/Esc/Ctrl-C");
			case _:
				fail("unexpected live terminal event: " + Std.string(event));
		}
		backend.restore(TerminalRestoreReason.NormalExit);
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
			case _:
				fail("unknown terminal key");
		}
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
