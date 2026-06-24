package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmationKind;

typedef SurfaceRecoveryConfirmationReportFields = {
	final confirmationKind:SurfaceRecoveryConfirmationKind;
	final confirmationSummary:String;
	final recoveryConfirmed:Bool;
	final surfaceUpdateCount:Int;
	final recoveryFrameIndex:Int;
	final recoveredThreadId:String;
	final recoveredFooterLabel:String;
	final recoveredLoaderStatus:String;
	final pendingInteractiveSurfaceCleared:Bool;
	final sideParentSurfaceCleared:Bool;
	final activeThreadSurfaceReplaced:Bool;
	final staleSurfaceLoaderAbsent:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final recoveryPageDecoded:Bool;
	final recoverySelectionPreserved:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final frameRequests:Int;
	final renderCount:Int;
	final pageRequests:Int;
	final readRequests:Int;
	final finalSnapshot:String;
	final confirmationLogSummaries:Array<String>;
	final stateSummaries:Array<String>;
	final surfaceUpdateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class SurfaceRecoveryConfirmationReport {
	@:recordDefault(SurfaceRecoveryConfirmationKind.Unknown)
	public final confirmationKind:SurfaceRecoveryConfirmationKind;
	public final confirmationSummary:String;
	public final recoveryConfirmed:Bool;
	public final surfaceUpdateCount:Int;
	public final recoveryFrameIndex:Int;
	public final recoveredThreadId:String;
	public final recoveredFooterLabel:String;
	public final recoveredLoaderStatus:String;
	public final pendingInteractiveSurfaceCleared:Bool;
	public final sideParentSurfaceCleared:Bool;
	public final activeThreadSurfaceReplaced:Bool;
	public final staleSurfaceLoaderAbsent:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final recoveryPageDecoded:Bool;
	public final recoverySelectionPreserved:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final finalSnapshot:String;
	public final confirmationLogSummaries:Array<String>;
	public final stateSummaries:Array<String>;
	public final surfaceUpdateSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.boolValue("recoveryConfirmed", recoveryConfirmed),
			DiagnosticSummary.enumValue("confirmationKind", Std.string(confirmationKind)),
			DiagnosticSummary.intValue("surfaceUpdateCount", surfaceUpdateCount),
			DiagnosticSummary.intValue("recoveryFrameIndex", recoveryFrameIndex),
			DiagnosticSummary.text("thread", recoveredThreadId),
			DiagnosticSummary.text("footer", recoveredFooterLabel),
			DiagnosticSummary.text("loader", recoveredLoaderStatus),
			DiagnosticSummary.boolValue("pendingCleared", pendingInteractiveSurfaceCleared),
			DiagnosticSummary.boolValue("sideParentCleared", sideParentSurfaceCleared),
			DiagnosticSummary.boolValue("activeThreadReplaced", activeThreadSurfaceReplaced),
			DiagnosticSummary.boolValue("staleSurfaceLoaderAbsent", staleSurfaceLoaderAbsent),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("recoveryPageDecoded", recoveryPageDecoded),
			DiagnosticSummary.boolValue("selectionPreserved", recoverySelectionPreserved),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.intValue("pageRequests", pageRequests),
			DiagnosticSummary.intValue("readRequests", readRequests),
			DiagnosticSummary.nested("confirmation", confirmationSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("confirmationLog", confirmationLogSummaries),
			DiagnosticSummary.logList("states", stateSummaries),
			DiagnosticSummary.logList("surfaceUpdates", surfaceUpdateSummaries)
		]);
	}
}
