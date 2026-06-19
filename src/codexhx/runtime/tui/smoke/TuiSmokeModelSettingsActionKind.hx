package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeModelSettingsActionKind(String) to String {
	final ModelPopup = "model_popup";
	final AllModelsPopup = "all_models_popup";
	final ReasoningPopup = "reasoning_popup";
	final PlanScopePrompt = "plan_scope_prompt";
	final ServiceTier = "service_tier";
	final Personality = "personality";
	final RealtimeAudio = "realtime_audio";
	final ExperimentalFeatures = "experimental_features";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeModelSettingsActionKind {
		return switch value {
			case "model_popup": ModelPopup;
			case "all_models_popup": AllModelsPopup;
			case "reasoning_popup": ReasoningPopup;
			case "plan_scope_prompt": PlanScopePrompt;
			case "service_tier": ServiceTier;
			case "personality": Personality;
			case "realtime_audio": RealtimeAudio;
			case "experimental_features": ExperimentalFeatures;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
