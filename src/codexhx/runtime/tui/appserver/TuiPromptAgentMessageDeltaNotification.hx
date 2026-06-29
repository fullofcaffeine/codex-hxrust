package codexhx.runtime.tui.appserver;

import codexhx.protocol.ItemId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `item/agentMessage/delta` notification emitted by the fake prompt
	exchange for the minimal live TUI.
**/
class TuiPromptAgentMessageDeltaNotification {
	public final threadId:ThreadId;
	public final turnId:TurnId;
	public final itemId:ItemId;
	public final delta:String;

	public function new(threadId:ThreadId, turnId:TurnId, itemId:ItemId, delta:String) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.itemId = itemId;
		this.delta = delta == null ? "" : delta;
	}

	public static function fromEnvelope(envelope:TuiPromptSubmitEnvelope, turn:TuiPromptTurnStartResponse):TuiPromptAgentMessageDeltaNotification {
		return new TuiPromptAgentMessageDeltaNotification(envelope.threadId, turn.turnId, makeItemId(envelope.requestId.toString()),
			"echo: " + envelope.promptText);
	}

	public function methodText():String {
		return TuiPromptJsonRpcNotificationMethod.AgentMessageDelta.text();
	}

	public function paramsValue():Value {
		return JObject(["threadId", "turnId", "itemId", "delta"], [
			JString(threadId.toString()),
			JString(turnId.toString()),
			JString(itemId.toString()),
			JString(delta)
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

	static function makeItemId(requestId:String):ItemId {
		final parsed = ItemId.fromString("item-" + requestId);
		if (parsed != null)
			return parsed;
		final fallback = ItemId.fromString("item-prompt-submit");
		if (fallback != null)
			return fallback;
		throw "static fallback item id is invalid";
	}
}
