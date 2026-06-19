package codexhx.runtime.model.catalog;

import codexhx.runtime.model.admission.ProviderAdmissionOutcome;

class ModelCatalogOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final providerId:String;
	public final admissionCode:String;
	public final catalogSource:String;
	public final refreshStrategy:ModelCatalogRefreshStrategy;
	public final includeHidden:Bool;
	public final allowLiveFetch:Bool;
	public final usesCodexBackend:Bool;
	public final liveFetchAttempted:Bool;
	public final selectedModelId:String;
	public final selectedHidden:Bool;
	public final defaultModelId:String;
	public final catalogCount:Int;
	public final providerModelCount:Int;
	public final visibleCount:Int;
	public final hiddenCount:Int;
	public final apiFilteredCount:Int;
	public final capabilitySummary:String;
	public final modelSummaries:Array<String>;
	public final errorMessage:String;
	public final sequence:String;

	function new(ok:Bool, code:String, request:ModelCatalogRequest, admission:ProviderAdmissionOutcome, liveFetchAttempted:Bool, selectedModelId:String,
			selectedHidden:Bool, defaultModelId:String, catalogCount:Int, providerModelCount:Int, visibleCount:Int, hiddenCount:Int, apiFilteredCount:Int,
			capabilitySummary:String, modelSummaries:Array<String>, errorMessage:String, sequence:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.providerId = request.admissionRequest == null
			|| request.admissionRequest.provider == null ? "" : request.admissionRequest.provider.providerId;
		this.admissionCode = admission == null ? "none" : admission.code;
		this.catalogSource = request.catalogSource;
		this.refreshStrategy = request.refreshStrategy;
		this.includeHidden = request.includeHidden;
		this.allowLiveFetch = request.allowLiveFetch;
		this.usesCodexBackend = request.usesCodexBackend;
		this.liveFetchAttempted = liveFetchAttempted;
		this.selectedModelId = selectedModelId;
		this.selectedHidden = selectedHidden;
		this.defaultModelId = defaultModelId;
		this.catalogCount = catalogCount;
		this.providerModelCount = providerModelCount;
		this.visibleCount = visibleCount;
		this.hiddenCount = hiddenCount;
		this.apiFilteredCount = apiFilteredCount;
		this.capabilitySummary = capabilitySummary;
		this.modelSummaries = modelSummaries == null ? [] : modelSummaries;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function accepted(request:ModelCatalogRequest, admission:ProviderAdmissionOutcome, liveFetchAttempted:Bool, selected:ModelCatalogEntry,
			defaultModelId:String, catalogCount:Int, providerModelCount:Int, visibleCount:Int, hiddenCount:Int, apiFilteredCount:Int,
			capabilitySummary:String, modelSummaries:Array<String>, sequence:String):ModelCatalogOutcome {
		return new ModelCatalogOutcome(true, "model_catalog_admitted", request, admission, liveFetchAttempted,
			selected == null ? "" : selected.modelId, selected != null
			&& selected.hidden(), defaultModelId, catalogCount, providerModelCount, visibleCount, hiddenCount, apiFilteredCount,
			capabilitySummary, modelSummaries, "", sequence);
	}

	public static function denied(request:ModelCatalogRequest, admission:ProviderAdmissionOutcome, code:String, liveFetchAttempted:Bool, catalogCount:Int,
			providerModelCount:Int, visibleCount:Int, hiddenCount:Int, apiFilteredCount:Int, capabilitySummary:String, modelSummaries:Array<String>,
			errorMessage:String, sequence:String):ModelCatalogOutcome {
		return new ModelCatalogOutcome(false, code, request, admission, liveFetchAttempted, "", false, "", catalogCount, providerModelCount, visibleCount,
			hiddenCount, apiFilteredCount, capabilitySummary, modelSummaries, errorMessage, sequence);
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";provider=" + providerId + ";admissionCode=" + admissionCode
			+ ";catalogSource=" + catalogSource + ";refreshStrategy=" + refreshStrategy + ";includeHidden=" + boolText(includeHidden) + ";allowLiveFetch="
			+ boolText(allowLiveFetch) + ";usesCodexBackend=" + boolText(usesCodexBackend) + ";liveFetchAttempted=" + boolText(liveFetchAttempted)
			+ ";selected=" + selectedModelId + ";selectedHidden=" + boolText(selectedHidden) + ";default=" + defaultModelId + ";catalogCount="
			+ Std.string(catalogCount) + ";providerModelCount=" + Std.string(providerModelCount) + ";visible=" + Std.string(visibleCount) + ";hidden="
			+ Std.string(hiddenCount) + ";apiFiltered=" + Std.string(apiFilteredCount) + ";capabilities={" + capabilitySummary + "}" + ";models=["
			+ modelSummaries.join("##") + "]" + ";error=" + errorMessage + ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
