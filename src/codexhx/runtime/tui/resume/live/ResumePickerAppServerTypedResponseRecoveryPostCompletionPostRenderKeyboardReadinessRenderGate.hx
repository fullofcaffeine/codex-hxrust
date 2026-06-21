package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessRenderGateReport {
		final handoffReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderedStateHandoffRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessPolicy();
		final readiness = policy.admit(handoffReport, [
			ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveDown,
			ResumePickerAppServerTypedResponseRecoveryKeyboardIntentKind.MoveUp
		]);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderKeyboardReadinessRenderGateReport({
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
