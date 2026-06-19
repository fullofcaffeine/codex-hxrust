package codexhx.runtime.model.streamitem;

class ModelClearUiHeaderOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final activeShutdownRequestId:String;
	public final decisionKind:ModelClearUiHeaderDecisionKind;
	public final requestKind:ModelClearUiHeaderRequestKind;
	public final titleLine:String;
	public final modelLine:String;
	public final directoryLine:String;
	public final lineCount:Int;
	public final width:Int;
	public final version:String;
	public final headerRendered:Bool;
	public final clearPendingHistoryLines:Bool;
	public final visibleScreenCleared:Bool;
	public final scrollbackCleared:Bool;
	public final viewportAnchoredToTop:Bool;
	public final queuedHeaderInserted:Bool;
	public final hasEmittedHistoryLinesAfter:Bool;
	public final transcriptStateReset:Bool;
	public final staleNoticeSuppressed:Bool;
	public final staleTranscriptSuppressed:Bool;
	public final ctrlLReusedClearHeader:Bool;
	public final fastStatusShown:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, activeShutdownRequestId:String, decisionKind:ModelClearUiHeaderDecisionKind,
			requestKind:ModelClearUiHeaderRequestKind, titleLine:String, modelLine:String, directoryLine:String, lineCount:Int, width:Int, version:String,
			headerRendered:Bool, clearPendingHistoryLines:Bool, visibleScreenCleared:Bool, scrollbackCleared:Bool, viewportAnchoredToTop:Bool,
			queuedHeaderInserted:Bool, hasEmittedHistoryLinesAfter:Bool, transcriptStateReset:Bool, staleNoticeSuppressed:Bool,
			staleTranscriptSuppressed:Bool, ctrlLReusedClearHeader:Bool, fastStatusShown:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.activeShutdownRequestId = activeShutdownRequestId == null ? "" : activeShutdownRequestId;
		this.decisionKind = decisionKind == null ? ModelClearUiHeaderDecisionKind.RenderedFreshHeader : decisionKind;
		this.requestKind = requestKind == null ? ModelClearUiHeaderRequestKind.SlashClear : requestKind;
		this.titleLine = titleLine == null ? "" : titleLine;
		this.modelLine = modelLine == null ? "" : modelLine;
		this.directoryLine = directoryLine == null ? "" : directoryLine;
		this.lineCount = lineCount < 0 ? 0 : lineCount;
		this.width = width < 0 ? 0 : width;
		this.version = version == null ? "" : version;
		this.headerRendered = headerRendered;
		this.clearPendingHistoryLines = clearPendingHistoryLines;
		this.visibleScreenCleared = visibleScreenCleared;
		this.scrollbackCleared = scrollbackCleared;
		this.viewportAnchoredToTop = viewportAnchoredToTop;
		this.queuedHeaderInserted = queuedHeaderInserted;
		this.hasEmittedHistoryLinesAfter = hasEmittedHistoryLinesAfter;
		this.transcriptStateReset = transcriptStateReset;
		this.staleNoticeSuppressed = staleNoticeSuppressed;
		this.staleTranscriptSuppressed = staleTranscriptSuppressed;
		this.ctrlLReusedClearHeader = ctrlLReusedClearHeader;
		this.fastStatusShown = fastStatusShown;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";activeShutdownRequest=" + noneIfEmpty(activeShutdownRequestId)
			+ ";decisionKind=" + decisionKind + ";requestKind=" + requestKind + ";titleLine=" + noneIfEmpty(titleLine) + ";modelLine="
			+ noneIfEmpty(modelLine) + ";directoryLine=" + noneIfEmpty(directoryLine) + ";lineCount=" + lineCount + ";width=" + width + ";version="
			+ noneIfEmpty(version) + ";headerRendered=" + boolText(headerRendered) + ";clearPendingHistoryLines=" + boolText(clearPendingHistoryLines)
			+ ";visibleScreenCleared=" + boolText(visibleScreenCleared) + ";scrollbackCleared=" + boolText(scrollbackCleared) + ";viewportAnchoredToTop="
			+ boolText(viewportAnchoredToTop) + ";queuedHeaderInserted=" + boolText(queuedHeaderInserted) + ";hasEmittedHistoryLinesAfter="
			+ boolText(hasEmittedHistoryLinesAfter) + ";transcriptStateReset=" + boolText(transcriptStateReset) + ";staleNoticeSuppressed="
			+ boolText(staleNoticeSuppressed) + ";staleTranscriptSuppressed=" + boolText(staleTranscriptSuppressed) + ";ctrlLReusedClearHeader="
			+ boolText(ctrlLReusedClearHeader) + ";fastStatusShown=" + boolText(fastStatusShown) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
