package codexhx.protocol.json;

class SerdeBridge {
	public static function parse(text:String):JsonParseOutcome {
		return CodexJson.parse(text);
	}

	public static function encodeStringObject(keys:Array<String>, values:Array<String>):String {
		return CodexJson.encodeStringObject(keys, values);
	}
}
