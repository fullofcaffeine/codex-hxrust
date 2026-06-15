package codexhx.runtime.model.streamitem;

enum abstract ModelFeedbackSubmissionCategory(String) from String to String {
	final Bug = "bug";
	final BadResult = "bad_result";
	final GoodResult = "good_result";
	final SafetyCheck = "safety_check";
	final Other = "other";
}
