package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalModeActionFields = {
	final kind:TuiSmokeTerminalModeActionKind;
	final rawModeRestore:TuiSmokeRawModeRestoreKind;
	final keyboardRestore:TuiSmokeKeyboardRestoreKind;
	final virtualTerminalProcessing:Bool;
	final bracketedPaste:Bool;
	final rawMode:Bool;
	final focusChange:Bool;
	final mouseCapture:Bool;
	final cursorDefault:Bool;
	final cursorShow:Bool;
	final keyboardEnhancementDisabled:Bool;
	final envOverride:String;
	final wsl:Bool;
	final vscodeTerminal:Bool;
	final tmuxSession:Bool;
	final tmuxCsiU:Bool;
	final pushKeyboardEnhancement:Bool;
	final popKeyboardEnhancement:Bool;
	final resetKeyboardEnhancement:Bool;
	final modifyOtherKeys:Bool;
	final stdinTerminal:Bool;
	final stdoutTerminal:Bool;
	final flushInput:Bool;
	final panicHook:Bool;
	final terminalStderrFinish:Bool;
	final supported:Bool;
	final failureCode:String;
}

class TuiSmokeTerminalModeAction {
	public final kind:TuiSmokeTerminalModeActionKind;
	public final rawModeRestore:TuiSmokeRawModeRestoreKind;
	public final keyboardRestore:TuiSmokeKeyboardRestoreKind;
	public final virtualTerminalProcessing:Bool;
	public final bracketedPaste:Bool;
	public final rawMode:Bool;
	public final focusChange:Bool;
	public final mouseCapture:Bool;
	public final cursorDefault:Bool;
	public final cursorShow:Bool;
	public final keyboardEnhancementDisabled:Bool;
	public final envOverride:String;
	public final wsl:Bool;
	public final vscodeTerminal:Bool;
	public final tmuxSession:Bool;
	public final tmuxCsiU:Bool;
	public final pushKeyboardEnhancement:Bool;
	public final popKeyboardEnhancement:Bool;
	public final resetKeyboardEnhancement:Bool;
	public final modifyOtherKeys:Bool;
	public final stdinTerminal:Bool;
	public final stdoutTerminal:Bool;
	public final flushInput:Bool;
	public final panicHook:Bool;
	public final terminalStderrFinish:Bool;
	public final supported:Bool;
	public final failureCode:String;

	public function new(fields:TuiSmokeTerminalModeActionFields) {
		this.kind = fields.kind == null ? TuiSmokeTerminalModeActionKind.Unknown : fields.kind;
		this.rawModeRestore = fields.rawModeRestore == null ? TuiSmokeRawModeRestoreKind.None : fields.rawModeRestore;
		this.keyboardRestore = fields.keyboardRestore == null ? TuiSmokeKeyboardRestoreKind.None : fields.keyboardRestore;
		this.virtualTerminalProcessing = fields.virtualTerminalProcessing;
		this.bracketedPaste = fields.bracketedPaste;
		this.rawMode = fields.rawMode;
		this.focusChange = fields.focusChange;
		this.mouseCapture = fields.mouseCapture;
		this.cursorDefault = fields.cursorDefault;
		this.cursorShow = fields.cursorShow;
		this.keyboardEnhancementDisabled = fields.keyboardEnhancementDisabled;
		this.envOverride = fields.envOverride == null ? "none" : fields.envOverride;
		this.wsl = fields.wsl;
		this.vscodeTerminal = fields.vscodeTerminal;
		this.tmuxSession = fields.tmuxSession;
		this.tmuxCsiU = fields.tmuxCsiU;
		this.pushKeyboardEnhancement = fields.pushKeyboardEnhancement;
		this.popKeyboardEnhancement = fields.popKeyboardEnhancement;
		this.resetKeyboardEnhancement = fields.resetKeyboardEnhancement;
		this.modifyOtherKeys = fields.modifyOtherKeys;
		this.stdinTerminal = fields.stdinTerminal;
		this.stdoutTerminal = fields.stdoutTerminal;
		this.flushInput = fields.flushInput;
		this.panicHook = fields.panicHook;
		this.terminalStderrFinish = fields.terminalStderrFinish;
		this.supported = fields.supported;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}
}
