package codexhx.runtime.app;

class RuntimeClientOutcome {
    public final ok:Bool;
    public final code:String;
    public final message:String;
    public final requestId:String;
    public final method:String;
    public final canonicalJson:String;
    public final queue:Null<RuntimeQueuePushOutcome>;
    public final pendingCount:Int;

    function new(
        ok:Bool,
        code:String,
        message:String,
        requestId:String,
        method:String,
        canonicalJson:String,
        queue:Null<RuntimeQueuePushOutcome>,
        pendingCount:Int
    ) {
        this.ok = ok;
        this.code = code;
        this.message = message;
        this.requestId = requestId;
        this.method = method;
        this.canonicalJson = canonicalJson;
        this.queue = queue;
        this.pendingCount = pendingCount;
    }

    public static function accepted(command:CodexRuntimeCommand, canonicalJson:String, pendingCount:Int):RuntimeClientOutcome {
        return new RuntimeClientOutcome(true, "accepted", "", command.requestId, command.method, canonicalJson, null, pendingCount);
    }

    public static function evented(
        code:String,
        requestId:String,
        method:String,
        canonicalJson:String,
        queue:RuntimeQueuePushOutcome,
        pendingCount:Int
    ):RuntimeClientOutcome {
        return new RuntimeClientOutcome(queue.ok, code, queue.message, requestId, method, canonicalJson, queue, pendingCount);
    }

    public static function failure(code:String, message:String, requestId:String, method:String, pendingCount:Int):RuntimeClientOutcome {
        return new RuntimeClientOutcome(false, code, message, requestId, method, "", null, pendingCount);
    }
}
