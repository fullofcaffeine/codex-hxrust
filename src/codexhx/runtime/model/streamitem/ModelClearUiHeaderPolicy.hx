package codexhx.runtime.model.streamitem;

class ModelClearUiHeaderPolicy {
	public static function apply(request:ModelClearUiHeaderRequest):ModelClearUiHeaderOutcome {
		if (request == null)
			return failure("", "", "missing clear UI header request");
		final activeShutdownRequestId = request.activeShutdownOutcome == null ? "" : request.activeShutdownOutcome.requestId;
		if (request.activeShutdownOutcome == null)
			return failure(request.requestId, "", "missing active non-primary shutdown outcome");
		if (!request.activeShutdownOutcome.ok)
			return failure(request.requestId, activeShutdownRequestId, "active non-primary shutdown outcome was not successful");

		final ordered = request.activeShutdownOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1;
		if (!request.redrawHeader) {
			return new ModelClearUiHeaderOutcome(true, "clear_ui_header_modeled", request.requestId, activeShutdownRequestId,
				ModelClearUiHeaderDecisionKind.SkippedNoRedraw, request.requestKind, "", "", "", 0, request.width, request.version, false, true,
				request.altScreenActive, !request.altScreenActive, request.viewportYBefore > 0, false, false, true, request.staleNoticeProbe.length > 0,
				request.staleTranscriptProbe.length > 0, request.requestKind == ModelClearUiHeaderRequestKind.CtrlL, false, ordered,
				request.activeShutdownOutcome.liveNetworkAttempted, request.activeShutdownOutcome.realFilesystemMutated,
				request.activeShutdownOutcome.toolExecutedOutsideFixture, "");
		}

		final titleLine = ">_ OpenAI Codex (v" + request.version + ")";
		final modelLine = "model: " + request.model + reasoningSuffix(request.reasoningEffort) + (request.fastStatusEligible ? "   fast" : "")
			+ "   /model to change";
		final directoryLine = "directory: " + request.cwd;
		final decisionKind = request.fastStatusEligible ? ModelClearUiHeaderDecisionKind.RenderedFastStatusHeader : (request.requestKind == ModelClearUiHeaderRequestKind.CtrlL ? ModelClearUiHeaderDecisionKind.ReusedClearHeaderForCtrlL : ModelClearUiHeaderDecisionKind.RenderedFreshHeader);

		return new ModelClearUiHeaderOutcome(true, "clear_ui_header_modeled", request.requestId, activeShutdownRequestId, decisionKind, request.requestKind,
			titleLine, modelLine, directoryLine, 6, request.width, request.version, true, true, request.altScreenActive, !request.altScreenActive,
			request.viewportYBefore > 0, true, true, true, request.staleNoticeProbe.length > 0, request.staleTranscriptProbe.length > 0,
			request.requestKind == ModelClearUiHeaderRequestKind.CtrlL, request.fastStatusEligible, ordered,
			request.activeShutdownOutcome.liveNetworkAttempted, request.activeShutdownOutcome.realFilesystemMutated,
			request.activeShutdownOutcome.toolExecutedOutsideFixture, "");
	}

	static function reasoningSuffix(reasoningEffort:String):String {
		return reasoningEffort == null || reasoningEffort.length == 0 ? "" : " " + reasoningEffort;
	}

	static function failure(requestId:String, activeShutdownRequestId:String, errorMessage:String):ModelClearUiHeaderOutcome {
		return new ModelClearUiHeaderOutcome(false, "clear_ui_header_failed", requestId, activeShutdownRequestId,
			ModelClearUiHeaderDecisionKind.RenderedFreshHeader, ModelClearUiHeaderRequestKind.SlashClear, "", "", "", 0, 0, "", false, false, false, false,
			false, false, false, false, false, false, false, false, false, false, false, false, errorMessage);
	}
}
