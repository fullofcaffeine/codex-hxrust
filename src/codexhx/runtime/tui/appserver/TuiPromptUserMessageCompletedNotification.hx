package codexhx.runtime.tui.appserver;

import codexhx.protocol.ItemId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `item/completed` notification for the submitted user message item.
**/
class TuiPromptUserMessageCompletedNotification {
	public final threadId:ThreadId;
	public final turnId:TurnId;
	public final itemId:ItemId;
	public final text:String;
	public final completedAtMs:Float;

	public function new(threadId:ThreadId, turnId:TurnId, itemId:ItemId, text:String, completedAtMs:Float) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.itemId = itemId;
		this.text = text == null ? "" : text;
		this.completedAtMs = completedAtMs < 0 ? 0 : completedAtMs;
	}

	public static function fromEnvelope(envelope:TuiPromptSubmitEnvelope, turn:TuiPromptTurnStartResponse):TuiPromptUserMessageCompletedNotification {
		return new TuiPromptUserMessageCompletedNotification(envelope.threadId, turn.turnId, makeItemId(turn.turnId.toString()), envelope.promptText, 500);
	}

	public function methodText():String {
		return TuiPromptJsonRpcNotificationMethod.ItemCompleted.text();
	}

	public function itemValue():Value {
		return JObject(["id", "type", "content"], [
			JString(itemId.toString()),
			JString("userMessage"),
			JArray([JObject(["type", "text"], [JString("text"), JString(text)])])
		]);
	}

	public function paramsValue():Value {
		return JObject(["completedAtMs", "item", "threadId", "turnId"], [
			JNumber(completedAtMs),
			itemValue(),
			JString(threadId.toString()),
			JString(turnId.toString())
		]);
	}

	public function paramsJson():String {
		return JsonValueCodec.encode(paramsValue());
	}

	public function messageValue():Value {
		return JObject(["jsonrpc", "method", "params"], [JString("2.0"), JString(methodText()), paramsValue()]);
	}

	public function messageJson():String {
		return JsonValueCodec.encode(messageValue());
	}

	public function fixtureValue(fixtureId:String):Value {
		return JObject(["id", "kind", "method", "message"], [
			JString(fixtureId),
			JString("notification"),
			JString(methodText()),
			messageValue()
		]);
	}

	public function fixtureJson(fixtureId:String):String {
		return JsonValueCodec.encode(fixtureValue(fixtureId));
	}

	static function makeItemId(turnId:String):ItemId {
		final parsed = ItemId.fromString("user-" + turnId);
		if (parsed != null)
			return parsed;
		final fallback = ItemId.fromString("user-prompt-submit");
		if (fallback != null)
			return fallback;
		throw "static fallback user item id is invalid";
	}
}
