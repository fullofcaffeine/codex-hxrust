package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartupRoutingPolicy {
	public static function apply(request:ModelThreadSideThreadStartupRoutingRequest):ModelThreadSideThreadStartupRoutingOutcome {
		if (request == null) return failure("", "", "missing thread side-thread startup routing request");
		final startRequestId = request.startOutcome == null ? "" : request.startOutcome.requestId;
		if (request.startOutcome == null) return failure(request.requestId, "", "missing thread side-thread start outcome");
		if (!request.startOutcome.ok) return failure(request.requestId, startRequestId, "thread side-thread start outcome was not successful");

		final serverKnown = trim(request.mcpServerName).length > 0;
		final failedStartup = request.startupEventKind == ModelThreadSideThreadStartupEventKind.Failed;
		final rendersFailure = serverKnown && failedStartup && trim(request.startupErrorMessage).length > 0;

		if (!request.notificationThreadScoped) {
			return success(
				request,
				startRequestId,
				ModelThreadSideThreadStartupRoutingDecisionKind.AppScopedIgnored,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false,
				false
			);
		}

		if (request.snapshotReplay) {
			return success(
				request,
				startRequestId,
				request.snapshotSessionIsSideThread
					? ModelThreadSideThreadStartupRoutingDecisionKind.SideSessionConfigured
					: ModelThreadSideThreadStartupRoutingDecisionKind.ReplayedBufferedChildThread,
				false,
				false,
				false,
				true,
				false,
				request.snapshotSessionIsSideThread,
				request.snapshotSessionIsSideThread,
				request.snapshotSessionIsSideThread || request.visibleThreadIsSideThread,
				request.startupEventKind != ModelThreadSideThreadStartupEventKind.Ready,
				rendersFailure,
				rendersFailure,
				rendersFailure,
				rendersFailure
			);
		}

		if (request.activeThreadChannel && !request.notificationTargetsVisibleThread) {
			return success(
				request,
				startRequestId,
				ModelThreadSideThreadStartupRoutingDecisionKind.MisroutedVisibleThreadIgnored,
				false,
				true,
				false,
				false,
				false,
				false,
				false,
				request.visibleThreadIsSideThread,
				false,
				false,
				false,
				false,
				false
			);
		}

		if (request.notificationTargetsVisibleThread && request.activeThreadChannel && request.targetThreadIsSideThread) {
			return success(
				request,
				startRequestId,
				ModelThreadSideThreadStartupRoutingDecisionKind.RenderedActiveSideThread,
				false,
				false,
				false,
				true,
				true,
				false,
				true,
				request.visibleThreadIsSideThread,
				request.startupEventKind != ModelThreadSideThreadStartupEventKind.Ready,
				rendersFailure,
				rendersFailure,
				rendersFailure,
				rendersFailure
			);
		}

		return success(
			request,
			startRequestId,
			ModelThreadSideThreadStartupRoutingDecisionKind.BufferedForChildThread,
			false,
			false,
			true,
			true,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false
		);
	}

	static function success(
		request:ModelThreadSideThreadStartupRoutingRequest,
		startRequestId:String,
		decisionKind:ModelThreadSideThreadStartupRoutingDecisionKind,
		appScopedIgnored:Bool,
		misroutedVisibleThreadIgnored:Bool,
		childThreadChannelEnsured:Bool,
		notificationBuffered:Bool,
		notificationSentToActiveReceiver:Bool,
		sideThreadSessionHandled:Bool,
		sideConversationDisplayMode:Bool,
		contextLabelPreserved:Bool,
		startupStatusRendered:Bool,
		startupFailureWarningRendered:Bool,
		loginErrorRendered:Bool,
		activeTranscriptMutated:Bool,
		appEventRendered:Bool
	):ModelThreadSideThreadStartupRoutingOutcome {
		return new ModelThreadSideThreadStartupRoutingOutcome(
			true,
			"thread_side_thread_startup_routing_modeled",
			request.requestId,
			startRequestId,
			decisionKind,
			request.startupEventKind,
			true,
			appScopedIgnored,
			misroutedVisibleThreadIgnored,
			childThreadChannelEnsured,
			notificationBuffered,
			notificationSentToActiveReceiver,
			sideThreadSessionHandled,
			sideConversationDisplayMode,
			contextLabelPreserved,
			startupStatusRendered,
			startupFailureWarningRendered,
			loginErrorRendered,
			activeTranscriptMutated,
			appEventRendered,
			request.startOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1,
			request.startOutcome.liveNetworkAttempted,
			request.startOutcome.realFilesystemMutated,
			request.startOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function failure(requestId:String, startRequestId:String, errorMessage:String):ModelThreadSideThreadStartupRoutingOutcome {
		return new ModelThreadSideThreadStartupRoutingOutcome(
			false,
			"thread_side_thread_startup_routing_failed",
			requestId,
			startRequestId,
			ModelThreadSideThreadStartupRoutingDecisionKind.BufferedForChildThread,
			ModelThreadSideThreadStartupEventKind.Starting,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}

	static function trim(value:String):String {
		return value == null ? "" : StringTools.trim(value);
	}
}
