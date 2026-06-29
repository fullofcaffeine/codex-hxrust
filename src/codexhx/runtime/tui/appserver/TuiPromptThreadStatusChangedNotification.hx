package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `thread/status/changed` notification for the fake prompt stream.
**/
class TuiPromptThreadStatusChangedNotification {
	public final threadId:ThreadId;
	public final status:TuiAppServerThreadStatus;

	public function new(threadId:ThreadId, status:TuiAppServerThreadStatus) {
		this.threadId = threadId;
		this.status = status;
	}

	public static function active(threadId:ThreadId):TuiPromptThreadStatusChangedNotification {
		return new TuiPromptThreadStatusChangedNotification(threadId, TuiAppServerThreadStatus.Working("submitted"));
	}

	public static function idle(threadId:ThreadId):TuiPromptThreadStatusChangedNotification {
		return new TuiPromptThreadStatusChangedNotification(threadId, TuiAppServerThreadStatus.Ready("ready"));
	}

	public function methodText():String {
		return TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text();
	}

	public function statusValue():Value {
		return switch status {
			case Working(_):
				JObject(["activeFlags", "type"], [JArray([JString("turnRunning")]), JString("active")]);
			case Ready(_):
				JObject(["type"], [JString("idle")]);
			case Failed(_):
				JObject(["type"], [JString("systemError")]);
		}
	}

	public function paramsValue():Value {
		return JObject(["status", "threadId"], [statusValue(), JString(threadId.toString())]);
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
