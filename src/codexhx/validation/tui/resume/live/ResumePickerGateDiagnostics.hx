package codexhx.validation.tui.resume.live;

import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.ResumePickerState;

class ResumePickerGateDiagnostics {
	public static function inlineErrorState(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.boolValue("errorShown", state.inlineErrorShown),
			DiagnosticSummary.text("failure", emptyLabel(state.lastFailureCode)),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
	}

	public static function runtimeClientOutcome(outcome:RuntimeClientOutcome):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("ok", outcome.ok),
			DiagnosticSummary.text("code", outcome.code),
			DiagnosticSummary.text("request", outcome.requestId),
			DiagnosticSummary.text("method", outcome.method),
			DiagnosticSummary.intValue("pending", outcome.pendingCount),
			DiagnosticSummary.text("message", outcome.message)
		]);
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}
}
