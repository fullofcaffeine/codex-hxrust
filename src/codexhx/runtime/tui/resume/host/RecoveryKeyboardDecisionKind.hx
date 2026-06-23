package codexhx.runtime.tui.resume.host;

enum abstract RecoveryKeyboardDecisionKind(String) to String {
	final NavigationAdmitted = "navigation_admitted";
	final NavigationRejected = "navigation_rejected";
	final Unknown = "unknown";
}
