package codexhx.runtime.tui.terminal;

/**
	Terminal viewport dimensions in character cells.
**/
class TerminalSize {
	public final columns:Int;
	public final rows:Int;

	public function new(columns:Int, rows:Int) {
		this.columns = columns;
		this.rows = rows;
	}

	public static function of(columns:Int, rows:Int):TerminalSize {
		return new TerminalSize(columns, rows);
	}

	public function valid():Bool {
		return columns > 0 && rows > 0;
	}

	public function summary():String {
		return Std.string(columns) + "x" + Std.string(rows);
	}
}
