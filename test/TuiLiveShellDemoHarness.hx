import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.live.TuiLiveShellRunPolicy;
import codexhx.runtime.tui.live.TuiLiveShellRunRequest;
import codexhx.runtime.tui.live.TuiLiveShellRunner;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveShellDemoHarness {
	static function main():Void {
		testPollTimeoutConfiguration();
		testNoTtyDemoRunCompletes();
		Sys.println("tui-live-shell-demo ok");
	}

	static function testPollTimeoutConfiguration():Void {
		final negative = new LiveTerminalBackend(-10);
		assertIntEquals(0, negative.pollTimeoutMs(), "negative timeout clamps to zero");
		final configured = new LiveTerminalBackend().withPollTimeoutMs(75);
		assertIntEquals(75, configured.pollTimeoutMs(), "configured timeout");
		final capped = new LiveTerminalBackend(2000);
		assertIntEquals(1000, capped.pollTimeoutMs(), "large timeout cap");
	}

	static function testNoTtyDemoRunCompletes():Void {
		final backend = new LiveTerminalBackend(25);
		final outcome = TuiLiveShellRunner.run(new TuiLiveShellRunRequest(backend, TerminalSetup.live(TerminalSize.of(96, 16)),
			SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000129999"), ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001"),
			"gpt-live-demo").withPolicy(TuiLiveShellRunPolicy.bounded(8, 2)).withInitialEvents([
				TuiAppServerEvent.AgentThreadUpsert(ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120002"), "Demo agent", "worker", false)
			]));

		assertTrue(outcome.setupAccepted(), "setup accepted or no-tty skipped");
		assertTrue(outcome.restored(), "restore");
		assertTrue(outcome.drawFrames() >= 1, "initial frame drawn");
		assertStringEquals("Codex | model: gpt-live-demo | status: session started | agent: Main [default]", outcome.finalFrameLineAt(0), "demo header");
		assertIntEquals(2, outcome.noEvents(), "bounded no-tty idle exit");
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
