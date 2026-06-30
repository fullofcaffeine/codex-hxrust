package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	JSON-RPC `turn/interrupt` request wrapper emitted by the live prompt path.
**/
class TuiPromptTurnInterruptRequest {
	public final requestId:RequestId;
	public final method:TuiPromptJsonRpcMethod;
	public final params:TuiPromptTurnInterruptParams;

	public function new(requestId:RequestId, params:TuiPromptTurnInterruptParams) {
		this.requestId = requestId;
		this.method = TuiPromptJsonRpcMethod.TurnInterrupt;
		this.params = params;
	}

	public static function fromEnvelope(envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptRequest {
		return new TuiPromptTurnInterruptRequest(envelope.requestId, TuiPromptTurnInterruptParams.fromEnvelope(envelope));
	}

	public function methodText():String {
		return method.text();
	}

	public function paramsJson():String {
		return params.toJson();
	}

	public function messageValue():Value {
		return JObject(["jsonrpc", "id", "method", "params"], [
			JString("2.0"),
			requestId.toJsonValue(),
			JString(methodText()),
			params.toJsonValue()
		]);
	}

	public function messageJson():String {
		return JsonValueCodec.encode(messageValue());
	}

	public function fixtureValue(fixtureId:String):Value {
		return JObject(["id", "kind", "method", "message"], [JString(fixtureId), JString("request"), JString(methodText()), messageValue()]);
	}

	public function fixtureJson(fixtureId:String):String {
		return JsonValueCodec.encode(fixtureValue(fixtureId));
	}
}
