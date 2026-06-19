package codexhx.runtime.model.planning;

import codexhx.runtime.model.catalog.ModelCatalogOutcome;
import codexhx.runtime.model.catalog.ModelCatalogToolMode;

class TurnModelPlanOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final catalogCode:String;
	public final providerId:String;
	public final selectedModelId:String;
	public final effectiveToolMode:ModelCatalogToolMode;
	public final requestedCapability:TurnModelToolCapabilityKind;
	public final capabilityEnabled:Bool;
	public final plan:TurnModelCapabilityPlan;
	public final errorMessage:String;
	public final sequence:String;

	function new(ok:Bool, code:String, request:TurnModelPlanRequest, catalog:ModelCatalogOutcome, selectedModelId:String,
			effectiveToolMode:ModelCatalogToolMode, capabilityEnabled:Bool, plan:TurnModelCapabilityPlan, errorMessage:String, sequence:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.catalogCode = catalog == null ? "none" : catalog.code;
		this.providerId = catalog == null ? "" : catalog.providerId;
		this.selectedModelId = selectedModelId;
		this.effectiveToolMode = effectiveToolMode;
		this.requestedCapability = request.requestedCapability;
		this.capabilityEnabled = capabilityEnabled;
		this.plan = plan;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function accepted(request:TurnModelPlanRequest, catalog:ModelCatalogOutcome, selectedModelId:String, effectiveToolMode:ModelCatalogToolMode,
			capabilityEnabled:Bool, plan:TurnModelCapabilityPlan, sequence:String):TurnModelPlanOutcome {
		return new TurnModelPlanOutcome(true, "turn_model_plan_admitted", request, catalog, selectedModelId, effectiveToolMode, capabilityEnabled, plan, "",
			sequence);
	}

	public static function denied(request:TurnModelPlanRequest, catalog:ModelCatalogOutcome, code:String, selectedModelId:String,
			effectiveToolMode:ModelCatalogToolMode, plan:TurnModelCapabilityPlan, errorMessage:String, sequence:String):TurnModelPlanOutcome {
		return new TurnModelPlanOutcome(false, code, request, catalog, selectedModelId, effectiveToolMode, false, plan, errorMessage, sequence);
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";catalogCode=" + catalogCode + ";provider=" + providerId + ";model="
			+ selectedModelId + ";toolMode=" + effectiveToolMode + ";requestedCapability=" + requestedCapability + ";capabilityEnabled="
			+ boolText(capabilityEnabled) + ";plan={" + (plan == null ? "none" : plan.summary()) + "}" + ";error=" + errorMessage + ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
