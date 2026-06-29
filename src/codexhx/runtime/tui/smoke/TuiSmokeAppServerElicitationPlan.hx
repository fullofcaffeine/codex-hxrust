package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerElicitationPlanFields = {
	final allowAppLinkView:Bool;
	final allowBrowserLaunch:Bool;
	final allowAppServerDelivery:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeAppServerElicitationAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for upstream ChatWidget app-server elicitation parity smoke events. */
class TuiSmokeAppServerElicitationPlan {
	public final allowAppLinkView:Bool;
	public final allowBrowserLaunch:Bool;
	public final allowAppServerDelivery:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeAppServerElicitationAction>;

	public function enabled():Bool {
		return !allowAppLinkView && !allowBrowserLaunch && !allowAppServerDelivery && !allowNetwork && !allowModelCall && actions != null && actions.length > 0;
	}
}
