package codexhx.runtime.tui.resume.live;

class ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoffRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoffRenderGateReport {
		final executionReport = ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderScheduledRenderExecutionRenderGate.run();
		final policy = new DeterministicResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoffPolicy();
		final handoff = policy.handoff(executionReport);
		return new ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderRenderedStateHandoffRenderGateReport({
			handoffKind: handoff.kind,
			handoffSummary: handoff.summary(),
			postRenderIdleListReady: handoff.postRenderIdleListReady,
			keyboardInputReady: handoff.keyboardInputReady,
			listNavigationReady: handoff.listNavigationReady,
			noLeftoverScheduledRenderRequest: handoff.noLeftoverScheduledRenderRequest,
			sourceSchedulerRequestCount: handoff.sourceSchedulerRequestCount,
			consumedScheduledRequestCount: handoff.consumedScheduledRequestCount,
			renderCount: handoff.renderCount,
			renderedSnapshotPreserved: handoff.renderedSnapshotPreserved,
			finalThreadId: handoff.finalThreadId,
			finalFooter: handoff.finalFooter,
			finalSelectionPreserved: handoff.finalSelectionPreserved,
			finalFooterPreserved: handoff.finalFooterPreserved,
			inputAdmitted: handoff.inputAdmitted,
			localOnlyRenderIntent: handoff.localOnlyRenderIntent,
			replayCount: handoff.replayCount,
			snapshotOrderPreserved: handoff.snapshotOrderPreserved,
			selectedMarkersPreserved: handoff.selectedMarkersPreserved,
			footerSummariesPreserved: handoff.footerSummariesPreserved,
			selectedMarkerMoved: handoff.selectedMarkerMoved,
			recoveredSelectionRestored: handoff.recoveredSelectionRestored,
			sourcePreExecutionSchedulerRequestCount: handoff.sourcePreExecutionSchedulerRequestCount,
			sourcePreExecutionConsumedRequestCount: handoff.sourcePreExecutionConsumedRequestCount,
			sourcePreExecutionRenderCount: handoff.sourcePreExecutionRenderCount,
			sourceRenderedSnapshotPreserved: handoff.sourceRenderedSnapshotPreserved,
			stalePromptActionInactive: handoff.stalePromptActionInactive,
			staleSideParentActionInactive: handoff.staleSideParentActionInactive,
			staleActiveThreadActionInactive: handoff.staleActiveThreadActionInactive,
			ignoredNoSurfaceRecordsAbsent: handoff.ignoredNoSurfaceRecordsAbsent,
			noPressureDropRejection: handoff.noPressureDropRejection,
			liveTransportSuppressed: handoff.liveTransportSuppressed,
			liveTerminalSuppressed: handoff.liveTerminalSuppressed,
			stateDbUntouched: handoff.stateDbUntouched,
			noModelCall: handoff.noModelCall,
			noFilesystemMutation: handoff.noFilesystemMutation,
			finalSnapshot: handoff.finalSnapshot,
			executionSummary: executionReport.summary(),
			handoffLogSummaries: policy.summaries()
		});
	}
}
