package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalPalettePlanFields = {
	final allowLiveQuery:Bool;
	final actions:Array<TuiSmokeTerminalPaletteAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalPalettePlan {
	public final allowLiveQuery:Bool;
	public final actions:Array<TuiSmokeTerminalPaletteAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
