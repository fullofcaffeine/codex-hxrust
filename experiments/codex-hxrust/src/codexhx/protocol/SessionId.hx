package codexhx.protocol;

class SessionId {
    final value:String;

    function new(value:String) {
        this.value = value;
    }

    public static function fromString(value:String):Null<SessionId> {
        final normalized = IdValidation.parseUuid(value);
        return normalized == null ? null : new SessionId(normalized);
    }

    public static function unsafeAssumeValid(value:String):SessionId {
        return new SessionId(value);
    }

    public static function fromThreadId(value:ThreadId):SessionId {
        return new SessionId(value.toString());
    }

    public function toThreadId():ThreadId {
        return ThreadId.unsafeAssumeValid(value);
    }

    public function toString():String {
        return value;
    }

    public function toJsonString():String {
        return JsonScalar.quote(value);
    }

    public function equals(other:SessionId):Bool {
        return other != null && value == other.value;
    }
}
