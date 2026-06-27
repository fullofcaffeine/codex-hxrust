package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppLinkViewPlanFields = {
	final allowTerminalMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowBrowserLaunch:Bool;
	final allowAppServerDelivery:Bool;
	final allowFilesystemMutation:Bool;
	final allowClipboardMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeAppLinkViewAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAppLinkViewPlan {
	public final allowTerminalMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowBrowserLaunch:Bool;
	public final allowAppServerDelivery:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowClipboardMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeAppLinkViewAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
