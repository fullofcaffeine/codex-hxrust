package codexhx.runtime.tui.smoke;

typedef TuiSmokeModelSettingsPlanFields = {
	final allowRatatuiRender:Bool;
	final allowModelCall:Bool;
	final allowConfigMutation:Bool;
	final actions:Array<TuiSmokeModelSettingsAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeModelSettingsPlan {
	public final allowRatatuiRender:Bool;
	public final allowModelCall:Bool;
	public final allowConfigMutation:Bool;
	public final actions:Array<TuiSmokeModelSettingsAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
