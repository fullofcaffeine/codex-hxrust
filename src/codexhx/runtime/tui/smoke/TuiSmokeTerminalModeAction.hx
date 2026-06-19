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

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalModeAction {
	public final kind:TuiSmokeTerminalModeActionKind;
	@:recordDefault(TuiSmokeRawModeRestoreKind.None)
	public final rawModeRestore:TuiSmokeRawModeRestoreKind;
	@:recordDefault(TuiSmokeKeyboardRestoreKind.None)
	public final keyboardRestore:TuiSmokeKeyboardRestoreKind;
	public final virtualTerminalProcessing:Bool;
	public final bracketedPaste:Bool;
	public final rawMode:Bool;
	public final focusChange:Bool;
	public final mouseCapture:Bool;
	public final cursorDefault:Bool;
	public final cursorShow:Bool;
	public final keyboardEnhancementDisabled:Bool;
	@:recordDefault("none")
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
}
