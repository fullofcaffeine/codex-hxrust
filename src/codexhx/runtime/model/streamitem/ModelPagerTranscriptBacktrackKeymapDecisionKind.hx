package codexhx.runtime.model.streamitem;

enum abstract ModelPagerTranscriptBacktrackKeymapDecisionKind(String) to String {
	final PagerTranscriptBacktrackConflictRejected = "pager_transcript_backtrack_conflict_rejected";
	final PagerTranscriptBacktrackConflictMissed = "pager_transcript_backtrack_conflict_missed";
}
