package codexhx.runtime.tui.smoke;

typedef TuiSmokeTranscriptRowFields = {
	final source:TuiSmokeTranscriptSource;
	final text:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTranscriptRow {
	public final source:TuiSmokeTranscriptSource;
	public final text:String;

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
