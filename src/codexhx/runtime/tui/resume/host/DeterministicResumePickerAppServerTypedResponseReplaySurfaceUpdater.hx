package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerAppServerTypedResponseReplaySurfaceUpdater {
	final updates:Array<ResumePickerAppServerTypedResponseReplaySurfaceUpdate>;
	final log:Array<String>;
	var nextSurfaceSequence:Int;

	public function new() {
		this.updates = [];
		this.log = [];
		this.nextSurfaceSequence = 1;
	}

	public function apply(delivery:ResumePickerAppServerTypedResponseRefreshReplayDelivery):ResumePickerAppServerTypedResponseReplaySurfaceUpdate {
		if (delivery == null) {
			log.push("surface-skip:missing_delivery");
			return null;
		}
		final update = updateFor(delivery);
		if (update.kind == ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.Unknown) {
			log.push("surface-skip:unsupported_delivery;request=" + delivery.requestId);
			return update;
		}
		updates.push(update);
		log.push("surface:" + update.summary());
		nextSurfaceSequence = nextSurfaceSequence + 1;
		return update;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function updateSummaries():Array<String> {
		final out:Array<String> = [];
		for (update in updates)
			out.push(update.summary());
		return out;
	}

	public function updateCount():Int {
		return updates.length;
	}

	function updateFor(delivery:ResumePickerAppServerTypedResponseRefreshReplayDelivery):ResumePickerAppServerTypedResponseReplaySurfaceUpdate {
		final kind = surfaceKind(delivery);
		return new ResumePickerAppServerTypedResponseReplaySurfaceUpdate({
			kind: kind,
			requestClass: delivery.requestClass,
			payloadKind: delivery.payloadKind,
			requestId: delivery.requestId,
			deliverySequence: delivery.deliverySequence,
			surfaceSequence: nextSurfaceSequence,
			replayKind: delivery.replayKind,
			promptKind: delivery.promptKind,
			sideStatusKind: delivery.sideStatusKind,
			pendingInteractiveSurfaceUpdated: kind == ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.PendingInteractivePrompt,
			sideParentSurfaceUpdated: kind == ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.SideParentStatus,
			activeThreadSurfaceUpdated: kind == ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.ActiveThreadStatus,
			deliveryOrderPreserved: delivery.deliveryOrderPreserved,
			surfaceOrderPreserved: nextSurfaceSequence == delivery.deliverySequence,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			surfaceLabel: surfaceLabel(kind, delivery),
			reason: "replay_surface_updated"
		});
	}

	static function surfaceKind(delivery:ResumePickerAppServerTypedResponseRefreshReplayDelivery):ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind {
		return switch delivery.kind {
			case ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.PendingInteractiveReplay:
				ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.PendingInteractivePrompt;
			case ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.SideParentStatus:
				ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.SideParentStatus;
			case ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.ActiveThreadStatus:
				ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.ActiveThreadStatus;
			case _:
				ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.Unknown;
		}
	}

	static function surfaceLabel(kind:ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind,
			delivery:ResumePickerAppServerTypedResponseRefreshReplayDelivery):String {
		return switch kind {
			case ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.PendingInteractivePrompt:
				"pending interactive " + delivery.promptKind;
			case ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.SideParentStatus:
				"side parent " + delivery.sideStatusKind;
			case ResumePickerAppServerTypedResponseReplaySurfaceUpdateKind.ActiveThreadStatus:
				"active thread status refreshed";
			case _:
				"unknown";
		}
	}
}
