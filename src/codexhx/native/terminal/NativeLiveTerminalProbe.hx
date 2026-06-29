package codexhx.native.terminal;

/**
	Why
	- TUI-LIVE-1 must pressure real Rust terminal ownership without allowing raw
	  Rust calls to leak into Codex runtime code.

	What
	- A narrow extern binding to `native/src/live_terminal_probe.rs`.
	- The Rust side owns crossterm raw mode, alternate screen, ratatui frame
	  drawing, key polling, and terminal restoration.

	How
	- `LiveTerminalBackend` wraps these scalar functions and converts them into
	  typed `TerminalBackend` operations plus `LiveTerminalProbeReport`.
	- CI usually has no TTY; in that case the native module returns a typed
	  skipped/no-TTY status instead of taking over a terminal or hanging.
**/
@:rustExtraSrc("native/src/live_terminal_probe.rs")
@:rustCargo({name: "crossterm", version: "0.27"})
@:rustCargo({name: "ratatui", version: "0.26"})
@:native("crate::live_terminal_probe")
extern class NativeLiveTerminalProbe {
	@:native("setup_live")
	public static function setupLive(columns:Int, rows:Int):Int;

	@:native("draw_live")
	public static function drawLive(title:String, body:String, cursorRow:Int, cursorColumn:Int):Int;

	@:native("poll_live")
	public static function pollLive(timeoutMs:Int):Int;

	@:native("request_exit")
	public static function requestExit(reason:Int):Int;

	@:native("restore_live")
	public static function restoreLive(reason:Int):Int;

	@:native("last_status")
	public static function lastStatus():Int;

	@:native("is_interactive")
	public static function isInteractive():Bool;

	@:native("is_active")
	public static function isActive():Bool;

	@:native("setup_was_attempted")
	public static function setupWasAttempted():Bool;

	@:native("draw_was_attempted")
	public static function drawWasAttempted():Bool;

	@:native("restore_was_attempted")
	public static function restoreWasAttempted():Bool;

	@:native("was_restored")
	public static function wasRestored():Bool;

	@:native("setup_count")
	public static function setupCount():Int;

	@:native("draw_count")
	public static function drawCount():Int;

	@:native("exit_count")
	public static function exitCount():Int;

	@:native("restore_count")
	public static function restoreCount():Int;

	@:native("last_exit_reason")
	public static function lastExitReason():Int;

	@:native("last_message")
	public static function lastMessage():String;
}
