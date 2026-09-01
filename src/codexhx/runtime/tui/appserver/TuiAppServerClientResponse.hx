package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	One typed response to a request initiated by the app-server.

	Upstream Codex currently serializes these envelopes as `{id,result}` or
	`{id,error}` without a `jsonrpc` member. Keeping that detail here prevents
	transport implementations and TUI callers from rebuilding protocol JSON.
**/
class TuiAppServerClientResponse {
	public final requestId:RequestId;

	final resultValue:Null<Value>;
	final errorValue:Null<TuiAppServerJsonRpcError>;
	final errorResponse:Bool;

	function new(requestId:RequestId, result:Null<Value>, error:Null<TuiAppServerJsonRpcError>, errorResponse:Bool) {
		this.requestId = requestId;
		this.resultValue = result;
		this.errorValue = error;
		this.errorResponse = errorResponse;
	}

	public static function resolved(requestId:RequestId, result:Value):TuiAppServerClientResponse {
		return new TuiAppServerClientResponse(requestId, result, null, false);
	}

	public static function rejected(requestId:RequestId, error:TuiAppServerJsonRpcError):TuiAppServerClientResponse {
		return new TuiAppServerClientResponse(requestId, null, error, true);
	}

	public function validationCode():String {
		if (requestId == null)
			return "missing_request_id";
		if (errorResponse) {
			if (errorValue == null)
				return "missing_error";
			return "valid";
		}
		return resultValue == null ? "missing_result" : "valid";
	}

	public function messageValue():Value {
		if (errorResponse) {
			final error = errorValue;
			return JObject(["id", "error"], [requestId.toJsonValue(), error == null ? JNull : error.toJsonValue()]);
		}
		return JObject(["id", "result"], [requestId.toJsonValue(), resultValue == null ? JNull : resultValue]);
	}

	public function messageJson():String {
		return JsonValueCodec.encode(messageValue());
	}
}
