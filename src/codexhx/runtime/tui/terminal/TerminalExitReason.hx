package codexhx.runtime.tui.terminal;

/**
	Reason the live shell wants to leave the terminal loop.
**/
enum abstract TerminalExitReason(String) to String {
	final Requested = "requested";
	final Escape = "escape";
	final CtrlC = "ctrl_c";
	final Error = "error";
}
