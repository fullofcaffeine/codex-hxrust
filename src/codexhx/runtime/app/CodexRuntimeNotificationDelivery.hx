package codexhx.runtime.app;

class CodexRuntimeNotificationDelivery {
    public static function classify(method:String):CodexRuntimeEventDelivery {
        return requiresDelivery(method) ? CodexRuntimeEventDelivery.Lossless : CodexRuntimeEventDelivery.BestEffort;
    }

    public static function requiresDelivery(method:String):Bool {
        return method == "turn/completed"
            || method == "thread/settings/updated"
            || method == "item/completed"
            || method == "item/agentMessage/delta"
            || method == "item/plan/delta"
            || method == "item/reasoning/summaryTextDelta"
            || method == "item/reasoning/textDelta";
    }
}
