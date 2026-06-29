package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	JSON-RPC request wrapper emitted by the minimal live prompt transport.
**/
class TuiPromptJsonRpcRequest {
	public final requestId:RequestId;
	public final method:TuiPromptJsonRpcMethod;
	public final params:TuiPromptTurnStartParams;

	public function new(requestId:RequestId, method:TuiPromptJsonRpcMethod, params:TuiPromptTurnStartParams) {
		this.requestId = requestId;
		this.method = method;
		this.params = params;
	}

	public static function turnStart(envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcRequest {
		return new TuiPromptJsonRpcRequest(envelope.requestId, TuiPromptJsonRpcMethod.TurnStart, TuiPromptTurnStartParams.fromEnvelope(envelope));
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
