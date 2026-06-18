package codexhx.runtime.tui.smoke;

typedef TuiSmokeTranscriptRowFields = {
	final source:TuiSmokeTranscriptSource;
	final text:String;
}

class TuiSmokeTranscriptRow {
	public final source:TuiSmokeTranscriptSource;
	public final text:String;

	public function new(fields:TuiSmokeTranscriptRowFields) {
		this.source = fields.source == null ? TuiSmokeTranscriptSource.Unknown : fields.source;
		this.text = fields.text == null ? "" : fields.text;
	}

	public function label():String {
		return switch source {
			case TuiSmokeTranscriptSource.System: "system";
			case TuiSmokeTranscriptSource.User: "user";
			case TuiSmokeTranscriptSource.Assistant: "assistant";
			case TuiSmokeTranscriptSource.Tool: "tool";
			case _: "unknown";
		}
	}
}
