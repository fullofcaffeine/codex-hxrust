package codexhx.runtime.model.catalog;

import codexhx.runtime.model.admission.ProviderAdmissionRequest;

class ModelCatalogRequest {
	public final requestId:String;
	public final admissionRequest:ProviderAdmissionRequest;
	public final catalogSource:String;
	public final refreshStrategy:ModelCatalogRefreshStrategy;
	public final includeHidden:Bool;
	public final allowLiveFetch:Bool;
	public final usesCodexBackend:Bool;
	public final requestedModelId:String;
	public final catalog:Array<ModelCatalogEntry>;

	public function new(
		requestId:String,
		admissionRequest:ProviderAdmissionRequest,
		catalogSource:String,
		refreshStrategy:ModelCatalogRefreshStrategy,
		includeHidden:Bool,
		allowLiveFetch:Bool,
		usesCodexBackend:Bool,
		requestedModelId:String,
		catalog:Array<ModelCatalogEntry>
	) {
		this.requestId = requestId;
		this.admissionRequest = admissionRequest;
		this.catalogSource = catalogSource;
		this.refreshStrategy = refreshStrategy;
		this.includeHidden = includeHidden;
		this.allowLiveFetch = allowLiveFetch;
		this.usesCodexBackend = usesCodexBackend;
		this.requestedModelId = requestedModelId;
		this.catalog = catalog == null ? [] : catalog;
	}
}
