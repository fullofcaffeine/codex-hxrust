package codexhx.runtime.tui.resume.host;

import codexhx.runtime.model.streamitem.ModelPendingInteractivePromptKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveSideStatusKind;
import codexhx.runtime.model.streamitem.ModelTurnReplayKind;

typedef ResumePickerAppServerTypedResponseReplaySurfaceUpdateFields = {
	final kind:ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind;
	final requestClass:ResumePickerAppServerPendingRequestClassKind;
	final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	final requestId:String;
	final deliverySequence:Int;
	final surfaceSequence:Int;
	final replayKind:ModelTurnReplayKind;
	final promptKind:ModelPendingInteractivePromptKind;
	final sideStatusKind:ModelPendingInteractiveSideStatusKind;
	final pendingInteractiveSurfaceUpdated:Bool;
	final sideParentSurfaceUpdated:Bool;
	final activeThreadSurfaceUpdated:Bool;
	final deliveryOrderPreserved:Bool;
	final surfaceOrderPreserved:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
	final surfaceLabel:String;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseReplaySurfaceUpdate {
	@:recordDefault(ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind;
	@:recordDefault(ResumePickerAppServerPendingRequestClassKind.Unknown)
	public final requestClass:ResumePickerAppServerPendingRequestClassKind;
	@:recordDefault(ResumePickerAppServerTypedResponsePayloadKind.Unknown)
	public final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	public final requestId:String;
	public final deliverySequence:Int;
	public final surfaceSequence:Int;
	@:recordDefault(ModelTurnReplayKind.ThreadSnapshot)
	public final replayKind:ModelTurnReplayKind;
	@:recordDefault(ModelPendingInteractivePromptKind.None)
	public final promptKind:ModelPendingInteractivePromptKind;
	@:recordDefault(ModelPendingInteractiveSideStatusKind.None)
	public final sideStatusKind:ModelPendingInteractiveSideStatusKind;
	public final pendingInteractiveSurfaceUpdated:Bool;
	public final sideParentSurfaceUpdated:Bool;
	public final activeThreadSurfaceUpdated:Bool;
	public final deliveryOrderPreserved:Bool;
	public final surfaceOrderPreserved:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;
	public final surfaceLabel:String;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";payloadKind=" + payloadKind + ";request=" + requestId + ";deliverySequence=" + deliverySequence
			+ ";surfaceSequence=" + surfaceSequence + ";replayKind=" + replayKind + ";promptKind=" + promptKind + ";sideStatusKind=" + sideStatusKind
			+ ";pendingInteractiveSurface=" + boolLabel(pendingInteractiveSurfaceUpdated) + ";sideParentSurface=" + boolLabel(sideParentSurfaceUpdated)
			+ ";activeThreadSurface=" + boolLabel(activeThreadSurfaceUpdated) + ";deliveryOrderPreserved=" + boolLabel(deliveryOrderPreserved)
			+ ";surfaceOrderPreserved=" + boolLabel(surfaceOrderPreserved) + ";liveTransport=" + boolLabel(liveTransportAttempted) + ";suppressed="
			+ boolLabel(liveTransportSuppressed) + ";label=" + surfaceLabel + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
