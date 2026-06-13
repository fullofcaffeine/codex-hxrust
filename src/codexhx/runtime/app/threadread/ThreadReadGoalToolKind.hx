package codexhx.runtime.app.threadread;

enum abstract ThreadReadGoalToolKind(String) to String {
	public var Get = "get_goal";
	public var Create = "create_goal";
	public var Update = "update_goal";
}
