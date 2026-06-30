package codexhx.runtime.tui.appserver;

import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `turn/interrupt` params emitted by the minimal live prompt path.
**/
class TuiPromptTurnInterruptParams {
	public final threadId:ThreadId;
	public final turnId:TurnId;

	public function new(threadId:ThreadId, turnId:TurnId) {
		this.threadId = threadId;
		this.turnId = turnId;
	}

	public static function fromEnvelope(envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptParams {
		return new TuiPromptTurnInterruptParams(envelope.threadId, envelope.turnId);
	}

	public function toJsonValue():Value {
		return JObject(["threadId", "turnId"], [JString(threadId.toString()), JString(turnId.toString())]);
	}

	public function toJson():String {
		return JsonValueCodec.encode(toJsonValue());
	}
}
