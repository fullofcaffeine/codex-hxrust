package codexhx.runtime.model.streamitem;

class ModelFreshSessionPreviousConversationShutdownPolicy {
	public static function apply(request:ModelFreshSessionPreviousConversationShutdownRequest):ModelFreshSessionPreviousConversationShutdownOutcome {
		if (request == null)
			return failure("", "missing fresh-session previous-conversation shutdown request");

		final previousConversationPresent = request.chatWidgetThreadKnown && request.previousThreadId.length > 0;
		final shutdownCurrentThreadAttempted = request.newSessionRequested && previousConversationPresent;
		final pendingRollbackCleared = shutdownCurrentThreadAttempted && request.pendingRollbackBefore;
		final threadUnsubscribeAttempted = shutdownCurrentThreadAttempted && request.appServerSessionAvailable;
		final threadUnsubscribeSucceeded = threadUnsubscribeAttempted && request.unsubscribeSucceeded;
		final listenerAbortAttempted = shutdownCurrentThreadAttempted && request.listenerTaskTracked;
		final listenerTaskRemoved = listenerAbortAttempted;
		final opShutdownSubmitted = false;
		final opQueueLengthAfter = request.opQueueLengthBefore;
		final duplicateShutdownSuppressed = shutdownCurrentThreadAttempted
			&& !opShutdownSubmitted
			&& opQueueLengthAfter == request.opQueueLengthBefore;
		final newSessionMayStartAfterShutdown = request.newSessionRequested && (!threadUnsubscribeAttempted || threadUnsubscribeSucceeded);
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = decision(previousConversationPresent, shutdownCurrentThreadAttempted, threadUnsubscribeAttempted, threadUnsubscribeSucceeded);
		final ok = previousConversationPresent && shutdownCurrentThreadAttempted && threadUnsubscribeAttempted && threadUnsubscribeSucceeded
			&& listenerTaskRemoved && duplicateShutdownSuppressed && newSessionMayStartAfterShutdown && eventOrderingPreserved;

		return new ModelFreshSessionPreviousConversationShutdownOutcome({
			ok: ok,
			code: ok ? "fresh_session_previous_conversation_shutdown_modeled" : "fresh_session_previous_conversation_shutdown_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			previousConversationPresent: previousConversationPresent,
			shutdownCurrentThreadAttempted: shutdownCurrentThreadAttempted,
			pendingRollbackCleared: pendingRollbackCleared,
			threadUnsubscribeAttempted: threadUnsubscribeAttempted,
			threadUnsubscribeSucceeded: threadUnsubscribeSucceeded,
			listenerAbortAttempted: listenerAbortAttempted,
			listenerTaskRemoved: listenerTaskRemoved,
			opShutdownSubmitted: opShutdownSubmitted,
			opQueueLengthBefore: request.opQueueLengthBefore,
			opQueueLengthAfter: opQueueLengthAfter,
			duplicateShutdownSuppressed: duplicateShutdownSuppressed,
			newSessionMayStartAfterShutdown: newSessionMayStartAfterShutdown,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "fresh-session previous conversation shutdown invariants were not satisfied"
		});
	}

	static function decision(previousConversationPresent:Bool, shutdownCurrentThreadAttempted:Bool, threadUnsubscribeAttempted:Bool,
			threadUnsubscribeSucceeded:Bool):ModelFreshSessionPreviousConversationShutdownDecisionKind {
		if (!previousConversationPresent || !shutdownCurrentThreadAttempted) {
			return ModelFreshSessionPreviousConversationShutdownDecisionKind.NoPreviousConversationNoop;
		}
		if (threadUnsubscribeAttempted && !threadUnsubscribeSucceeded) {
			return ModelFreshSessionPreviousConversationShutdownDecisionKind.PreviousConversationUnsubscribeFailed;
		}
		return ModelFreshSessionPreviousConversationShutdownDecisionKind.PreviousConversationShutdownRequested;
	}

	static function failure(requestId:String, errorMessage:String):ModelFreshSessionPreviousConversationShutdownOutcome {
		return new ModelFreshSessionPreviousConversationShutdownOutcome({
			ok: false,
			code: "fresh_session_previous_conversation_shutdown_failed",
			requestId: requestId,
			decisionKind: ModelFreshSessionPreviousConversationShutdownDecisionKind.NoPreviousConversationNoop,
			previousConversationPresent: false,
			shutdownCurrentThreadAttempted: false,
			pendingRollbackCleared: false,
			threadUnsubscribeAttempted: false,
			threadUnsubscribeSucceeded: false,
			listenerAbortAttempted: false,
			listenerTaskRemoved: false,
			opShutdownSubmitted: false,
			opQueueLengthBefore: 0,
			opQueueLengthAfter: 0,
			duplicateShutdownSuppressed: false,
			newSessionMayStartAfterShutdown: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
