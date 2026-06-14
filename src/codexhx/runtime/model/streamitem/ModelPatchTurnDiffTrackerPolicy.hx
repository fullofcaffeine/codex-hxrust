package codexhx.runtime.model.streamitem;

class ModelPatchTurnDiffTrackerPolicy {
	public static function update(request:ModelPatchTurnDiffTrackerRequest):ModelPatchTurnDiffTrackerOutcome {
		if (request == null) return failure("", "missing patch turn-diff tracker request");
		if (request.verificationOutcome == null || !request.verificationOutcome.ok || request.verificationOutcome.endEvent == null) {
			return failure(request.requestId, "turn-diff tracker update requires a verified patch outcome");
		}
		if (request.applicationOutcome == null || !request.applicationOutcome.ok) {
			return failure(request.requestId, "turn-diff tracker update requires a modeled application outcome");
		}
		if (request.approvalOutcome == null || !request.approvalOutcome.ok) {
			return failure(request.requestId, "turn-diff tracker update requires a modeled approval outcome");
		}

		final updateKind = updateKindFor(request.stage, request.appliedDelta);
		final trackerValid = updateKind != ModelPatchTurnDiffTrackerUpdateKind.Invalidate
			&& !(updateKind == ModelPatchTurnDiffTrackerUpdateKind.Track && !request.appliedDelta.exact);
		final unifiedDiff = trackerValid && updateKind == ModelPatchTurnDiffTrackerUpdateKind.Track ? renderUnifiedDiff(request.environmentId, request.appliedDelta.changes) : "";
		final shouldEmit = updateKind != ModelPatchTurnDiffTrackerUpdateKind.None && (request.previousUnifiedDiff.length > 0 || unifiedDiff.length > 0);
		return new ModelPatchTurnDiffTrackerOutcome(
			true,
			"patch_turn_diff_tracker_updated",
			request.requestId,
			updateKind,
			trackerValid,
			shouldEmit,
			unifiedDiff,
			false,
			false,
			false,
			""
		);
	}

	static function updateKindFor(stage:ModelPatchToolEventStageKind, delta:ModelPatchAppliedDelta):ModelPatchTurnDiffTrackerUpdateKind {
		if (delta != null && delta.known) {
			if (delta.exact && delta.isEmpty()) return ModelPatchTurnDiffTrackerUpdateKind.None;
			return ModelPatchTurnDiffTrackerUpdateKind.Track;
		}
		if (stage == ModelPatchToolEventStageKind.Success || stage == ModelPatchToolEventStageKind.FailureOutput) {
			return ModelPatchTurnDiffTrackerUpdateKind.Invalidate;
		}
		return ModelPatchTurnDiffTrackerUpdateKind.None;
	}

	static function renderUnifiedDiff(environmentId:String, changes:Array<ModelPatchFileChange>):String {
		final out:Array<String> = [];
		for (change in changes) {
			final display = environmentId.length > 0 ? environmentId + ":" + change.path : change.path;
			if (change.kind == ModelPatchFileChangeKind.Add) {
				out.push("diff --git a/" + display + " b/" + display);
				out.push("--- /dev/null");
				out.push("+++ b/" + display);
				for (line in splitLines(change.content)) out.push("+" + line);
			} else if (change.kind == ModelPatchFileChangeKind.Delete) {
				out.push("diff --git a/" + display + " b/" + display);
				out.push("--- a/" + display);
				out.push("+++ /dev/null");
				for (line in splitLines(change.content)) out.push("-" + line);
			} else if (change.kind == ModelPatchFileChangeKind.Update) {
				final dest = change.movePath.length > 0 ? change.movePath : change.path;
				final destDisplay = environmentId.length > 0 ? environmentId + ":" + dest : dest;
				out.push("diff --git a/" + display + " b/" + destDisplay);
				out.push("--- a/" + display);
				out.push("+++ b/" + destDisplay);
				for (chunk in change.chunks) out.push(chunk.unifiedDiff());
			}
		}
		return out.join("\n");
	}

	static function splitLines(content:String):Array<String> {
		if (content == null || content.length == 0) return [];
		final raw = content.split("\n");
		if (raw.length > 0 && raw[raw.length - 1] == "") raw.resize(raw.length - 1);
		return raw;
	}

	static function failure(requestId:String, errorMessage:String):ModelPatchTurnDiffTrackerOutcome {
		return new ModelPatchTurnDiffTrackerOutcome(
			false,
			"patch_turn_diff_tracker_failed",
			requestId,
			ModelPatchTurnDiffTrackerUpdateKind.None,
			false,
			false,
			"",
			false,
			false,
			false,
			errorMessage
		);
	}
}
