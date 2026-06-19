package codexhx.runtime.model.catalog;

import codexhx.runtime.model.admission.ProviderAdmissionOutcome;
import codexhx.runtime.model.admission.ProviderAdmissionPolicy;

class ModelCatalogPolicy {
	public static function buildCases(requests:Array<ModelCatalogRequest>):ModelCatalogReport {
		final outcomes:Array<ModelCatalogOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ModelCatalogReport(outcomes);
	}

	public static function build(request:ModelCatalogRequest):ModelCatalogOutcome {
		final emptySummaries:Array<String> = [];
		final admission = request.admissionRequest == null ? null : ProviderAdmissionPolicy.build(request.admissionRequest);
		final capabilities = request.admissionRequest == null ? ModelProviderCapabilities.defaultConfigured() : ModelProviderCapabilities.forProvider(request.admissionRequest.provider);
		final capabilitySummary = capabilities.summary();
		final liveFetchAttempted = request.refreshStrategy == ModelCatalogRefreshStrategy.Online
			|| request.refreshStrategy == ModelCatalogRefreshStrategy.OnlineIfUncached;

		if (admission == null || !admission.ok) {
			return ModelCatalogOutcome.denied(request, admission, "provider_admission_denied", liveFetchAttempted, request.catalog.length, 0, 0, 0, 0,
				capabilitySummary, emptySummaries, admission == null ? "missing provider admission request" : admission.errorMessage,
				"model_catalog->provider_admission:error");
		}
		if (liveFetchAttempted && !request.allowLiveFetch) {
			return ModelCatalogOutcome.denied(request, admission, "live_model_fetch_disabled", liveFetchAttempted, request.catalog.length, 0, 0, 0, 0,
				capabilitySummary, emptySummaries, "live model catalog refresh is disabled for this credential-free fixture gate",
				"model_catalog->refresh_strategy:" + request.refreshStrategy + "->live_fetch_disabled");
		}

		final providerModels = providerCatalog(request);
		for (model in providerModels) {
			if (!model.valid()) {
				return ModelCatalogOutcome.denied(request, admission, "invalid_model_catalog", liveFetchAttempted, request.catalog.length,
					providerModels.length, 0, 0, 0, capabilitySummary, emptySummaries, "model catalog row is incomplete",
					"model_catalog->validate_model:error");
			}
		}

		final authFiltered = filterByAuth(providerModels, request.usesCodexBackend);
		final apiFilteredCount = providerModels.length - authFiltered.length;
		sortByPriority(authFiltered);
		final defaultModel = defaultModel(authFiltered);
		final visibleModels = visibleForAppServer(authFiltered, request.includeHidden);
		final hiddenCount = countHidden(authFiltered);
		final summaries = modelSummaries(authFiltered, capabilities);

		if (StringTools.trim(request.requestedModelId).length > 0) {
			final requested = findModel(authFiltered, request.requestedModelId);
			if (requested == null) {
				return ModelCatalogOutcome.denied(request, admission, "unsupported_model", liveFetchAttempted, request.catalog.length, providerModels.length,
					visibleModels.length, hiddenCount, apiFilteredCount, capabilitySummary, summaries,
					"requested model is not available for the active provider/auth mode", "model_catalog->find_requested_model:not_found");
			}
			if (!request.includeHidden && requested.hidden()) {
				return ModelCatalogOutcome.denied(request, admission, "hidden_model", liveFetchAttempted, request.catalog.length, providerModels.length,
					visibleModels.length, hiddenCount, apiFilteredCount, capabilitySummary, summaries,
					"requested model is hidden from the picker without include_hidden", "model_catalog->app_server_filter:hidden");
			}
			return ModelCatalogOutcome.accepted(request, admission, liveFetchAttempted, requested, defaultModel == null ? "" : defaultModel.modelId,
				request.catalog.length, providerModels.length, visibleModels.length, hiddenCount, apiFilteredCount, capabilitySummary, summaries,
				"model_catalog->provider_admission:ok->filter_by_auth->requested_model");
		}

		if (defaultModel == null) {
			return ModelCatalogOutcome.denied(request, admission, "unsupported_model", liveFetchAttempted, request.catalog.length, providerModels.length,
				visibleModels.length, hiddenCount, apiFilteredCount, capabilitySummary, summaries,
				"no models are available for the active provider/auth mode", "model_catalog->default_model:none");
		}

		return ModelCatalogOutcome.accepted(request, admission, liveFetchAttempted, defaultModel, defaultModel.modelId, request.catalog.length,
			providerModels.length, visibleModels.length, hiddenCount, apiFilteredCount, capabilitySummary, summaries,
			"model_catalog->provider_admission:ok->filter_by_auth->mark_default_by_picker_visibility");
	}

	static function providerCatalog(request:ModelCatalogRequest):Array<ModelCatalogEntry> {
		final out:Array<ModelCatalogEntry> = [];
		final providerId = request.admissionRequest.provider.providerId;
		for (model in request.catalog)
			if (model.providerId == providerId)
				out.push(model);
		return out;
	}

	static function filterByAuth(models:Array<ModelCatalogEntry>, usesCodexBackend:Bool):Array<ModelCatalogEntry> {
		final out:Array<ModelCatalogEntry> = [];
		for (model in models)
			if (usesCodexBackend || model.supportedInApi)
				out.push(model);
		return out;
	}

	static function visibleForAppServer(models:Array<ModelCatalogEntry>, includeHidden:Bool):Array<ModelCatalogEntry> {
		final out:Array<ModelCatalogEntry> = [];
		for (model in models)
			if (includeHidden || model.showInPicker())
				out.push(model);
		return out;
	}

	static function countHidden(models:Array<ModelCatalogEntry>):Int {
		var count = 0;
		for (model in models)
			if (model.hidden())
				count = count + 1;
		return count;
	}

	static function modelSummaries(models:Array<ModelCatalogEntry>, capabilities:ModelProviderCapabilities):Array<String> {
		final out:Array<String> = [];
		for (model in models)
			out.push(model.summary(capabilities));
		return out;
	}

	static function defaultModel(models:Array<ModelCatalogEntry>):ModelCatalogEntry {
		for (model in models)
			if (model.showInPicker())
				return model;
		return models.length > 0 ? models[0] : null;
	}

	static function findModel(models:Array<ModelCatalogEntry>, modelId:String):ModelCatalogEntry {
		for (model in models)
			if (model.modelId == modelId)
				return model;
		return null;
	}

	static function sortByPriority(models:Array<ModelCatalogEntry>):Void {
		models.sort(function(left, right) {
			if (left.priority < right.priority)
				return -1;
			if (left.priority > right.priority)
				return 1;
			if (left.modelId < right.modelId)
				return -1;
			if (left.modelId > right.modelId)
				return 1;
			return 0;
		});
	}
}
