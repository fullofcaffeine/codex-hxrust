package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	JSON-RPC empty-result response for an accepted `turn/interrupt`.
**/
class TuiPromptTurnInterruptResponse {
	public final requestId:RequestId;
	public final method:TuiPromptJsonRpcMethod;

	public function new(requestId:RequestId) {
		this.requestId = requestId;
		this.method = TuiPromptJsonRpcMethod.TurnInterrupt;
	}

	public static function fromRequest(request:TuiPromptTurnInterruptRequest):TuiPromptTurnInterruptResponse {
		return new TuiPromptTurnInterruptResponse(request.requestId);
	}

	public function methodText():String {
		return method.text();
	}

	public function resultValue():Value {
		return JObject([], []);
	}

	public function resultJson():String {
		return JsonValueCodec.encode(resultValue());
	}

	public function messageValue():Value {
		return JObject(["jsonrpc", "id", "result"], [JString("2.0"), requestId.toJsonValue(), resultValue()]);
	}

	public function messageJson():String {
		return JsonValueCodec.encode(messageValue());
	}

	public function fixtureValue(fixtureId:String):Value {
		return JObject(["id", "kind", "method", "message"], [JString(fixtureId), JString("response"), JString(methodText()), messageValue()]);
	}

	public function fixtureJson(fixtureId:String):String {
		return JsonValueCodec.encode(fixtureValue(fixtureId));
	}
}
