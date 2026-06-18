package codexhx.runtime.tui.smoke;

class TuiSmokeRunner {
	public static function run(request:TuiSmokeFrameRequest):TuiSmokeOutcome {
		if (request == null) return rejected("missing_request", "");
		if (request.allowNetwork || request.allowModelCall) return rejected("live_effects_not_allowed", "");

		final terminal = new TuiSmokeTerminalFacade(request.terminalMode, [request.key]);
		if (!terminal.setup(request.allowLiveTerminal)) return rejected("terminal_setup_rejected", "");

		final frame = terminal.render(request);
		final key = terminal.pollKey();
		final exit = exitForKey(key);
		terminal.restore();
		final snapshot = frame + "\nkey: " + key + "\nexit: " + exit + "\nterminal: restored";
		final ok = exit == request.expectedExit && terminal.wasRestored();
		return new TuiSmokeOutcome({
			ok: ok,
			code: ok ? "ok" : "unexpected_exit",
			exit: exit,
			snapshot: snapshot,
			terminalRestored: terminal.wasRestored()
		});
	}

	public static function exitForKey(key:TuiSmokeKeyKind):TuiSmokeExitKind {
		return switch key {
			case TuiSmokeKeyKind.CtrlC: TuiSmokeExitKind.Cancelled;
			case TuiSmokeKeyKind.Escape | TuiSmokeKeyKind.CharQ: TuiSmokeExitKind.Quit;
			case TuiSmokeKeyKind.None: TuiSmokeExitKind.Rendered;
			case _: TuiSmokeExitKind.Rejected;
		}
	}

	static function rejected(code:String, snapshot:String):TuiSmokeOutcome {
		return new TuiSmokeOutcome({
			ok: false,
			code: code,
			exit: TuiSmokeExitKind.Rejected,
			snapshot: snapshot,
			terminalRestored: false
		});
	}
}
