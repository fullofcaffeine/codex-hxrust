package codexhx.runtime.app;

class CodexRuntimeEvent {
    public final sequence:Int;
    public final kind:CodexRuntimeEventKind;
    public final delivery:CodexRuntimeEventDelivery;
    public final method:String;
    public final requestId:String;
    public final payloadJson:String;
    public final summary:String;
    public final skipped:Int;

    function new(
        sequence:Int,
        kind:CodexRuntimeEventKind,
        delivery:CodexRuntimeEventDelivery,
        method:String,
        requestId:String,
        payloadJson:String,
        summary:String,
        skipped:Int
    ) {
        this.sequence = sequence;
        this.kind = kind;
        this.delivery = delivery;
        this.method = method;
        this.requestId = requestId;
        this.payloadJson = payloadJson;
        this.summary = summary;
        this.skipped = skipped;
    }

    public static function notification(sequence:Int, method:String, payloadJson:String, summary:String):CodexRuntimeEvent {
        return new CodexRuntimeEvent(
            sequence,
            CodexRuntimeEventKind.ServerNotification,
            CodexRuntimeNotificationDelivery.classify(method),
            method,
            "",
            payloadJson,
            summary,
            0
        );
    }

    public static function response(sequence:Int, requestId:String, method:String, payloadJson:String):CodexRuntimeEvent {
        return new CodexRuntimeEvent(
            sequence,
            CodexRuntimeEventKind.ClientResponse,
            CodexRuntimeEventDelivery.Control,
            method,
            requestId,
            payloadJson,
            "response:" + method,
            0
        );
    }

    public static function error(sequence:Int, requestId:String, method:String, payloadJson:String, summary:String):CodexRuntimeEvent {
        return new CodexRuntimeEvent(
            sequence,
            CodexRuntimeEventKind.ClientError,
            CodexRuntimeEventDelivery.Control,
            method,
            requestId,
            payloadJson,
            summary,
            0
        );
    }

    public static function lagged(sequence:Int, skipped:Int):CodexRuntimeEvent {
        return new CodexRuntimeEvent(
            sequence,
            CodexRuntimeEventKind.Lagged,
            CodexRuntimeEventDelivery.BestEffort,
            "",
            "",
            "{\"skipped\":" + Std.string(skipped) + "}",
            "lagged:" + Std.string(skipped),
            skipped
        );
    }

    public static function disconnected(sequence:Int, message:String):CodexRuntimeEvent {
        return new CodexRuntimeEvent(
            sequence,
            CodexRuntimeEventKind.Disconnected,
            CodexRuntimeEventDelivery.Control,
            "",
            "",
            "{\"message\":" + quote(message) + "}",
            "disconnected",
            0
        );
    }

    public function canonicalSummary():String {
        return Std.string(sequence) + ":" + kind + ":" + delivery + ":" + method + ":" + requestId + ":" + summary + ":" + Std.string(skipped);
    }

    static function quote(value:String):String {
        var out = "\"";
        var i = 0;
        while (i < value.length) {
            final ch = value.charAt(i);
            out += switch ch {
                case "\\": "\\\\";
                case "\"": "\\\"";
                case "\n": "\\n";
                case "\r": "\\r";
                case "\t": "\\t";
                case _: ch;
            }
            i = i + 1;
        }
        return out + "\"";
    }
}
