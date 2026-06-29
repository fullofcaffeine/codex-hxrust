package codexhx.runtime.tui.terminal;

/**
	Terminal setup request for headless and future live backends.
**/
class TerminalSetup {
	public final mode:TerminalMode;
	public final size:TerminalSize;
	public final rawMode:Bool;
	public final alternateScreen:Bool;
	public final keyboardEnhancement:Bool;

	public function new(mode:TerminalMode, size:TerminalSize, rawMode:Bool, alternateScreen:Bool, keyboardEnhancement:Bool) {
		this.mode = mode;
		this.size = size;
		this.rawMode = rawMode;
		this.alternateScreen = alternateScreen;
		this.keyboardEnhancement = keyboardEnhancement;
	}

	public static function headless(size:TerminalSize):TerminalSetup {
		return new TerminalSetup(TerminalMode.Headless, size, false, false, false);
	}

	public static function live(size:TerminalSize):TerminalSetup {
		return new TerminalSetup(TerminalMode.Live, size, true, true, true);
	}
}
