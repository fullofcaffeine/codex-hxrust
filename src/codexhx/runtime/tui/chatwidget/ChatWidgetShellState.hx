package codexhx.runtime.tui.chatwidget;

import codexhx.runtime.tui.terminal.TerminalComposerEffect;
import codexhx.runtime.tui.terminal.TerminalComposerState;
import codexhx.runtime.tui.terminal.TerminalInputEvent;

/**
	Production-shaped, minimal ChatWidget state for the first live shell.

	The full upstream widget owns many more surfaces. This state keeps only the
	parts needed to draw a credible shell and bridge typed input into transcript
	and submit effects without model, DB, or app-server authority.
**/
class ChatWidgetShellState {
	final rows:Array<ChatWidgetTranscriptRow>;
	final composerState:TerminalComposerState;
	var modelLabelValue:String;
	var statusKindValue:ChatWidgetStatusKind;
	var statusTextValue:String;
	var activeAgentLabelValue:String;
	var revisionValue:Int;

	public function new(modelLabel:String, statusKind:ChatWidgetStatusKind, statusText:String) {
		this.rows = [];
		this.composerState = new TerminalComposerState();
		this.modelLabelValue = normalizeLabel(modelLabel, "model pending");
		this.statusKindValue = statusKind;
		this.statusTextValue = normalizeLabel(statusText, "idle");
		this.activeAgentLabelValue = "";
		this.revisionValue = 0;
	}

	public static function initial(modelLabel:String):ChatWidgetShellState {
		return new ChatWidgetShellState(modelLabel, ChatWidgetStatusKind.Idle, "idle");
	}

	public function applyInput(input:TerminalInputEvent):Array<ChatWidgetShellEffect> {
		final effects:Array<ChatWidgetShellEffect> = [];
		final composerEffects = composerState.apply(input);
		for (effect in composerEffects) {
			switch effect {
				case TerminalComposerEffect.DrawRequested:
					effects.push(ChatWidgetShellEffect.DrawRequested);
				case TerminalComposerEffect.Submitted(text):
					if (text.length > 0) {
						rows.push(new ChatWidgetTranscriptRow(ChatWidgetTranscriptRole.User, text));
						effects.push(ChatWidgetShellEffect.PromptSubmitted(text));
					}
				case TerminalComposerEffect.ExitRequested(reason):
					effects.push(ChatWidgetShellEffect.ExitRequested(reason));
			}
		}
		if (effects.length > 0)
			revisionValue = revisionValue + 1;
		return effects;
	}

	public function appendTranscript(role:ChatWidgetTranscriptRole, text:String):Array<ChatWidgetShellEffect> {
		rows.push(new ChatWidgetTranscriptRow(role, text));
		revisionValue = revisionValue + 1;
		return [ChatWidgetShellEffect.DrawRequested];
	}

	public function setStatus(kind:ChatWidgetStatusKind, text:String):Array<ChatWidgetShellEffect> {
		statusKindValue = kind;
		statusTextValue = normalizeLabel(text, statusKindText(kind));
		revisionValue = revisionValue + 1;
		return [ChatWidgetShellEffect.DrawRequested];
	}

	public function setModelLabel(modelLabel:String):Array<ChatWidgetShellEffect> {
		modelLabelValue = normalizeLabel(modelLabel, "model pending");
		revisionValue = revisionValue + 1;
		return [ChatWidgetShellEffect.DrawRequested];
	}

	public function setActiveAgentLabel(label:String):Array<ChatWidgetShellEffect> {
		final normalized = label == null ? "" : label;
		if (activeAgentLabelValue == normalized)
			return [];
		activeAgentLabelValue = normalized;
		revisionValue = revisionValue + 1;
		return [ChatWidgetShellEffect.DrawRequested];
	}

	public function composer():TerminalComposerState {
		return composerState;
	}

	public function transcriptCount():Int {
		return rows.length;
	}

	public function transcriptAt(index:Int):ChatWidgetTranscriptRow {
		if (index < 0 || index >= rows.length)
			return new ChatWidgetTranscriptRow(ChatWidgetTranscriptRole.System, "");
		return rows[index];
	}

	public function modelLabel():String {
		return modelLabelValue;
	}

	public function statusKind():ChatWidgetStatusKind {
		return statusKindValue;
	}

	public function statusText():String {
		return statusTextValue;
	}

	public function activeAgentLabel():String {
		return activeAgentLabelValue;
	}

	public function revision():Int {
		return revisionValue;
	}

	public static function statusKindText(kind:ChatWidgetStatusKind):String {
		return switch kind {
			case Idle:
				"idle";
			case Working:
				"working";
			case Error:
				"error";
		}
	}

	static function normalizeLabel(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
