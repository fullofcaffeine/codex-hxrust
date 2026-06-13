package codexhx.runtime.tui.render;

class TuiGlyph {
    public final text:String;
    public final width:Int;
    public final whitespace:Bool;
    public final newline:Bool;

    public function new(text:String, width:Int, whitespace:Bool, newline:Bool) {
        this.text = text;
        this.width = width;
        this.whitespace = whitespace;
        this.newline = newline;
    }
}
