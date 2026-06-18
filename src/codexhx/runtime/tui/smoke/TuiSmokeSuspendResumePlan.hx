package codexhx.runtime.tui.smoke;

typedef TuiSmokeSuspendResumePlanFields = {
	final action:TuiSmokeResumeActionKind;
	final altScreenActive:Bool;
	final cachedCursorY:Int;
	final cursorYAfterResume:Int;
	final savedViewportX:Int;
	final savedViewportY:Int;
	final savedViewportWidth:Int;
	final savedViewportHeight:Int;
	final appliedViewportX:Int;
	final appliedViewportY:Int;
	final appliedViewportWidth:Int;
	final appliedViewportHeight:Int;
	final enterAltScreen:Bool;
	final leaveAltScreen:Bool;
	final altScroll:Bool;
	final clearAfterRestore:Bool;
}

class TuiSmokeSuspendResumePlan {
	public final action:TuiSmokeResumeActionKind;
	public final altScreenActive:Bool;
	public final cachedCursorY:Int;
	public final cursorYAfterResume:Int;
	public final savedViewportX:Int;
	public final savedViewportY:Int;
	public final savedViewportWidth:Int;
	public final savedViewportHeight:Int;
	public final appliedViewportX:Int;
	public final appliedViewportY:Int;
	public final appliedViewportWidth:Int;
	public final appliedViewportHeight:Int;
	public final enterAltScreen:Bool;
	public final leaveAltScreen:Bool;
	public final altScroll:Bool;
	public final clearAfterRestore:Bool;

	public function new(fields:TuiSmokeSuspendResumePlanFields) {
		this.action = fields.action == null ? TuiSmokeResumeActionKind.Unknown : fields.action;
		this.altScreenActive = fields.altScreenActive;
		this.cachedCursorY = fields.cachedCursorY;
		this.cursorYAfterResume = fields.cursorYAfterResume;
		this.savedViewportX = fields.savedViewportX;
		this.savedViewportY = fields.savedViewportY;
		this.savedViewportWidth = fields.savedViewportWidth;
		this.savedViewportHeight = fields.savedViewportHeight;
		this.appliedViewportX = fields.appliedViewportX;
		this.appliedViewportY = fields.appliedViewportY;
		this.appliedViewportWidth = fields.appliedViewportWidth;
		this.appliedViewportHeight = fields.appliedViewportHeight;
		this.enterAltScreen = fields.enterAltScreen;
		this.leaveAltScreen = fields.leaveAltScreen;
		this.altScroll = fields.altScroll;
		this.clearAfterRestore = fields.clearAfterRestore;
	}

	public function enabled():Bool {
		return action != TuiSmokeResumeActionKind.None && action != TuiSmokeResumeActionKind.Unknown;
	}

	public function savedViewportText():String {
		return areaText(savedViewportX, savedViewportY, savedViewportWidth, savedViewportHeight);
	}

	public function appliedViewportText():String {
		return areaText(appliedViewportX, appliedViewportY, appliedViewportWidth, appliedViewportHeight);
	}

	static function areaText(x:Int, y:Int, width:Int, height:Int):String {
		return Std.string(x) + "," + Std.string(y) + "," + Std.string(width) + "x" + Std.string(height);
	}
}
