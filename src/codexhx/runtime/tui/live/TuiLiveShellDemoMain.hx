package codexhx.runtime.tui.live;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

/**
	User-runnable, credential-free generated live TUI demo entrypoint.

	The demo intentionally uses the fake app-server facade from the minimal live
	shell. It proves a real terminal can run the Haxe-authored loop while keeping
	model traffic, JSON-RPC sockets, tools, and persistent state out of scope.
**/
class TuiLiveShellDemoMain {
	static inline final PollTimeoutMs:Int = 50;
	static inline final MaxIterations:Int = 100000;
	static inline final IdleEventLimit:Int = 5000;

	static function main():Void {
		final backend = new LiveTerminalBackend(PollTimeoutMs);
		final request = new TuiLiveShellRunRequest(backend, TerminalSetup.live(TerminalSize.of(96, 24)),
			SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001"), ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120101"),
			"gpt-live-demo").withPolicy(TuiLiveShellRunPolicy.bounded(MaxIterations, IdleEventLimit)).withInitialEvents([
				TuiAppServerEvent.AgentThreadUpsert(ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120102"), "Demo agent", "worker", false)
			]);

		final outcome = TuiLiveShellRunner.run(request);
		Sys.println("codex-hxrust live TUI demo exited: restored=" + boolText(outcome.restored()) + ", iterations=" + Std.string(outcome.iterations())
			+ ", prompts=" + Std.string(outcome.acceptedPrompts()) + ", exit=" + boolText(outcome.exitRequested()));
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
