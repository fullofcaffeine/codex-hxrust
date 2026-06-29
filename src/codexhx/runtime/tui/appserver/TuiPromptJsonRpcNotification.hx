package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	JSON-RPC notification wrapper emitted by the fake live prompt exchange.
**/
class TuiPromptJsonRpcNotification {
	public final method:TuiPromptJsonRpcNotificationMethod;
	public final threadId:ThreadId;
	public final turn:TuiPromptTurnStartResponse;

	public function new(method:TuiPromptJsonRpcNotificationMethod, threadId:ThreadId, turn:TuiPromptTurnStartResponse) {
		this.method = method;
		this.threadId = threadId;
		this.turn = turn;
	}

	public static function turnStarted(envelope:TuiPromptSubmitEnvelope, turn:TuiPromptTurnStartResponse):TuiPromptJsonRpcNotification {
		return new TuiPromptJsonRpcNotification(TuiPromptJsonRpcNotificationMethod.TurnStarted, envelope.threadId, turn);
	}

	public static function turnCompleted(envelope:TuiPromptSubmitEnvelope, turn:TuiPromptTurnStartResponse):TuiPromptJsonRpcNotification {
		return new TuiPromptJsonRpcNotification(TuiPromptJsonRpcNotificationMethod.TurnCompleted, envelope.threadId,
			turn.withStatus(TuiPromptTurnStatus.Completed));
	}

	public function methodText():String {
		return method.text();
	}

	public function paramsValue():Value {
		return JObject(["threadId", "turn"], [JString(threadId.toString()), turn.turnValue()]);
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
