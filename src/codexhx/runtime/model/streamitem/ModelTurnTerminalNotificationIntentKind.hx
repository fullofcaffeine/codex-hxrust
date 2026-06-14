package codexhx.runtime.model.streamitem;

enum abstract ModelTurnTerminalNotificationIntentKind(String) to String {
	final None = "none";
	final AppServerTurnCompleted = "app_server_turn_completed";
	final TuiAgentTurnComplete = "tui_agent_turn_complete";
	final TuiInterruptedTurn = "tui_interrupted_turn";
	final TuiErrorSurface = "tui_error_surface";
}
