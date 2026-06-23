package codexhx.runtime.tui.resume.live;

typedef ToolbarFooterReportFields = {
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ToolbarFooterReport {
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;

	public function summary():String {
		return "frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n");
	}
}
