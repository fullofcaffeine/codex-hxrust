import codexhx.native.state.StateSqliteAdapterReport;
import codexhx.native.state.StateSqliteBridge;
import codexhx.native.state.StateSqliteCommand;
import codexhx.native.state.StateSqliteQueryRequest;
import codexhx.native.state.StateSqliteReconcileRequest;
import codexhx.protocol.PathLikeId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.persistence.ThreadPersistenceMetadata;
import haxe.json.Value;
import sys.io.File;

class NativeStateAdapterHarness {
	static function main():Void {
		final root = fixtureRoot();
		final commands = arrayField(root, "commands");
		final report = StateSqliteBridge.runInMemory(commandsFromFixture(commands));
		assertReport(root, report);
		assertEquals(Std.string(commands.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < commands.length) {
			final expect = objectField(objectValue(commands[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "operation", ""), outcome.operation);
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(Std.string(intField(expect, "rowCount", 0)), Std.string(outcome.rowCount));
			assertTrue(outcome.backend == "fixture_sqlite_simulation" || outcome.backend == "haxe_rust_sys_db_sqlite", "unexpected backend: " + outcome.backend);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function commandsFromFixture(values:Array<Value>):Array<StateSqliteCommand> {
		final out:Array<StateSqliteCommand> = [];
		for (value in values) {
			final command = objectValue(value);
			switch stringField(command, "type", "") {
				case "reconcile":
					out.push(Reconcile(reconcileRequest(command)));
				case "query":
					out.push(Query(queryRequest(command)));
				case other:
					throw "unsupported command type: " + other;
			}
		}
		return out;
	}

	static function reconcileRequest(command:Value):StateSqliteReconcileRequest {
		final metadata = objectField(command, "metadata");
		return new StateSqliteReconcileRequest(
			new ThreadPersistenceMetadata(
				ThreadId.fromString(stringField(metadata, "threadId", "")),
				SessionId.fromString(stringField(metadata, "sessionId", "")),
				PathLikeId.fromString(stringField(metadata, "rolloutPath", "")),
				intField(metadata, "historyItemCount", 0),
				intField(metadata, "persistedItemCount", 0),
				stringArrayField(metadata, "rolloutItemKinds"),
				boolField(metadata, "includeHistory", false),
				boolField(metadata, "archived", false),
				boolField(metadata, "goalStateRequested", false)
			),
			boolField(command, "mutationEnabled", false)
		);
	}

	static function queryRequest(command:Value):StateSqliteQueryRequest {
		return new StateSqliteQueryRequest(
			ThreadId.fromString(stringField(command, "threadId", "")),
			nullableBoolField(command, "archivedOnly")
		);
	}

	static function assertReport(root:Value, report:StateSqliteAdapterReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "operationCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "okCount", 0)), Std.string(report.okCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/native-state-adapter.v1.json")));
	}

	static function objectField(object:Value, name:String):Value {
		return objectValue(valueField(object, name));
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function stringArrayField(object:Value, name:String):Array<String> {
		final out:Array<String> = [];
		for (value in arrayField(object, name)) {
			switch value {
				case JString(text): out.push(text);
				case _: throw "expected string array field";
			}
		}
		return out;
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch optionalField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch optionalField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch optionalField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}

	static function nullableBoolField(object:Value, name:String):Null<Bool> {
		return switch optionalField(object, name) {
			case JBool(value): value;
			case JNull: null;
			case _: throw "expected nullable bool field: " + name;
		}
	}

	static function valueField(object:Value, name:String):Value {
		final value = optionalField(object, name);
		return switch value {
			case JNull: throw "missing field: " + name;
			case _: value;
		}
	}

	static function optionalField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) return values[i];
					i = i + 1;
				}
				JNull;
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function objectValue(value:Value):Value {
		return switch value {
			case JObject(_, _): value;
			case _: throw "expected object";
		}
	}

	static function expectParse(outcome:JsonParseOutcome):Value {
		if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) throw "expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value) throw message;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) < 0) throw "expected to find " + needle + " in " + haystack;
	}
}
