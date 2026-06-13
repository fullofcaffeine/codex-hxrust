package codexhx.runtime.tui.render;

class TuiGlyphScanner {
    public static function scan(input:String):Array<TuiGlyph> {
        final glyphs:Array<TuiGlyph> = [];
        var i = 0;
        while (i < input.length) {
            final ch = input.charAt(i);
            if (ch == "\n") {
                glyphs.push(new TuiGlyph("\n", 0, true, true));
                i = i + 1;
            } else if (ch == "\r") {
                i = i + 1;
            } else {
                glyphs.push(new TuiGlyph(ch, charWidth(ch), isWhitespace(ch), false));
                i = i + 1;
            }
        }
        return glyphs;
    }

    public static function textWidth(input:String):Int {
        var width = 0;
        for (glyph in scan(input)) {
            width = width + glyph.width;
        }
        return width;
    }

    static function charWidth(ch:String):Int {
        return switch ch {
            case "😀" | "你" | "好" | "世" | "界": 2;
            case _: 1;
        }
    }

    static function isWhitespace(ch:String):Bool {
        return ch == " " || ch == "\t";
    }
}
