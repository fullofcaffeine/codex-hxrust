package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	JSON-RPC response wrapper emitted by the fake live prompt transport.
**/
class TuiPromptJsonRpcResponse {
	public final requestId:RequestId;
	public final method:TuiPromptJsonRpcMethod;
	public final result:TuiPromptTurnStartResponse;

	public function new(requestId:RequestId, method:TuiPromptJsonRpcMethod, result:TuiPromptTurnStartResponse) {
		this.requestId = requestId;
		this.method = method;
		this.result = result;
	}

	public static function turnStart(request:TuiPromptJsonRpcRequest, result:TuiPromptTurnStartResponse):TuiPromptJsonRpcResponse {
		return new TuiPromptJsonRpcResponse(request.requestId, request.method, result);
	}

	public function methodText():String {
		return method.text();
	}

	public function resultJson():String {
		return result.resultJson();
	}

	public function messageValue():Value {
		return JObject(["jsonrpc", "id", "result"], [JString("2.0"), requestId.toJsonValue(), result.resultValue()]);
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
