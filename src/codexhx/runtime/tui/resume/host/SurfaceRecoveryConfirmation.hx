package codexhx.runtime.tui.resume.host;

typedef SurfaceRecoveryConfirmationFields = {
	final kind:SurfaceRecoveryConfirmationKind;
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
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class SurfaceRecoveryConfirmation {
	@:recordDefault(SurfaceRecoveryConfirmationKind.Unknown)
	public final kind:SurfaceRecoveryConfirmationKind;
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
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";surfaceUpdateCount=" + surfaceUpdateCount + ";recoveryFrameIndex=" + recoveryFrameIndex + ";thread=" + recoveredThreadId
			+ ";footer=" + recoveredFooterLabel + ";loader=" + recoveredLoaderStatus + ";pendingCleared=" + boolLabel(pendingInteractiveSurfaceCleared)
			+ ";sideParentCleared=" + boolLabel(sideParentSurfaceCleared) + ";activeThreadReplaced=" + boolLabel(activeThreadSurfaceReplaced)
			+ ";staleSurfaceLoaderAbsent=" + boolLabel(staleSurfaceLoaderAbsent) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";recoveryPageDecoded=" + boolLabel(recoveryPageDecoded) + ";selectionPreserved=" + boolLabel(recoverySelectionPreserved)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
