package codexhx.runtime.tui.smoke;

typedef TuiSmokeGitActionDirectivePlanFields = {
	final allowGitMutation:Bool;
	final allowFilesystemMutation:Bool;
	final allowNetwork:Bool;
	final allowGithubCall:Bool;
	final allowTerminalMutation:Bool;
	final actions:Array<TuiSmokeGitActionDirectiveAction>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGitActionDirectivePlan {
	public final allowGitMutation:Bool;
	public final allowFilesystemMutation:Bool;
	public final allowNetwork:Bool;
	public final allowGithubCall:Bool;
	public final allowTerminalMutation:Bool;
	public final actions:Array<TuiSmokeGitActionDirectiveAction>;

	public function enabled():Bool {
		return actions.length > 0;
	}
}
