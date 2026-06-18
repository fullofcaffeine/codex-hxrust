package codexhx.runtime.tui.smoke;

typedef TuiSmokeViewportResizePlanFields = {
	final requestedHeight:Int;
	final previousX:Int;
	final previousY:Int;
	final previousWidth:Int;
	final previousHeight:Int;
	final nextX:Int;
	final nextY:Int;
	final nextWidth:Int;
	final nextHeight:Int;
	final terminalHeightShrank:Bool;
	final terminalHeightGrew:Bool;
	final bottomAligned:Bool;
	final scrollBy:Int;
	final pendingHistoryBatches:Int;
	final pendingHistoryRows:Int;
	final zellijRaw:Bool;
	final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	final clearAfterY:Int;
	final needsFullRepaint:Bool;
}

class TuiSmokeViewportResizePlan {
	public final requestedHeight:Int;
	public final previousX:Int;
	public final previousY:Int;
	public final previousWidth:Int;
	public final previousHeight:Int;
	public final nextX:Int;
	public final nextY:Int;
	public final nextWidth:Int;
	public final nextHeight:Int;
	public final terminalHeightShrank:Bool;
	public final terminalHeightGrew:Bool;
	public final bottomAligned:Bool;
	public final scrollBy:Int;
	public final pendingHistoryBatches:Int;
	public final pendingHistoryRows:Int;
	public final zellijRaw:Bool;
	public final wrapPolicy:TuiSmokeHistoryWrapPolicy;
	public final clearAfterY:Int;
	public final needsFullRepaint:Bool;

	public function new(fields:TuiSmokeViewportResizePlanFields) {
		this.requestedHeight = fields.requestedHeight;
		this.previousX = fields.previousX;
		this.previousY = fields.previousY;
		this.previousWidth = fields.previousWidth;
		this.previousHeight = fields.previousHeight;
		this.nextX = fields.nextX;
		this.nextY = fields.nextY;
		this.nextWidth = fields.nextWidth;
		this.nextHeight = fields.nextHeight;
		this.terminalHeightShrank = fields.terminalHeightShrank;
		this.terminalHeightGrew = fields.terminalHeightGrew;
		this.bottomAligned = fields.bottomAligned;
		this.scrollBy = fields.scrollBy;
		this.pendingHistoryBatches = fields.pendingHistoryBatches;
		this.pendingHistoryRows = fields.pendingHistoryRows;
		this.zellijRaw = fields.zellijRaw;
		this.wrapPolicy = fields.wrapPolicy == null ? TuiSmokeHistoryWrapPolicy.Unknown : fields.wrapPolicy;
		this.clearAfterY = fields.clearAfterY;
		this.needsFullRepaint = fields.needsFullRepaint;
	}

	public function changed():Bool {
		return previousX != nextX || previousY != nextY || previousWidth != nextWidth || previousHeight != nextHeight;
	}

	public function previousAreaText():String {
		return areaText(previousX, previousY, previousWidth, previousHeight);
	}

	public function nextAreaText():String {
		return areaText(nextX, nextY, nextWidth, nextHeight);
	}

	public function insertMode():String {
		return zellijRaw && wrapPolicy == TuiSmokeHistoryWrapPolicy.Terminal ? "zellij_raw" : "standard";
	}

	static function areaText(x:Int, y:Int, width:Int, height:Int):String {
		return Std.string(x) + "," + Std.string(y) + "," + Std.string(width) + "x" + Std.string(height);
	}
}
