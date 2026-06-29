package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReadSessionActionFields = {
	final kind:TuiSmokeThreadReadSessionActionKind;
	final name:String;
	final primaryThreadId:String;
	final readThreadId:String;
	final primaryCwd:String;
	final readCwd:String;
	final threadName:String;
	final modelProviderId:String;
	final primaryPermissionProfile:String;
	final widgetPermissionProfile:String;
	final primaryRuntimeWorkspaceRoots:Array<String>;
	final expectedThreadId:String;
	final expectedCwd:String;
	final expectedRuntimeWorkspaceRoots:Array<String>;
	final expectedPermissionProfile:String;
	final expectedPrimaryProfileReused:Bool;
	final failureCode:String;
	final noAppServerMutation:Bool;
	final noFilesystemMutation:Bool;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadReadSessionAction {
	public final kind:TuiSmokeThreadReadSessionActionKind;
	public final name:String;
	public final primaryThreadId:String;
	public final readThreadId:String;
	public final primaryCwd:String;
	public final readCwd:String;
	public final threadName:String;
	public final modelProviderId:String;
	public final primaryPermissionProfile:String;
	public final widgetPermissionProfile:String;
	public final primaryRuntimeWorkspaceRoots:Array<String>;
	public final expectedThreadId:String;
	public final expectedCwd:String;
	public final expectedRuntimeWorkspaceRoots:Array<String>;
	public final expectedPermissionProfile:String;
	public final expectedPrimaryProfileReused:Bool;
	public final failureCode:String;
	public final noAppServerMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
