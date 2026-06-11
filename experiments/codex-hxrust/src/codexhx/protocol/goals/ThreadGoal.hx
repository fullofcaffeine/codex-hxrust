package codexhx.protocol.goals;

import codexhx.protocol.JsonScalar;
import haxe.json.Value;

class ThreadGoal {
    public final threadId:String;
    public final objective:String;
    public final status:String;
    public final hasTokenBudget:Bool;
    public final tokenBudget:Int;
    public final tokensUsed:Int;
    public final timeUsedSeconds:Int;
    public final createdAt:Int;
    public final updatedAt:Int;

    public function new(
        threadId:String,
        objective:String,
        status:String,
        hasTokenBudget:Bool,
        tokenBudget:Int,
        tokensUsed:Int,
        timeUsedSeconds:Int,
        createdAt:Int,
        updatedAt:Int
    ) {
        this.threadId = threadId;
        this.objective = objective;
        this.status = status;
        this.hasTokenBudget = hasTokenBudget;
        this.tokenBudget = tokenBudget;
        this.tokensUsed = tokensUsed;
        this.timeUsedSeconds = timeUsedSeconds;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public function withStatus(status:String, updatedAt:Int):ThreadGoal {
        return new ThreadGoal(threadId, objective, status, hasTokenBudget, tokenBudget, tokensUsed, timeUsedSeconds, createdAt, updatedAt);
    }

    public function withObjective(objective:String, status:String, updatedAt:Int):ThreadGoal {
        return new ThreadGoal(threadId, objective, status, hasTokenBudget, tokenBudget, tokensUsed, timeUsedSeconds, createdAt, updatedAt);
    }

    public function withBudget(hasTokenBudget:Bool, tokenBudget:Int, updatedAt:Int):ThreadGoal {
        return new ThreadGoal(threadId, objective, status, hasTokenBudget, tokenBudget, tokensUsed, timeUsedSeconds, createdAt, updatedAt);
    }

    public function withUsage(tokensUsed:Int, timeUsedSeconds:Int, updatedAt:Int):ThreadGoal {
        return new ThreadGoal(threadId, objective, status, hasTokenBudget, tokenBudget, tokensUsed, timeUsedSeconds, createdAt, updatedAt);
    }

    public function remainingTokens():GoalBudgetRead {
        if (!hasTokenBudget) return GoalBudgetRead.absent();
        final remaining = tokenBudget - tokensUsed;
        return GoalBudgetRead.some(remaining < 0 ? 0 : remaining);
    }

    public function appJson():String {
        return baseJson(true);
    }

    public function toolJson():String {
        return baseJson(false);
    }

    function baseJson(includeNullBudget:Bool):String {
        var json = "{"
            + "\"threadId\":" + quote(threadId)
            + ",\"objective\":" + quote(objective)
            + ",\"status\":" + quote(status);
        if (hasTokenBudget) {
            json = json + ",\"tokenBudget\":" + Std.string(tokenBudget);
        } else if (includeNullBudget) {
            json = json + ",\"tokenBudget\":null";
        }
        return json
            + ",\"tokensUsed\":" + Std.string(tokensUsed)
            + ",\"timeUsedSeconds\":" + Std.string(timeUsedSeconds)
            + ",\"createdAt\":" + Std.string(createdAt)
            + ",\"updatedAt\":" + Std.string(updatedAt)
            + "}";
    }

    public static function parseApp(value:Value):ThreadGoalRead {
        return switch value {
            case JObject(keys, values):
                final threadId = stringField(keys, values, "threadId");
                final objective = stringField(keys, values, "objective");
                final status = stringField(keys, values, "status");
                final tokenBudget = optionalBudget(keys, values, "tokenBudget");
                final tokensUsed = intField(keys, values, "tokensUsed");
                final timeUsedSeconds = intField(keys, values, "timeUsedSeconds");
                final createdAt = intField(keys, values, "createdAt");
                final updatedAt = intField(keys, values, "updatedAt");
                if (!threadId.ok || !objective.ok || !status.ok || !tokenBudget.ok || !tokensUsed.ok || !timeUsedSeconds.ok || !createdAt.ok || !updatedAt.ok) {
                    ThreadGoalRead.failure("invalid_goal_json");
                } else if (!ThreadGoalStatus.isValid(status.value)) {
                    ThreadGoalRead.failure("invalid_goal_status");
                } else {
                    ThreadGoalRead.success(new ThreadGoal(
                        threadId.value,
                        objective.value,
                        status.value,
                        tokenBudget.present,
                        tokenBudget.value,
                        tokensUsed.value,
                        timeUsedSeconds.value,
                        createdAt.value,
                        updatedAt.value
                    ));
                }
            case _:
                ThreadGoalRead.failure("expected_goal_object");
        }
    }

    static function stringField(keys:Array<String>, values:Array<Value>, name:String):GoalStringRead {
        final i = fieldIndex(keys, name);
        if (i < 0) return GoalStringRead.failure();
        return switch values[i] {
            case JString(value): GoalStringRead.success(value);
            case _: GoalStringRead.failure();
        }
    }

    static function intField(keys:Array<String>, values:Array<Value>, name:String):GoalIntRead {
        final i = fieldIndex(keys, name);
        if (i < 0) return GoalIntRead.failure();
        return switch values[i] {
            case JNumber(value): GoalIntRead.success(Std.int(value));
            case _: GoalIntRead.failure();
        }
    }

    static function optionalBudget(keys:Array<String>, values:Array<Value>, name:String):GoalBudgetRead {
        final i = fieldIndex(keys, name);
        if (i < 0) return GoalBudgetRead.absent();
        return switch values[i] {
            case JNull: GoalBudgetRead.absent();
            case JNumber(value): GoalBudgetRead.some(Std.int(value));
            case _: GoalBudgetRead.failure();
        }
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }
}

class ThreadGoalRead {
    public final ok:Bool;
    public final value:ThreadGoal;
    public final errorCode:String;

    function new(ok:Bool, value:ThreadGoal, errorCode:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
    }

    public static function success(value:ThreadGoal):ThreadGoalRead {
        return new ThreadGoalRead(true, value, "");
    }

    public static function failure(errorCode:String):ThreadGoalRead {
        return new ThreadGoalRead(false, null, errorCode);
    }
}

class GoalStringRead {
    public final ok:Bool;
    public final value:String;

    function new(ok:Bool, value:String) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:String):GoalStringRead {
        return new GoalStringRead(true, value);
    }

    public static function failure():GoalStringRead {
        return new GoalStringRead(false, "");
    }
}

class GoalIntRead {
    public final ok:Bool;
    public final value:Int;

    function new(ok:Bool, value:Int) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:Int):GoalIntRead {
        return new GoalIntRead(true, value);
    }

    public static function failure():GoalIntRead {
        return new GoalIntRead(false, 0);
    }
}

class GoalBudgetRead {
    public final ok:Bool;
    public final present:Bool;
    public final value:Int;

    function new(ok:Bool, present:Bool, value:Int) {
        this.ok = ok;
        this.present = present;
        this.value = value;
    }

    public static function some(value:Int):GoalBudgetRead {
        return new GoalBudgetRead(true, true, value);
    }

    public static function absent():GoalBudgetRead {
        return new GoalBudgetRead(true, false, 0);
    }

    public static function failure():GoalBudgetRead {
        return new GoalBudgetRead(false, false, 0);
    }
}
