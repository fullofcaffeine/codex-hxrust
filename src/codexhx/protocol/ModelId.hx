package codexhx.protocol;

class ModelId {
	final value:String;

	function new(value:String) {
		this.value = value;
	}

	public static function fromString(value:String):Null<ModelId> {
		final valid = IdValidation.parseNonEmptyScalar(value);
		return valid == null ? null : new ModelId(valid);
	}

	public function toString():String {
		return value;
	}

	public function toJsonString():String {
		return JsonScalar.quote(value);
	}
}
