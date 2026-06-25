package codexhx.runtime.tui.smoke;

typedef TuiSmokeLoadedThreadFields = {
	final threadId:String;
	final validThreadId:Bool;
	final source:TuiSmokeLoadedThreadSourceKind;
	final parentThreadId:String;
	final agentNickname:String;
	final agentRole:String;
	final agentPath:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLoadedThread {
	public final threadId:String;
	public final validThreadId:Bool;
	@:recordDefault(TuiSmokeLoadedThreadSourceKind.Unknown)
	public final source:TuiSmokeLoadedThreadSourceKind;
	public final parentThreadId:String;
	public final agentNickname:String;
	public final agentRole:String;
	public final agentPath:String;
}
