package codexhx.runtime.model.stream;

import codexhx.runtime.model.request.ModelRequestEnvelopeOutcome;

class ModelStreamRouteOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final envelopeCode:String;
	public final providerId:String;
	public final selectedModelId:String;
	public final upstreamRequestId:String;
	public final lastModelRequestId:String;
	public final lastModelResponseId:String;
	public final completed:Bool;
	public final failed:Bool;
	public final cancelled:Bool;
	public final endTurn:Bool;
	public final itemsAdded:Int;
	public final totalTokens:Int;
	public final liveNetworkAttempted:Bool;
	public final errorMessage:String;
	public final sequence:String;

	function new(ok:Bool, code:String, request:ModelStreamRouteRequest, envelope:ModelRequestEnvelopeOutcome, lastModelRequestId:String,
			lastModelResponseId:String, completed:Bool, failed:Bool, cancelled:Bool, endTurn:Bool, itemsAdded:Int, totalTokens:Int, liveNetworkAttempted:Bool,
			errorMessage:String, sequence:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.envelopeCode = envelope == null ? "none" : envelope.code;
		this.providerId = envelope == null ? "" : envelope.providerId;
		this.selectedModelId = envelope == null ? "" : envelope.selectedModelId;
		this.upstreamRequestId = request.upstreamRequestId;
		this.lastModelRequestId = lastModelRequestId;
		this.lastModelResponseId = lastModelResponseId;
		this.completed = completed;
		this.failed = failed;
		this.cancelled = cancelled;
		this.endTurn = endTurn;
		this.itemsAdded = itemsAdded;
		this.totalTokens = totalTokens;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function mapped(request:ModelStreamRouteRequest, envelope:ModelRequestEnvelopeOutcome, lastModelRequestId:String,
			lastModelResponseId:String, completed:Bool, failed:Bool, cancelled:Bool, endTurn:Bool, itemsAdded:Int, totalTokens:Int, liveNetworkAttempted:Bool,
			errorMessage:String, sequence:String):ModelStreamRouteOutcome {
		final code = completed ? "model_stream_completed" : (cancelled ? "model_stream_cancelled" : "model_stream_failed");
		return new ModelStreamRouteOutcome(completed, code, request, envelope, lastModelRequestId, lastModelResponseId, completed, failed, cancelled, endTurn,
			itemsAdded, totalTokens, liveNetworkAttempted, errorMessage, sequence);
	}

	public static function denied(request:ModelStreamRouteRequest, envelope:ModelRequestEnvelopeOutcome, code:String, errorMessage:String,
			sequence:String):ModelStreamRouteOutcome {
		return new ModelStreamRouteOutcome(false, code, request, envelope, "", "", false, true, false, false, 0, 0, false, errorMessage, sequence);
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";envelopeCode=" + envelopeCode + ";provider=" + providerId + ";model="
			+ selectedModelId + ";upstreamRequestId=" + noneIfEmpty(upstreamRequestId) + ";lastModelRequestId=" + noneIfEmpty(lastModelRequestId)
			+ ";lastModelResponseId=" + noneIfEmpty(lastModelResponseId) + ";completed=" + boolText(completed) + ";failed=" + boolText(failed)
			+ ";cancelled=" + boolText(cancelled) + ";endTurn=" + boolText(endTurn) + ";itemsAdded=" + Std.string(itemsAdded) + ";totalTokens="
			+ Std.string(totalTokens) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";error=" + errorMessage + ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
