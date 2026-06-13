package codexhx.runtime.model.planning;

import codexhx.runtime.model.catalog.ModelCatalogEntry;
import codexhx.runtime.model.catalog.ModelCatalogOutcome;
import codexhx.runtime.model.catalog.ModelCatalogPolicy;
import codexhx.runtime.model.catalog.ModelCatalogToolMode;
import codexhx.runtime.model.catalog.ModelCatalogWebSearchToolType;
import codexhx.runtime.model.catalog.ModelProviderCapabilities;

class TurnModelPlanPolicy {
	public static function buildCases(requests:Array<TurnModelPlanRequest>):TurnModelPlanReport {
		final outcomes:Array<TurnModelPlanOutcome> = [];
		for (request in requests) outcomes.push(build(request));
		return new TurnModelPlanReport(outcomes);
	}

	public static function build(request:TurnModelPlanRequest):TurnModelPlanOutcome {
		final catalog = request.catalogRequest == null ? null : ModelCatalogPolicy.build(request.catalogRequest);
		final capabilities = request.catalogRequest == null || request.catalogRequest.admissionRequest == null
			? ModelProviderCapabilities.defaultConfigured()
			: ModelProviderCapabilities.forProvider(request.catalogRequest.admissionRequest.provider);
		final emptyPlan = disabledPlan();
		if (catalog == null || !catalog.ok) {
			return TurnModelPlanOutcome.denied(
				request,
				catalog,
				"model_catalog_denied",
				"",
				ModelCatalogToolMode.None,
				emptyPlan,
				catalog == null ? "missing model catalog request" : catalog.errorMessage,
				"turn_model_plan->model_catalog:error"
			);
		}
		final selected = selectedModel(request, catalog);
		if (selected == null) {
			return TurnModelPlanOutcome.denied(
				request,
				catalog,
				"selected_model_missing",
				catalog.selectedModelId,
				ModelCatalogToolMode.None,
				emptyPlan,
				"selected catalog model metadata is missing",
				"turn_model_plan->selected_model_metadata:missing"
			);
		}
		final toolMode = effectiveToolMode(selected, request.features);
		final plan = capabilityPlan(selected, capabilities, toolMode, request);
		if (!plan.enabled(request.requestedCapability)) {
			return TurnModelPlanOutcome.denied(
				request,
				catalog,
				"unsupported_tool_capability",
				selected.modelId,
				toolMode,
				plan,
				"requested capability is not available for the selected model/provider/tool mode",
				"turn_model_plan->capability:" + request.requestedCapability + ":disabled"
			);
		}
		return TurnModelPlanOutcome.accepted(
			request,
			catalog,
			selected.modelId,
			toolMode,
			true,
			plan,
			"turn_model_plan->model_catalog:ok->tool_mode:" + toolMode + "->capability:" + request.requestedCapability
		);
	}

	static function selectedModel(request:TurnModelPlanRequest, catalog:ModelCatalogOutcome):ModelCatalogEntry {
		for (model in request.catalogRequest.catalog) {
			if (model.providerId == catalog.providerId && model.modelId == catalog.selectedModelId) return model;
		}
		return null;
	}

	static function effectiveToolMode(model:ModelCatalogEntry, features:TurnModelFeatureFlags):ModelCatalogToolMode {
		if (model.toolMode != ModelCatalogToolMode.None) return model.toolMode;
		if (features.codeModeOnly) return ModelCatalogToolMode.CodeModeOnly;
		if (features.codeMode) return ModelCatalogToolMode.CodeMode;
		return ModelCatalogToolMode.Direct;
	}

	static function capabilityPlan(
		model:ModelCatalogEntry,
		capabilities:ModelProviderCapabilities,
		toolMode:ModelCatalogToolMode,
		request:TurnModelPlanRequest
	):TurnModelCapabilityPlan {
		final namespaceTools = capabilities.namespaceTools;
		final webModeOn = request.webSearchMode != TurnWebSearchMode.Disabled;
		final standaloneWebRun = namespaceTools
			&& request.features.standaloneWebSearch
			&& request.extensionTools.standaloneWebRunAvailable
			&& webModeOn;
		final hostedWebSearch = !model.useResponsesLite
			&& !standaloneWebRun
			&& capabilities.webSearch
			&& webModeOn;
		final hostedWebAccess = hostedWebSearch ? webAccess(request.webSearchMode) : "none";
		final hostedWebTypes = hostedWebSearch && model.webSearchToolType == ModelCatalogWebSearchToolType.TextAndImage ? "text,image" : "text";
		final imageRuntime = request.catalogRequest.usesCodexBackend
			&& capabilities.imageGeneration
			&& model.inputModalities.indexOf("image") >= 0;
		final standaloneImageVisible = imageRuntime
			&& namespaceTools
			&& (model.useResponsesLite || request.features.imageGenExt)
			&& request.extensionTools.standaloneImageGenerationAvailable;
		final hostedImage = imageRuntime
			&& request.features.imageGeneration
			&& !standaloneImageVisible;
		final codeModeNested = toolMode == ModelCatalogToolMode.CodeMode || toolMode == ModelCatalogToolMode.CodeModeOnly;
		final toolSearch = model.supportsSearchTool && namespaceTools && request.features.deferredToolsAvailable;
		return new TurnModelCapabilityPlan(
			hostedWebSearch,
			hostedWebAccess,
			hostedWebTypes,
			standaloneWebRun,
			hostedImage,
			standaloneImageVisible,
			namespaceTools,
			codeModeNested,
			toolSearch
		);
	}

	static function disabledPlan():TurnModelCapabilityPlan {
		return new TurnModelCapabilityPlan(false, "none", "text", false, false, false, false, false, false);
	}

	static function webAccess(mode:TurnWebSearchMode):String {
		return mode == TurnWebSearchMode.Live ? "live" : "cached";
	}
}
