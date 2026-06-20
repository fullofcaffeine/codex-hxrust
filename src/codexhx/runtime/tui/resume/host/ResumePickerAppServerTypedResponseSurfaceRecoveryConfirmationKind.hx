package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseSurfaceRecoveryConfirmationKind(String) to String {
	final RecoveryConfirmed = "recovery_confirmed";
	final RecoveryRejected = "recovery_rejected";
	final Unknown = "unknown";
}
