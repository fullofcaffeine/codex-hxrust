package codexhx.runtime.tui.smoke;

typedef TuiSmokeAltScreenActionFields = {
	final kind:TuiSmokeAltScreenActionKind;
	final enabled:Bool;
	final activeBefore:Bool;
	final activeAfter:Bool;
	final savedViewportPresentBefore:Bool;
	final savedViewportPresentAfter:Bool;
	final previousViewportX:Int;
	final previousViewportY:Int;
	final previousViewportWidth:Int;
	final previousViewportHeight:Int;
	final savedViewportX:Int;
	final savedViewportY:Int;
	final savedViewportWidth:Int;
	final savedViewportHeight:Int;
	final terminalWidth:Int;
	final terminalHeight:Int;
	final appliedViewportX:Int;
	final appliedViewportY:Int;
	final appliedViewportWidth:Int;
	final appliedViewportHeight:Int;
	final enterAlternateScreen:Bool;
	final leaveAlternateScreen:Bool;
	final enableAlternateScroll:Bool;
	final disableAlternateScroll:Bool;
	final clearTerminal:Bool;
	final clearAfterX:Int;
	final clearAfterY:Int;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAltScreenAction {
	public final kind:TuiSmokeAltScreenActionKind;
	public final enabled:Bool;
	public final activeBefore:Bool;
	public final activeAfter:Bool;
	public final savedViewportPresentBefore:Bool;
	public final savedViewportPresentAfter:Bool;
	public final previousViewportX:Int;
	public final previousViewportY:Int;
	public final previousViewportWidth:Int;
	public final previousViewportHeight:Int;
	public final savedViewportX:Int;
	public final savedViewportY:Int;
	public final savedViewportWidth:Int;
	public final savedViewportHeight:Int;
	public final terminalWidth:Int;
	public final terminalHeight:Int;
	public final appliedViewportX:Int;
	public final appliedViewportY:Int;
	public final appliedViewportWidth:Int;
	public final appliedViewportHeight:Int;
	public final enterAlternateScreen:Bool;
	public final leaveAlternateScreen:Bool;
	public final enableAlternateScroll:Bool;
	public final disableAlternateScroll:Bool;
	public final clearTerminal:Bool;
	public final clearAfterX:Int;
	public final clearAfterY:Int;
	public final failureCode:String;


	public function activeTransitionText():String {
		return activeBefore + "->" + activeAfter;
	}

	public function terminalSizeText():String {
		return terminalWidth + "x" + terminalHeight;
	}

	public function previousViewportText():String {
		return areaText(previousViewportX, previousViewportY, previousViewportWidth, previousViewportHeight);
	}

	public function savedViewportText():String {
		return areaText(savedViewportX, savedViewportY, savedViewportWidth, savedViewportHeight);
	}

	public function appliedViewportText():String {
		return areaText(appliedViewportX, appliedViewportY, appliedViewportWidth, appliedViewportHeight);
	}

	public function clearAfterText():String {
		return clearAfterX + "," + clearAfterY;
	}

	static function areaText(x:Int, y:Int, width:Int, height:Int):String {
		return x + "," + y + " " + width + "x" + height;
	}
}
