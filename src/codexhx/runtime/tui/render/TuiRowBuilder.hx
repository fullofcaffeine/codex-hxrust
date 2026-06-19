package codexhx.runtime.tui.render;

class TuiRowBuilder {
	final targetWidth:Int;
	final rows:Array<TuiRenderRow>;
	var currentText:String;
	var currentWidth:Int;

	public function new(targetWidth:Int) {
		this.targetWidth = targetWidth < 1 ? 1 : targetWidth;
		this.rows = [];
		this.currentText = "";
		this.currentWidth = 0;
	}

	public function pushFragment(fragment:String):Void {
		final clean = TuiAnsiSanitizer.strip(fragment);
		final glyphs = TuiGlyphScanner.scan(clean);
		var i = 0;
		while (i < glyphs.length) {
			final glyph = glyphs[i];
			if (glyph.newline) {
				finishRow();
				i = i + 1;
			} else if (glyph.whitespace) {
				appendSpace(glyph);
				i = i + 1;
			} else {
				final word:Array<TuiGlyph> = [];
				while (i < glyphs.length && !glyphs[i].newline && !glyphs[i].whitespace) {
					word.push(glyphs[i]);
					i = i + 1;
				}
				appendWord(word);
			}
		}
	}

	public function drainCommitReady(maxKeep:Int):Array<TuiRenderRow> {
		final committed:Array<TuiRenderRow> = [];
		while (rows.length > maxKeep) {
			committed.push(rows[0]);
			rows.splice(0, 1);
		}
		return committed;
	}

	public function committedRows():Array<TuiRenderRow> {
		final out:Array<TuiRenderRow> = [];
		for (row in rows)
			out.push(row);
		if (currentText.length > 0)
			out.push(new TuiRenderRow(currentText, currentWidth));
		return out;
	}

	function appendSpace(glyph:TuiGlyph):Void {
		if (currentWidth == 0)
			return;
		if (currentWidth + glyph.width > targetWidth) {
			finishRow();
			return;
		}
		currentText = currentText + glyph.text;
		currentWidth = currentWidth + glyph.width;
	}

	function appendWord(word:Array<TuiGlyph>):Void {
		final wordWidth = glyphsWidth(word);
		if (currentWidth > 0 && currentWidth + wordWidth > targetWidth) {
			finishRow();
		}
		if (wordWidth <= targetWidth) {
			appendGlyphs(word);
		} else {
			appendLongWord(word);
		}
	}

	function appendLongWord(word:Array<TuiGlyph>):Void {
		for (glyph in word) {
			if (currentWidth > 0 && currentWidth + glyph.width > targetWidth) {
				finishRow();
			}
			currentText = currentText + glyph.text;
			currentWidth = currentWidth + glyph.width;
		}
	}

	function appendGlyphs(glyphs:Array<TuiGlyph>):Void {
		for (glyph in glyphs) {
			currentText = currentText + glyph.text;
			currentWidth = currentWidth + glyph.width;
		}
	}

	function finishRow():Void {
		rows.push(new TuiRenderRow(currentText, currentWidth));
		currentText = "";
		currentWidth = 0;
	}

	static function glyphsWidth(glyphs:Array<TuiGlyph>):Int {
		var width = 0;
		for (glyph in glyphs) {
			width = width + glyph.width;
		}
		return width;
	}
}
