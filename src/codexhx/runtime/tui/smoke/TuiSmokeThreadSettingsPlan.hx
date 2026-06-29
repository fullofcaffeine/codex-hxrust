package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadSettingsPlanFields = {
	final allowAppServerDelivery:Bool;
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final actions:Array<TuiSmokeThreadSettingsAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Headless-only plan for upstream ChatWidget ThreadSettingsUpdated parity smoke events. */
class TuiSmokeThreadSettingsPlan {
	public final allowAppServerDelivery:Bool;
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final actions:Array<TuiSmokeThreadSettingsAction>;

	public function enabled():Bool {
		return !allowAppServerDelivery && !allowRatatuiRender && !allowModelCall && actions != null && actions.length > 0;
	}
}
