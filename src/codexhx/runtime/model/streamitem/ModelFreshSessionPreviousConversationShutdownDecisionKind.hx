package codexhx.runtime.model.streamitem;

enum abstract ModelFreshSessionPreviousConversationShutdownDecisionKind(String) to String {
	final PreviousConversationShutdownRequested = "previous_conversation_shutdown_requested";
	final NoPreviousConversationNoop = "no_previous_conversation_noop";
	final PreviousConversationUnsubscribeFailed = "previous_conversation_unsubscribe_failed";
}
