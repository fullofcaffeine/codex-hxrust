package codexhx.protocol;

class RequestIds {
	public static function fromString(value:String):Null<RequestId> {
		return RequestId.fromString(value);
	}

	public static function fromInteger(value:Int):RequestId {
		return RequestId.fromInteger(value);
	}

	public static function toString(value:RequestId):String {
		return value.toString();
	}

	public static function toJsonScalar(value:RequestId):String {
		return value.toJsonScalar();
	}
}
