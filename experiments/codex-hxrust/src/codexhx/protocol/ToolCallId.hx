package codexhx.protocol;

class ToolCallId {
    final value:String;

    function new(value:String) {
        this.value = value;
    }

    public static function fromString(value:String):Null<ToolCallId> {
        final valid = IdValidation.parseNonEmptyScalar(value);
        return valid == null ? null : new ToolCallId(valid);
    }

    public function toString():String {
        return value;
    }

    public function toJsonString():String {
        return JsonScalar.quote(value);
    }
}
