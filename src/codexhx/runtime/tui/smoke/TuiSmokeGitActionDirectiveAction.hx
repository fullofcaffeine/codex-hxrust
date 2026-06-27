package codexhx.runtime.tui.smoke;

typedef TuiSmokeGitActionDirectiveActionFields = {
	final kind:TuiSmokeGitActionDirectiveActionKind;
	final name:String;
	final cwd:String;
	final markdown:String;
	final expectedVisibleMarkdown:String;
	final expectedLastCreatedBranchCwd:String;
	final expectedDirectives:Array<TuiSmokeGitActionDirectiveExpectation>;
	final failureCode:String;
	final noGitMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noGithubCall:Bool;
	final noTerminalMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGitActionDirectiveAction {
	public final kind:TuiSmokeGitActionDirectiveActionKind;
	public final name:String;
	public final cwd:String;
	public final markdown:String;
	public final expectedVisibleMarkdown:String;
	public final expectedLastCreatedBranchCwd:String;
	public final expectedDirectives:Array<TuiSmokeGitActionDirectiveExpectation>;
	public final failureCode:String;
	public final noGitMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noGithubCall:Bool;
	public final noTerminalMutation:Bool;
	public final unsupportedRejected:Bool;
}
