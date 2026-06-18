package codexhx.runtime.tui.smoke;

typedef TuiSmokeReplayBufferPlanFields = {
	final kind:TuiSmokeReplayBufferKind;
	final terminalWidth:Int;
	final terminalHeight:Int;
	final previousWidth:Int;
	final previousHeight:Int;
	final maxRows:Int;
	final retainedRows:Int;
	final renderFromTranscriptTail:Bool;
	final flushAfterReplay:Bool;
	final reflowAfterFlush:Bool;
}

class TuiSmokeReplayBufferPlan {
	public final kind:TuiSmokeReplayBufferKind;
	public final terminalWidth:Int;
	public final terminalHeight:Int;
	public final previousWidth:Int;
	public final previousHeight:Int;
	public final maxRows:Int;
	public final retainedRows:Int;
	public final renderFromTranscriptTail:Bool;
	public final flushAfterReplay:Bool;
	public final reflowAfterFlush:Bool;

	public function new(fields:TuiSmokeReplayBufferPlanFields) {
		this.kind = fields.kind == null ? TuiSmokeReplayBufferKind.Unknown : fields.kind;
		this.terminalWidth = fields.terminalWidth;
		this.terminalHeight = fields.terminalHeight;
		this.previousWidth = fields.previousWidth;
		this.previousHeight = fields.previousHeight;
		this.maxRows = fields.maxRows;
		this.retainedRows = fields.retainedRows;
		this.renderFromTranscriptTail = fields.renderFromTranscriptTail;
		this.flushAfterReplay = fields.flushAfterReplay;
		this.reflowAfterFlush = fields.reflowAfterFlush;
	}

	public function enabled():Bool {
		return kind != TuiSmokeReplayBufferKind.None && kind != TuiSmokeReplayBufferKind.Unknown;
	}

	public function sizeText():String {
		if (terminalWidth <= 0 || terminalHeight <= 0) return "unknown";
		return Std.string(terminalWidth) + "x" + Std.string(terminalHeight);
	}

	public function previousSizeText():String {
		if (previousWidth <= 0 || previousHeight <= 0) return "unknown";
		return Std.string(previousWidth) + "x" + Std.string(previousHeight);
	}

	public function maxRowsText():String {
		return maxRows < 0 ? "none" : Std.string(maxRows);
	}

	public function targetWidthText():String {
		return terminalWidth <= 0 ? "none" : Std.string(terminalWidth);
	}

	public function heightChanged():Bool {
		return previousHeight > 0 && terminalHeight > 0 && previousHeight != terminalHeight;
	}

	public function widthChanged():Bool {
		return previousWidth > 0 && terminalWidth > 0 && previousWidth != terminalWidth;
	}

	public function shouldScheduleReflow():Bool {
		return enabled() && (reflowAfterFlush || widthChanged() || heightChanged());
	}
}
