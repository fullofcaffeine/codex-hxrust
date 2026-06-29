package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerLifecycleActionFields = {
	final kind:TuiSmokeAppServerLifecycleActionKind;
	final threadId:String;
	final incomingThreadId:String;
	final originalThreadName:String;
	final incomingThreadName:String;
	final finalThreadName:String;
	final resumeCommand:String;
	final renderedHint:String;
	final replayKind:String;
	final exitMode:TuiSmokeExitMode;
	final failureCode:String;
	final historyCellCount:Int;
	final appEventQueued:Bool;
	final immediateExit:Bool;
	final liveNotification:Bool;
	final invalidThreadIdRejected:Bool;
	final threadIdPreserved:Bool;
	final threadNamePreserved:Bool;
	final threadNameUpdated:Bool;
	final resumeHintInserted:Bool;
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
	public final incomingThreadId:String;
	public final originalThreadName:String;
	public final incomingThreadName:String;
	public final finalThreadName:String;
	public final resumeCommand:String;
	public final renderedHint:String;
	public final replayKind:String;
	public final exitMode:TuiSmokeExitMode;
	public final failureCode:String;
	public final historyCellCount:Int;
	public final appEventQueued:Bool;
	public final immediateExit:Bool;
	public final liveNotification:Bool;
	public final invalidThreadIdRejected:Bool;
	public final threadIdPreserved:Bool;
	public final threadNamePreserved:Bool;
	public final threadNameUpdated:Bool;
	public final resumeHintInserted:Bool;
	public final replaySuppressed:Bool;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
