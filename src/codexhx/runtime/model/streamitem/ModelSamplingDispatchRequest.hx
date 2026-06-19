package codexhx.runtime.model.streamitem;

class ModelSamplingDispatchRequest {
	public final requestId:String;
	public final assemblyOutcome:ModelSamplingInputAssemblyOutcome;
	public final transportKind:ModelSamplingDispatchTransportKind;
	public final windowId:String;
	public final turnMetadataHeaderPresent:Bool;
	public final maxRetries:Int;
	public final previousDispatchCount:Int;
	public final modelClientSessionReused:Bool;
	public final stickyRoutingTokenPreserved:Bool;
	public final cancellationChildTokenCreated:Bool;
	public final liveProviderEnabled:Bool;
	public final secretProbe:String;

	public function new(requestId:String, assemblyOutcome:ModelSamplingInputAssemblyOutcome, transportKind:ModelSamplingDispatchTransportKind,
			windowId:String, turnMetadataHeaderPresent:Bool, maxRetries:Int, previousDispatchCount:Int, modelClientSessionReused:Bool,
			stickyRoutingTokenPreserved:Bool, cancellationChildTokenCreated:Bool, liveProviderEnabled:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.assemblyOutcome = assemblyOutcome;
		this.transportKind = transportKind;
		this.windowId = windowId == null ? "" : windowId;
		this.turnMetadataHeaderPresent = turnMetadataHeaderPresent;
		this.maxRetries = maxRetries < 0 ? 0 : maxRetries;
		this.previousDispatchCount = previousDispatchCount < 0 ? 0 : previousDispatchCount;
		this.modelClientSessionReused = modelClientSessionReused;
		this.stickyRoutingTokenPreserved = stickyRoutingTokenPreserved;
		this.cancellationChildTokenCreated = cancellationChildTokenCreated;
		this.liveProviderEnabled = liveProviderEnabled;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
