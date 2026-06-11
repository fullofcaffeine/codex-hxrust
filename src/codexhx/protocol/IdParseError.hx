package codexhx.protocol;

class IdParseError {
    public final kind:String;
    public final input:String;
    public final message:String;

    public function new(kind:String, input:String, message:String) {
        this.kind = kind;
        this.input = input;
        this.message = message;
    }

    public function toString():String {
        return kind + ": " + message;
    }
}
