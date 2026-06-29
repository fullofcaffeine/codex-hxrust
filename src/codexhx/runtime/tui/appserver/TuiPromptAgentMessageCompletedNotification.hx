package codexhx.runtime.tui.appserver;

import codexhx.protocol.ItemId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `item/completed` notification for the fake assistant message item.
**/
class TuiPromptAgentMessageCompletedNotification {
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

	public static function fromDelta(delta:TuiPromptAgentMessageDeltaNotification):TuiPromptAgentMessageCompletedNotification {
		return new TuiPromptAgentMessageCompletedNotification(delta.threadId, delta.turnId, delta.itemId, delta.delta, 2000);
	}

	public function methodText():String {
		return TuiPromptJsonRpcNotificationMethod.ItemCompleted.text();
	}

	public function itemValue():Value {
		return JObject(["id", "type", "text"], [JString(itemId.toString()), JString("agentMessage"), JString(text)]);
	}

	public function paramsValue():Value {
		return JObject(["threadId", "turnId", "item", "completedAtMs"], [
			JString(threadId.toString()),
			JString(turnId.toString()),
			itemValue(),
			JNumber(completedAtMs)
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
}
