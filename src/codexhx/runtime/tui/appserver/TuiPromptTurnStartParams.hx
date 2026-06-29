package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `turn/start` params for the minimal live prompt submit path.
**/
class TuiPromptTurnStartParams {
	public final threadId:ThreadId;
	public final text:String;

	public function new(threadId:ThreadId, text:String) {
		this.threadId = threadId;
		this.text = text == null ? "" : text;
	}

	public static function fromEnvelope(envelope:TuiPromptSubmitEnvelope):TuiPromptTurnStartParams {
		return new TuiPromptTurnStartParams(envelope.threadId, envelope.promptText);
	}

	public function toJsonValue():Value {
		return JObject(["threadId", "input"], [
			JString(threadId.toString()),
			JArray([JObject(["type", "text"], [JString("text"), JString(text)])])
		]);
	}

	public function toJson():String {
		return JsonValueCodec.encode(toJsonValue());
	}
}
