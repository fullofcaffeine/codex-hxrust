package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.RecoveryKeyboardIntentKind;

class ReplayAwareKeyboardReadinessGate {
	public static function run():ReplayAwareKeyboardReadinessReport {
		final handoffReport = PostRenderStateHandoffGate.run();
		final policy = new ReplayAwareKeyboardReadinessPolicy();
		final readiness = policy.admit(handoffReport, [RecoveryKeyboardIntentKind.MoveDown, RecoveryKeyboardIntentKind.MoveUp]);
		return new ReplayAwareKeyboardReadinessReport({
			readinessKind: readiness.kind,
			readinessSummary: readiness.summary(),
			decisionCount: readiness.decisionCount,
			admittedCount: readiness.admittedCount,
			postRenderIdleListReady: readiness.postRenderIdleListReady,
			keyboardInputReady: readiness.keyboardInputReady,
			listNavigationReady: readiness.listNavigationReady,
			recoveredSelectionStableUntilNavigation: readiness.recoveredSelectionStableUntilNavigation,
			navigationApplied: readiness.navigationApplied,
			returnedToRecoveredSelection: readiness.returnedToRecoveredSelection,
			noLeftoverScheduledRenderRequest: readiness.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: readiness.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: readiness.consumedScheduledRequestCount,
			renderCount: readiness.renderCount,
			renderedSnapshotPreserved: readiness.renderedSnapshotPreserved,
			finalThreadId: readiness.finalThreadId,
			finalFooter: readiness.finalFooter,
			finalSelectionPreserved: readiness.finalSelectionPreserved,
			finalFooterPreserved: readiness.finalFooterPreserved,
			inputAdmitted: readiness.inputAdmitted,
			localOnlyRenderIntent: readiness.localOnlyRenderIntent,
			replayCount: readiness.replayCount,
			snapshotOrderPreserved: readiness.snapshotOrderPreserved,
			selectedMarkersPreserved: readiness.selectedMarkersPreserved,
			footerSummariesPreserved: readiness.footerSummariesPreserved,
			selectedMarkerMoved: readiness.selectedMarkerMoved,
			recoveredSelectionRestored: readiness.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: readiness.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: readiness.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: readiness.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: readiness.sourceRenderedSnapshotPreserved,
			stalePromptActionInactive: readiness.stalePromptActionInactive,
			staleSideParentActionInactive: readiness.staleSideParentActionInactive,
			staleActiveThreadActionInactive: readiness.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: readiness.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: readiness.noPressureDropRejection,
			liveTransportSuppressed: readiness.liveTransportSuppressed,
			liveTerminalSuppressed: readiness.liveTerminalSuppressed,
			stateDbUntouched: readiness.stateDbUntouched,
			noModelCall: readiness.noModelCall,
			noFilesystemMutation: readiness.noFilesystemMutation,
			decisionSummaries: readiness.decisionSummaries,
			policyLogSummaries: policy.summaries(),
			sourceHandoffSummary: readiness.sourceHandoffSummary
		});
	}
}
