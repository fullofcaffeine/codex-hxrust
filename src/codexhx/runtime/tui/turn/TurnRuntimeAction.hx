package codexhx.runtime.tui.turn;

class TurnRuntimeAction {
    public final kind:TurnRuntimeActionKind;
    public final text:String;
    public final fromReplay:Bool;
    public final activeGoalContinuation:Bool;
    public final copySource:Bool;
    public final planItems:Array<TurnPlanItem>;

    function new(
        kind:TurnRuntimeActionKind,
        text:String,
        fromReplay:Bool,
        activeGoalContinuation:Bool,
        copySource:Bool,
        planItems:Array<TurnPlanItem>
    ) {
        this.kind = kind;
        this.text = text;
        this.fromReplay = fromReplay;
        this.activeGoalContinuation = activeGoalContinuation;
        this.copySource = copySource;
        this.planItems = planItems;
    }

    public static function taskStarted():TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.TaskStarted, "", false, false, false, []);
    }

    public static function assistantDelta(text:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.AssistantDelta, text, false, false, false, []);
    }

    public static function assistantFinal(markdown:String, copySource:Bool):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.AssistantFinal, markdown, false, false, copySource, []);
    }

    public static function planDelta(text:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.PlanDelta, text, false, false, false, []);
    }

    public static function planFinal(items:Array<TurnPlanItem>):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.PlanFinal, "", false, false, false, items);
    }

    public static function queueFollowUp(prompt:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.QueueFollowUp, prompt, false, false, false, []);
    }

    public static function queueSteer(prompt:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.QueueSteer, prompt, false, false, false, []);
    }

    public static function taskCompleted(lastAgentMessage:String, fromReplay:Bool, activeGoalContinuation:Bool):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.TaskCompleted, lastAgentMessage, fromReplay, activeGoalContinuation, false, []);
    }

    public static function taskFailed(message:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.TaskFailed, message, false, false, false, []);
    }

    public static function taskCancelled(message:String):TurnRuntimeAction {
        return new TurnRuntimeAction(TurnRuntimeActionKind.TaskCancelled, message, false, false, false, []);
    }
}
