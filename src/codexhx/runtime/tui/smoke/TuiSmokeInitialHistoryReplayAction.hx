package codexhx.runtime.tui.smoke;

typedef TuiSmokeInitialHistoryReplayActionFields = {
	final kind:TuiSmokeInitialHistoryReplayActionKind;
	final label:String;
	final turnCount:Int;
	final overlayActive:Bool;
	final maxRows:Int;
	final renderFromTranscriptTail:Bool;
	final displayLines:Array<String>;
	final transcriptTailLines:Array<String>;
	final expectedRows:Array<String>;
	final expectedDeferred:Array<String>;
	final expectedInserted:Array<String>;
	final expectedBeginEmitted:Bool;
	final expectedEndEmitted:Bool;
	final failureCode:String;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final noFilesystemMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeInitialHistoryReplayAction {
	@:recordDefault(TuiSmokeInitialHistoryReplayActionKind.Unknown)
	public final kind:TuiSmokeInitialHistoryReplayActionKind;
	public final label:String;
	public final turnCount:Int;
	public final overlayActive:Bool;
	public final maxRows:Int;
	public final renderFromTranscriptTail:Bool;
	public final displayLines:Array<String>;
	public final transcriptTailLines:Array<String>;
	public final expectedRows:Array<String>;
	public final expectedDeferred:Array<String>;
	public final expectedInserted:Array<String>;
	public final expectedBeginEmitted:Bool;
	public final expectedEndEmitted:Bool;
	public final failureCode:String;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final noFilesystemMutation:Bool;
	public final unsupportedRejected:Bool;

	public function displaySummary():String {
		return linesSummary(displayLines);
	}

	public function expectedRowsSummary():String {
		return linesSummary(expectedRows);
	}

	public function expectedDeferredSummary():String {
		return linesSummary(expectedDeferred);
	}

	public function expectedInsertedSummary():String {
		return linesSummary(expectedInserted);
	}

	public static function linesSummary(lines:Array<String>):String {
		if (lines == null || lines.length == 0)
			return "-";
		return lines.join("|");
	}
}
