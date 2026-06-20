package codexhx.runtime.tui.resume.host;

import codexhx.runtime.model.streamitem.ModelPendingInteractivePromptKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveSideStatusKind;
import codexhx.runtime.model.streamitem.ModelTurnReplayKind;

typedef ResumePickerAppServerTypedResponseRefreshReplayDeliveryFields = {
	final kind:ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind;
	final requestClass:ResumePickerAppServerPendingRequestClassKind;
	final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	final requestId:String;
	final dispatchSequence:Int;
	final appliedIndex:Int;
	final deliverySequence:Int;
	final groupIndex:Int;
	final replayKind:ModelTurnReplayKind;
	final promptKind:ModelPendingInteractivePromptKind;
	final sideStatusKind:ModelPendingInteractiveSideStatusKind;
	final pendingInteractiveReplayDelivered:Bool;
	final sideParentStatusDelivered:Bool;
	final activeThreadStatusDelivered:Bool;
	final replayKindAttached:Bool;
	final deliveryOrderPreserved:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRefreshReplayDelivery {
	@:recordDefault(ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.Unknown)
	public final kind:ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind;
	@:recordDefault(ResumePickerAppServerPendingRequestClassKind.Unknown)
	public final requestClass:ResumePickerAppServerPendingRequestClassKind;
	@:recordDefault(ResumePickerAppServerTypedResponsePayloadKind.Unknown)
	public final payloadKind:ResumePickerAppServerTypedResponsePayloadKind;
	public final requestId:String;
	public final dispatchSequence:Int;
	public final appliedIndex:Int;
	public final deliverySequence:Int;
	public final groupIndex:Int;
	@:recordDefault(ModelTurnReplayKind.ThreadSnapshot)
	public final replayKind:ModelTurnReplayKind;
	@:recordDefault(ModelPendingInteractivePromptKind.None)
	public final promptKind:ModelPendingInteractivePromptKind;
	@:recordDefault(ModelPendingInteractiveSideStatusKind.None)
	public final sideStatusKind:ModelPendingInteractiveSideStatusKind;
	public final pendingInteractiveReplayDelivered:Bool;
	public final sideParentStatusDelivered:Bool;
	public final activeThreadStatusDelivered:Bool;
	public final replayKindAttached:Bool;
	public final deliveryOrderPreserved:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";payloadKind=" + payloadKind + ";request=" + requestId + ";dispatchSequence=" + dispatchSequence
			+ ";appliedIndex=" + appliedIndex + ";deliverySequence=" + deliverySequence + ";groupIndex=" + groupIndex + ";replayKind=" + replayKind
			+ ";promptKind=" + promptKind + ";sideStatusKind=" + sideStatusKind + ";pendingInteractiveReplay=" + boolLabel(pendingInteractiveReplayDelivered)
			+ ";sideParentStatus=" + boolLabel(sideParentStatusDelivered) + ";activeThreadStatus=" + boolLabel(activeThreadStatusDelivered)
			+ ";replayKindAttached=" + boolLabel(replayKindAttached) + ";deliveryOrderPreserved=" + boolLabel(deliveryOrderPreserved) + ";liveTransport="
			+ boolLabel(liveTransportAttempted) + ";suppressed=" + boolLabel(liveTransportSuppressed) + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
