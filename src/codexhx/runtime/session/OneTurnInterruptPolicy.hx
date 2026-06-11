package codexhx.runtime.session;

class OneTurnInterruptPolicy {
    public final cancelBeforeStart:Bool;
    public final cancelAfterEvents:Int;

    function new(cancelBeforeStart:Bool, cancelAfterEvents:Int) {
        this.cancelBeforeStart = cancelBeforeStart;
        this.cancelAfterEvents = cancelAfterEvents;
    }

    public static function never():OneTurnInterruptPolicy {
        return new OneTurnInterruptPolicy(false, -1);
    }

    public static function beforeStart():OneTurnInterruptPolicy {
        return new OneTurnInterruptPolicy(true, -1);
    }

    public static function afterEvents(eventCount:Int):OneTurnInterruptPolicy {
        return new OneTurnInterruptPolicy(false, eventCount);
    }

    public function shouldCancelAfterEvents(eventCount:Int):Bool {
        return cancelAfterEvents >= 0 && eventCount >= cancelAfterEvents;
    }
}
