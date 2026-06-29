package codexhx.runtime.tui.terminal;

/**
	Reason terminal state is being restored.
**/
enum abstract TerminalRestoreReason(String) to String {
	final NormalExit = "normal_exit";
	final ErrorExit = "error_exit";
	final PanicFallback = "panic_fallback";
}
