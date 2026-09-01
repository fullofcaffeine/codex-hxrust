package codexhx.runtime.tui.appserver;

import haxe.json.Value;

/**
	Typed error body for rejecting an app-server request.

	This mirrors upstream `JSONRPCErrorError`. The optional data remains at the
	JSON boundary and is omitted from the encoded object when it is absent.
**/
class TuiAppServerJsonRpcError {
	public final code:Int;
	public final message:String;

	final dataValue:Null<Value>;

	public function new(code:Int, message:String, ?data:Value) {
		this.code = code;
		this.message = message;
		this.dataValue = data;
	}

	public function data():Null<Value> {
		return dataValue;
	}

	public function toJsonValue():Value {
		final keys = ["code", "message"];
		final values:Array<Value> = [JNumber(code), JString(message)];
		if (dataValue != null) {
			keys.push("data");
			values.push(dataValue);
		}
		return JObject(keys, values);
	}
}
