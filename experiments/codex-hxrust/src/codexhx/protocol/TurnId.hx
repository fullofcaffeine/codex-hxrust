package codexhx.protocol;

class TurnId {
    final value:String;

    function new(value:String) {
        this.value = value;
    }

    public static function fromString(value:String):Null<TurnId> {
        final valid = IdValidation.parseNonEmptyScalar(value);
        return valid == null ? null : new TurnId(valid);
    }

    public function toString():String {
        return value;
    }

    public function toJsonString():String {
        return JsonScalar.quote(value);
    }
}
