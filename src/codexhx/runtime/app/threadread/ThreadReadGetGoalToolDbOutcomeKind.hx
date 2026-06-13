package codexhx.runtime.app.threadread;

enum abstract ThreadReadGetGoalToolDbOutcomeKind(String) to String {
	public var Found = "found";
	public var Missing = "missing";
	public var Error = "error";
}
