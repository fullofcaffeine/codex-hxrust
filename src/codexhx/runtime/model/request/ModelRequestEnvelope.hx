package codexhx.runtime.model.request;

class ModelRequestEnvelope {
	public final modelId:String;
	public final providerId:String;
	public final route:String;
	public final endpoint:String;
	public final stream:Bool;
	public final store:Bool;
	public final parallelToolCalls:Bool;
	public final reasoningIncluded:Bool;
	public final reasoningContext:String;
	public final includeEncryptedReasoning:Bool;
	public final textControls:String;
	public final serviceTier:String;
	public final promptCacheKey:Bool;
	public final clientMetadata:Bool;
	public final requestCompression:Bool;
	public final liveNetworkAttempted:Bool;
	public final toolSpecCount:Int;
	public final inputItemCount:Int;

	public function new(modelId:String, providerId:String, route:String, endpoint:String, stream:Bool, store:Bool, parallelToolCalls:Bool,
			reasoningIncluded:Bool, reasoningContext:String, includeEncryptedReasoning:Bool, textControls:String, serviceTier:String, promptCacheKey:Bool,
			clientMetadata:Bool, requestCompression:Bool, liveNetworkAttempted:Bool, toolSpecCount:Int, inputItemCount:Int) {
		this.modelId = modelId;
		this.providerId = providerId;
		this.route = route;
		this.endpoint = endpoint;
		this.stream = stream;
		this.store = store;
		this.parallelToolCalls = parallelToolCalls;
		this.reasoningIncluded = reasoningIncluded;
		this.reasoningContext = reasoningContext;
		this.includeEncryptedReasoning = includeEncryptedReasoning;
		this.textControls = textControls;
		this.serviceTier = serviceTier;
		this.promptCacheKey = promptCacheKey;
		this.clientMetadata = clientMetadata;
		this.requestCompression = requestCompression;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.toolSpecCount = toolSpecCount;
		this.inputItemCount = inputItemCount;
	}

	public function summary():String {
		return "model=" + modelId + ";provider=" + providerId + ";route=" + route + ";endpoint=" + endpoint + ";stream=" + boolText(stream) + ";store="
			+ boolText(store) + ";parallelToolCalls=" + boolText(parallelToolCalls) + ";reasoningIncluded=" + boolText(reasoningIncluded)
			+ ";reasoningContext=" + reasoningContext + ";includeEncryptedReasoning=" + boolText(includeEncryptedReasoning) + ";textControls=" + textControls
			+ ";serviceTier=" + serviceTier + ";promptCacheKey=" + boolText(promptCacheKey) + ";clientMetadata=" + boolText(clientMetadata)
			+ ";requestCompression=" + boolText(requestCompression) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";toolSpecCount="
			+ Std.string(toolSpecCount) + ";inputItemCount=" + Std.string(inputItemCount);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
