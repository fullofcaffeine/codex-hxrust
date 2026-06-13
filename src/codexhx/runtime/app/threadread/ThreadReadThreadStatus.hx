package codexhx.runtime.app.threadread;

enum abstract ThreadReadThreadStatus(String) from String to String {
	public var NotLoaded = "notLoaded";
	public var Idle = "idle";
	public var SystemError = "systemError";
	public var Active = "active";

	public static function isValid(value:String):Bool {
		return value == NotLoaded || value == Idle || value == SystemError || value == Active;
	}
}
