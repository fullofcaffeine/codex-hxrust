package codexhx.runtime.tui.smoke;

typedef TuiSmokePasteBurstPlanFields = {
	final allowTerminalMutation:Bool;
	final allowTextareaMutation:Bool;
	final allowRatatuiBuffer:Bool;
	final allowClipboardMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final allowAppServerDelivery:Bool;
	final actions:Array<TuiSmokePasteBurstAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokePasteBurstPlan {
	public final allowTerminalMutation:Bool;
	public final allowTextareaMutation:Bool;
	public final allowRatatuiBuffer:Bool;
	public final allowClipboardMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final allowAppServerDelivery:Bool;
	public final actions:Array<TuiSmokePasteBurstAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
