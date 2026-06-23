package codexhx.runtime.tui.resume.host;

import codexhx.runtime.model.streamitem.ModelPendingInteractivePromptKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveSideStatusKind;
import codexhx.runtime.model.streamitem.ModelTurnReplayKind;

class RefreshReplayDeliveryPlanner {
	final deliveries:Array<RefreshReplayDelivery>;
	final log:Array<String>;
	var nextDeliverySequence:Int;

	public function new() {
		this.deliveries = [];
		this.log = [];
		this.nextDeliverySequence = 1;
	}

	public function deliver(application:RefreshApplication):Array<RefreshReplayDelivery> {
		if (application == null || !application.mutationApplied) {
			final reason = application == null ? "missing_refresh_application" : "refresh_application_no_delivery";
			log.push("delivery-skip:" + reason + ";request=" + (application == null ? "" : application.requestId));
			return [];
		}

		final out = [
			delivery(application, RefreshReplayDeliveryKind.PendingInteractiveReplay, 1),
			delivery(application, RefreshReplayDeliveryKind.SideParentStatus, 2),
			delivery(application, RefreshReplayDeliveryKind.ActiveThreadStatus, 3)
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

	function delivery(application:RefreshApplication, kind:RefreshReplayDeliveryKind, groupIndex:Int):RefreshReplayDelivery {
		final sequence = nextDeliverySequence;
		nextDeliverySequence = nextDeliverySequence + 1;
		return new RefreshReplayDelivery({
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
			pendingInteractiveReplayDelivered: kind == RefreshReplayDeliveryKind.PendingInteractiveReplay,
			sideParentStatusDelivered: kind == RefreshReplayDeliveryKind.SideParentStatus,
			activeThreadStatusDelivered: kind == RefreshReplayDeliveryKind.ActiveThreadStatus,
			replayKindAttached: kind == RefreshReplayDeliveryKind.PendingInteractiveReplay,
			deliveryOrderPreserved: sequence == ((application.appliedIndex - 1) * 3) + groupIndex,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			reason: "refresh_replay_delivery_intent"
		});
	}

	static function promptKind(requestClass:PendingRequestClassKind):ModelPendingInteractivePromptKind {
		return switch requestClass {
			case PendingRequestClassKind.ExecApproval:
				ModelPendingInteractivePromptKind.ExecApproval;
			case PendingRequestClassKind.FileChangeApproval:
				ModelPendingInteractivePromptKind.PatchApproval;
			case PendingRequestClassKind.PermissionsApproval:
				ModelPendingInteractivePromptKind.RequestPermissions;
			case PendingRequestClassKind.UserInput:
				ModelPendingInteractivePromptKind.RequestUserInput;
			case PendingRequestClassKind.McpElicitation:
				ModelPendingInteractivePromptKind.Elicitation;
			case _:
				ModelPendingInteractivePromptKind.None;
		}
	}

	static function sideStatusKind(requestClass:PendingRequestClassKind):ModelPendingInteractiveSideStatusKind {
		if (requestClass == PendingRequestClassKind.UserInput)
			return ModelPendingInteractiveSideStatusKind.NeedsInput;
		if (promptKind(requestClass) != ModelPendingInteractivePromptKind.None)
			return ModelPendingInteractiveSideStatusKind.NeedsApproval;
		return ModelPendingInteractiveSideStatusKind.None;
	}
}
