package codexhx.runtime.tui.terminal;

/**
	Minimal frame payload passed from TUI state/render code to a terminal backend.
**/
class TerminalFrame {
	public final size:TerminalSize;
	public final title:String;

	final lines:Array<String>;

	public final cursorRow:Int;
	public final cursorColumn:Int;

	public function new(size:TerminalSize, title:String, lines:Array<String>, cursorRow:Int, cursorColumn:Int) {
		this.size = size;
		this.title = title;
		this.lines = lines == null ? [] : lines.copy();
		this.cursorRow = cursorRow;
		this.cursorColumn = cursorColumn;
	}

	public static function empty(size:TerminalSize):TerminalFrame {
		return new TerminalFrame(size, "", [], 0, 0);
	}

	public function lineCount():Int {
		return lines.length;
	}

	public function lineAt(index:Int):String {
		if (index < 0 || index >= lines.length)
			return "";
		return lines[index];
	}

	public function text():String {
		final out:Array<String> = [];
		if (title.length > 0)
			out.push(title);
		for (line in lines)
			out.push(line);
		return out.join("\n");
	}
}
