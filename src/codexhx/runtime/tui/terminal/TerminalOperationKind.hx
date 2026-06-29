package codexhx.runtime.tui.terminal;

/**
	Typed outcome categories emitted by terminal backend operations.
**/
enum abstract TerminalOperationKind(String) to String {
	final SetupComplete = "setup_complete";
	final DrawComplete = "draw_complete";
	final ResizeComplete = "resize_complete";
	final ExitRequested = "exit_requested";
	final RestoreComplete = "restore_complete";
	final Rejected = "rejected";
	final Inactive = "inactive";
	final AlreadyActive = "already_active";
}
