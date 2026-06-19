package codexhx.runtime.tui.smoke;

typedef TuiSmokeResizeRepaintPlanFields = {
	final transcriptCellCount:Int;
	final reflowedRows:Int;
	final rowCap:Int;
	final pendingHistoryBatches:Int;
	final deferredHistoryRows:Int;
	final clearKind:TuiSmokeResizeClearKind;
	final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	final viewportReset:Bool;
	final needsFullRepaint:Bool;
	final emptyTranscript:Bool;
	final insertRows:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeResizeRepaintPlan {
	public final transcriptCellCount:Int;
	public final reflowedRows:Int;
	public final rowCap:Int;
	public final pendingHistoryBatches:Int;
	public final deferredHistoryRows:Int;
	public final clearKind:TuiSmokeResizeClearKind;
	public final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	public final viewportReset:Bool;
	public final needsFullRepaint:Bool;
	public final emptyTranscript:Bool;
	public final insertRows:Bool;

	public function rowCapText():String {
		return rowCap < 0 ? "none" : Std.string(rowCap);
	}
}
