package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessKind(String) to String {
	final PostRenderKeyboardReady = "post_render_keyboard_ready";
	final PostRenderKeyboardReadinessRejected = "post_render_keyboard_readiness_rejected";
	final Unknown = "unknown";
}
