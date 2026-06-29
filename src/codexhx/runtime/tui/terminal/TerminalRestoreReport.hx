package codexhx.runtime.tui.terminal;

/**
	Report returned after restoring terminal state.
**/
class TerminalRestoreReport {
	public final restored:Bool;
	public final wasActive:Bool;
	public final reason:TerminalRestoreReason;
	public final restoreCount:Int;
	public final message:String;

	public function new(restored:Bool, wasActive:Bool, reason:TerminalRestoreReason, restoreCount:Int, message:String) {
		this.restored = restored;
		this.wasActive = wasActive;
		this.reason = reason;
		this.restoreCount = restoreCount;
		this.message = message;
	}
}
