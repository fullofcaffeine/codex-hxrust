package codexhx.runtime.tui.smoke;

typedef TuiSmokeGitActionDirectiveExpectationFields = {
	final kind:String;
	final cwd:String;
	final branch:String;
	final url:String;
	final isDraft:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeGitActionDirectiveExpectation {
	public final kind:String;
	public final cwd:String;
	public final branch:String;
	public final url:String;
	public final isDraft:Bool;
}
