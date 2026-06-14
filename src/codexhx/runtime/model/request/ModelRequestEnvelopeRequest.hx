package codexhx.runtime.model.request;

import codexhx.runtime.model.planning.TurnModelPlanRequest;

class ModelRequestEnvelopeRequest {
	public final requestId:String;
	public final planRequest:TurnModelPlanRequest;
	public final prompt:ModelRequestPromptEnvelope;
	public final routeIntent:ModelRequestRouteIntent;
	public final liveNetworkAllowed:Bool;
	public final hasCredentialMaterial:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		planRequest:TurnModelPlanRequest,
		prompt:ModelRequestPromptEnvelope,
		routeIntent:ModelRequestRouteIntent,
		liveNetworkAllowed:Bool,
		hasCredentialMaterial:Bool,
		secretProbe:String
	) {
		this.requestId = requestId;
		this.planRequest = planRequest;
		this.prompt = prompt;
		this.routeIntent = routeIntent;
		this.liveNetworkAllowed = liveNetworkAllowed;
		this.hasCredentialMaterial = hasCredentialMaterial;
		this.secretProbe = secretProbe;
	}
}
