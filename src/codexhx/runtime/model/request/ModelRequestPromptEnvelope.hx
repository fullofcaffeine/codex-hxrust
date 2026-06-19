package codexhx.runtime.model.request;

class ModelRequestPromptEnvelope {
	public final inputItemCount:Int;
	public final toolSpecCount:Int;
	public final parallelToolCalls:Bool;
	public final supportsReasoningSummaries:Bool;
	public final reasoningEffort:String;
	public final reasoningSummary:String;
	public final supportsVerbosity:Bool;
	public final requestedVerbosity:String;
	public final outputSchemaPresent:Bool;
	public final outputSchemaStrict:Bool;
	public final requestedServiceTier:String;
	public final windowId:String;
	public final turnMetadataHeaderPresent:Bool;
	public final betaFeaturesHeaderPresent:Bool;
	public final enableRequestCompression:Bool;

	public function new(inputItemCount:Int, toolSpecCount:Int, parallelToolCalls:Bool, supportsReasoningSummaries:Bool, reasoningEffort:String,
			reasoningSummary:String, supportsVerbosity:Bool, requestedVerbosity:String, outputSchemaPresent:Bool, outputSchemaStrict:Bool,
			requestedServiceTier:String, windowId:String, turnMetadataHeaderPresent:Bool, betaFeaturesHeaderPresent:Bool, enableRequestCompression:Bool) {
		this.inputItemCount = inputItemCount;
		this.toolSpecCount = toolSpecCount;
		this.parallelToolCalls = parallelToolCalls;
		this.supportsReasoningSummaries = supportsReasoningSummaries;
		this.reasoningEffort = reasoningEffort;
		this.reasoningSummary = reasoningSummary;
		this.supportsVerbosity = supportsVerbosity;
		this.requestedVerbosity = requestedVerbosity;
		this.outputSchemaPresent = outputSchemaPresent;
		this.outputSchemaStrict = outputSchemaStrict;
		this.requestedServiceTier = requestedServiceTier;
		this.windowId = windowId;
		this.turnMetadataHeaderPresent = turnMetadataHeaderPresent;
		this.betaFeaturesHeaderPresent = betaFeaturesHeaderPresent;
		this.enableRequestCompression = enableRequestCompression;
	}
}
