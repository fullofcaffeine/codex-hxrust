package codexhx.runtime.tui.terminal;

/**
	Typed effects emitted by the minimal composer reducer.
**/
enum TerminalComposerEffect {
	DrawRequested;
	Submitted(text:String);
	ExitRequested(reason:TerminalExitReason);
}
