package codexhx.runtime.tui;

enum abstract TuiStoryDirection(String) from String to String {
	var Meta = "meta";
	var ToTui = "to_tui";
	var FromTui = "from_tui";

	public static function isValid(value:String):Bool {
		return value == Meta || value == ToTui || value == FromTui;
	}
}
