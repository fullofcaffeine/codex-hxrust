package codexhx.runtime.model.stream;

import codexhx.runtime.model.request.ModelRequestEnvelopeRequest;

class ModelStreamRouteRequest {
	public final requestId:String;
	public final envelopeRequest:ModelRequestEnvelopeRequest;
	public final upstreamRequestId:String;
	public final events:Array<ModelStreamFixtureEvent>;
	public final secretProbe:String;

	public function new(requestId:String, envelopeRequest:ModelRequestEnvelopeRequest, upstreamRequestId:String, events:Array<ModelStreamFixtureEvent>,
			secretProbe:String) {
		this.requestId = requestId;
		this.envelopeRequest = envelopeRequest;
		this.upstreamRequestId = upstreamRequestId;
		this.events = events == null ? [] : events;
		this.secretProbe = secretProbe;
	}
}
