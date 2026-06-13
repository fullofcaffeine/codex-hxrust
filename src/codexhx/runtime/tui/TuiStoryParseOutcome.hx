package codexhx.runtime.tui;

class TuiStoryParseOutcome {
    public final ok:Bool;
    public final record:Null<TuiStoryRecord>;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, record:Null<TuiStoryRecord>, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.record = record;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(record:TuiStoryRecord):TuiStoryParseOutcome {
        return new TuiStoryParseOutcome(true, record, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):TuiStoryParseOutcome {
        return new TuiStoryParseOutcome(false, null, code, path, message);
    }
}
