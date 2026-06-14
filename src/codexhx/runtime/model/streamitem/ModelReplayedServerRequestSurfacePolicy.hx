package codexhx.runtime.model.streamitem;

class ModelReplayedServerRequestSurfacePolicy {
	public static function surface(request:ModelReplayedServerRequestSurfaceRequest):ModelReplayedServerRequestSurfaceOutcome {
		if (request == null) return failure("", "", ModelReplayedServerRequestKind.UserInput, ModelTurnReplayKind.ThreadSnapshot, "missing replayed server request surface request");
		if (!request.liveRequest && request.dispatchOutcome == null) {
			return failure(request.requestId, "", request.requestKind, request.replayKind, "missing replay dispatch outcome");
		}
		if (request.dispatchOutcome != null && !request.dispatchOutcome.ok) {
			return failure(request.requestId, request.dispatchOutcome.requestId, request.requestKind, request.replayKind, "replay dispatch outcome was not successful");
		}

		final dispatchRequestId = request.dispatchOutcome == null ? "" : request.dispatchOutcome.requestId;
		final replayAttached = request.liveRequest ? false : request.dispatchOutcome.replayKindAttached;
		final delivered = request.liveRequest || (request.dispatchOutcome.requestDeliveredWithReplayKind && request.snapshotRequestAllowed);
		final interactive = isInteractive(request.requestKind);
		final handled = delivered && (interactive || isUnsupported(request.requestKind));
		final unsupportedStub = request.liveRequest && isUnsupported(request.requestKind);
		final unsupportedSuppressed = !request.liveRequest && delivered && isUnsupported(request.requestKind) && replayAttached;
		final filtered = !delivered;

		return new ModelReplayedServerRequestSurfaceOutcome(
			true,
			"replayed_server_request_surface_modeled",
			request.requestId,
			dispatchRequestId,
			request.requestKind,
			surfaceKind(request, filtered, unsupportedStub, unsupportedSuppressed),
			request.liveRequest ? request.replayKind : request.dispatchOutcome.replayKind,
			replayAttached,
			request.snapshotRequestAllowed,
			handled,
			delivered && request.requestKind == ModelReplayedServerRequestKind.ExecApproval,
			delivered && request.requestKind == ModelReplayedServerRequestKind.FileChangeApproval,
			delivered && request.requestKind == ModelReplayedServerRequestKind.McpElicitation && !request.elicitationUrlRequest,
			delivered && request.requestKind == ModelReplayedServerRequestKind.McpElicitation && request.elicitationUrlRequest,
			delivered && request.requestKind == ModelReplayedServerRequestKind.PermissionsApproval,
			delivered && request.requestKind == ModelReplayedServerRequestKind.UserInput,
			unsupportedStub,
			unsupportedSuppressed,
			replayAttached || unsupportedSuppressed,
			request.dispatchOutcome != null && request.dispatchOutcome.liveNetworkAttempted,
			request.dispatchOutcome != null && request.dispatchOutcome.realFilesystemMutated,
			request.dispatchOutcome != null && request.dispatchOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function isInteractive(kind:ModelReplayedServerRequestKind):Bool {
		return kind == ModelReplayedServerRequestKind.ExecApproval
			|| kind == ModelReplayedServerRequestKind.FileChangeApproval
			|| kind == ModelReplayedServerRequestKind.McpElicitation
			|| kind == ModelReplayedServerRequestKind.PermissionsApproval
			|| kind == ModelReplayedServerRequestKind.UserInput;
	}

	static function isUnsupported(kind:ModelReplayedServerRequestKind):Bool {
		return kind == ModelReplayedServerRequestKind.DynamicToolCall
			|| kind == ModelReplayedServerRequestKind.AttestationGenerate
			|| kind == ModelReplayedServerRequestKind.ChatgptAuthTokensRefresh
			|| kind == ModelReplayedServerRequestKind.LegacyApplyPatchApproval
			|| kind == ModelReplayedServerRequestKind.LegacyExecCommandApproval;
	}

	static function surfaceKind(
		request:ModelReplayedServerRequestSurfaceRequest,
		filtered:Bool,
		unsupportedStub:Bool,
		unsupportedSuppressed:Bool
	):ModelReplayedServerRequestSurfaceKind {
		if (filtered) return ModelReplayedServerRequestSurfaceKind.RequestFiltered;
		if (unsupportedStub) return ModelReplayedServerRequestSurfaceKind.UnsupportedStubError;
		if (unsupportedSuppressed) return ModelReplayedServerRequestSurfaceKind.UnsupportedReplaySuppressed;
		return switch request.requestKind {
			case ModelReplayedServerRequestKind.ExecApproval:
				ModelReplayedServerRequestSurfaceKind.ExecApprovalPrompt;
			case ModelReplayedServerRequestKind.FileChangeApproval:
				ModelReplayedServerRequestSurfaceKind.FileChangeApprovalPrompt;
			case ModelReplayedServerRequestKind.McpElicitation:
				ModelReplayedServerRequestSurfaceKind.McpElicitationPrompt;
			case ModelReplayedServerRequestKind.PermissionsApproval:
				ModelReplayedServerRequestSurfaceKind.PermissionsPrompt;
			case ModelReplayedServerRequestKind.UserInput:
				ModelReplayedServerRequestSurfaceKind.UserInputPrompt;
			case _:
				ModelReplayedServerRequestSurfaceKind.RequestFiltered;
		}
	}

	static function failure(
		requestId:String,
		dispatchRequestId:String,
		requestKind:ModelReplayedServerRequestKind,
		replayKind:ModelTurnReplayKind,
		errorMessage:String
	):ModelReplayedServerRequestSurfaceOutcome {
		return new ModelReplayedServerRequestSurfaceOutcome(
			false,
			"replayed_server_request_surface_failed",
			requestId,
			dispatchRequestId,
			requestKind,
			ModelReplayedServerRequestSurfaceKind.RequestFiltered,
			replayKind,
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
}
