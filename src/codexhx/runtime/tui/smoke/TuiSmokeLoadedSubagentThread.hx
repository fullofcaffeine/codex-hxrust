package codexhx.runtime.tui.smoke;

typedef TuiSmokeLoadedSubagentThreadFields = {
	final threadId:String;
	final agentNickname:String;
	final agentRole:String;
	final agentPath:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLoadedSubagentThread {
	public final threadId:String;
	public final agentNickname:String;
	public final agentRole:String;
	public final agentPath:String;

	public function summary():String {
		return threadId + ":" + agentNickname + ":" + agentRole + ":" + agentPath;
	}
}
