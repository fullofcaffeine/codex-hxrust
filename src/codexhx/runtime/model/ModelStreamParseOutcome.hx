package codexhx.runtime.model;

class ModelStreamParseOutcome {
    public final ok:Bool;
    public final events:Array<ModelStreamEvent>;
    public final assistantText:String;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, events:Array<ModelStreamEvent>, assistantText:String, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.events = events;
        this.assistantText = assistantText;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(events:Array<ModelStreamEvent>, assistantText:String):ModelStreamParseOutcome {
        return new ModelStreamParseOutcome(true, events, assistantText, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ModelStreamParseOutcome {
        return new ModelStreamParseOutcome(false, [], "", code, path, message);
    }

    public function canonicalEventsJson():String {
        final parts:Array<String> = [];
        for (event in events) {
            parts.push(event.canonicalJson());
        }
        return "[" + parts.join(",") + "]";
    }
}
