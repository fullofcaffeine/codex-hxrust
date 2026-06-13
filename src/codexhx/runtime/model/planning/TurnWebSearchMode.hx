package codexhx.runtime.model.planning;

enum abstract TurnWebSearchMode(String) to String {
	public var Disabled = "disabled";
	public var Cached = "cached";
	public var Live = "live";
}
