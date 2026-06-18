package codexhx.runtime.tui.smoke;

import codexhx.protocol.json.CodexJson;
import haxe.json.Value;
import sys.io.File;

class TuiSmokeFixtureLoader {
	public static function load(path:String):Array<TuiSmokeFrameRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		final cases = arrayField(parsed.value, "cases");
		final out:Array<TuiSmokeFrameRequest> = [];
		for (caseValue in cases) {
			out.push(frameRequest(caseValue));
		}
		return out;
	}

	public static function loadLoops(path:String):Array<TuiSmokeLoopRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		final cases = arrayField(parsed.value, "loopCases");
		final out:Array<TuiSmokeLoopRequest> = [];
		for (caseValue in cases) {
			out.push(loopRequest(caseValue));
		}
		return out;
	}

	static function frameRequest(value:Value):TuiSmokeFrameRequest {
		return new TuiSmokeFrameRequest({
			name: stringField(value, "name", ""),
			title: stringField(value, "title", ""),
			status: stringField(value, "status", ""),
			model: stringField(value, "model", ""),
			width: intField(value, "width", 80),
			transcript: transcriptRows(arrayField(value, "transcript")),
			input: stringField(value, "input", ""),
			terminalMode: TuiSmokeTerminalMode.fromString(stringField(value, "terminalMode", "")),
			key: TuiSmokeKeyKind.fromString(stringField(value, "key", "")),
			expectedExit: TuiSmokeExitKind.fromString(stringField(value, "expectedExit", "")),
			allowLiveTerminal: boolField(value, "allowLiveTerminal", false),
			allowNetwork: boolField(value, "allowNetwork", false),
			allowModelCall: boolField(value, "allowModelCall", false),
			expectedSnapshot: stringField(value, "expectedSnapshot", "")
		});
	}

	static function loopRequest(value:Value):TuiSmokeLoopRequest {
		return new TuiSmokeLoopRequest(
			stringField(value, "name", ""),
			frameRequest(valueField(value, "frame")),
			events(arrayField(value, "events")),
			TuiSmokeExitKind.fromString(stringField(value, "expectedExit", "")),
			stringField(value, "expectedTrace", ""),
			stringField(value, "expectedSnapshot", "")
		);
	}

	static function events(values:Array<Value>):Array<TuiSmokeEvent> {
		final out:Array<TuiSmokeEvent> = [];
		for (value in values) {
			out.push(new TuiSmokeEvent({
				kind: TuiSmokeEventKind.fromString(stringField(value, "kind", "")),
				key: TuiSmokeKeyKind.fromString(optionalStringField(value, "key", "none")),
				status: optionalStringField(value, "status", ""),
				input: optionalStringField(value, "input", ""),
				exitMode: TuiSmokeExitMode.fromString(optionalStringField(value, "exitMode", "unknown")),
				appEvent: optionalAppEvent(value, "appEvent"),
				appServerEvent: optionalAppServerEvent(value, "appServerEvent"),
				appServerRequest: optionalAppServerRequest(value, "appServerRequest"),
				appServerResolution: optionalAppServerResolution(value, "appServerResolution"),
				threadDelivery: optionalThreadDelivery(value, "threadDelivery")
			}));
		}
		return out;
	}

	static function optionalAppEvent(object:Value, name:String):Null<TuiSmokeAppEvent> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppEvent(
					TuiSmokeAppEventKind.fromString(stringField(value, "kind", "")),
					optionalStringField(value, "status", ""),
					TuiSmokeExitMode.fromString(optionalStringField(value, "exitMode", "unknown"))
				);
		}
	}

	static function optionalAppServerEvent(object:Value, name:String):Null<TuiSmokeAppServerEvent> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerEvent(
					TuiSmokeAppServerEventKind.fromString(stringField(value, "kind", "")),
					optionalStringField(value, "threadId", ""),
					optionalStringField(value, "status", ""),
					optionalStringField(value, "delta", ""),
					optionalStringField(value, "message", "")
				);
		}
	}

	static function optionalAppServerRequest(object:Value, name:String):Null<TuiSmokeAppServerRequest> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerRequest({
					kind: TuiSmokeAppServerRequestKind.fromString(stringField(value, "kind", "")),
					requestId: optionalStringField(value, "requestId", ""),
					threadId: optionalStringField(value, "threadId", ""),
					turnId: optionalStringField(value, "turnId", ""),
					itemId: optionalStringField(value, "itemId", ""),
					approvalId: optionalStringField(value, "approvalId", ""),
					serverName: optionalStringField(value, "serverName", "")
				});
		}
	}

	static function optionalAppServerResolution(object:Value, name:String):Null<TuiSmokeAppServerResolution> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerResolution({
					kind: TuiSmokeAppServerResolutionKind.fromString(stringField(value, "kind", "")),
					id: optionalStringField(value, "id", ""),
					requestId: optionalStringField(value, "requestId", ""),
					decision: optionalStringField(value, "decision", ""),
					response: optionalStringField(value, "response", "")
				});
		}
	}

	static function optionalThreadDelivery(object:Value, name:String):Null<TuiSmokeThreadDeliveryAction> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadDeliveryAction({
					kind: TuiSmokeThreadDeliveryActionKind.fromString(stringField(value, "kind", "")),
					threadId: optionalStringField(value, "threadId", ""),
					requestId: optionalStringField(value, "requestId", "")
				});
		}
	}

	static function transcriptRows(values:Array<Value>):Array<TuiSmokeTranscriptRow> {
		final out:Array<TuiSmokeTranscriptRow> = [];
		for (value in values) {
			out.push(new TuiSmokeTranscriptRow({
				source: TuiSmokeTranscriptSource.fromString(stringField(value, "source", "")),
				text: stringField(value, "text", "")
			}));
		}
		return out;
	}

	static function valueField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) return values[i];
					i = i + 1;
				}
				throw "missing field: " + name;
			case _:
				throw "expected object for field: " + name;
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
				throw "expected object for field: " + name;
		}
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch valueField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function optionalStringField(object:Value, name:String, fallback:String):String {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) {
						return switch values[i] {
							case JString(value): value;
							case JNull: fallback;
							case _: throw "expected string field: " + name;
						}
					}
					i = i + 1;
				}
				fallback;
			case _:
				throw "expected object for field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch valueField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch valueField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}
}
