package codexhx.runtime.model.streamitem;

class ModelPatchVerificationPolicy {
	public static function verify(request:ModelPatchVerificationRequest):ModelPatchVerificationOutcome {
		if (request == null) return failure("", "missing_patch_verification_request", "missing patch verification request");
		if (request.reducerOutcome == null || !request.reducerOutcome.ok) {
			return failure(request.requestId, "reducer_outcome_not_reduced", "patch verification requires a reduced stream outcome");
		}

		final patchInput = queuedApplyPatchInput(request.reducerOutcome, request.callId);
		if (patchInput.length == 0) return failure(request.requestId, "missing_apply_patch_input", "missing queued apply_patch input for callId=" + request.callId);

		final parse = parsePatch(request.callId, patchInput);
		if (parse == null) return failure(request.requestId, "invalid_apply_patch_input", "apply_patch input could not be parsed");

		final verificationError = verifyChanges(parse.changes, request.files);
		if (verificationError.length > 0) return failure(request.requestId, "patch_verification_failed", verificationError);

		final verifiedChanges = hydrateVerifiedChanges(parse.changes, request.files);
		final begin = new ModelPatchVerificationEvent(
			ModelPatchVerificationEventKind.Begin,
			request.callId,
			request.turnId,
			request.autoApproved,
			request.desiredStatus,
			false,
			verifiedChanges,
			"",
			""
		);
		final success = request.desiredStatus == ModelPatchApplyStatus.Completed;
		final end = new ModelPatchVerificationEvent(
			ModelPatchVerificationEventKind.End,
			request.callId,
			request.turnId,
			request.autoApproved,
			request.desiredStatus,
			success,
			verifiedChanges,
			request.stdout,
			request.stderr
		);
		return new ModelPatchVerificationOutcome(
			true,
			"patch_apply_verified",
			request.requestId,
			begin,
			end,
			false,
			false,
			false,
			""
		);
	}

	static function queuedApplyPatchInput(outcome:ModelStreamItemReducerOutcome, callId:String):String {
		for (event in outcome.runtimeEvents) {
			if (event.kind == ModelStreamRuntimeEventKind.ToolCallQueued
				&& event.callId == callId
				&& event.toolName == "apply_patch") return event.text;
		}
		return "";
	}

	static function parsePatch(callId:String, patchInput:String):ModelToolArgumentDiffConsumerEvent {
		final consumer = ModelToolArgumentDiffConsumerState.create("apply_patch", callId);
		final delta = new ModelStreamToolInputDelta(callId, "", patchInput, patchInput, ModelStreamToolInputDeltaStatus.Accepted, 1);
		final first = consumer.consume(delta);
		if (consumer.hasError()) return null;
		final finished = consumer.finish();
		if (consumer.hasError()) return null;
		return finished == null ? first : finished;
	}

	static function verifyChanges(changes:Array<ModelPatchFileChange>, files:Array<ModelPatchVirtualFile>):String {
		if (changes == null || changes.length == 0) return "apply_patch input has no file changes";
		for (change in changes) {
			if (change.path.length == 0) return "patch change path must not be empty";
			if (change.kind == ModelPatchFileChangeKind.Delete && !hasFile(files, change.path)) {
				return "delete source is missing from fixture filesystem: " + change.path;
			}
			if (change.kind == ModelPatchFileChangeKind.Update && !hasFile(files, change.path)) {
				return "update source is missing from fixture filesystem: " + change.path;
			}
			if (change.kind == ModelPatchFileChangeKind.Update && change.movePath.length > 0 && hasFile(files, change.movePath)) {
				return "move destination already exists in fixture filesystem: " + change.movePath;
			}
		}
		return "";
	}

	static function hydrateVerifiedChanges(changes:Array<ModelPatchFileChange>, files:Array<ModelPatchVirtualFile>):Array<ModelPatchFileChange> {
		final out:Array<ModelPatchFileChange> = [];
		for (change in changes) {
			final copy = change.copy();
			if (copy.kind == ModelPatchFileChangeKind.Delete || copy.kind == ModelPatchFileChangeKind.Update) copy.content = fileContent(files, copy.path);
			out.push(copy);
		}
		return out;
	}

	static function hasFile(files:Array<ModelPatchVirtualFile>, path:String):Bool {
		for (file in files) if (file.path == path) return true;
		return false;
	}

	static function fileContent(files:Array<ModelPatchVirtualFile>, path:String):String {
		for (file in files) if (file.path == path) return file.content;
		return "";
	}

	static function failure(requestId:String, code:String, errorMessage:String):ModelPatchVerificationOutcome {
		return new ModelPatchVerificationOutcome(false, code, requestId, null, null, false, false, false, errorMessage);
	}
}
