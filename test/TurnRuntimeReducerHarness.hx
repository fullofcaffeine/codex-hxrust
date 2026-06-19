import codexhx.protocol.json.CodexJson;
import codexhx.runtime.tui.turn.TurnPlanItem;
import codexhx.runtime.tui.turn.TurnRuntimeAction;
import codexhx.runtime.tui.turn.TurnRuntimeReducer;
import codexhx.runtime.tui.turn.TurnRuntimeState;
import haxe.json.Value;
import sys.io.File;

class TurnRuntimeReducerHarness {
	static function main():Void {
		final fixture = fixtureRoot();
		final scenarios = arrayField(fixture, "scenarios");
		assertEquals("8", Std.string(scenarios.length));
		for (scenarioValue in scenarios) {
			runScenario(scenarioValue);
		}
	}

	static function runScenario(scenarioValue:Value):Void {
		final name = stringField(scenarioValue, "name", "");
		final actions = arrayField(scenarioValue, "actions");
		var state = TurnRuntimeState.initial();
		for (actionValue in actions) {
			state = TurnRuntimeReducer.apply(state, parseAction(actionValue));
		}
		assertExpected(name, state, objectField(scenarioValue, "expect"));
	}

	static function parseAction(value:Value):TurnRuntimeAction {
		final actionType = stringField(value, "type", "");
		return switch actionType {
			case "task_started":
				TurnRuntimeAction.taskStarted();
			case "assistant_delta":
				TurnRuntimeAction.assistantDelta(stringField(value, "text", ""));
			case "assistant_final":
				TurnRuntimeAction.assistantFinal(stringField(value, "markdown", ""), boolField(value, "copySource", false));
			case "plan_delta":
				TurnRuntimeAction.planDelta(stringField(value, "text", ""));
			case "plan_final":
				TurnRuntimeAction.planFinal(planItems(arrayField(value, "items")));
			case "queue_follow_up":
				TurnRuntimeAction.queueFollowUp(stringField(value, "prompt", ""));
			case "queue_steer":
				TurnRuntimeAction.queueSteer(stringField(value, "prompt", ""));
			case "task_completed":
				TurnRuntimeAction.taskCompleted(stringField(value, "lastAgentMessage", ""), boolField(value, "fromReplay", false),
					boolField(value, "activeGoalContinuation", false));
			case "task_failed":
				TurnRuntimeAction.taskFailed(stringField(value, "message", ""));
			case "task_cancelled":
				TurnRuntimeAction.taskCancelled(stringField(value, "message", ""));
			case _:
				throw "unsupported action type: " + actionType;
		}
	}

	static function planItems(values:Array<Value>):Array<TurnPlanItem> {
		final out:Array<TurnPlanItem> = [];
		for (value in values) {
			out.push(new TurnPlanItem(stringField(value, "label", ""), stringField(value, "status", "")));
		}
		return out;
	}

	static function assertExpected(name:String, state:TurnRuntimeState, expect:Value):Void {
		maybeString(expect, "status", name, state.status);
		maybeBool(expect, "running", name, state.running);
		maybeString(expect, "assistantFinalMarkdown", name, state.assistantFinalMarkdown);
		maybeString(expect, "assistantFinalSource", name, state.assistantFinalSource);
		maybeString(expect, "lastAgentMarkdown", name, state.lastAgentMarkdown);
		maybeBool(expect, "sawCopySourceThisTurn", name, state.sawCopySourceThisTurn);
		maybeString(expect, "notificationResponse", name, state.notificationResponse);
		maybeString(expect, "planFingerprint", name, state.planFingerprint());
		maybeString(expect, "consolidatedPlanFingerprint", name, state.consolidatedPlanFingerprint());
		maybeBool(expect, "sawPlanItemThisTurn", name, state.sawPlanItemThisTurn);
		maybeBool(expect, "finalSeparatorNeeded", name, state.finalSeparatorNeeded);
		maybeString(expect, "startedFollowUp", name, state.startedFollowUp);
		maybeInt(expect, "pendingFollowUps", name, state.pendingFollowUps.length);
		maybeInt(expect, "pendingSteers", name, state.pendingSteers.length);
		maybeBool(expect, "submitPendingSteersAfterInterrupt", name, state.submitPendingSteersAfterInterrupt);
		maybeBool(expect, "completionNotified", name, state.completionNotified);
		maybeString(expect, "terminalReason", name, state.terminalReason);
		maybeString(expect, "failureMessage", name, state.failureMessage);
	}

	static function fixtureRoot():Value {
		final parsed = CodexJson.parse(File.getContent("fixtures/upstream/turn-runtime-selected.v1.json"));
		if (!parsed.ok)
			throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		return parsed.value;
	}

	static function objectField(object:Value, name:String):Value {
		return switch valueField(object, name) {
			case JObject(_, _): valueField(object, name);
			case _: throw "expected object field: " + name;
		}
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		final found = maybeField(object, name);
		if (!found.exists)
			return fallback;
		return switch found.value {
			case JString(value): value;
			case _: throw "expected string field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		final found = maybeField(object, name);
		if (!found.exists)
			return fallback;
		return switch found.value {
			case JBool(value): value;
			case _: throw "expected bool field: " + name;
		}
	}

	static function maybeString(object:Value, field:String, scenario:String, actual:String):Void {
		final found = maybeField(object, field);
		if (!found.exists)
			return;
		switch found.value {
			case JString(expected):
				assertEquals(expected, actual, scenario + "." + field);
			case _:
				throw "expected string expectation: " + scenario + "." + field;
		}
	}

	static function maybeBool(object:Value, field:String, scenario:String, actual:Bool):Void {
		final found = maybeField(object, field);
		if (!found.exists)
			return;
		switch found.value {
			case JBool(expected):
				if (expected != actual)
					throw scenario + "." + field + " expected " + Std.string(expected) + " but got " + Std.string(actual);
			case _:
				throw "expected bool expectation: " + scenario + "." + field;
		}
	}

	static function maybeInt(object:Value, field:String, scenario:String, actual:Int):Void {
		final found = maybeField(object, field);
		if (!found.exists)
			return;
		switch found.value {
			case JNumber(expected):
				assertEquals(Std.string(Std.int(expected)), Std.string(actual), scenario + "." + field);
			case _:
				throw "expected int expectation: " + scenario + "." + field;
		}
	}

	static function valueField(object:Value, name:String):Value {
		final found = maybeField(object, name);
		if (found.exists)
			return found.value;
		throw "missing field: " + name;
	}

	static function maybeField(object:Value, name:String):FieldLookup {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name)
						return new FieldLookup(true, values[i]);
					i = i + 1;
				}
				new FieldLookup(false, JNull);
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function assertEquals(expected:String, actual:String, label:String = ""):Void {
		if (expected != actual) {
			final prefix = if (label.length > 0) label + " " else "";
			throw prefix + "expected " + expected + " but got " + actual;
		}
	}
}

class FieldLookup {
	public final exists:Bool;
	public final value:Value;

	public function new(exists:Bool, value:Value) {
		this.exists = exists;
		this.value = value;
	}
}
