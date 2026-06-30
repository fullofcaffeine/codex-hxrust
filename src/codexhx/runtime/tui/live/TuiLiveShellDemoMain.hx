package codexhx.runtime.tui.live;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalBackend;
import codexhx.runtime.tui.terminal.TerminalEvent;
import codexhx.runtime.tui.terminal.TerminalKey;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

/**
	User-runnable, credential-free generated live TUI demo entrypoint.

	The demo intentionally uses the fake app-server facade from the minimal live
	shell by default. It can also select the dry-run connector-backed JSONL line
	transport so the same generated binary exercises the app-server-shaped prompt
	path while keeping model traffic, real processes/sockets, tools, and persistent
	state out of scope.
**/
class TuiLiveShellDemoMain {
	static inline final PollTimeoutMs:Int = 50;
	static inline final MaxIterations:Int = 100000;
	static inline final IdleEventLimit:Int = 5000;

	static function main():Void {
		final config = TuiLiveShellDemoConfig.parse(Sys.args());
		if (!config.ok) {
			Sys.println("codex-hxrust live TUI demo configuration error: " + config.code);
			return;
		}
		final setup = demoSetup(config);
		final request = config.apply(baseRequest(demoBackend(config), setup, demoPolicy(config)));
		final outcome = TuiLiveShellRunner.run(request);
		Sys.println("codex-hxrust live TUI demo exited: transport=" + config.transportCode() + ", restored=" + boolText(outcome.restored())
			+ ", iterations=" + Std.string(outcome.iterations()) + ", prompts=" + Std.string(outcome.acceptedPrompts()) + ", exit="
			+ boolText(outcome.exitRequested()));
	}

	public static function baseRequest(backend:TerminalBackend, setup:TerminalSetup, policy:TuiLiveShellRunPolicy):TuiLiveShellRunRequest {
		return new TuiLiveShellRunRequest(backend, setup, SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001"),
			ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120101"),
			"gpt-live-demo").withPolicy(policy == null ? TuiLiveShellRunPolicy.bounded(MaxIterations, IdleEventLimit) : policy).withInitialEvents([
				TuiAppServerEvent.AgentThreadUpsert(ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120102"), "Demo agent", "worker", false)
			]);
	}

	public static function scriptedBackend(prompt:String):HeadlessTerminalBackend {
		final events:Array<TerminalEvent> = [];
		final text = prompt == null ? "" : prompt;
		var index = 0;
		while (index < text.length) {
			events.push(TerminalEvent.Key(TerminalKey.Character(text.charAt(index))));
			index++;
		}
		events.push(TerminalEvent.Key(TerminalKey.Enter));
		events.push(TerminalEvent.NoEvent);
		events.push(TerminalEvent.NoEvent);
		return new HeadlessTerminalBackend(events);
	}

	static function demoBackend(config:TuiLiveShellDemoConfig):TerminalBackend {
		if (config.hasScriptedPrompt())
			return scriptedBackend(config.scriptedPrompt);
		return new LiveTerminalBackend(PollTimeoutMs);
	}

	static function demoSetup(config:TuiLiveShellDemoConfig):TerminalSetup {
		final size = TerminalSize.of(96, 24);
		if (config.hasScriptedPrompt())
			return TerminalSetup.headless(size);
		return TerminalSetup.live(size);
	}

	static function demoPolicy(config:TuiLiveShellDemoConfig):TuiLiveShellRunPolicy {
		if (config.hasScriptedPrompt())
			return TuiLiveShellRunPolicy.bounded(128, 3);
		return TuiLiveShellRunPolicy.bounded(MaxIterations, IdleEventLimit);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
