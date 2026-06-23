package codexhx.runtime.tui.resume.host;

class ReplaySurfaceUpdater {
	final updates:Array<ReplaySurfaceUpdate>;
	final log:Array<String>;
	var nextSurfaceSequence:Int;

	public function new() {
		this.updates = [];
		this.log = [];
		this.nextSurfaceSequence = 1;
	}

	public function apply(delivery:RefreshReplayDelivery):ReplaySurfaceUpdate {
		if (delivery == null) {
			log.push("surface-skip:missing_delivery");
			return null;
		}
		final update = updateFor(delivery);
		if (update.kind == ReplaySurfaceUpdateKind.Unknown) {
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

	function updateFor(delivery:RefreshReplayDelivery):ReplaySurfaceUpdate {
		final kind = surfaceKind(delivery);
		return new ReplaySurfaceUpdate({
			kind: kind,
			requestClass: delivery.requestClass,
			payloadKind: delivery.payloadKind,
			requestId: delivery.requestId,
			deliverySequence: delivery.deliverySequence,
			surfaceSequence: nextSurfaceSequence,
			replayKind: delivery.replayKind,
			promptKind: delivery.promptKind,
			sideStatusKind: delivery.sideStatusKind,
			pendingInteractiveSurfaceUpdated: kind == ReplaySurfaceUpdateKind.PendingInteractivePrompt,
			sideParentSurfaceUpdated: kind == ReplaySurfaceUpdateKind.SideParentStatus,
			activeThreadSurfaceUpdated: kind == ReplaySurfaceUpdateKind.ActiveThreadStatus,
			deliveryOrderPreserved: delivery.deliveryOrderPreserved,
			surfaceOrderPreserved: nextSurfaceSequence == delivery.deliverySequence,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			surfaceLabel: surfaceLabel(kind, delivery),
			reason: "replay_surface_updated"
		});
	}

	static function surfaceKind(delivery:RefreshReplayDelivery):ReplaySurfaceUpdateKind {
		return switch delivery.kind {
			case RefreshReplayDeliveryKind.PendingInteractiveReplay:
				ReplaySurfaceUpdateKind.PendingInteractivePrompt;
			case RefreshReplayDeliveryKind.SideParentStatus:
				ReplaySurfaceUpdateKind.SideParentStatus;
			case RefreshReplayDeliveryKind.ActiveThreadStatus:
				ReplaySurfaceUpdateKind.ActiveThreadStatus;
			case _:
				ReplaySurfaceUpdateKind.Unknown;
		}
	}

	static function surfaceLabel(kind:ReplaySurfaceUpdateKind, delivery:RefreshReplayDelivery):String {
		return switch kind {
			case ReplaySurfaceUpdateKind.PendingInteractivePrompt:
				"pending interactive " + delivery.promptKind;
			case ReplaySurfaceUpdateKind.SideParentStatus:
				"side parent " + delivery.sideStatusKind;
			case ReplaySurfaceUpdateKind.ActiveThreadStatus:
				"active thread status refreshed";
			case _:
				"unknown";
		}
	}
}
