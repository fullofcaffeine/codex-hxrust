package codexhx.runtime.tui.smoke;

enum abstract TuiSmokePermissionSelectionActionKind(String) to String {
	final ModeList = "mode_list";
	final ProfileList = "profile_list";
	final SelectProfile = "select_profile";
	final FullAccessConfirm = "full_access_confirm";
	final AutoReviewDenials = "auto_review_denials";
	final DisabledPreset = "disabled_preset";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokePermissionSelectionActionKind {
		return switch value {
			case "mode_list": ModeList;
			case "profile_list": ProfileList;
			case "select_profile": SelectProfile;
			case "full_access_confirm": FullAccessConfirm;
			case "auto_review_denials": AutoReviewDenials;
			case "disabled_preset": DisabledPreset;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
