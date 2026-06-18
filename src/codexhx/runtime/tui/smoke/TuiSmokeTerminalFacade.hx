package codexhx.runtime.tui.smoke;

class TuiSmokeTerminalFacade {
	final mode:TuiSmokeTerminalMode;
	final keys:Array<TuiSmokeKeyKind>;
	var setupComplete:Bool;
	var restored:Bool;

	public function new(mode:TuiSmokeTerminalMode, keys:Array<TuiSmokeKeyKind>) {
		this.mode = mode == null ? TuiSmokeTerminalMode.Unknown : mode;
		this.keys = keys == null ? [] : keys;
		this.setupComplete = false;
		this.restored = false;
	}

	public function setup(allowLiveTerminal:Bool):Bool {
		if (mode != TuiSmokeTerminalMode.Headless) return false;
		if (allowLiveTerminal) return false;
		setupComplete = true;
		restored = false;
		return true;
	}

	public function render(request:TuiSmokeFrameRequest):String {
		if (!setupComplete) return "";
		return TuiSmokeRenderer.renderFrame(request);
	}

	public function pollKey():TuiSmokeKeyKind {
		if (keys.length == 0) return TuiSmokeKeyKind.None;
		final key = keys[0];
		keys.splice(0, 1);
		return key;
	}

	public function restore():Void {
		restored = true;
		setupComplete = false;
	}

	public function wasRestored():Bool {
		return restored;
	}
}
