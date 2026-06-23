package codexhx.runtime.tui.resume.host;

enum abstract CompletionScheduledRenderExecutionKind(String) to String {
	final LocalRenderExecuted = "local_render_executed";
	final RenderExecutionRejected = "render_execution_rejected";
	final Unknown = "unknown";
}
