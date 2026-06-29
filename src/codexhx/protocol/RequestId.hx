package codexhx.protocol;

import haxe.json.Value;

class RequestId {
	final value:String;
	final integer:Bool;

	function new(value:String, integer:Bool) {
		this.value = value;
		this.integer = integer;
	}

	public static function fromString(value:String):Null<RequestId> {
		final valid = IdValidation.parseNonEmptyScalar(value);
		return valid == null ? null : new RequestId(valid, false);
	}

	public static function fromInteger(value:Int):RequestId {
		return new RequestId(Std.string(value), true);
	}

	public function isString():Bool {
		return !integer;
	}

	public function toString():String {
		return value;
	}

	public function toJsonScalar():String {
		return integer ? value : JsonScalar.quote(value);
	}

	public function toJsonValue():Value {
		return integer ? JNumber(Std.parseFloat(value)) : JString(value);
	}
}
