package codexhx.runtime.model.planning;

import codexhx.runtime.model.catalog.ModelCatalogRequest;

class TurnModelPlanRequest {
	public final requestId:String;
	public final catalogRequest:ModelCatalogRequest;
	public final features:TurnModelFeatureFlags;
	public final extensionTools:TurnExtensionToolState;
	public final webSearchMode:TurnWebSearchMode;
	public final requestedCapability:TurnModelToolCapabilityKind;

	public function new(requestId:String, catalogRequest:ModelCatalogRequest, features:TurnModelFeatureFlags, extensionTools:TurnExtensionToolState,
			webSearchMode:TurnWebSearchMode, requestedCapability:TurnModelToolCapabilityKind) {
		this.requestId = requestId;
		this.catalogRequest = catalogRequest;
		this.features = features;
		this.extensionTools = extensionTools;
		this.webSearchMode = webSearchMode;
		this.requestedCapability = requestedCapability;
	}
}
