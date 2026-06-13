package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnItemsView(String) from String to String {
	public var NotLoaded = "notLoaded";
	public var Summary = "summary";
	public var Full = "full";

	public static function isValid(value:String):Bool {
		return value == NotLoaded || value == Summary || value == Full;
	}
}
