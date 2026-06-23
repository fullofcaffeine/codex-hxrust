package codexhx.runtime.tui.resume.host;

enum abstract CompletionRenderedStateHandoffKind(String) to String {
	final RenderedIdleListReady = "rendered_idle_list_ready";
	final RenderedStateHandoffRejected = "rendered_state_handoff_rejected";
	final Unknown = "unknown";
}
