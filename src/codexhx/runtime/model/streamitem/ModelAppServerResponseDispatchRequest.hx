package codexhx.runtime.model.streamitem;

class ModelAppServerResponseDispatchRequest {
	public final requestId:String;
	public final resolutionOutcome:ModelAppServerRequestResolutionOutcome;
	public final dispatchKind:ModelAppServerResponseDispatchKind;
	public final appServerSessionAvailable:Bool;
	public final serializedPayloadAvailable:Bool;
	public final transportSendSucceeds:Bool;
	public final unsupportedRejectReason:String;
	public final previousDispatchCount:Int;
	public final responseOrderIndex:Int;
	public final secretProbe:String;

	public function new(requestId:String, resolutionOutcome:ModelAppServerRequestResolutionOutcome, dispatchKind:ModelAppServerResponseDispatchKind,
			appServerSessionAvailable:Bool, serializedPayloadAvailable:Bool, transportSendSucceeds:Bool, unsupportedRejectReason:String,
			previousDispatchCount:Int, responseOrderIndex:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.resolutionOutcome = resolutionOutcome;
		this.dispatchKind = dispatchKind == null ? ModelAppServerResponseDispatchKind.ResolveResponse : dispatchKind;
		this.appServerSessionAvailable = appServerSessionAvailable;
		this.serializedPayloadAvailable = serializedPayloadAvailable;
		this.transportSendSucceeds = transportSendSucceeds;
		this.unsupportedRejectReason = unsupportedRejectReason == null ? "" : unsupportedRejectReason;
		this.previousDispatchCount = previousDispatchCount < 0 ? 0 : previousDispatchCount;
		this.responseOrderIndex = responseOrderIndex < 0 ? 0 : responseOrderIndex;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
