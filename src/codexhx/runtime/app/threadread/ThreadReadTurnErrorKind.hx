package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnErrorKind(String) from String to String {
	var UsageLimitExceeded = "usage_limit_exceeded";
	var TerminalError = "terminal_error";
}
