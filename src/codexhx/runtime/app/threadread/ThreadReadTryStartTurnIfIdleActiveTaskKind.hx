package codexhx.runtime.app.threadread;

enum abstract ThreadReadTryStartTurnIfIdleActiveTaskKind(String) from String to String {
	var None = "none";
	var Regular = "regular";
	var Review = "review";
}
