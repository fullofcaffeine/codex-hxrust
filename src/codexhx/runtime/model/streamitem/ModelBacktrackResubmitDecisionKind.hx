package codexhx.runtime.model.streamitem;

enum abstract ModelBacktrackResubmitDecisionKind(String) to String {
	final DataImageUrlPreserved = "data_image_url_preserved";
	final ResubmitBlocked = "resubmit_blocked";
}
