package codexhx.validation.tui.resume.live;

import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmation;
import codexhx.runtime.tui.resume.host.SurfaceRecoveryConfirmationKind;

class SurfaceRecoveryConfirmer {
	final log:Array<String>;

	public function new() {
		this.log = [];
	}

	public function confirm(report:ReplaySurfaceUpdateReport):SurfaceRecoveryConfirmation {
		final recoveryState = lastStateSummary(report.stateSummaries);
		final recoveredThreadId = fieldValue(recoveryState, "thread");
		final recoveredFooterLabel = fieldValue(recoveryState, "footer");
		final recoveredLoaderStatus = fieldValue(recoveryState, "loader");
		final confirmation = new SurfaceRecoveryConfirmation({
			kind: confirmationKind(report, recoveryState),
			surfaceUpdateCount: report.surfaceUpdateCount,
			recoveryFrameIndex: report.renderSnapshots.length - 1,
			recoveredThreadId: recoveredThreadId,
			recoveredFooterLabel: recoveredFooterLabel,
			recoveredLoaderStatus: recoveredLoaderStatus,
			pendingInteractiveSurfaceCleared: surfaceCleared(report.finalSnapshot, "typed_response_replay_surface_pending_interactive_prompt",
				"pending interactive "),
			sideParentSurfaceCleared: surfaceCleared(report.finalSnapshot, "typed_response_replay_surface_side_parent_status", "side parent "),
			activeThreadSurfaceReplaced: surfaceCleared(report.finalSnapshot, "typed_response_replay_surface_active_thread_status",
				"active thread status refreshed"),
			staleSurfaceLoaderAbsent: staleSurfaceLoaderAbsent(report.finalSnapshot),
			ignoredNoSurfaceRecordsAbsent: report.ignoredApplicationsAbsentFromSurfaces
			&& countContains(report.plannerLogSummaries, "delivery-skip:refresh_application_no_delivery") == 3
			&& !contains(report.finalSnapshot, "typed-surface-dynamic-6")
			&& !contains(report.finalSnapshot, "missing_pending_noop"),
			recoveryPageDecoded: report.recoveryDecoded
			&& contains(report.finalSnapshot, "typed_response_replay_surface_recovery_page_decoded"),
			recoverySelectionPreserved: recoveredThreadId == "thread-surface-a"
			&& contains(report.finalSnapshot, "selectedThread=thread-surface-a"),
			noPressureDropRejection: report.noPressureDropRejection,
			liveTransportSuppressed: report.liveTransportSuppressed,
			stateDbUntouched: report.stateDbUntouched,
			reason: confirmationReason(report, recoveryState)
		});
		log.push("confirmation:" + confirmation.summary());
		return confirmation;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	static function confirmationKind(report:ReplaySurfaceUpdateReport, recoveryState:String):SurfaceRecoveryConfirmationKind {
		if (report.surfaceUpdateCount == 15
			&& report.recoveryDecoded
			&& report.ignoredApplicationsAbsentFromSurfaces
			&& report.noPressureDropRejection
			&& report.liveTransportSuppressed
			&& report.stateDbUntouched
			&& contains(report.finalSnapshot, "typed_response_replay_surface_recovery_page_decoded")
			&& contains(recoveryState, "thread=thread-surface-a")
			&& contains(recoveryState, "footer=typed surface recovered")
			&& staleSurfaceLoaderAbsent(report.finalSnapshot))
			return SurfaceRecoveryConfirmationKind.RecoveryConfirmed;
		return SurfaceRecoveryConfirmationKind.RecoveryRejected;
	}

	static function confirmationReason(report:ReplaySurfaceUpdateReport, recoveryState:String):String {
		return confirmationKind(report,
			recoveryState) == SurfaceRecoveryConfirmationKind.RecoveryConfirmed ? "recovery_page_replaced_transient_response_surfaces" : "recovery_surface_policy_failed";
	}

	static function surfaceCleared(snapshot:String, loader:String, label:String):Bool {
		return !contains(snapshot, loader) && !contains(snapshot, label);
	}

	static function staleSurfaceLoaderAbsent(snapshot:String):Bool {
		return !contains(snapshot, "typed_response_replay_surface_pending_interactive_prompt")
			&& !contains(snapshot, "typed_response_replay_surface_side_parent_status")
			&& !contains(snapshot, "typed_response_replay_surface_active_thread_status");
	}

	static function lastStateSummary(states:Array<String>):String {
		return states.length == 0 ? "" : states[states.length - 1];
	}

	static function fieldValue(summary:String, name:String):String {
		final prefix = name + "=";
		final start = summary.indexOf(prefix);
		if (start < 0)
			return "";
		final valueStart = start + prefix.length;
		final end = summary.indexOf(";", valueStart);
		return end < 0 ? summary.substr(valueStart) : summary.substr(valueStart, end - valueStart);
	}

	static function countContains(values:Array<String>, needle:String):Int {
		var count = 0;
		for (value in values)
			if (contains(value, needle))
				count = count + 1;
		return count;
	}

	static function contains(value:String, needle:String):Bool {
		return value.indexOf(needle) >= 0;
	}
}
