package codexhx.runtime.tui.smoke;

typedef TuiSmokeDesktopNotificationPlanFields = {
	final allowLiveNotification:Bool;
	final actions:Array<TuiSmokeDesktopNotificationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeDesktopNotificationPlan {
	public final allowLiveNotification:Bool;
	public final actions:Array<TuiSmokeDesktopNotificationAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
