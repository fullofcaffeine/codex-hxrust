package codexhx.runtime.app.threadread;

enum abstract ThreadReadTurnSortDirection(String) from String to String {
	public var Asc = "asc";
	public var Desc = "desc";

	public static function isValid(value:String):Bool {
		return value == Asc || value == Desc;
	}
}
