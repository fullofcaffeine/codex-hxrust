package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadItemFields = {
	final kind:TuiSmokeThreadItemKind;
	final itemId:String;
	final text:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadItem {
	public final kind:TuiSmokeThreadItemKind;
	public final itemId:String;
	public final text:String;

	public function transcriptSource():TuiSmokeTranscriptSource {
		return switch kind {
			case TuiSmokeThreadItemKind.UserMessage: TuiSmokeTranscriptSource.User;
			case TuiSmokeThreadItemKind.AgentMessage | TuiSmokeThreadItemKind.Reasoning: TuiSmokeTranscriptSource.Assistant;
			case TuiSmokeThreadItemKind.Tool: TuiSmokeTranscriptSource.Tool;
			case _: TuiSmokeTranscriptSource.Unknown;
		}
	}
}
