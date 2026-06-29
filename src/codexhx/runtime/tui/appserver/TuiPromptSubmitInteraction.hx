package codexhx.runtime.tui.appserver;

import codexhx.runtime.tui.chatwidget.ChatWidgetShellEffect;

/**
	Combined outcome from composer input, prompt admission, event drain, and draw.
**/
class TuiPromptSubmitInteraction {
	final shellEffectsValue:Array<ChatWidgetShellEffect>;
	final submitResultValue:Null<TuiPromptSubmitResult>;
	final pumpOutcomeValue:TuiAppServerPumpOutcome;

	public function new(shellEffects:Array<ChatWidgetShellEffect>, submitResult:Null<TuiPromptSubmitResult>, pumpOutcome:TuiAppServerPumpOutcome) {
		this.shellEffectsValue = shellEffects == null ? [] : shellEffects;
		this.submitResultValue = submitResult;
		this.pumpOutcomeValue = pumpOutcome == null ? new TuiAppServerPumpOutcome() : pumpOutcome;
	}

	public function shellEffectCount():Int {
		return shellEffectsValue.length;
	}

	public function promptSubmittedCount():Int {
		var count = 0;
		for (effect in shellEffectsValue) {
			switch effect {
				case ChatWidgetShellEffect.PromptSubmitted(_):
					count = count + 1;
				case _:
			}
		}
		return count;
	}

	public function shellDrawRequestCount():Int {
		var count = 0;
		for (effect in shellEffectsValue) {
			switch effect {
				case ChatWidgetShellEffect.DrawRequested:
					count = count + 1;
				case _:
			}
		}
		return count;
	}

	public function hasSubmitResult():Bool {
		return submitResultValue != null;
	}

	public function submitAccepted():Bool {
		return submitResultValue != null && submitResultValue.acceptedPrompt();
	}

	public function submitStatusText():String {
		if (submitResultValue == null)
			return "none";
		return TuiPromptSubmitInteraction.statusText(submitResultValue.status());
	}

	public function submitRequestIdText():String {
		return submitResultValue == null ? "" : submitResultValue.requestIdText();
	}

	public function submitThreadIdText():String {
		return submitResultValue == null ? "" : submitResultValue.threadIdText();
	}

	public function submitPromptText():String {
		return submitResultValue == null ? "" : submitResultValue.promptText();
	}

	public function registeredPromptRequestCount():Int {
		return submitResultValue == null ? 0 : submitResultValue.registeredPromptRequestCount();
	}

	public function pumpOutcome():TuiAppServerPumpOutcome {
		return pumpOutcomeValue;
	}

	static function statusText(status:TuiPromptSubmitStatus):String {
		return switch status {
			case Accepted:
				"accepted";
			case EmptyPrompt:
				"empty-prompt";
			case MissingSession:
				"missing-session";
			case MissingThread:
				"missing-thread";
			case TransportRejected:
				"transport-rejected";
		}
	}
}
