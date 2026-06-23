package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessRenderGateReport {
		final handoffReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateSeventhCycleScheduledExecutionHandoffRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessPolicy();
		final readiness = policy.admit(handoffReport, [
			ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveDown,
			ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveUp
		]);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderedStateEighthCycleKeyboardReadinessRenderGateReport({
			readinessKind: readiness.kind,
			readinessSummary: compactReadinessSummary(readiness),
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
			completionReady: handoffReport.completionReady,
			nextSliceReady: handoffReport.nextSliceReady,
			replayCount: readiness.replayCount,
			sourceReplayCount: handoffReport.sourceReplayCount,
			sourceHandoffReplayCount: handoffReport.sourceHandoffReplayCount,
			sourceHandoffReadinessDecisionCount: handoffReport.sourceHandoffReadinessDecisionCount,
			sourceHandoffRenderStateCount: handoffReport.sourceHandoffRenderStateCount,
			sourceHandoffFrameRequests: handoffReport.sourceHandoffFrameRequests,
			sourceHandoffKeyboardRenderCount: handoffReport.sourceHandoffKeyboardRenderCount,
			sourceSecondCycleHandoffReplayCount: handoffReport.sourceSecondCycleHandoffReplayCount,
			sourceSecondCycleHandoffReadinessDecisionCount: handoffReport.sourceSecondCycleHandoffReadinessDecisionCount,
			sourceSecondCycleHandoffRenderStateCount: handoffReport.sourceSecondCycleHandoffRenderStateCount,
			sourceSecondCycleHandoffFrameRequests: handoffReport.sourceSecondCycleHandoffFrameRequests,
			sourceSecondCycleHandoffKeyboardRenderCount: handoffReport.sourceSecondCycleHandoffKeyboardRenderCount,
			sourceThirdCycleHandoffReplayCount: handoffReport.sourceThirdCycleHandoffReplayCount,
			sourceThirdCycleHandoffReadinessDecisionCount: handoffReport.sourceThirdCycleHandoffReadinessDecisionCount,
			sourceThirdCycleHandoffRenderStateCount: handoffReport.sourceThirdCycleHandoffRenderStateCount,
			sourceThirdCycleHandoffFrameRequests: handoffReport.sourceThirdCycleHandoffFrameRequests,
			sourceThirdCycleHandoffKeyboardRenderCount: handoffReport.sourceThirdCycleHandoffKeyboardRenderCount,
			sourceReadinessDecisionCount: handoffReport.sourceReadinessDecisionCount,
			sourceRenderStateCount: handoffReport.sourceRenderStateCount,
			sourceFrameRequests: handoffReport.sourceFrameRequests,
			sourceKeyboardRenderCount: handoffReport.sourceKeyboardRenderCount,
			snapshotOrderPreserved: readiness.snapshotOrderPreserved,
			selectedMarkersPreserved: readiness.selectedMarkersPreserved,
			footerSummariesPreserved: readiness.footerSummariesPreserved,
			selectedMarkerMoved: readiness.selectedMarkerMoved,
			recoveredSelectionRestored: readiness.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: readiness.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: readiness.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: readiness.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: readiness.sourceRenderedSnapshotPreserved,
			sourceInputAdmitted: handoffReport.sourceInputAdmitted,
			sourceLocalOnlyRenderIntent: handoffReport.sourceLocalOnlyRenderIntent,
			sourceHandoffInputAdmitted: handoffReport.sourceHandoffInputAdmitted,
			sourceHandoffLocalOnlyRenderIntent: handoffReport.sourceHandoffLocalOnlyRenderIntent,
			sourceSecondCycleHandoffInputAdmitted: handoffReport.sourceSecondCycleHandoffInputAdmitted,
			sourceSecondCycleHandoffLocalOnlyRenderIntent: handoffReport.sourceSecondCycleHandoffLocalOnlyRenderIntent,
			sourceThirdCycleHandoffInputAdmitted: handoffReport.sourceThirdCycleHandoffInputAdmitted,
			sourceThirdCycleHandoffLocalOnlyRenderIntent: handoffReport.sourceThirdCycleHandoffLocalOnlyRenderIntent,
			sourceFourthCycleHandoffInputAdmitted: handoffReport.sourceFourthCycleHandoffInputAdmitted,
			sourceFourthCycleHandoffLocalOnlyRenderIntent: handoffReport.sourceFourthCycleHandoffLocalOnlyRenderIntent,
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
			finalSnapshot: handoffReport.finalSnapshot,
			decisionSummaries: readiness.decisionSummaries,
			policyLogSummaries: policy.summaries(),
			sourceHandoffSummary: readiness.sourceHandoffSummary
		});
	}

	static function compactReadinessSummary(readiness:ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareKeyboardReadiness):String {
		return "kind="
			+ readiness.kind
			+ ";sourceHandoffKind="
			+ readiness.sourceHandoffKind
			+ ";decisionCount="
			+ readiness.decisionCount
			+ ";admittedCount="
			+ readiness.admittedCount
			+ ";postRenderIdleListReady="
			+ boolLabel(readiness.postRenderIdleListReady)
			+ ";keyboardInputReady="
			+ boolLabel(readiness.keyboardInputReady)
			+ ";listNavigationReady="
			+ boolLabel(readiness.listNavigationReady)
			+ ";recoveredSelectionStableUntilNavigation="
			+ boolLabel(readiness.recoveredSelectionStableUntilNavigation)
			+ ";navigationApplied="
			+ boolLabel(readiness.navigationApplied)
			+ ";returnedToRecoveredSelection="
			+ boolLabel(readiness.returnedToRecoveredSelection)
			+ ";noLeftoverScheduledRenderRequest="
			+ boolLabel(readiness.noLeftoverScheduledRenderRequest)
			+ ";sourceSchedulerRequestCount="
			+ readiness.sourceSchedulerRequestCount
			+ ";consumedScheduledRequestCount="
			+ readiness.consumedScheduledRequestCount
			+ ";renderCount="
			+ readiness.renderCount
			+ ";renderedSnapshotPreserved="
			+ boolLabel(readiness.renderedSnapshotPreserved)
			+ ";finalThread="
			+ readiness.finalThreadId
			+ ";finalFooter="
			+ readiness.finalFooter
			+ ";finalSelectionPreserved="
			+ boolLabel(readiness.finalSelectionPreserved)
			+ ";finalFooterPreserved="
			+ boolLabel(readiness.finalFooterPreserved)
			+ ";inputAdmitted="
			+ boolLabel(readiness.inputAdmitted)
			+ ";localOnlyRenderIntent="
			+ boolLabel(readiness.localOnlyRenderIntent)
			+ ";replayCount="
			+ readiness.replayCount
			+ ";snapshotOrderPreserved="
			+ boolLabel(readiness.snapshotOrderPreserved)
			+ ";selectedMarkersPreserved="
			+ boolLabel(readiness.selectedMarkersPreserved)
			+ ";footerSummariesPreserved="
			+ boolLabel(readiness.footerSummariesPreserved)
			+ ";selectedMarkerMoved="
			+ boolLabel(readiness.selectedMarkerMoved)
			+ ";recoveredSelectionRestored="
			+ boolLabel(readiness.recoveredSelectionRestored)
			+ ";sourcePreExecutionSchedulerRequestCount="
			+ readiness.sourcePreExecutionSchedulerRequestCount
			+ ";sourcePreExecutionConsumedRequestCount="
			+ readiness.sourcePreExecutionConsumedRequestCount
			+ ";sourcePreExecutionRenderCount="
			+ readiness.sourcePreExecutionRenderCount
			+ ";sourceRenderedSnapshotPreserved="
			+ boolLabel(readiness.sourceRenderedSnapshotPreserved)
			+ ";stalePromptActionInactive="
			+ boolLabel(readiness.stalePromptActionInactive)
			+ ";staleSideParentActionInactive="
			+ boolLabel(readiness.staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive="
			+ boolLabel(readiness.staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent="
			+ boolLabel(readiness.ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection="
			+ boolLabel(readiness.noPressureDropRejection)
			+ ";liveTransportSuppressed="
			+ boolLabel(readiness.liveTransportSuppressed)
			+ ";liveTerminalSuppressed="
			+ boolLabel(readiness.liveTerminalSuppressed)
			+ ";stateDbUntouched="
			+ boolLabel(readiness.stateDbUntouched)
			+ ";noModelCall="
			+ boolLabel(readiness.noModelCall)
			+ ";noFilesystemMutation="
			+ boolLabel(readiness.noFilesystemMutation)
			+ ";reason="
			+ readiness.reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
