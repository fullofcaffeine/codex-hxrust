package codexhx.runtime.tui.appserver;

/**
	Environment variable value for a future app-server process transport.
**/
class TuiAppServerJsonRpcProcessEnvVar {
	public final name:String;
	public final value:String;

	public function new(name:String, value:String) {
		this.name = normalize(name);
		this.value = normalize(value);
	}

	public function isValid():Bool {
		return name.length > 0;
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
