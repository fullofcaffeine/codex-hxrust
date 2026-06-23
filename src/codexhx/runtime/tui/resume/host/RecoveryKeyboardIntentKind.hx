package codexhx.runtime.tui.resume.host;

enum abstract RecoveryKeyboardIntentKind(String) to String {
	final MoveDown = "move_down";
	final MoveUp = "move_up";
	final Unknown = "unknown";
}
