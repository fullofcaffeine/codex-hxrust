package codexhx.runtime.app.threadread;

import codexhx.protocol.TurnId;
import codexhx.protocol.json.CodexJson;
import haxe.json.Value;

class ThreadReadTurnsCursor {
	public final turnId:TurnId;
	public final includeAnchor:Bool;

	public function new(turnId:TurnId, includeAnchor:Bool) {
		this.turnId = turnId;
		this.includeAnchor = includeAnchor;
	}

	public static function encode(turnId:String, includeAnchor:Bool):String {
		return "{"
			+ CodexJson.quote("turnId") + ":" + CodexJson.quote(turnId)
			+ ","
			+ CodexJson.quote("includeAnchor") + ":" + (includeAnchor ? "true" : "false")
			+ "}";
	}

	public static function parse(text:String):ThreadReadTurnsCursorParseOutcome {
		final parsed = try {
			CodexJson.parse(text);
		} catch (_:Dynamic) {
			return ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: " + text);
		}
		if (!parsed.ok) return ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: " + text);
		return switch parsed.value {
			case JObject(keys, values):
				final turnIdValue = stringField(keys, values, "turnId");
				if (turnIdValue == null) return ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: missing turnId");
				final turnId = TurnId.fromString(turnIdValue);
				if (turnId == null) return ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: invalid turnId");
				final includeAnchor = boolField(keys, values, "includeAnchor");
				if (includeAnchor == null) return ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: missing includeAnchor");
				ThreadReadTurnsCursorParseOutcome.success(new ThreadReadTurnsCursor(turnId, includeAnchor));
			case _:
				ThreadReadTurnsCursorParseOutcome.failure("invalid_cursor", "invalid cursor: " + text);
		}
	}

	static function stringField(keys:Array<String>, values:Array<Value>, name:String):Null<String> {
		var i = 0;
		while (i < keys.length && i < values.length) {
			if (keys[i] == name) {
				return switch values[i] {
					case JString(value): value;
					case _: null;
				}
			}
			i = i + 1;
		}
		return null;
	}

	static function boolField(keys:Array<String>, values:Array<Value>, name:String):Null<Bool> {
		var i = 0;
		while (i < keys.length && i < values.length) {
			if (keys[i] == name) {
				return switch values[i] {
					case JBool(value): value;
					case _: null;
				}
			}
			i = i + 1;
		}
		return null;
	}
}

class ThreadReadTurnsCursorParseOutcome {
	public final ok:Bool;
	public final code:String;
	public final message:String;
	public final cursor:Null<ThreadReadTurnsCursor>;

	function new(ok:Bool, code:String, message:String, cursor:Null<ThreadReadTurnsCursor>) {
		this.ok = ok;
		this.code = code;
		this.message = message;
		this.cursor = cursor;
	}

	public static function success(cursor:ThreadReadTurnsCursor):ThreadReadTurnsCursorParseOutcome {
		return new ThreadReadTurnsCursorParseOutcome(true, "cursor_parsed", "", cursor);
	}

	public static function failure(code:String, message:String):ThreadReadTurnsCursorParseOutcome {
		return new ThreadReadTurnsCursorParseOutcome(false, code, message, null);
	}
}
