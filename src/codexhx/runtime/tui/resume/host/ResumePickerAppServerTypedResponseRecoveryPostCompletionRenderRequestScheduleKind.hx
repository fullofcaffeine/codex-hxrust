package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind(String) to String {
	final LocalRenderScheduled = "local_render_scheduled";
	final RenderScheduleRejected = "render_schedule_rejected";
	final Unknown = "unknown";
}
