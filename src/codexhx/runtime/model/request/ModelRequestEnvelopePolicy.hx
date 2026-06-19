package codexhx.runtime.model.request;

import codexhx.runtime.model.catalog.ModelCatalogEntry;
import codexhx.runtime.model.planning.TurnModelPlanOutcome;
import codexhx.runtime.model.planning.TurnModelPlanPolicy;

class ModelRequestEnvelopePolicy {
	public static function buildCases(requests:Array<ModelRequestEnvelopeRequest>):ModelRequestEnvelopeReport {
		final outcomes:Array<ModelRequestEnvelopeOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ModelRequestEnvelopeReport(outcomes);
	}

	public static function build(request:ModelRequestEnvelopeRequest):ModelRequestEnvelopeOutcome {
		final plan = TurnModelPlanPolicy.build(request.planRequest);
		if (plan == null || !plan.ok) {
			return ModelRequestEnvelopeOutcome.denied(request, plan, "turn_model_plan_denied", plan == null ? "missing turn model plan" : plan.errorMessage,
				"model_request_envelope->turn_model_plan:error");
		}
		final model = selectedModel(request, plan);
		if (model == null) {
			return ModelRequestEnvelopeOutcome.denied(request, plan, "selected_model_missing", "selected catalog model metadata is missing",
				"model_request_envelope->selected_model_metadata:missing");
		}
		final provider = request.planRequest.catalogRequest.admissionRequest.provider;
		if (request.routeIntent != ModelRequestRouteIntent.PlanOnly && !request.liveNetworkAllowed) {
			return ModelRequestEnvelopeOutcome.denied(request, plan, "live_network_disabled", "fixture gate refused live model route before transport",
				"model_request_envelope->route:" + request.routeIntent + "->live_network:disabled");
		}
		if (request.routeIntent == ModelRequestRouteIntent.ResponsesWebsocket && !provider.supportsWebsockets) {
			return ModelRequestEnvelopeOutcome.denied(request, plan, "websocket_unsupported", "provider does not support Responses websocket transport",
				"model_request_envelope->route:responses_websocket->provider_websocket:unsupported");
		}
		if (request.routeIntent != ModelRequestRouteIntent.PlanOnly && !request.hasCredentialMaterial) {
			return ModelRequestEnvelopeOutcome.denied(request, plan, "credential_material_missing", "live model route requires credential material",
				"model_request_envelope->route:" + request.routeIntent + "->credential:missing");
		}
		return ModelRequestEnvelopeOutcome.accepted(request, plan, envelope(request, model),
			"model_request_envelope->turn_model_plan:ok->route:" + routeName(request.routeIntent) + "->envelope:built");
	}

	static function selectedModel(request:ModelRequestEnvelopeRequest, plan:TurnModelPlanOutcome):ModelCatalogEntry {
		for (model in request.planRequest.catalogRequest.catalog) {
			if (model.providerId == plan.providerId && model.modelId == plan.selectedModelId)
				return model;
		}
		return null;
	}

	static function envelope(request:ModelRequestEnvelopeRequest, model:ModelCatalogEntry):ModelRequestEnvelope {
		final provider = request.planRequest.catalogRequest.admissionRequest.provider;
		final prompt = request.prompt;
		final reasoningIncluded = prompt.supportsReasoningSummaries;
		final textControls = textControls(prompt);
		final serviceTier = prompt.requestedServiceTier.length > 0 ? prompt.requestedServiceTier : (model.defaultServiceTier.length > 0 ? model.defaultServiceTier : "none");
		return new ModelRequestEnvelope(model.modelId, provider.providerId, routeName(request.routeIntent), "responses", true,
			isAzureResponsesEndpoint(provider.baseUrl), prompt.parallelToolCalls && !model.useResponsesLite, reasoningIncluded,
			reasoningIncluded ? (model.useResponsesLite ? "all_turns" : "default") : "none", reasoningIncluded, textControls, serviceTier, true, true,
			prompt.enableRequestCompression, false, prompt.toolSpecCount, prompt.inputItemCount);
	}

	static function routeName(intent:ModelRequestRouteIntent):String {
		if (intent == ModelRequestRouteIntent.ResponsesHttp)
			return "responses_http";
		if (intent == ModelRequestRouteIntent.ResponsesWebsocket)
			return "responses_websocket";
		return "request_envelope_only";
	}

	static function textControls(prompt:ModelRequestPromptEnvelope):String {
		if (prompt.outputSchemaPresent)
			return prompt.outputSchemaStrict ? "json_schema_strict" : "json_schema";
		if (prompt.supportsVerbosity && prompt.requestedVerbosity.length > 0)
			return "verbosity:" + prompt.requestedVerbosity;
		return "none";
	}

	static function isAzureResponsesEndpoint(baseUrl:String):Bool {
		final lower = baseUrl == null ? "" : baseUrl.toLowerCase();
		return lower.indexOf("azure") >= 0;
	}
}
