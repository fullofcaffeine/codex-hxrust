package codexhx.runtime.model.streamitem;

import codexhx.runtime.model.stream.ModelStreamRouteRequest;

class ModelStreamItemReducerRequest {
	public final requestId:String;
	public final routeRequest:ModelStreamRouteRequest;
	public final events:Array<ModelStreamItemFixtureEvent>;
	public final planMode:Bool;
	public final showRawReasoning:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		routeRequest:ModelStreamRouteRequest,
		events:Array<ModelStreamItemFixtureEvent>,
		planMode:Bool,
		showRawReasoning:Bool,
		secretProbe:String
	) {
		this.requestId = requestId;
		this.routeRequest = routeRequest;
		this.events = events == null ? [] : events;
		this.planMode = planMode;
		this.showRawReasoning = showRawReasoning;
		this.secretProbe = secretProbe;
	}
}
