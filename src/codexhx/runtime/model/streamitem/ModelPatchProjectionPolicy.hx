package codexhx.runtime.model.streamitem;

class ModelPatchProjectionPolicy {
	public static function project(request:ModelPatchProjectionRequest):ModelPatchProjectionOutcome {
		if (request == null) return failure("", "missing patch projection request");
		if (request.verificationOutcome == null || !request.verificationOutcome.ok || request.verificationOutcome.endEvent == null) {
			return failure(request.requestId, "patch projection requires a verified patch outcome");
		}
		if (request.applicationOutcome == null || !request.applicationOutcome.ok) {
			return failure(request.requestId, "patch projection requires a modeled application outcome");
		}
		if (request.approvalOutcome == null || !request.approvalOutcome.ok) {
			return failure(request.requestId, "patch projection requires a modeled approval outcome");
		}
		if (request.trackerOutcome == null || !request.trackerOutcome.ok) {
			return failure(request.requestId, "patch projection requires a modeled turn-diff tracker outcome");
		}

		final endEvent = request.verificationOutcome.endEvent;
		final beginEvent = request.verificationOutcome.beginEvent;
		final changes:Array<ModelPatchFileChangeProjection> = [];
		for (change in endEvent.changes) changes.push(ModelPatchFileChangeProjection.fromChange(change));
		final events:Array<ModelPatchProjectionEventKind> = [ModelPatchProjectionEventKind.FileChangeItem];
		if (request.includeLegacyEvents && beginEvent != null) events.push(ModelPatchProjectionEventKind.PatchApplyBegin);
		if (request.includeLegacyEvents) events.push(ModelPatchProjectionEventKind.PatchApplyEnd);
		if (request.trackerOutcome.shouldEmitTurnDiff) events.push(ModelPatchProjectionEventKind.TurnDiff);
		return new ModelPatchProjectionOutcome(
			true,
			"patch_file_change_projection_modeled",
			request.requestId,
			endEvent.callId,
			true,
			request.includeLegacyEvents && beginEvent != null,
			request.includeLegacyEvents,
			request.trackerOutcome.shouldEmitTurnDiff,
			request.applicationOutcome.status,
			beginEvent != null && beginEvent.autoApproved,
			request.applicationOutcome.stdout.length > 0,
			request.applicationOutcome.stderr.length > 0,
			changes.length,
			request.trackerOutcome.unifiedDiff,
			events,
			changes,
			false,
			false,
			false,
			""
		);
	}

	static function failure(requestId:String, errorMessage:String):ModelPatchProjectionOutcome {
		return new ModelPatchProjectionOutcome(
			false,
			"patch_file_change_projection_failed",
			requestId,
			"",
			false,
			false,
			false,
			false,
			ModelPatchApplyStatus.Failed,
			false,
			false,
			false,
			0,
			"",
			[],
			[],
			false,
			false,
			false,
			errorMessage
		);
	}
}
