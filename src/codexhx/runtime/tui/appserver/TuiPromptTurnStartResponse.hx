package codexhx.runtime.tui.appserver;

import codexhx.protocol.TurnId;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

/**
	Typed `turn/start` response result for the minimal live prompt submit path.
**/
class TuiPromptTurnStartResponse {
	public final turnId:TurnId;
	public final status:TuiPromptTurnStatus;

	public function new(turnId:TurnId, status:TuiPromptTurnStatus) {
		this.turnId = turnId;
		this.status = status;
	}

	public static function fromEnvelope(envelope:TuiPromptSubmitEnvelope):TuiPromptTurnStartResponse {
		return new TuiPromptTurnStartResponse(makeTurnId(envelope.requestId.toString()), TuiPromptTurnStatus.InProgress);
	}

	public function statusText():String {
		return status.text();
	}

	public function turnValue():Value {
		return JObject(["id", "status", "itemsView", "items"], [JString(turnId.toString()), JString(statusText()), JString("full"), JArray([])]);
	}

	public function resultValue():Value {
		return JObject(["turn"], [turnValue()]);
	}

	public function resultJson():String {
		return JsonValueCodec.encode(resultValue());
	}

	static function makeTurnId(requestId:String):TurnId {
		final parsed = TurnId.fromString("turn-" + requestId);
		return parsed == null ? fallbackTurnId() : parsed;
	}

	static function fallbackTurnId():TurnId {
		final parsed = TurnId.fromString("turn-prompt-submit");
		if (parsed != null)
			return parsed;
		final minimal = TurnId.fromString("turn");
		if (minimal != null)
			return minimal;
		throw "static fallback turn id is invalid";
	}
}
