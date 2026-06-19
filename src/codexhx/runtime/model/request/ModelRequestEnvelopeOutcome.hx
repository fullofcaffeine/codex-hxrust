package codexhx.runtime.model.request;

import codexhx.runtime.model.planning.TurnModelPlanOutcome;

class ModelRequestEnvelopeOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final planCode:String;
	public final providerId:String;
	public final selectedModelId:String;
	public final routeIntent:ModelRequestRouteIntent;
	public final envelope:ModelRequestEnvelope;
	public final errorMessage:String;
	public final sequence:String;

	function new(ok:Bool, code:String, request:ModelRequestEnvelopeRequest, plan:TurnModelPlanOutcome, envelope:ModelRequestEnvelope, errorMessage:String,
			sequence:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.planCode = plan == null ? "none" : plan.code;
		this.providerId = plan == null ? "" : plan.providerId;
		this.selectedModelId = plan == null ? "" : plan.selectedModelId;
		this.routeIntent = request.routeIntent;
		this.envelope = envelope;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function accepted(request:ModelRequestEnvelopeRequest, plan:TurnModelPlanOutcome, envelope:ModelRequestEnvelope,
			sequence:String):ModelRequestEnvelopeOutcome {
		return new ModelRequestEnvelopeOutcome(true, "model_request_envelope_admitted", request, plan, envelope, "", sequence);
	}

	public static function denied(request:ModelRequestEnvelopeRequest, plan:TurnModelPlanOutcome, code:String, errorMessage:String,
			sequence:String):ModelRequestEnvelopeOutcome {
		return new ModelRequestEnvelopeOutcome(false, code, request, plan, null, errorMessage, sequence);
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";planCode=" + planCode + ";provider=" + providerId + ";model="
			+ selectedModelId + ";routeIntent=" + routeIntent + ";envelope={" + (envelope == null ? "none" : envelope.summary()) + "}" + ";error="
			+ errorMessage + ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
