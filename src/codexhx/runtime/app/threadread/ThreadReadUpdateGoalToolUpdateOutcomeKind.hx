package codexhx.runtime.app.threadread;

enum abstract ThreadReadUpdateGoalToolUpdateOutcomeKind(String) to String {
	public var Updated = "updated";
	public var Missing = "missing";
	public var Error = "error";
}
