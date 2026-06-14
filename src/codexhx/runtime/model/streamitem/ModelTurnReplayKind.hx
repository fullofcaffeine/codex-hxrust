package codexhx.runtime.model.streamitem;

enum abstract ModelTurnReplayKind(String) to String {
	final ResumeInitialMessages = "resume_initial_messages";
	final ThreadSnapshot = "thread_snapshot";
}
