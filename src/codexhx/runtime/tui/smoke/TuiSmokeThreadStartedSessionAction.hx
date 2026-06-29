package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadStartedSessionActionFields = {
	final kind:TuiSmokeThreadStartedSessionActionKind;
	final name:String;
	final primaryThreadId:String;
	final agentThreadId:String;
	final primaryCwd:String;
	final agentCwd:String;
	final primaryModel:String;
	final rolloutModel:String;
	final modelProviderId:String;
	final primaryApprovalPolicy:String;
	final threadName:String;
	final rolloutPath:String;
	final primaryRuntimeWorkspaceRoots:Array<String>;
	final expectedThreadId:String;
	final expectedThreadName:String;
	final expectedModel:String;
	final expectedModelProviderId:String;
	final expectedApprovalPolicy:String;
	final expectedCwd:String;
	final expectedRuntimeWorkspaceRoots:Array<String>;
	final expectedRolloutPath:String;
	final agentNickname:String;
	final agentRole:String;
	final expectedNavigationLabel:String;
	final expectedNavigationRunning:Bool;
	final expectedNavigationClosed:Bool;
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
class TuiSmokeThreadStartedSessionAction {
	public final kind:TuiSmokeThreadStartedSessionActionKind;
	public final name:String;
	public final primaryThreadId:String;
	public final agentThreadId:String;
	public final primaryCwd:String;
	public final agentCwd:String;
	public final primaryModel:String;
	public final rolloutModel:String;
	public final modelProviderId:String;
	public final primaryApprovalPolicy:String;
	public final threadName:String;
	public final rolloutPath:String;
	public final primaryRuntimeWorkspaceRoots:Array<String>;
	public final expectedThreadId:String;
	public final expectedThreadName:String;
	public final expectedModel:String;
	public final expectedModelProviderId:String;
	public final expectedApprovalPolicy:String;
	public final expectedCwd:String;
	public final expectedRuntimeWorkspaceRoots:Array<String>;
	public final expectedRolloutPath:String;
	public final agentNickname:String;
	public final agentRole:String;
	public final expectedNavigationLabel:String;
	public final expectedNavigationRunning:Bool;
	public final expectedNavigationClosed:Bool;
	public final failureCode:String;
	public final noAppServerMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
