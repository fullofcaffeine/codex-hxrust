package codexhx.runtime.model.streamitem;

enum abstract ModelOverrideTurnContextSettingsUpdateDecisionKind(String) to String {
	final ThreadSettingsUpdateSubmitted = "thread_settings_update_submitted";
	final NoSettingsChangesNoop = "no_settings_changes_noop";
	final OverrideTurnContextNotHandled = "override_turn_context_not_handled";
}
