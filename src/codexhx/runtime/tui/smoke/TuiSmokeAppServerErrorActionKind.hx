package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget app-server error history coverage. */
enum abstract TuiSmokeAppServerErrorActionKind(String) to String {
	final NonDuplicateFailedTurn = "non_duplicate_failed_turn";
	final ConsolidateStreamedAnswer = "consolidate_streamed_answer";
	final RetryStatusRecovery = "retry_status_recovery";
	final ServerOverloadedWarning = "server_overloaded_warning";
	final CyberPolicyNotice = "cyber_policy_notice";
	final SafetyAccessNotice = "safety_access_notice";
	final ModelVerificationWarning = "model_verification_warning";
	final ConfigErrorWrapping = "config_error_wrapping";
	final WarningNotification = "warning_notification";
	final GuardianWarningNotification = "guardian_warning_notification";
	final ConfigWarningNotification = "config_warning_notification";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAppServerErrorActionKind {
		return switch value {
			case "non_duplicate_failed_turn": NonDuplicateFailedTurn;
			case "consolidate_streamed_answer": ConsolidateStreamedAnswer;
			case "retry_status_recovery": RetryStatusRecovery;
			case "server_overloaded_warning": ServerOverloadedWarning;
			case "cyber_policy_notice": CyberPolicyNotice;
			case "safety_access_notice": SafetyAccessNotice;
			case "model_verification_warning": ModelVerificationWarning;
			case "config_error_wrapping": ConfigErrorWrapping;
			case "warning_notification": WarningNotification;
			case "guardian_warning_notification": GuardianWarningNotification;
			case "config_warning_notification": ConfigWarningNotification;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
