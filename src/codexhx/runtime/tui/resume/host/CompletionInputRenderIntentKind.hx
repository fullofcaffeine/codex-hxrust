package codexhx.runtime.tui.resume.host;

enum abstract CompletionInputRenderIntentKind(String) to String {
	final LocalRenderRequested = "local_render_requested";
	final RenderIntentRejected = "render_intent_rejected";
	final Unknown = "unknown";
}
