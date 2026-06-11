import codexhx.protocol.JsonScalar;
import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonValueCodec;
import codexhx.state.goals.GoalOperationOutcome;
import codexhx.state.goals.ThreadGoalStore;
import codexhx.tools.goals.GoalToolCallOutcome;
import codexhx.tools.goals.GoalToolHandler;
import haxe.json.Value;
import sys.io.File;

class GoalHarness {
    static inline final threadId = "thread-goal-1";
    static inline final t0 = 1781049600;

    static function main():Void {
        roundTripsGoalDto();
        runsStateTransitionFixture();
        runsGoalToolFixture();
        rejectsUnsupportedBehavior();
    }

    static function roundTripsGoalDto():Void {
        final fixture = StringTools.trim(File.getContent("fixtures/hxrust/thread-goal-active.v1.json"));
        final parsed = expectGoal(ThreadGoal.parseApp(expectJson(CodexJson.parse(fixture))));
        assertEquals(fixture, parsed.appJson());
        assertEquals(fixture, expectGoal(ThreadGoal.parseApp(expectJson(CodexJson.parse(parsed.appJson())))).appJson());
    }

    static function runsStateTransitionFixture():Void {
        final store = new ThreadGoalStore(threadId);
        final lines:Array<String> = [];

        final created = expectGoalOutcome(store.createGoal("Ship Caf goal flow", true, 12, t0));
        lines.push(stepGoal("create", created.goal));

        final paused = expectGoalOutcome(store.setStatus("paused", t0 + 10));
        lines.push(stepGoal("pause", paused.goal));

        final edited = expectGoalOutcome(store.setObjective("Ship Caf goal flow in Haxe", "active", t0 + 20));
        lines.push(stepGoal("edit", edited.goal));

        final usage = expectGoalOutcome(store.accountUsage(5, 3, t0 + 30));
        lines.push(stepGoal("usage", usage.goal));

        final complete = expectGoalOutcome(store.setStatus("complete", t0 + 40));
        lines.push(stepGoal("complete", complete.goal));

        final cleared = store.clear();
        assertTrue(cleared.ok, "clear should succeed");
        lines.push("{\"step\":\"clear\",\"cleared\":" + bool(cleared.cleared) + "}");

        assertEquals(File.getContent("fixtures/hxrust/thread-goal-transition.v1.jsonl"), lines.join("\n") + "\n");
    }

    static function runsGoalToolFixture():Void {
        final store = new ThreadGoalStore(threadId);
        final handler = new GoalToolHandler(store, t0);
        final lines:Array<String> = [];

        lines.push(toolOutput("get_goal", expectTool(handler.handle("get_goal", "{}"))));
        lines.push(toolOutput("create_goal", expectTool(handler.handle("create_goal", "{\"objective\":\" Ship Caf goal flow \",\"token_budget\":12}"))));
        lines.push(toolOutput("get_goal", expectTool(handler.handle("get_goal", "{}"))));
        lines.push(toolError("update_goal", handler.handle("update_goal", "{\"status\":\"active\"}")));
        handler.setNow(t0 + 10);
        lines.push(toolOutput("update_goal", expectTool(handler.handle("update_goal", "{\"status\":\"complete\"}"))));

        assertEquals(File.getContent("fixtures/hxrust/goal-tool-output.v1.jsonl"), lines.join("\n") + "\n");
    }

    static function rejectsUnsupportedBehavior():Void {
        final store = new ThreadGoalStore(threadId);
        final handler = new GoalToolHandler(store, t0);

        final empty = handler.handle("create_goal", "{\"objective\":\"\"}");
        assertFalse(empty.ok, "empty objective should fail");
        assertEquals("invalid_goal_objective", empty.errorCode);

        final badBudget = handler.handle("create_goal", "{\"objective\":\"Budget\",\"token_budget\":0}");
        assertFalse(badBudget.ok, "zero budget should fail");
        assertEquals("invalid_goal_budget", badBudget.errorCode);

        final unsupported = handler.handle("delete_goal", "{}");
        assertFalse(unsupported.ok, "unknown tool should fail");
        assertEquals("unsupported_goal_tool", unsupported.errorCode);
    }

    static function stepGoal(step:String, goal:ThreadGoal):String {
        return "{\"step\":" + quote(step) + ",\"goal\":" + goal.appJson() + "}";
    }

    static function toolOutput(tool:String, outputJson:String):String {
        expectJson(CodexJson.parse(outputJson));
        return "{\"tool\":" + quote(tool) + ",\"output\":" + outputJson + "}";
    }

    static function toolError(tool:String, outcome:GoalToolCallOutcome):String {
        assertFalse(outcome.ok, "tool call should fail");
        return "{\"tool\":" + quote(tool)
            + ",\"errorCode\":" + quote(outcome.errorCode)
            + ",\"errorMessage\":" + quote(outcome.errorMessage)
            + ",\"ok\":false}";
    }

    static function expectTool(outcome:GoalToolCallOutcome):String {
        if (!outcome.ok) throw outcome.errorCode + ": " + outcome.errorMessage;
        return outcome.outputJson;
    }

    static function expectGoalOutcome(outcome:GoalOperationOutcome):GoalOperationOutcome {
        if (!outcome.ok) throw outcome.errorCode + ": " + outcome.errorMessage;
        return outcome;
    }

    static function expectGoal(outcome:codexhx.protocol.goals.ThreadGoal.ThreadGoalRead):ThreadGoal {
        if (!outcome.ok) throw outcome.errorCode;
        return outcome.value;
    }

    static function expectJson(outcome:codexhx.protocol.json.JsonParseOutcome):Value {
        if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        return outcome.value;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }
}
