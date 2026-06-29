import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalMode;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiTerminalBackendHarness {
	static function main():Void {
		testHeadlessLifecycle();
		testQueuedTypedEvents();
		testSetupAndSizeRejections();
		Sys.println("tui-terminal-contract ok");
	}

	static function testHeadlessLifecycle():Void {
		final backend = new HeadlessTerminalBackend([]);
		final setup = backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24)));
		assertTrue(setup.ok, "headless setup should be accepted");
		assertOperationKindEquals(TerminalOperationKind.SetupComplete, setup.kind, "setup operation kind");
		assertTrue(backend.isActive(), "backend should be active after setup");
		assertFalse(backend.wasRestored(), "backend should not be restored immediately after setup");

		final frame = new TerminalFrame(TerminalSize.of(80, 24), "Codex", ["status: idle", "input> "], 2, 7);
		final draw = backend.draw(frame);
		assertTrue(draw.ok, "draw should be accepted");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, draw.kind, "draw operation kind");
		assertStringEquals("Codex\nstatus: idle\ninput> ", backend.currentFrame().text(), "frame text");
		assertIntEquals(2, backend.currentFrame().lineCount(), "frame line count");

		final resize = backend.resize(TerminalSize.of(100, 30));
		assertTrue(resize.ok, "resize should be accepted");
		assertStringEquals("100x30", backend.currentSize().summary(), "current size");

		final exit = backend.requestExit(TerminalExitReason.Escape);
		assertTrue(exit.ok, "exit request should be accepted");
		assertTrue(backend.exitWasRequested(), "exit should be recorded");
		assertExitReasonEquals(TerminalExitReason.Escape, backend.requestedExitReason(), "exit reason");

		final restore = backend.restore(TerminalRestoreReason.NormalExit);
		assertTrue(restore.restored, "restore report should mark restored");
		assertTrue(restore.wasActive, "restore should report active terminal");
		assertRestoreReasonEquals(TerminalRestoreReason.NormalExit, restore.reason, "restore reason");
		assertFalse(backend.isActive(), "backend should be inactive after restore");
		assertTrue(backend.wasRestored(), "backend should remember restore");
		assertIntEquals(1, backend.setupCount(), "setup count");
		assertIntEquals(1, backend.drawCount(), "draw count");
		assertIntEquals(1, backend.resizeCount(), "resize count");
		assertIntEquals(1, backend.exitCount(), "exit count");
		assertIntEquals(1, backend.restoreCount(), "restore count");
	}

	static function testQueuedTypedEvents():Void {
		final backend = new HeadlessTerminalBackend([
			TerminalEvent.Key(TerminalKey.Character("x")),
			TerminalEvent.Resize(TerminalSize.of(120, 40)),
			TerminalEvent.DrawRequested,
			TerminalEvent.Exit(TerminalExitReason.CtrlC)
		]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24))).ok, "queued setup should be accepted");

		switch backend.pollEvent() {
			case TerminalEvent.Key(TerminalKey.Character(value)):
				assertStringEquals("x", value, "character key value");
			case _:
				fail("expected character key event");
		}
		switch backend.pollEvent() {
			case TerminalEvent.Resize(size):
				assertStringEquals("120x40", size.summary(), "resize event size");
			case _:
				fail("expected resize event");
		}
		switch backend.pollEvent() {
			case TerminalEvent.DrawRequested:
			case _:
				fail("expected draw-request event");
		}
		switch backend.pollEvent() {
			case TerminalEvent.Exit(reason):
				assertExitReasonEquals(TerminalExitReason.CtrlC, reason, "exit event reason");
			case _:
				fail("expected exit event");
		}
		switch backend.pollEvent() {
			case TerminalEvent.NoEvent:
			case _:
				fail("expected queue exhaustion to return NoEvent");
		}
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testSetupAndSizeRejections():Void {
		final backend = new HeadlessTerminalBackend([]);
		final live = backend.setup(TerminalSetup.live(TerminalSize.of(80, 24)));
		assertFalse(live.ok, "headless backend should reject live setup");
		assertOperationKindEquals(TerminalOperationKind.Rejected, live.kind, "live rejection kind");
		assertFalse(backend.isActive(), "live rejection should not activate backend");

		final invalid = backend.setup(TerminalSetup.headless(TerminalSize.of(0, 24)));
		assertFalse(invalid.ok, "invalid size should be rejected");
		assertOperationKindEquals(TerminalOperationKind.Rejected, invalid.kind, "invalid size rejection kind");

		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24))).ok, "valid setup should work after rejection");
		final secondSetup = backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24)));
		assertFalse(secondSetup.ok, "active backend should reject second setup");
		assertOperationKindEquals(TerminalOperationKind.AlreadyActive, secondSetup.kind, "already-active rejection kind");

		final invalidResize = backend.resize(TerminalSize.of(80, 0));
		assertFalse(invalidResize.ok, "invalid resize should be rejected");
		assertOperationKindEquals(TerminalOperationKind.Rejected, invalidResize.kind, "invalid resize rejection kind");
		backend.restore(TerminalRestoreReason.ErrorExit);
		final drawAfterRestore = backend.draw(TerminalFrame.empty(TerminalSize.of(80, 24)));
		assertFalse(drawAfterRestore.ok, "draw after restore should be inactive");
		assertOperationKindEquals(TerminalOperationKind.Inactive, drawAfterRestore.kind, "inactive draw kind");
	}

	static function assertStringEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertIntEquals(expected:Int, actual:Int, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertOperationKindEquals(expected:TerminalOperationKind, actual:TerminalOperationKind, label:String):Void {
		assertStringEquals(operationKindText(expected), operationKindText(actual), label);
	}

	static function assertExitReasonEquals(expected:TerminalExitReason, actual:TerminalExitReason, label:String):Void {
		assertStringEquals(exitReasonText(expected), exitReasonText(actual), label);
	}

	static function assertRestoreReasonEquals(expected:TerminalRestoreReason, actual:TerminalRestoreReason, label:String):Void {
		assertStringEquals(restoreReasonText(expected), restoreReasonText(actual), label);
	}

	static function operationKindText(kind:TerminalOperationKind):String {
		return kind;
	}

	static function exitReasonText(reason:TerminalExitReason):String {
		return reason;
	}

	static function restoreReasonText(reason:TerminalRestoreReason):String {
		return reason;
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
