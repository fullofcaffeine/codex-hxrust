package codexhx.runtime.tui.resume.host;

enum abstract CompletionInputIntentKind(String) to String {
	final ConfirmRecoveredSelection = "confirm_recovered_selection";
	final Unknown = "unknown";
}
