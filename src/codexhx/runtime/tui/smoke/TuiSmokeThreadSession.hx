package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadSessionFields = {
	final threadId:String;
	final model:String;
	final title:String;
	final isSideThread:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadSession {
	public final threadId:String;
	public final model:String;
	public final title:String;
	public final isSideThread:Bool;

	public function displayFor(suppressReplayNotices:Bool):TuiSmokeThreadSessionDisplay {
		if (isSideThread) return TuiSmokeThreadSessionDisplay.SideConversation;
		return suppressReplayNotices ? TuiSmokeThreadSessionDisplay.Quiet : TuiSmokeThreadSessionDisplay.Normal;
	}
}
