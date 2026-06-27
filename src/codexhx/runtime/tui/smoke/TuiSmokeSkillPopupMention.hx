package codexhx.runtime.tui.smoke;

typedef TuiSmokeSkillPopupMentionFields = {
	final displayName:String;
	final description:String;
	final insertText:String;
	final searchTerms:Array<String>;
	final path:String;
	final categoryTag:String;
	final sortRank:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSkillPopupMention {
	public final displayName:String;
	public final description:String;
	public final insertText:String;
	public final searchTerms:Array<String>;
	public final path:String;
	public final categoryTag:String;
	public final sortRank:Int;
}
