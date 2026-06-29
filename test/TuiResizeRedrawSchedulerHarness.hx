import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalExitReason;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSchedulerEffect;
import codexhx.runtime.tui.terminal.TerminalSchedulerEvent;
import codexhx.runtime.tui.terminal.TerminalSchedulerRunner;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiResizeRedrawSchedulerHarness {
	static function main():Void {
		testCoalescedResizeFlush();
		testDrawRequestedAndTickAreTypedState();
		testHeadlessBackendResizedFramePath();
		testLiveBackendResizedFramePath();
		testAppExitEffect();
		Sys.println("tui-resize-redraw-scheduler ok");
	}

	static function testCoalescedResizeFlush():Void {
		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 24));
		assertNoEffects(scheduler.handle(TerminalSchedulerEvent.Resize(TerminalSize.of(100, 30))), "first resize should wait for flush");
		assertNoEffects(scheduler.handle(TerminalSchedulerEvent.Resize(TerminalSize.of(120, 40))), "second resize should coalesce before flush");
		assertNoEffects(scheduler.handle(TerminalSchedulerEvent.DrawRequested), "draw request should wait for flush");
		assertSizeEquals(TerminalSize.of(120, 40), scheduler.currentSize(), "latest coalesced size");
		assertTrue(scheduler.hasPendingResize(), "resize should be pending");
		assertTrue(scheduler.hasPendingDraw(), "draw should be pending");
		assertIntEquals(2, scheduler.resizeEventCount(), "resize event count");
		assertIntEquals(1, scheduler.drawRequestCount(), "draw request count");

		final effects = scheduler.flush(frame(TerminalSize.of(120, 40), "resized frame"));
		assertIntEquals(2, effects.length, "flush effect count");
		assertResizeEffect(TerminalSize.of(120, 40), effects[0], "coalesced resize effect");
		assertDrawEffect(TerminalSize.of(120, 40), "resized frame", effects[1], "draw effect");
		assertFalse(scheduler.hasPendingResize(), "resize should be drained");
		assertFalse(scheduler.hasPendingDraw(), "draw should be drained");
		assertIntEquals(1, scheduler.resizeApplyCount(), "resize apply count");
		assertIntEquals(1, scheduler.drawApplyCount(), "draw apply count");
	}

	static function testDrawRequestedAndTickAreTypedState():Void {
		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 24));
		assertNoEffects(scheduler.handle(TerminalSchedulerEvent.Tick), "tick should only mark draw pending");
		assertNoEffects(scheduler.handle(TerminalSchedulerEvent.DrawRequested), "draw request should only mark draw pending");
		assertTrue(scheduler.hasPendingDraw(), "draw should be pending after tick/request");
		assertIntEquals(1, scheduler.tickCount(), "tick count");
		assertIntEquals(1, scheduler.drawRequestCount(), "draw request count");

		final effects = scheduler.flush(frame(TerminalSize.of(80, 24), "tick frame"));
		assertIntEquals(1, effects.length, "tick/request flush effect count");
		assertDrawEffect(TerminalSize.of(80, 24), "tick frame", effects[0], "tick/request draw effect");
		assertIntEquals(1, scheduler.drawApplyCount(), "draw apply count");
	}

	static function testHeadlessBackendResizedFramePath():Void {
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24))).ok, "headless setup");
		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 24));
		scheduler.handle(TerminalSchedulerEvent.Resize(TerminalSize.of(132, 43)));
		final effects = scheduler.flush(frame(TerminalSize.of(132, 43), "headless resized"));
		final operations = TerminalSchedulerRunner.applyEffects(backend, effects);

		assertIntEquals(2, operations.length, "headless operation count");
		assertOperationKindEquals(TerminalOperationKind.ResizeComplete, operations[0].kind, "headless resize operation");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, operations[1].kind, "headless draw operation");
		assertIntEquals(1, backend.resizeCount(), "headless backend resize count");
		assertIntEquals(1, backend.drawCount(), "headless backend draw count");
		assertSizeEquals(TerminalSize.of(132, 43), backend.currentSize(), "headless backend size");
		assertStringEquals("headless resized", backend.currentFrame().lineAt(0), "headless backend frame text");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testLiveBackendResizedFramePath():Void {
		final backend = new LiveTerminalBackend();
		final setup = backend.setup(TerminalSetup.live(TerminalSize.of(80, 24)));
		assertTrue(setup.ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(backend.lastReport().status, "live setup status");

		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 24));
		scheduler.handle(TerminalSchedulerEvent.Resize(TerminalSize.of(90, 27)));
		final effects = scheduler.flush(frame(TerminalSize.of(90, 27), "live resized"));
		final operations = TerminalSchedulerRunner.applyEffects(backend, effects);
		assertIntEquals(2, operations.length, "live operation count");
		assertOperationKindEquals(TerminalOperationKind.ResizeComplete, operations[0].kind, "live resize operation");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, operations[1].kind, "live draw operation");
		assertTrue(operations[0].ok, "live resize operation ok");
		assertTrue(operations[1].ok, "live draw operation ok");
		assertIntEquals(1, backend.drawCount(), "live backend draw count");
		assertSizeEquals(TerminalSize.of(90, 27), backend.currentSize(), "live backend size");
		assertStatusAccepted(backend.lastReport().status, "live draw status");
		final restore = backend.restore(TerminalRestoreReason.NormalExit);
		assertTrue(restore.restored, "live scheduler path should restore");
	}

	static function testAppExitEffect():Void {
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 24))).ok, "exit setup");
		final scheduler = new TerminalRedrawScheduler(TerminalSize.of(80, 24));
		scheduler.handle(TerminalSchedulerEvent.Resize(TerminalSize.of(100, 25)));
		final effects = scheduler.handle(TerminalSchedulerEvent.AppExit(TerminalExitReason.CtrlC));
		assertTrue(scheduler.exitRequested(), "scheduler should record app exit");
		assertFalse(scheduler.hasPendingResize(), "exit clears pending resize");
		assertFalse(scheduler.hasPendingDraw(), "exit clears pending draw");
		assertIntEquals(1, effects.length, "exit effect count");
		assertExitEffect(TerminalExitReason.CtrlC, effects[0], "exit effect");

		final operations = TerminalSchedulerRunner.applyEffects(backend, effects);
		assertIntEquals(1, operations.length, "exit operation count");
		assertOperationKindEquals(TerminalOperationKind.ExitRequested, operations[0].kind, "exit operation");
		assertTrue(backend.exitWasRequested(), "backend exit should be requested");
		assertExitReasonEquals(TerminalExitReason.CtrlC, backend.requestedExitReason(), "backend exit reason");
		assertNoEffects(scheduler.flush(frame(TerminalSize.of(100, 25), "after exit")), "flush after exit should be empty");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function frame(size:TerminalSize, label:String):TerminalFrame {
		return new TerminalFrame(size, "Codex", [label], 1, label.length);
	}

	static function assertNoEffects(effects:Array<TerminalSchedulerEffect>, label:String):Void {
		assertIntEquals(0, effects.length, label);
	}

	static function assertResizeEffect(expected:TerminalSize, effect:TerminalSchedulerEffect, label:String):Void {
		switch effect {
			case TerminalSchedulerEffect.ResizeBackend(size):
				assertSizeEquals(expected, size, label);
			case _:
				fail(label + ": expected resize effect");
		}
	}

	static function assertDrawEffect(expectedSize:TerminalSize, expectedLine:String, effect:TerminalSchedulerEffect, label:String):Void {
		switch effect {
			case TerminalSchedulerEffect.DrawFrame(frame):
				assertSizeEquals(expectedSize, frame.size, label + " size");
				assertStringEquals(expectedLine, frame.lineAt(0), label + " line");
			case _:
				fail(label + ": expected draw effect");
		}
	}

	static function assertExitEffect(expected:TerminalExitReason, effect:TerminalSchedulerEffect, label:String):Void {
		switch effect {
			case TerminalSchedulerEffect.RequestExit(reason):
				assertExitReasonEquals(expected, reason, label);
			case _:
				fail(label + ": expected exit effect");
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

	static function assertExitReasonEquals(expected:TerminalExitReason, actual:TerminalExitReason, label:String):Void {
		assertStringEquals(exitReasonText(expected), exitReasonText(actual), label);
	}

	static function exitReasonText(reason:TerminalExitReason):String {
		return reason;
	}

	static function assertSizeEquals(expected:TerminalSize, actual:TerminalSize, label:String):Void {
		assertIntEquals(expected.columns, actual.columns, label + " columns");
		assertIntEquals(expected.rows, actual.rows, label + " rows");
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
