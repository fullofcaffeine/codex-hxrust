package codexhx.protocol;

class ItemId {
	final value:String;

	function new(value:String) {
		this.value = value;
	}

	public static function fromString(value:String):Null<ItemId> {
		final valid = IdValidation.parseNonEmptyScalar(value);
		return valid == null ? null : new ItemId(valid);
	}

	public function toString():String {
		return value;
	}

	public function toJsonString():String {
		return JsonScalar.quote(value);
	}
}
