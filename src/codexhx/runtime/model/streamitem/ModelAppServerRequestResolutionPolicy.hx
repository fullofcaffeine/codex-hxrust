package codexhx.runtime.model.streamitem;

class ModelAppServerRequestResolutionPolicy {
	public static function resolve(request:ModelAppServerRequestResolutionRequest):ModelAppServerRequestResolutionOutcome {
		if (request == null)
			return failure("", "", ModelReplayedServerRequestKind.UserInput, ModelAppServerRequestResolutionCommandKind.UserInputAnswer,
				"missing app-server request resolution request");
		if (request.surfaceOutcome == null)
			return failure(request.requestId, "", request.requestKind, request.commandKind, "missing replayed server request surface outcome");
		if (!request.surfaceOutcome.ok)
			return failure(request.requestId, request.surfaceOutcome.requestId, request.requestKind, request.commandKind,
				"replayed server request surface outcome was not successful");

		final supported = isSupported(request.requestKind);
		final pendingRecorded = supported && request.appServerRequestId.length > 0 && request.pendingRequestCountBefore > 0;
		final commandMatched = pendingRecorded && !request.duplicateResponse && commandMatches(request);
		final notification = request.commandKind == ModelAppServerRequestResolutionCommandKind.ServerRequestResolvedNotification;
		final serialized = commandMatched && !notification;
		final userInputPopped = commandMatched && request.commandKind == ModelAppServerRequestResolutionCommandKind.UserInputAnswer;
		final unsupportedRejected = !supported;
		final noop = !commandMatched && !unsupportedRejected;
		final queueAfter = userInputPopped ? request.userInputQueueLengthBefore - 1 : request.userInputQueueLengthBefore;
		final live = request.surfaceOutcome.liveNetworkAttempted;
		final fs = request.surfaceOutcome.realFilesystemMutated;
		final tool = request.surfaceOutcome.toolExecutedOutsideFixture;

		return new ModelAppServerRequestResolutionOutcome(true, "app_server_request_resolution_modeled", request.requestId, request.surfaceOutcome.requestId,
			request.requestKind, request.commandKind, serialized ? payloadKind(request.commandKind) : ModelAppServerRequestResolutionPayloadKind.None,
			request.appServerRequestId, request.requestKey, request.commandKey, pendingRecorded, commandMatched, commandMatched, serialized, commandMatched
			&& request.commandKind == ModelAppServerRequestResolutionCommandKind.ExecApprovalResponse, commandMatched && request.commandKind == ModelAppServerRequestResolutionCommandKind.FileChangeApprovalResponse,
			commandMatched
			&& request.commandKind == ModelAppServerRequestResolutionCommandKind.PermissionsResponse, userInputPopped, queueAfter,
			userInputPopped ? request.pendingItemId : "", commandMatched && request.commandKind == ModelAppServerRequestResolutionCommandKind.McpElicitationResponse, commandMatched
			&& notification, noop,
			unsupportedRejected, true, live, fs, tool, "");
	}

	static function isSupported(kind:ModelReplayedServerRequestKind):Bool {
		return kind == ModelReplayedServerRequestKind.ExecApproval
			|| kind == ModelReplayedServerRequestKind.FileChangeApproval
			|| kind == ModelReplayedServerRequestKind.PermissionsApproval
			|| kind == ModelReplayedServerRequestKind.UserInput
			|| kind == ModelReplayedServerRequestKind.McpElicitation;
	}

	static function commandMatches(request:ModelAppServerRequestResolutionRequest):Bool {
		return switch request.commandKind {
			case ModelAppServerRequestResolutionCommandKind.ExecApprovalResponse: request.requestKind == ModelReplayedServerRequestKind.ExecApproval && request.requestKey == request.commandKey;
			case ModelAppServerRequestResolutionCommandKind.FileChangeApprovalResponse: request.requestKind == ModelReplayedServerRequestKind.FileChangeApproval && request.requestKey == request.commandKey;
			case ModelAppServerRequestResolutionCommandKind.PermissionsResponse: request.requestKind == ModelReplayedServerRequestKind.PermissionsApproval && request.requestKey == request.commandKey;
			case ModelAppServerRequestResolutionCommandKind.UserInputAnswer:
				request.requestKind == ModelReplayedServerRequestKind.UserInput
				&& request.requestKey == request.commandKey
				&& request.userInputQueueLengthBefore > 0
				&& request.userInputQueuePosition == 0;
			case ModelAppServerRequestResolutionCommandKind.McpElicitationResponse: request.requestKind == ModelReplayedServerRequestKind.McpElicitation && request.serverName == request.commandServerName && request.mcpRequestId == request.commandMcpRequestId;
			case ModelAppServerRequestResolutionCommandKind.ServerRequestResolvedNotification:
				request.appServerRequestId.length > 0;
		}
	}

	static function payloadKind(commandKind:ModelAppServerRequestResolutionCommandKind):ModelAppServerRequestResolutionPayloadKind {
		return switch commandKind {
			case ModelAppServerRequestResolutionCommandKind.ExecApprovalResponse:
				ModelAppServerRequestResolutionPayloadKind.CommandExecutionApprovalResponse;
			case ModelAppServerRequestResolutionCommandKind.FileChangeApprovalResponse:
				ModelAppServerRequestResolutionPayloadKind.FileChangeApprovalResponse;
			case ModelAppServerRequestResolutionCommandKind.PermissionsResponse:
				ModelAppServerRequestResolutionPayloadKind.PermissionsApprovalResponse;
			case ModelAppServerRequestResolutionCommandKind.UserInputAnswer:
				ModelAppServerRequestResolutionPayloadKind.ToolRequestUserInputResponse;
			case ModelAppServerRequestResolutionCommandKind.McpElicitationResponse:
				ModelAppServerRequestResolutionPayloadKind.McpElicitationResponse;
			case ModelAppServerRequestResolutionCommandKind.ServerRequestResolvedNotification:
				ModelAppServerRequestResolutionPayloadKind.None;
		}
	}

	static function failure(requestId:String, surfaceRequestId:String, requestKind:ModelReplayedServerRequestKind,
			commandKind:ModelAppServerRequestResolutionCommandKind, errorMessage:String):ModelAppServerRequestResolutionOutcome {
		return new ModelAppServerRequestResolutionOutcome(false, "app_server_request_resolution_failed", requestId, surfaceRequestId, requestKind,
			commandKind, ModelAppServerRequestResolutionPayloadKind.None, "", "", "", false, false, false, false, false, false, false, false, 0, "", false,
			false, false, false, true, false, false, false, errorMessage);
	}
}
