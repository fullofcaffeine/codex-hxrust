package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadItemFields = {
	final kind:TuiSmokeThreadItemKind;
	final itemId:String;
	final text:String;
}

class TuiSmokeThreadItem {
	public final kind:TuiSmokeThreadItemKind;
	public final itemId:String;
	public final text:String;

	public function new(fields:TuiSmokeThreadItemFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadItemKind.Unknown : fields.kind;
		this.itemId = fields.itemId == null ? "" : fields.itemId;
		this.text = fields.text == null ? "" : fields.text;
	}

	public function transcriptSource():TuiSmokeTranscriptSource {
		return switch kind {
			case TuiSmokeThreadItemKind.UserMessage: TuiSmokeTranscriptSource.User;
			case TuiSmokeThreadItemKind.AgentMessage | TuiSmokeThreadItemKind.Reasoning: TuiSmokeTranscriptSource.Assistant;
			case TuiSmokeThreadItemKind.Tool: TuiSmokeTranscriptSource.Tool;
			case _: TuiSmokeTranscriptSource.Unknown;
		}
	}
}
