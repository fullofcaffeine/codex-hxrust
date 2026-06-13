package codexhx.runtime.app.threadread;

enum abstract ThreadReadCreateGoalToolPreviewOutcomeKind(String) to String {
	public var Updated = "updated";
	public var Unchanged = "unchanged";
	public var Error = "error";
	public var NotAttempted = "not_attempted";
}
