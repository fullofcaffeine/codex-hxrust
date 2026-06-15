package codexhx.runtime.model.streamitem;

enum abstract ModelInactiveThreadSettingsNotificationDecisionKind(String) to String {
	final InactiveThreadSettingsNotificationCached = "inactive_thread_settings_notification_cached";
	final InactiveThreadSettingsNotificationIgnored = "inactive_thread_settings_notification_ignored";
	final InactiveThreadSettingsNotificationUnavailable = "inactive_thread_settings_notification_unavailable";
}
