package codexhx.runtime.model.streamitem;

enum abstract ModelFeedbackSubmissionHistoryCellKind(String) from String to String {
	final None = "none";
	final Success = "success";
	final Error = "error";
}
