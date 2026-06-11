package codexhx.state.goals;

import codexhx.protocol.goals.ThreadGoal;

class GoalOperationOutcome {
    public final ok:Bool;
    public final goal:ThreadGoal;
    public final cleared:Bool;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, goal:ThreadGoal, cleared:Bool, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.goal = goal;
        this.cleared = cleared;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(goal:ThreadGoal):GoalOperationOutcome {
        return new GoalOperationOutcome(true, goal, false, "", "");
    }

    public static function clearResult(value:Bool):GoalOperationOutcome {
        return new GoalOperationOutcome(true, null, value, "", "");
    }

    public static function failure(code:String, message:String):GoalOperationOutcome {
        return new GoalOperationOutcome(false, null, false, code, message);
    }
}
