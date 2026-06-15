package codexhx.runtime.model.streamitem;

enum abstract ModelClearOnlySkillWarningRerenderDecisionKind(String) to String {
	final SkillWarningRerenderEnabled = "skill_warning_rerender_enabled";
	final SkillWarningStillSuppressed = "skill_warning_still_suppressed";
	final SkillWarningUnavailable = "skill_warning_unavailable";
}
