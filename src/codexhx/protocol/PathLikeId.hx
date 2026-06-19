package codexhx.protocol;

class PathLikeId {
	final value:String;

	function new(value:String) {
		this.value = value;
	}

	public static function fromString(value:String):Null<PathLikeId> {
		final valid = IdValidation.parseNonEmptyScalar(value);
		return valid == null ? null : new PathLikeId(valid);
	}

	public function toString():String {
		return value;
	}

	public function toJsonString():String {
		return JsonScalar.quote(value);
	}
}
