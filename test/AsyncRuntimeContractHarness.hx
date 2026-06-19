import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.asyncruntime.AsyncCancelReason;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncDeliveryKind;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.asyncruntime.AsyncRuntimeContractReport;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.asyncruntime.DeterministicAsyncStream;
import codexhx.runtime.asyncruntime.DeterministicAsyncTask;
import haxe.json.Value;
import sys.io.File;

class AsyncRuntimeContractHarness {
	static function main():Void {
		final root = fixtureRoot("fixtures/hxrust/async-runtime-contract.v1.json");
		final cases = arrayField(root, "cases");
		final summaries:Array<String> = [];
		for (value in cases) {
			final testCase = objectValue(value);
			summaries.push(runCase(testCase));
		}
		final report = new AsyncRuntimeContractReport(summaries);
		assertReport(root, report);

		var i = 0;
		while (i < cases.length) {
			final testCase = objectValue(cases[i]);
			final expect = objectField(testCase, "expect");
			assertContains(summaries[i], stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function runCase(testCase:Value):String {
		final id = stringField(testCase, "id", "");
		return switch stringField(testCase, "kind", "") {
			case "task_complete": runTaskComplete(id, testCase);
			case "task_token_cancel": runTaskTokenCancel(id, testCase);
			case "stream_lossless_backpressure": runLosslessBackpressure(id, testCase);
			case "stream_best_effort_drop": runBestEffortDrop(id, testCase);
			case "stream_failure": runStreamFailure(id, testCase);
			case other: throw "invalid async fixture kind: " + other;
		}
	}

	static function runTaskComplete(id:String, testCase:Value):String {
		final task = new DeterministicAsyncTask<String>();
		final first = task.poll(AsyncContext.fixture("before-complete"));
		task.complete(stringField(testCase, "value", ""));
		final second = task.poll(AsyncContext.fixture("after-complete"));
		return "case=" + id + ";first=" + AsyncPollSummary.summary(first) + ";second=" + AsyncPollSummary.summary(second) + ";value="
			+ AsyncPollSummary.stringValue(second);
	}

	static function runTaskTokenCancel(id:String, testCase:Value):String {
		final context = AsyncContext.fixture("cancelled-token");
		context.cancellation.requestCancel(cancelReason(stringField(testCase, "cancelReason", "")));
		final task = new DeterministicAsyncTask<String>();
		final poll = task.poll(context);
		return "case=" + id + ";poll=" + AsyncPollSummary.summary(poll);
	}

	static function runLosslessBackpressure(id:String, testCase:Value):String {
		final stream = new DeterministicAsyncStream<String>(intField(testCase, "capacity", 1));
		stream.push(stringField(testCase, "first", ""), AsyncDeliveryKind.Lossless);
		final push2 = stream.push(stringField(testCase, "second", ""), AsyncDeliveryKind.Lossless);
		final drain1 = stream.pollNext(AsyncContext.fixture("drain-first"));
		final push3 = stream.push(stringField(testCase, "second", ""), AsyncDeliveryKind.Lossless);
		final drain2 = stream.pollNext(AsyncContext.fixture("drain-second"));
		stream.close();
		final terminal = stream.pollNext(AsyncContext.fixture("terminal"));
		return "case=" + id + ";push2=" + AsyncPollSummary.summary(push2) + ";drain1=" + AsyncPollSummary.summary(drain1) + ";item="
			+ pollItemSummary(drain1) + ";push3=" + AsyncPollSummary.summary(push3) + ";drain2=" + AsyncPollSummary.summary(drain2) + ";item="
			+ pollItemSummary(drain2) + ";terminal=" + AsyncPollSummary.summary(terminal);
	}

	static function runBestEffortDrop(id:String, testCase:Value):String {
		final stream = new DeterministicAsyncStream<String>(intField(testCase, "capacity", 1));
		stream.push(stringField(testCase, "first", ""), AsyncDeliveryKind.Lossless);
		final push2 = stream.push(stringField(testCase, "second", ""), AsyncDeliveryKind.BestEffort);
		final drain = stream.pollNext(AsyncContext.fixture("drain"));
		return "case="
			+ id
			+ ";push2="
			+ AsyncPollSummary.summary(push2)
			+ ";drain="
			+ AsyncPollSummary.summary(drain)
			+ ";item="
			+ pollItemSummary(drain);
	}

	static function runStreamFailure(id:String, testCase:Value):String {
		final stream = new DeterministicAsyncStream<String>(intField(testCase, "capacity", 1));
		stream.fail(stringField(testCase, "errorCode", ""), stringField(testCase, "errorMessage", ""), false);
		final poll = stream.pollNext(AsyncContext.fixture("failure"));
		return "case=" + id + ";poll=" + AsyncPollSummary.summary(poll);
	}

	static function pollItemSummary(poll:AsyncPoll<AsyncStreamItem<String>>):String {
		return switch poll {
			case Ready(item, _, _): item.summary(item.value);
			case _: "none";
		}
	}

	static function cancelReason(value:String):AsyncCancelReason {
		return switch value {
			case "user_interrupt": AsyncCancelReason.UserInterrupt;
			case "consumer_dropped": AsyncCancelReason.ConsumerDropped;
			case "timeout": AsyncCancelReason.Timeout;
			case "shutdown": AsyncCancelReason.Shutdown;
			case "test_fixture": AsyncCancelReason.TestFixture;
			case _: throw "invalid cancel reason: " + value;
		}
	}

	static function assertReport(root:Value, report:AsyncRuntimeContractReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.caseSummaries.length));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot(path:String):Value {
		return expectParse(CodexJson.parse(File.getContent(path)));
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

	static function valueField(object:Value, name:String):Value {
		return optionalField(object, name);
	}

	static function optionalField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name)
						return values[i];
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
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function assertContains(value:String, needle:String):Void {
		if (needle.length == 0)
			return;
		if (value.indexOf(needle) < 0)
			throw "expected to find `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected `" + expected + "` but got `" + actual + "`";
	}
}
