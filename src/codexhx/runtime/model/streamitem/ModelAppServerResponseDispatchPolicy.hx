package codexhx.runtime.model.streamitem;

class ModelAppServerResponseDispatchPolicy {
	public static function dispatch(request:ModelAppServerResponseDispatchRequest):ModelAppServerResponseDispatchOutcome {
		if (request == null) return failure("", "", ModelAppServerResponseDispatchKind.ResolveResponse, "missing app-server response dispatch request");
		if (request.resolutionOutcome == null) return failure(request.requestId, "", request.dispatchKind, "missing app-server request resolution outcome");
		if (!request.resolutionOutcome.ok) return failure(request.requestId, request.resolutionOutcome.requestId, request.dispatchKind, "app-server request resolution outcome was not successful");

		final missingSession = !request.appServerSessionAvailable || request.dispatchKind == ModelAppServerResponseDispatchKind.MissingSessionNoop;
		final resolve = request.dispatchKind == ModelAppServerResponseDispatchKind.ResolveResponse
			&& request.resolutionOutcome.serializedResponseIntentEmitted
			&& request.serializedPayloadAvailable
			&& !missingSession;
		final reject = request.dispatchKind == ModelAppServerResponseDispatchKind.RejectUnsupported
			&& request.resolutionOutcome.unsupportedRequestRejected
			&& request.unsupportedRejectReason.length > 0
			&& !missingSession;
		final serializationRefused = request.dispatchKind == ModelAppServerResponseDispatchKind.SerializationRefusal
			|| (request.dispatchKind == ModelAppServerResponseDispatchKind.ResolveResponse && !request.serializedPayloadAvailable);
		final dispatchIntent = (resolve || reject) && !serializationRefused;
		final sendFailed = dispatchIntent && !request.transportSendSucceeds;
		final orderingPreserved = dispatchIntent && request.responseOrderIndex == request.previousDispatchCount + 1;
		final refresh = resolve && request.transportSendSucceeds && opCanChangePendingReplayState(request.resolutionOutcome.commandKind);

		return new ModelAppServerResponseDispatchOutcome(
			true,
			"app_server_response_dispatch_modeled",
			request.requestId,
			request.resolutionOutcome.requestId,
			request.resolutionOutcome.requestKind,
			request.dispatchKind,
			request.resolutionOutcome.appServerRequestId,
			request.resolutionOutcome.payloadKind,
			request.appServerSessionAvailable,
			request.serializedPayloadAvailable,
			dispatchIntent,
			resolve,
			reject,
			reject,
			orderingPreserved,
			refresh,
			missingSession,
			serializationRefused,
			sendFailed,
			false,
			true,
			request.resolutionOutcome.liveNetworkAttempted,
			request.resolutionOutcome.realFilesystemMutated,
			request.resolutionOutcome.toolExecutedOutsideFixture,
			sendFailed ? "failed to dispatch app-server request response" : ""
		);
	}

	static function opCanChangePendingReplayState(commandKind:ModelAppServerRequestResolutionCommandKind):Bool {
		return commandKind == ModelAppServerRequestResolutionCommandKind.ExecApprovalResponse
			|| commandKind == ModelAppServerRequestResolutionCommandKind.FileChangeApprovalResponse
			|| commandKind == ModelAppServerRequestResolutionCommandKind.PermissionsResponse
			|| commandKind == ModelAppServerRequestResolutionCommandKind.UserInputAnswer
			|| commandKind == ModelAppServerRequestResolutionCommandKind.McpElicitationResponse;
	}

	static function failure(
		requestId:String,
		resolutionRequestId:String,
		dispatchKind:ModelAppServerResponseDispatchKind,
		errorMessage:String
	):ModelAppServerResponseDispatchOutcome {
		return new ModelAppServerResponseDispatchOutcome(
			false,
			"app_server_response_dispatch_failed",
			requestId,
			resolutionRequestId,
			ModelReplayedServerRequestKind.UserInput,
			dispatchKind,
			"",
			ModelAppServerRequestResolutionPayloadKind.None,
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
			true,
			false,
			false,
			false,
			errorMessage
		);
	}
}
