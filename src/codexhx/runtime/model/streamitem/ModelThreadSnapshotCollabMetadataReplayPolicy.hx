package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotCollabMetadataReplayPolicy {
	public static function replay(request:ModelThreadSnapshotCollabMetadataReplayRequest):ModelThreadSnapshotCollabMetadataReplayOutcome {
		if (request == null) return failure("", ModelTurnReplayKind.ThreadSnapshot, "missing collab metadata replay request");

		final reseeded = request.replacementCreatedBeforeReplay ? request.navigationEntries.copy() : [];
		var namedWaitItemCount = 0;
		var waitItemRendered = false;
		var renderedWaitContainsMetadata = false;
		var fallbackThreadIdRendered = false;
		var renderedWaitSummary = "";

		for (waitItem in request.waitItems) {
			waitItemRendered = true;
			final metadata = metadataForThread(reseeded, waitItem.receiverThreadId);
			if (metadata == null) {
				fallbackThreadIdRendered = true;
				if (renderedWaitSummary.length == 0) renderedWaitSummary = "receiver=" + waitItem.receiverThreadId;
			} else {
				namedWaitItemCount = namedWaitItemCount + 1;
				final rendered = renderAgentLabel(metadata);
				if (renderedWaitSummary.length == 0) renderedWaitSummary = rendered;
				if (rendered == request.expectedAgentNickname + " [" + request.expectedAgentRole + "]") renderedWaitContainsMetadata = true;
			}
		}

		final agentNicknamePreserved = containsNickname(reseeded, request.expectedAgentNickname);
		final agentRolePreserved = containsRole(reseeded, request.expectedAgentRole);
		final metadataReseededBeforeReplay = request.replacementCreatedBeforeReplay && reseeded.length == request.navigationEntries.length && reseeded.length > 0;
		final ok = request.replayKind == ModelTurnReplayKind.ThreadSnapshot
			&& metadataReseededBeforeReplay
			&& agentNicknamePreserved
			&& agentRolePreserved
			&& waitItemRendered
			&& renderedWaitContainsMetadata
			&& !fallbackThreadIdRendered;

		return new ModelThreadSnapshotCollabMetadataReplayOutcome({
			ok: ok,
			code: ok ? "thread_snapshot_collab_metadata_replay_modeled" : "thread_snapshot_collab_metadata_replay_blocked",
			requestId: request.requestId,
			replayKind: request.replayKind,
			decisionKind: ok ? ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReseededForReplay : ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReplayBlocked,
			navigationEntryCount: request.navigationEntries.length,
			reseededMetadataCount: reseeded.length,
			replayedWaitItemCount: request.waitItems.length,
			namedWaitItemCount: namedWaitItemCount,
			replacementCreatedBeforeReplay: request.replacementCreatedBeforeReplay,
			metadataReseededBeforeReplay: metadataReseededBeforeReplay,
			agentNicknamePreserved: agentNicknamePreserved,
			agentRolePreserved: agentRolePreserved,
			waitItemRendered: waitItemRendered,
			renderedWaitContainsMetadata: renderedWaitContainsMetadata,
			fallbackThreadIdRendered: fallbackThreadIdRendered,
			liveOnlyEffectsSuppressed: true,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			renderedWaitSummary: renderedWaitSummary,
			errorMessage: ok ? "" : "collab metadata replay mismatch"
		});
	}

	static function metadataForThread(entries:Array<ModelCollabAgentMetadataEntry>, threadId:String):ModelCollabAgentMetadataEntry {
		for (entry in entries) if (entry.threadId == threadId) return entry;
		return null;
	}

	static function containsNickname(entries:Array<ModelCollabAgentMetadataEntry>, nickname:String):Bool {
		for (entry in entries) if (entry.agentNickname == nickname) return true;
		return false;
	}

	static function containsRole(entries:Array<ModelCollabAgentMetadataEntry>, role:String):Bool {
		for (entry in entries) if (entry.agentRole == role) return true;
		return false;
	}

	static function renderAgentLabel(metadata:ModelCollabAgentMetadataEntry):String {
		if (metadata.agentNickname.length > 0 && metadata.agentRole.length > 0) return metadata.agentNickname + " [" + metadata.agentRole + "]";
		if (metadata.agentNickname.length > 0) return metadata.agentNickname;
		if (metadata.agentRole.length > 0) return "[" + metadata.agentRole + "]";
		return metadata.threadId;
	}

	static function failure(
		requestId:String,
		replayKind:ModelTurnReplayKind,
		errorMessage:String
	):ModelThreadSnapshotCollabMetadataReplayOutcome {
		return new ModelThreadSnapshotCollabMetadataReplayOutcome({
			ok: false,
			code: "thread_snapshot_collab_metadata_replay_failed",
			requestId: requestId,
			replayKind: replayKind,
			decisionKind: ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReplayBlocked,
			navigationEntryCount: 0,
			reseededMetadataCount: 0,
			replayedWaitItemCount: 0,
			namedWaitItemCount: 0,
			replacementCreatedBeforeReplay: false,
			metadataReseededBeforeReplay: false,
			agentNicknamePreserved: false,
			agentRolePreserved: false,
			waitItemRendered: false,
			renderedWaitContainsMetadata: false,
			fallbackThreadIdRendered: false,
			liveOnlyEffectsSuppressed: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			renderedWaitSummary: "",
			errorMessage: errorMessage
		});
	}
}
