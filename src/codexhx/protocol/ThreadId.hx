package codexhx.protocol;

class ThreadId {
	final value:String;

	function new(value:String) {
		this.value = value;
	}

	public static function fromString(value:String):Null<ThreadId> {
		final normalized = IdValidation.parseUuid(value);
		return normalized == null ? null : new ThreadId(normalized);
	}

	public static function unsafeAssumeValid(value:String):ThreadId {
		return new ThreadId(value);
	}

	public static function fromSessionId(value:SessionId):ThreadId {
		return new ThreadId(value.toString());
	}

	public function toSessionId():SessionId {
		return SessionId.unsafeAssumeValid(value);
	}

	public function toString():String {
		return value;
	}

	public function toJsonString():String {
		return JsonScalar.quote(value);
	}

	public function equals(other:ThreadId):Bool {
		return other != null && value == other.value;
	}
}
