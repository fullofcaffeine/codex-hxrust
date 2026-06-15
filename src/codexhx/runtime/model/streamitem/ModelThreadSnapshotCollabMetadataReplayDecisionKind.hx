package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSnapshotCollabMetadataReplayDecisionKind(String) to String {
	final MetadataReseededForReplay = "metadata_reseeded_for_replay";
	final MetadataReplayBlocked = "metadata_replay_blocked";
}
