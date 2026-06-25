package codexhx.runtime.tui.smoke;

typedef TuiSmokeAgentStatusActionFields = {
	final kind:TuiSmokeAgentStatusActionKind;
	final itemKind:TuiSmokeAgentStatusItemKind;
	final agentPath:String;
	final itemId:String;
	final rawText:String;
	final summary:String;
	final displayText:String;
	final server:String;
	final namespace:String;
	final tool:String;
	final collabTool:String;
	final subAgentActivity:String;
	final fileChangeCount:Int;
	final accepted:Bool;
	final duplicate:Bool;
	final rawReasoningHidden:Bool;
	final aggregatedOutputHidden:Bool;
	final whitespaceCollapsed:Bool;
	final emptyState:Bool;
	final previewLineCount:Int;
	final previewItemCount:Int;
	final maxPreviewLines:Int;
	final maxPreviewItems:Int;
	final maxGraphemes:Int;
	final failureCode:String;
	final noModelCall:Bool;
	final noAppServerMutation:Bool;
	final noFilesystemMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeAgentStatusAction {
	@:recordDefault(TuiSmokeAgentStatusActionKind.Unknown)
	public final kind:TuiSmokeAgentStatusActionKind;
	@:recordDefault(TuiSmokeAgentStatusItemKind.Unknown)
	public final itemKind:TuiSmokeAgentStatusItemKind;
	public final agentPath:String;
	public final itemId:String;
	public final rawText:String;
	public final summary:String;
	public final displayText:String;
	public final server:String;
	public final namespace:String;
	public final tool:String;
	public final collabTool:String;
	public final subAgentActivity:String;
	public final fileChangeCount:Int;
	public final accepted:Bool;
	public final duplicate:Bool;
	public final rawReasoningHidden:Bool;
	public final aggregatedOutputHidden:Bool;
	public final whitespaceCollapsed:Bool;
	public final emptyState:Bool;
	public final previewLineCount:Int;
	public final previewItemCount:Int;
	public final maxPreviewLines:Int;
	public final maxPreviewItems:Int;
	public final maxGraphemes:Int;
	public final failureCode:String;
	public final noModelCall:Bool;
	public final noAppServerMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final unsupportedRejected:Bool;

	public function computedDisplayText():String {
		return switch itemKind {
			case TuiSmokeAgentStatusItemKind.AgentMessage | TuiSmokeAgentStatusItemKind.Plan:
				boundedSummary(rawText, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.Reasoning:
				boundedSummary(summary, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.CommandExecution:
				boundedSummary("$ " + truncate(rawText, maxGraphemes - 2), maxGraphemes);
			case TuiSmokeAgentStatusItemKind.FileChange:
				"Updated " + fileChangeCount + " file(s)";
			case TuiSmokeAgentStatusItemKind.McpToolCall:
				boundedSummary("MCP " + server + "/" + tool, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.DynamicToolCall:
				final toolName = namespace == "" ? tool : namespace + "/" + tool;
				boundedSummary("Tool " + toolName, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.CollabAgentToolCall:
				collabSummary();
			case TuiSmokeAgentStatusItemKind.SubAgentActivity:
				boundedSummary(subAgentActivitySummary() + " " + agentPath, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.WebSearch:
				boundedSummary("Web search: " + rawText, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.ImageView:
				boundedSummary("Viewed " + rawText, maxGraphemes);
			case TuiSmokeAgentStatusItemKind.ImageGeneration:
				"Generated an image";
			case TuiSmokeAgentStatusItemKind.EnteredReviewMode:
				"Entered review mode";
			case TuiSmokeAgentStatusItemKind.ExitedReviewMode:
				"Exited review mode";
			case TuiSmokeAgentStatusItemKind.ContextCompaction:
				"Compacted context";
			case _:
				"";
		}
	}

	public function displayMatches():Bool {
		return displayText == "" || displayText == computedDisplayText();
	}

	static function boundedSummary(value:String, maxChars:Int):String {
		return collapseWhitespace(truncate(value, maxChars));
	}

	static function truncate(value:String, maxChars:Int):String {
		if (maxChars < 0)
			return "";
		if (value.length <= maxChars)
			return value;
		return value.substr(0, maxChars);
	}

	static function collapseWhitespace(value:String):String {
		var out = "";
		var inWhitespace = false;
		for (i in 0...value.length) {
			final ch = value.charAt(i);
			final whitespace = ch == " " || ch == "\n" || ch == "\r" || ch == "\t";
			if (whitespace) {
				inWhitespace = true;
			} else {
				if (inWhitespace && out != "")
					out += " ";
				out += ch;
				inWhitespace = false;
			}
		}
		return out;
	}

	function collabSummary():String {
		return switch collabTool {
			case "spawn_agent": "Spawned an agent";
			case "send_input": "Sent input to an agent";
			case "resume_agent": "Resumed an agent";
			case "wait": "Waited for an agent";
			case "close_agent": "Closed an agent";
			case _: "";
		}
	}

	function subAgentActivitySummary():String {
		return switch subAgentActivity {
			case "started": "Started";
			case "interacted": "Contacted";
			case "interrupted": "Interrupted";
			case _: "";
		}
	}
}
