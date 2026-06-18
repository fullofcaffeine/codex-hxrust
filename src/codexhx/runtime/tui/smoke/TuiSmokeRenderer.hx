package codexhx.runtime.tui.smoke;

import codexhx.runtime.tui.render.TuiRowBuilder;

class TuiSmokeRenderer {
	public static function renderFrame(request:TuiSmokeFrameRequest):String {
		final lines:Array<String> = [];
		lines.push(request.title);
		lines.push("status: " + request.status + " | model: " + request.model);
		for (row in request.transcript) {
			appendWrapped(lines, request.width, row.label() + "> " + row.text);
		}
		appendWrapped(lines, request.width, "input> " + request.input);
		return lines.join("\n");
	}

	static function appendWrapped(lines:Array<String>, width:Int, text:String):Void {
		final builder = new TuiRowBuilder(width);
		builder.pushFragment(text);
		for (row in builder.committedRows()) {
			lines.push(row.text);
		}
	}
}
