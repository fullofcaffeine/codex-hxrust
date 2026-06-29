package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerLifecycleActionFields = {
	final kind:TuiSmokeAppServerLifecycleActionKind;
	final threadId:String;
	final replayKind:String;
	final exitMode:TuiSmokeExitMode;
	final failureCode:String;
	final appEventQueued:Bool;
	final immediateExit:Bool;
	final liveNotification:Bool;
	final replaySuppressed:Bool;
	final noAppServerDelivery:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget app-server lifecycle behavior. */
class TuiSmokeAppServerLifecycleAction {
	public final kind:TuiSmokeAppServerLifecycleActionKind;
	public final threadId:String;
	public final replayKind:String;
	public final exitMode:TuiSmokeExitMode;
	public final failureCode:String;
	public final appEventQueued:Bool;
	public final immediateExit:Bool;
	public final liveNotification:Bool;
	public final replaySuppressed:Bool;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
