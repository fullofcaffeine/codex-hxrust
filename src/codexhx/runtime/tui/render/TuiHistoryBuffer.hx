package codexhx.runtime.tui.render;

class TuiHistoryBuffer {
    final width:Int;
    final rows:Array<TuiRenderRow>;
    var cursorX:Int;
    var cursorY:Int;

    public function new(width:Int) {
        this.width = width;
        this.rows = [];
        this.cursorX = 0;
        this.cursorY = 0;
    }

    public function insertHistoryLines(lines:Array<String>):Void {
        for (line in lines) {
            final builder = new TuiRowBuilder(width);
            builder.pushFragment(line);
            final built = builder.committedRows();
            for (row in built) {
                rows.push(row);
            }
        }
        cursorX = 0;
        cursorY = 0;
    }

    public function contents():String {
        final parts:Array<String> = [];
        for (row in rows) {
            parts.push(row.text);
        }
        return parts.join("\n");
    }

    public function countChar(ch:String):Int {
        var count = 0;
        for (row in rows) {
            var i = 0;
            while (i < row.text.length) {
                if (row.text.charAt(i) == ch) count = count + 1;
                i = i + 1;
            }
        }
        return count;
    }

    public function contains(value:String):Bool {
        return contents().indexOf(value) >= 0;
    }

    public function cursorSummary():String {
        return Std.string(cursorX) + "," + Std.string(cursorY);
    }
}
