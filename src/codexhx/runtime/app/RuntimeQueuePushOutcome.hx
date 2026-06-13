package codexhx.runtime.app;

class RuntimeQueuePushOutcome {
    public final ok:Bool;
    public final code:String;
    public final message:String;
    public final event:Null<CodexRuntimeEvent>;
    public final queuedCount:Int;
    public final skippedCount:Int;

    function new(ok:Bool, code:String, message:String, event:Null<CodexRuntimeEvent>, queuedCount:Int, skippedCount:Int) {
        this.ok = ok;
        this.code = code;
        this.message = message;
        this.event = event;
        this.queuedCount = queuedCount;
        this.skippedCount = skippedCount;
    }

    public static function queued(event:CodexRuntimeEvent, queuedCount:Int, skippedCount:Int):RuntimeQueuePushOutcome {
        return new RuntimeQueuePushOutcome(true, "queued", "", event, queuedCount, skippedCount);
    }

    public static function dropped(code:String, message:String, queuedCount:Int, skippedCount:Int):RuntimeQueuePushOutcome {
        return new RuntimeQueuePushOutcome(true, code, message, null, queuedCount, skippedCount);
    }

    public static function blocked(code:String, message:String, queuedCount:Int, skippedCount:Int):RuntimeQueuePushOutcome {
        return new RuntimeQueuePushOutcome(false, code, message, null, queuedCount, skippedCount);
    }
}
