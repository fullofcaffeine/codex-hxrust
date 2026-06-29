package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `rawResponseItem/completed` notification for assistant output.
**/
class TuiPromptRawResponseItemCompletedNotification {
	public final threadId:ThreadId;
	public final turnId:TurnId;
	public final text:String;

	public function new(threadId:ThreadId, turnId:TurnId, text:String) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.text = text == null ? "" : text;
	}

	public static function fromDelta(delta:TuiPromptAgentMessageDeltaNotification):TuiPromptRawResponseItemCompletedNotification {
		return new TuiPromptRawResponseItemCompletedNotification(delta.threadId, delta.turnId, delta.delta);
	}

	public function methodText():String {
		return TuiPromptJsonRpcNotificationMethod.RawResponseItemCompleted.text();
	}

	public function itemValue():Value {
		return JObject(["content", "role", "type"], [
			JArray([JObject(["text", "type"], [JString(text), JString("output_text")])]),
			JString("assistant"),
			JString("message")
		]);
	}

	public function paramsValue():Value {
		return JObject(["item", "threadId", "turnId"], [itemValue(), JString(threadId.toString()), JString(turnId.toString())]);
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
