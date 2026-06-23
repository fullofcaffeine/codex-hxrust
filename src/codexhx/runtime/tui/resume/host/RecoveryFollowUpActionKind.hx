package codexhx.runtime.tui.resume.host;

enum abstract RecoveryFollowUpActionKind(String) to String {
	final RestoredListStatus = "restored_list_status";
	final ScheduleRecoveryFrame = "schedule_recovery_frame";
	final RecoveredSelectionReady = "recovered_selection_ready";
	final Unknown = "unknown";
}
