package codexhx.runtime.tui.resume.host;

import codexhx.runtime.model.streamitem.ModelPendingInteractivePromptKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveSideStatusKind;
import codexhx.runtime.model.streamitem.ModelTurnReplayKind;

class DeterministicResumePickerAppServerTypedResponseRefreshReplayDeliveryPlanner {
	final deliveries:Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery>;
	final log:Array<String>;
	var nextDeliverySequence:Int;

	public function new() {
		this.deliveries = [];
		this.log = [];
		this.nextDeliverySequence = 1;
	}

	public function deliver(application:ResumePickerAppServerTypedResponseRefreshApplication):Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery> {
		if (application == null || !application.mutationApplied) {
			final reason = application == null ? "missing_refresh_application" : "refresh_application_no_delivery";
			log.push("delivery-skip:" + reason + ";request=" + (application == null ? "" : application.requestId));
			return [];
		}

		final out = [
			delivery(application, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.PendingInteractiveReplay, 1),
			delivery(application, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.SideParentStatus, 2),
			delivery(application, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.ActiveThreadStatus, 3)
		];
		for (intent in out) {
			deliveries.push(intent);
			log.push("delivery:" + intent.summary());
		}
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function deliverySummaries():Array<String> {
		final out:Array<String> = [];
		for (delivery in deliveries)
			out.push(delivery.summary());
		return out;
	}

	public function deliveryCount():Int {
		return deliveries.length;
	}

	function delivery(application:ResumePickerAppServerTypedResponseRefreshApplication, kind:ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind,
			groupIndex:Int):ResumePickerAppServerTypedResponseRefreshReplayDelivery {
		final sequence = nextDeliverySequence;
		nextDeliverySequence = nextDeliverySequence + 1;
		return new ResumePickerAppServerTypedResponseRefreshReplayDelivery({
			kind: kind,
			requestClass: application.requestClass,
			payloadKind: application.payloadKind,
			requestId: application.requestId,
			dispatchSequence: application.dispatchSequence,
			appliedIndex: application.appliedIndex,
			deliverySequence: sequence,
			groupIndex: groupIndex,
			replayKind: ModelTurnReplayKind.ThreadSnapshot,
			promptKind: promptKind(application.requestClass),
			sideStatusKind: sideStatusKind(application.requestClass),
			pendingInteractiveReplayDelivered: kind == ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.PendingInteractiveReplay,
			sideParentStatusDelivered: kind == ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.SideParentStatus,
			activeThreadStatusDelivered: kind == ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.ActiveThreadStatus,
			replayKindAttached: kind == ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.PendingInteractiveReplay,
			deliveryOrderPreserved: sequence == ((application.appliedIndex - 1) * 3) + groupIndex,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			reason: "refresh_replay_delivery_intent"
		});
	}

	static function promptKind(requestClass:ResumePickerAppServerPendingRequestClassKind):ModelPendingInteractivePromptKind {
		return switch requestClass {
			case ResumePickerAppServerPendingRequestClassKind.ExecApproval:
				ModelPendingInteractivePromptKind.ExecApproval;
			case ResumePickerAppServerPendingRequestClassKind.FileChangeApproval:
				ModelPendingInteractivePromptKind.PatchApproval;
			case ResumePickerAppServerPendingRequestClassKind.PermissionsApproval:
				ModelPendingInteractivePromptKind.RequestPermissions;
			case ResumePickerAppServerPendingRequestClassKind.UserInput:
				ModelPendingInteractivePromptKind.RequestUserInput;
			case ResumePickerAppServerPendingRequestClassKind.McpElicitation:
				ModelPendingInteractivePromptKind.Elicitation;
			case _:
				ModelPendingInteractivePromptKind.None;
		}
	}

	static function sideStatusKind(requestClass:ResumePickerAppServerPendingRequestClassKind):ModelPendingInteractiveSideStatusKind {
		if (requestClass == ResumePickerAppServerPendingRequestClassKind.UserInput)
			return ModelPendingInteractiveSideStatusKind.NeedsInput;
		if (promptKind(requestClass) != ModelPendingInteractivePromptKind.None)
			return ModelPendingInteractiveSideStatusKind.NeedsApproval;
		return ModelPendingInteractiveSideStatusKind.None;
	}
}
