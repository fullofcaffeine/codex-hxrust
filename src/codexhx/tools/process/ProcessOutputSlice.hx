package codexhx.tools.process;

import codexhx.protocol.JsonScalar;

class ProcessOutputSlice {
	public final text:String;
	public final originalLength:Int;
	public final truncated:Bool;

	public function new(text:String, originalLength:Int, truncated:Bool) {
		this.text = text;
		this.originalLength = originalLength;
		this.truncated = truncated;
	}

	public static function fromText(text:String, limit:Int):ProcessOutputSlice {
		final safeLimit = limit < 0 ? 0 : limit;
		if (text.length > safeLimit) {
			return new ProcessOutputSlice(text.substr(0, safeLimit), text.length, true);
		}
		return new ProcessOutputSlice(text, text.length, false);
	}

	public function json():String {
		return "{"
			+ "\"text\":"
			+ JsonScalar.quote(text)
			+ ",\"originalLength\":"
			+ Std.string(originalLength)
			+ ",\"truncated\":"
			+ bool(truncated)
			+ "}";
	}

	static function bool(value:Bool):String {
		if (value)
			return "true";
		return "false";
	}
}
