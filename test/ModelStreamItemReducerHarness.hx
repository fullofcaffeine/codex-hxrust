import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.model.stream.ModelStreamFixtureEvent;
import codexhx.runtime.model.stream.ModelStreamRouteRequest;
import codexhx.runtime.model.streamitem.ModelStreamItemEventKind;
import codexhx.runtime.model.streamitem.ModelStreamItemFixtureEvent;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerPolicy;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerReport;
import codexhx.runtime.model.streamitem.ModelStreamItemReducerRequest;
import codexhx.runtime.model.streamitem.ModelStreamOutputItem;
import codexhx.runtime.model.streamitem.ModelStreamOutputItemKind;
import codexhx.runtime.model.streamitem.ModelCollabAgentMetadataEntry;
import codexhx.runtime.model.streamitem.ModelCollabReplayWaitItem;
import codexhx.runtime.model.streamitem.ModelCollabReplayWaitStatusKind;
import codexhx.runtime.model.streamitem.ModelPatchApplicationPolicy;
import codexhx.runtime.model.streamitem.ModelPatchApplicationRequest;
import codexhx.runtime.model.streamitem.ModelPatchApplicationOutcome;
import codexhx.runtime.model.streamitem.ModelPatchApplyStatus;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionPolicy;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionRequest;
import codexhx.runtime.model.streamitem.ModelPatchApprovalDecisionOutcome;
import codexhx.runtime.model.streamitem.ModelPatchApprovalRequirement;
import codexhx.runtime.model.streamitem.ModelPatchProjectionPolicy;
import codexhx.runtime.model.streamitem.ModelPatchProjectionRequest;
import codexhx.runtime.model.streamitem.ModelPatchReviewDecision;
import codexhx.runtime.model.streamitem.ModelPatchSandboxAttemptKind;
import codexhx.runtime.model.streamitem.ModelPatchToolEventStageKind;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpOutcome;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpPolicy;
import codexhx.runtime.model.streamitem.ModelPatchToolFollowUpRequest;
import codexhx.runtime.model.streamitem.ModelPatchToolOutputItemKind;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputOutcome;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputPolicy;
import codexhx.runtime.model.streamitem.ModelPatchToolResponseInputRequest;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationRequest;
import codexhx.runtime.model.streamitem.ModelSamplingContinuationOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyRequest;
import codexhx.runtime.model.streamitem.ModelSamplingInputAssemblyOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingInputItem;
import codexhx.runtime.model.streamitem.ModelSamplingInputItemKind;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchRequest;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchTransportKind;
import codexhx.runtime.model.streamitem.ModelSamplingDispatchOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingStreamAttemptRequest;
import codexhx.runtime.model.streamitem.ModelSamplingStreamErrorKind;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffRequest;
import codexhx.runtime.model.streamitem.ModelSamplingStreamEventHandoffOutcome;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainFailureKind;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainItem;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainPolicy;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainRequest;
import codexhx.runtime.model.streamitem.ModelInFlightToolDrainOutcome;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionPolicy;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionRequest;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionOutcome;
import codexhx.runtime.model.streamitem.ModelPostDrainEmissionKind;
import codexhx.runtime.model.streamitem.ModelPostDrainCancellationKind;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationRequest;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingResultIntegrationStatusKind;
import codexhx.runtime.model.streamitem.ModelSamplingErrorTerminalKind;
import codexhx.runtime.model.streamitem.ModelSamplingErrorTerminalOutcome;
import codexhx.runtime.model.streamitem.ModelSamplingErrorTerminalPolicy;
import codexhx.runtime.model.streamitem.ModelSamplingErrorTerminalRequest;
import codexhx.runtime.model.streamitem.ModelTurnLifecycleEventKind;
import codexhx.runtime.model.streamitem.ModelTurnLifecycleOutcome;
import codexhx.runtime.model.streamitem.ModelTurnLifecyclePolicy;
import codexhx.runtime.model.streamitem.ModelTurnLifecycleRequest;
import codexhx.runtime.model.streamitem.ModelTurnLifecycleTerminalKind;
import codexhx.runtime.model.streamitem.ModelTurnTerminalNotificationIntentKind;
import codexhx.runtime.model.streamitem.ModelTurnTerminalProjectedStatusKind;
import codexhx.runtime.model.streamitem.ModelTurnTerminalProjectionEventKind;
import codexhx.runtime.model.streamitem.ModelTurnTerminalProjectionOutcome;
import codexhx.runtime.model.streamitem.ModelTurnTerminalProjectionPolicy;
import codexhx.runtime.model.streamitem.ModelTurnTerminalProjectionRequest;
import codexhx.runtime.model.streamitem.ModelTurnReplayKind;
import codexhx.runtime.model.streamitem.ModelTurnReplayReconstructionOutcome;
import codexhx.runtime.model.streamitem.ModelTurnReplayReconstructionPolicy;
import codexhx.runtime.model.streamitem.ModelTurnReplayReconstructionRequest;
import codexhx.runtime.model.streamitem.ModelTurnReplayTargetKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractivePromptKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveReplayEventKind;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveReplayOutcome;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveReplayPolicy;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveReplayRequest;
import codexhx.runtime.model.streamitem.ModelPendingInteractiveSideStatusKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotReplayDispatchKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotReplayDispatchOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotReplayDispatchPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotReplayDispatchRequest;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotReplayEventKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryItem;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryItemKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryReplayOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryReplayPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryReplayRequest;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnHistoryTurn;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotTurnStatusKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotCollabMetadataReplayDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotCollabMetadataReplayOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotCollabMetadataReplayPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotCollabMetadataReplayRequest;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotSessionRefreshDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotSessionRefreshOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotSessionRefreshPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotSessionRefreshRequest;
import codexhx.runtime.model.streamitem.ModelThreadSnapshotSessionRefreshTurn;
import codexhx.runtime.model.streamitem.ModelReplayedServerRequestKind;
import codexhx.runtime.model.streamitem.ModelReplayedServerRequestSurfaceKind;
import codexhx.runtime.model.streamitem.ModelReplayedServerRequestSurfaceOutcome;
import codexhx.runtime.model.streamitem.ModelReplayedServerRequestSurfacePolicy;
import codexhx.runtime.model.streamitem.ModelReplayedServerRequestSurfaceRequest;
import codexhx.runtime.model.streamitem.ModelAppServerRequestResolutionCommandKind;
import codexhx.runtime.model.streamitem.ModelAppServerRequestResolutionOutcome;
import codexhx.runtime.model.streamitem.ModelAppServerRequestResolutionPayloadKind;
import codexhx.runtime.model.streamitem.ModelAppServerRequestResolutionPolicy;
import codexhx.runtime.model.streamitem.ModelAppServerRequestResolutionRequest;
import codexhx.runtime.model.streamitem.ModelAppServerResponseDispatchKind;
import codexhx.runtime.model.streamitem.ModelAppServerResponseDispatchOutcome;
import codexhx.runtime.model.streamitem.ModelAppServerResponseDispatchPolicy;
import codexhx.runtime.model.streamitem.ModelAppServerResponseDispatchRequest;
import codexhx.runtime.model.streamitem.ModelAppServerRequestEnqueueOutcome;
import codexhx.runtime.model.streamitem.ModelAppServerRequestEnqueuePolicy;
import codexhx.runtime.model.streamitem.ModelAppServerRequestEnqueueRequest;
import codexhx.runtime.model.streamitem.ModelAppServerRequestEnqueueRouteKind;
import codexhx.runtime.model.streamitem.ModelAppServerQueuedRequestDeliveryKind;
import codexhx.runtime.model.streamitem.ModelAppServerQueuedRequestDeliveryOutcome;
import codexhx.runtime.model.streamitem.ModelAppServerQueuedRequestDeliveryPolicy;
import codexhx.runtime.model.streamitem.ModelAppServerQueuedRequestDeliveryRequest;
import codexhx.runtime.model.streamitem.ModelThreadActiveTurnDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadActiveTurnEventKind;
import codexhx.runtime.model.streamitem.ModelThreadActiveTurnOutcome;
import codexhx.runtime.model.streamitem.ModelThreadActiveTurnPolicy;
import codexhx.runtime.model.streamitem.ModelThreadActiveTurnRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideParentPendingDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideParentPendingEventKind;
import codexhx.runtime.model.streamitem.ModelThreadSideParentPendingOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideParentPendingPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideParentPendingRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusChangeDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusChangeEventKind;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusChangeOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusChangePolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusChangeRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideParentStatusKind;
import codexhx.runtime.model.streamitem.ModelThreadSideParentTurnStatusKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadUiSyncDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadUiSyncOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadUiSyncPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadUiSyncRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadDiscardDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadDiscardOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadDiscardPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadDiscardRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadInterruptKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartFailureKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartupEventKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartupRoutingDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartupRoutingOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartupRoutingPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadStartupRoutingRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadComposerHandoffDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadComposerHandoffOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadComposerHandoffPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadComposerHandoffRequest;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadNavigationCleanupDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadNavigationCleanupOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadNavigationCleanupPolicy;
import codexhx.runtime.model.streamitem.ModelThreadSideThreadNavigationCleanupRequest;
import codexhx.runtime.model.streamitem.ModelActiveNonPrimaryShutdownDecisionKind;
import codexhx.runtime.model.streamitem.ModelActiveNonPrimaryShutdownEventKind;
import codexhx.runtime.model.streamitem.ModelActiveNonPrimaryShutdownOutcome;
import codexhx.runtime.model.streamitem.ModelActiveNonPrimaryShutdownPolicy;
import codexhx.runtime.model.streamitem.ModelActiveNonPrimaryShutdownRequest;
import codexhx.runtime.model.streamitem.ModelClearUiHeaderDecisionKind;
import codexhx.runtime.model.streamitem.ModelClearUiHeaderOutcome;
import codexhx.runtime.model.streamitem.ModelClearUiHeaderPolicy;
import codexhx.runtime.model.streamitem.ModelClearUiHeaderRequest;
import codexhx.runtime.model.streamitem.ModelClearUiHeaderRequestKind;
import codexhx.runtime.model.streamitem.ModelClearOnlyUiResetDecisionKind;
import codexhx.runtime.model.streamitem.ModelClearOnlyUiResetOutcome;
import codexhx.runtime.model.streamitem.ModelClearOnlyUiResetPolicy;
import codexhx.runtime.model.streamitem.ModelClearOnlyUiResetRequest;
import codexhx.runtime.model.streamitem.ModelClearOnlySkillWarningRerenderDecisionKind;
import codexhx.runtime.model.streamitem.ModelClearOnlySkillWarningRerenderOutcome;
import codexhx.runtime.model.streamitem.ModelClearOnlySkillWarningRerenderPolicy;
import codexhx.runtime.model.streamitem.ModelClearOnlySkillWarningRerenderRequest;
import codexhx.runtime.model.streamitem.ModelBacktrackEscVimInsertGuardDecisionKind;
import codexhx.runtime.model.streamitem.ModelBacktrackEscVimInsertGuardOutcome;
import codexhx.runtime.model.streamitem.ModelBacktrackEscVimInsertGuardPolicy;
import codexhx.runtime.model.streamitem.ModelBacktrackEscVimInsertGuardRequest;
import codexhx.runtime.model.streamitem.ModelSideConversationBacktrackEscVimGuardDecisionKind;
import codexhx.runtime.model.streamitem.ModelSideConversationBacktrackEscVimGuardOutcome;
import codexhx.runtime.model.streamitem.ModelSideConversationBacktrackEscVimGuardPolicy;
import codexhx.runtime.model.streamitem.ModelSideConversationBacktrackEscVimGuardRequest;
import codexhx.runtime.model.streamitem.ModelSideBacktrackUnavailableMessageDecisionKind;
import codexhx.runtime.model.streamitem.ModelSideBacktrackUnavailableMessageOutcome;
import codexhx.runtime.model.streamitem.ModelSideBacktrackUnavailableMessagePolicy;
import codexhx.runtime.model.streamitem.ModelSideBacktrackUnavailableMessageRequest;
import codexhx.runtime.model.streamitem.ModelInterruptBacktrackKeymapDecisionKind;
import codexhx.runtime.model.streamitem.ModelInterruptBacktrackFixedShortcutActionKind;
import codexhx.runtime.model.streamitem.ModelInterruptBacktrackKeymapOutcome;
import codexhx.runtime.model.streamitem.ModelInterruptBacktrackKeymapPolicy;
import codexhx.runtime.model.streamitem.ModelInterruptBacktrackKeymapRequest;
import codexhx.runtime.model.streamitem.ModelInterruptQuestionNavigationKeymapDecisionKind;
import codexhx.runtime.model.streamitem.ModelInterruptQuestionNavigationKeymapOutcome;
import codexhx.runtime.model.streamitem.ModelInterruptQuestionNavigationKeymapPolicy;
import codexhx.runtime.model.streamitem.ModelInterruptQuestionNavigationKeymapRequest;
import codexhx.runtime.model.streamitem.ModelKeymapComposerFixedShortcutConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapComposerFixedShortcutConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapComposerFixedShortcutConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapComposerFixedShortcutConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapComposerFixedShortcutConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapAliasDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapAliasOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapAliasPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapAliasRequest;
import codexhx.runtime.model.streamitem.ModelKeymapBindingInputDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapBindingInputOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapBindingInputPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapBindingInputRequest;
import codexhx.runtime.model.streamitem.ModelKeymapBinding;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningCase;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultPruningRequest;
import codexhx.runtime.model.streamitem.ModelKeymapEditorAssignmentActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorAssignmentDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorAssignmentOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapEditorAssignmentPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapEditorAssignmentRequest;
import codexhx.runtime.model.streamitem.ModelKeymapEditorConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapEditorConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapEditorConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapEditorUnbindConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorUnbindConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapEditorUnbindConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapEditorUnbindConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapEditorUnbindConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceAssignmentActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceAssignmentDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceAssignmentOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceAssignmentPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceAssignmentRequest;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapPagerConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapPagerConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapPagerConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapPagerConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapPagerConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapListConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapListConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapListConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapListConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapListConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapApprovalConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapApprovalConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapApprovalConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapApprovalConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapApprovalConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapFixedShortcutActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapFixedShortcutDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapFixedShortcutOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapFixedShortcutPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapFixedShortcutRequest;
import codexhx.runtime.model.streamitem.ModelKeymapOverlapConflictActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapOverlapConflictDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapOverlapConflictOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapOverlapConflictPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapOverlapConflictRequest;
import codexhx.runtime.model.streamitem.ModelKeymapVimOperatorTextObjectActionKind;
import codexhx.runtime.model.streamitem.ModelKeymapVimOperatorTextObjectDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapVimOperatorTextObjectOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapVimOperatorTextObjectPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapVimOperatorTextObjectRequest;
import codexhx.runtime.model.streamitem.ModelKeymapVimNormalDefaultsDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapVimNormalDefaultsOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapVimNormalDefaultsPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapVimNormalDefaultsRequest;
import codexhx.runtime.model.streamitem.ModelKeymapInvalidGlobalCopyDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapInvalidGlobalCopyOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapInvalidGlobalCopyPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapInvalidGlobalCopyRequest;
import codexhx.runtime.model.streamitem.ModelKeymapDefaultActionCase;
import codexhx.runtime.model.streamitem.ModelKeymapShadowCase;
import codexhx.runtime.model.streamitem.ModelKeymapShadowDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeymapShadowOutcome;
import codexhx.runtime.model.streamitem.ModelKeymapShadowPolicy;
import codexhx.runtime.model.streamitem.ModelKeymapShadowRequest;
import codexhx.runtime.model.streamitem.ModelKeymapShadowScopeKind;
import codexhx.runtime.model.streamitem.ModelKeymapMainSurfaceActionKind;
import codexhx.runtime.model.streamitem.ModelKeyParserCase;
import codexhx.runtime.model.streamitem.ModelKeyParserDecisionKind;
import codexhx.runtime.model.streamitem.ModelKeyParserOutcome;
import codexhx.runtime.model.streamitem.ModelKeyParserPolicy;
import codexhx.runtime.model.streamitem.ModelKeyParserRequest;
import codexhx.runtime.model.streamitem.ModelParsedKeyKind;
import codexhx.runtime.model.streamitem.ModelPagerTranscriptBacktrackKeymapDecisionKind;
import codexhx.runtime.model.streamitem.ModelPagerTranscriptBacktrackKeymapOutcome;
import codexhx.runtime.model.streamitem.ModelPagerTranscriptBacktrackKeymapPolicy;
import codexhx.runtime.model.streamitem.ModelPagerTranscriptBacktrackKeymapRequest;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowDecisionKind;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowMaxRowsKind;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowOutcome;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowPolicy;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowRequest;
import codexhx.runtime.model.streamitem.ModelTerminalResizeReflowRequestKind;
import codexhx.runtime.model.streamitem.ModelResizeReflowSchedulingDecisionKind;
import codexhx.runtime.model.streamitem.ModelResizeReflowSchedulingOutcome;
import codexhx.runtime.model.streamitem.ModelResizeReflowSchedulingPolicy;
import codexhx.runtime.model.streamitem.ModelResizeReflowSchedulingRequest;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionCategory;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionDecisionKind;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionHistoryCellKind;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionRequestKind;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionRoutingOutcome;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionRoutingPolicy;
import codexhx.runtime.model.streamitem.ModelFeedbackSubmissionRoutingRequest;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorDecisionKind;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorOutcome;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorPolicy;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorRequest;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorRequestKind;
import codexhx.runtime.model.streamitem.ModelTuiActiveTurnErrorTurnKind;
import codexhx.runtime.model.streamitem.ModelFreshSessionServiceTierDecisionKind;
import codexhx.runtime.model.streamitem.ModelFreshSessionServiceTierOutcome;
import codexhx.runtime.model.streamitem.ModelFreshSessionServiceTierPolicy;
import codexhx.runtime.model.streamitem.ModelFreshSessionServiceTierRequest;
import codexhx.runtime.model.streamitem.ModelFreshSessionServiceTierValue;
import codexhx.runtime.model.streamitem.ModelFreshSessionPreviousConversationShutdownDecisionKind;
import codexhx.runtime.model.streamitem.ModelFreshSessionPreviousConversationShutdownOutcome;
import codexhx.runtime.model.streamitem.ModelFreshSessionPreviousConversationShutdownPolicy;
import codexhx.runtime.model.streamitem.ModelFreshSessionPreviousConversationShutdownRequest;
import codexhx.runtime.model.streamitem.ModelInterruptWithoutActiveTurnDecisionKind;
import codexhx.runtime.model.streamitem.ModelInterruptWithoutActiveTurnOutcome;
import codexhx.runtime.model.streamitem.ModelInterruptWithoutActiveTurnPolicy;
import codexhx.runtime.model.streamitem.ModelInterruptWithoutActiveTurnRequest;
import codexhx.runtime.model.streamitem.ModelOverrideTurnContextSettingsUpdateDecisionKind;
import codexhx.runtime.model.streamitem.ModelOverrideTurnContextSettingsUpdateOutcome;
import codexhx.runtime.model.streamitem.ModelOverrideTurnContextSettingsUpdatePolicy;
import codexhx.runtime.model.streamitem.ModelOverrideTurnContextSettingsUpdateRequest;
import codexhx.runtime.model.streamitem.ModelInactiveThreadSettingsNotificationDecisionKind;
import codexhx.runtime.model.streamitem.ModelInactiveThreadSettingsNotificationOutcome;
import codexhx.runtime.model.streamitem.ModelInactiveThreadSettingsNotificationPolicy;
import codexhx.runtime.model.streamitem.ModelInactiveThreadSettingsNotificationRequest;
import codexhx.runtime.model.streamitem.ModelBacktrackSelectionDecisionKind;
import codexhx.runtime.model.streamitem.ModelBacktrackSelectionOutcome;
import codexhx.runtime.model.streamitem.ModelBacktrackSelectionPolicy;
import codexhx.runtime.model.streamitem.ModelBacktrackSelectionRequest;
import codexhx.runtime.model.streamitem.ModelBacktrackTranscriptCell;
import codexhx.runtime.model.streamitem.ModelBacktrackTranscriptCellKind;
import codexhx.runtime.model.streamitem.ModelBacktrackRollbackDecisionKind;
import codexhx.runtime.model.streamitem.ModelBacktrackRollbackOutcome;
import codexhx.runtime.model.streamitem.ModelBacktrackRollbackPolicy;
import codexhx.runtime.model.streamitem.ModelBacktrackRollbackRequest;
import codexhx.runtime.model.streamitem.ModelCancelledTurnEditDecisionKind;
import codexhx.runtime.model.streamitem.ModelCancelledTurnEditOutcome;
import codexhx.runtime.model.streamitem.ModelCancelledTurnEditPolicy;
import codexhx.runtime.model.streamitem.ModelCancelledTurnEditRequest;
import codexhx.runtime.model.streamitem.ModelBacktrackResubmitDecisionKind;
import codexhx.runtime.model.streamitem.ModelBacktrackResubmitOutcome;
import codexhx.runtime.model.streamitem.ModelBacktrackResubmitPolicy;
import codexhx.runtime.model.streamitem.ModelBacktrackResubmitRequest;
import codexhx.runtime.model.streamitem.ModelQueuedRollbackOverlaySyncDecisionKind;
import codexhx.runtime.model.streamitem.ModelQueuedRollbackOverlaySyncOutcome;
import codexhx.runtime.model.streamitem.ModelQueuedRollbackOverlaySyncPolicy;
import codexhx.runtime.model.streamitem.ModelQueuedRollbackOverlaySyncRequest;
import codexhx.runtime.model.streamitem.ModelThreadRollbackResponseActiveQueueFlushDecisionKind;
import codexhx.runtime.model.streamitem.ModelThreadRollbackResponseActiveQueueFlushOutcome;
import codexhx.runtime.model.streamitem.ModelThreadRollbackResponseActiveQueueFlushPolicy;
import codexhx.runtime.model.streamitem.ModelThreadRollbackResponseActiveQueueFlushRequest;
import codexhx.runtime.model.streamitem.ModelThreadBufferedEventKind;
import codexhx.runtime.model.streamitem.ModelThreadBufferedRequestEvictionKind;
import codexhx.runtime.model.streamitem.ModelThreadBufferedRequestEvictionOutcome;
import codexhx.runtime.model.streamitem.ModelThreadBufferedRequestEvictionPolicy;
import codexhx.runtime.model.streamitem.ModelThreadBufferedRequestEvictionRequest;
import codexhx.runtime.model.streamitem.ModelThreadSessionRebaseEventKind;
import codexhx.runtime.model.streamitem.ModelThreadSessionRebaseKind;
import codexhx.runtime.model.streamitem.ModelThreadSessionRebaseOutcome;
import codexhx.runtime.model.streamitem.ModelThreadSessionRebasePolicy;
import codexhx.runtime.model.streamitem.ModelThreadSessionRebaseRequest;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainPolicy;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainRequest;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainItem;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputDrainOutcome;
import codexhx.runtime.model.streamitem.ModelPostSamplingPendingInputSourceKind;
import codexhx.runtime.model.streamitem.ModelPendingInputHookActionKind;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingItem;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingOutcome;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingPolicy;
import codexhx.runtime.model.streamitem.ModelPendingInputHookRecordingRequest;
import codexhx.runtime.model.streamitem.ModelPromptPreparationOutcome;
import codexhx.runtime.model.streamitem.ModelPromptPreparationPolicy;
import codexhx.runtime.model.streamitem.ModelPromptPreparationRequest;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookDecisionKind;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookOutcome;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookPolicy;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookRequest;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookRunStatusKind;
import codexhx.runtime.model.streamitem.ModelTerminalStopHookTargetKind;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerPolicy;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerOutcome;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerRequest;
import codexhx.runtime.model.streamitem.ModelPatchTurnDiffTrackerUpdateKind;
import codexhx.runtime.model.streamitem.ModelPatchAppliedDelta;
import codexhx.runtime.model.streamitem.ModelPatchVerificationPolicy;
import codexhx.runtime.model.streamitem.ModelPatchVerificationRequest;
import codexhx.runtime.model.streamitem.ModelPatchVerificationOutcome;
import codexhx.runtime.model.streamitem.ModelPatchVirtualFile;
import haxe.json.Value;
import sys.io.File;

class ModelStreamItemReducerHarness {
	static function main():Void {
		final root = fixtureRoot("fixtures/hxrust/model-stream-item-reducer.v1.json");
		final envelopeRoot = fixtureRoot(stringField(root, "envelopeFixture", "fixtures/hxrust/model-request-envelope.v1.json"));
		final routeRoot = fixtureRoot(stringField(root, "routeFixture", "fixtures/hxrust/model-stream-route.v1.json"));
		final cases = arrayField(root, "cases");
		final report = ModelStreamItemReducerPolicy.buildCases(requests(cases, envelopeRoot, routeRoot));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final testCase = objectValue(cases[i]);
			final expect = objectField(testCase, "expect");
			final outcome = report.outcomes[i];
			final secretProbe = stringField(testCase, "secretProbe", "");
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "requestId", ""), outcome.requestId);
			assertEquals(stringField(expect, "routeCode", ""), outcome.routeCode);
			assertEquals(stringField(expect, "providerId", ""), outcome.providerId);
			assertEquals(stringField(expect, "selectedModelId", ""), outcome.selectedModelId);
			assertEquals(Std.string(intField(expect, "startedCount", 0)), Std.string(outcome.startedCount));
			assertEquals(Std.string(intField(expect, "completedCount", 0)), Std.string(outcome.completedCount));
			assertEquals(Std.string(intField(expect, "assistantDeltaCount", 0)), Std.string(outcome.assistantDeltaCount));
			assertEquals(Std.string(intField(expect, "reasoningDeltaCount", 0)), Std.string(outcome.reasoningDeltaCount));
			assertEquals(Std.string(intField(expect, "rawReasoningDeltaCount", 0)), Std.string(outcome.rawReasoningDeltaCount));
			assertEquals(Std.string(intField(expect, "toolInputDeltaCount", 0)), Std.string(outcome.toolInputDeltaCount));
			assertEquals(Std.string(intField(expect, "toolInputDeltaIgnoredCount", 0)), Std.string(outcome.toolInputDeltaIgnoredCount));
			assertEquals(Std.string(intField(expect, "toolArgumentDiffEventCount", 0)), Std.string(outcome.toolArgumentDiffEventCount));
			assertEquals(Std.string(intField(expect, "toolCallCount", 0)), Std.string(outcome.toolCallCount));
			assertEquals(boolText(boolField(expect, "needsFollowUp", false)), boolText(outcome.needsFollowUp));
			assertEquals(stringField(expect, "lastAgentMessage", ""), outcome.lastAgentMessage);
			assertEquals(stringField(expect, "terminalResponseId", ""), outcome.terminalResponseId);
			assertEquals(Std.string(intField(expect, "totalTokens", 0)), Std.string(outcome.totalTokens));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
			final topLevelIntegrations = assertTopLevelSamplingResultIntegrations(testCase, outcome, secretProbe);
			final topLevelPendingInputDrains = assertTopLevelPostSamplingPendingInputDrains(testCase, topLevelIntegrations, secretProbe);
			final topLevelHookRecordings = assertTopLevelPendingInputHookRecordings(testCase, topLevelPendingInputDrains, secretProbe);
			final topLevelPromptPreparations = assertTopLevelPromptPreparations(testCase, topLevelHookRecordings, secretProbe);
			final topLevelTerminalStopHooks = assertTopLevelTerminalStopHooks(testCase, topLevelIntegrations, topLevelPromptPreparations, secretProbe);
			final topLevelSamplingErrorTerminals = assertTopLevelSamplingErrorTerminals(testCase, topLevelTerminalStopHooks, secretProbe);
			final topLevelTurnLifecycles = assertTopLevelTurnLifecycles(testCase, topLevelTerminalStopHooks, topLevelSamplingErrorTerminals, secretProbe);
			final topLevelTurnTerminalProjections = assertTopLevelTurnTerminalProjections(testCase, topLevelTurnLifecycles, secretProbe);
			final topLevelTurnReplayReconstructions = assertTopLevelTurnReplayReconstructions(testCase, topLevelTurnTerminalProjections, secretProbe);
			final topLevelPendingInteractiveReplays = assertTopLevelPendingInteractiveReplays(testCase, topLevelTurnReplayReconstructions, secretProbe);
			final topLevelThreadSnapshotReplayDispatches = assertTopLevelThreadSnapshotReplayDispatches(testCase, topLevelPendingInteractiveReplays, secretProbe);
			assertTopLevelThreadSnapshotTurnHistoryReplays(testCase, secretProbe);
			assertTopLevelThreadSnapshotCollabMetadataReplays(testCase, secretProbe);
			assertTopLevelThreadSnapshotSessionRefreshes(testCase, secretProbe);
			final topLevelReplayedServerRequestSurfaces = assertTopLevelReplayedServerRequestSurfaces(testCase, topLevelThreadSnapshotReplayDispatches, secretProbe);
			final topLevelAppServerRequestResolutions = assertTopLevelAppServerRequestResolutions(testCase, topLevelReplayedServerRequestSurfaces, secretProbe);
			final topLevelAppServerResponseDispatches = assertTopLevelAppServerResponseDispatches(testCase, topLevelAppServerRequestResolutions, secretProbe);
			final topLevelAppServerRequestEnqueues = assertTopLevelAppServerRequestEnqueues(testCase, topLevelAppServerResponseDispatches, secretProbe);
			final topLevelAppServerQueuedRequestDeliveries = assertTopLevelAppServerQueuedRequestDeliveries(testCase, topLevelAppServerRequestEnqueues, secretProbe);
			final topLevelThreadBufferedRequestEvictions = assertTopLevelThreadBufferedRequestEvictions(testCase, topLevelAppServerQueuedRequestDeliveries, secretProbe);
			final topLevelThreadSessionRebases = assertTopLevelThreadSessionRebases(testCase, topLevelThreadBufferedRequestEvictions, secretProbe);
			final topLevelThreadActiveTurns = assertTopLevelThreadActiveTurns(testCase, topLevelThreadSessionRebases, secretProbe);
			final topLevelThreadSideParentPendingStatuses = assertTopLevelThreadSideParentPendingStatuses(testCase, topLevelThreadActiveTurns, secretProbe);
			final topLevelThreadSideParentStatusChanges = assertTopLevelThreadSideParentStatusChanges(testCase, topLevelThreadSideParentPendingStatuses, secretProbe);
			final topLevelThreadSideThreadUiSyncs = assertTopLevelThreadSideThreadUiSyncs(testCase, topLevelThreadSideParentStatusChanges, secretProbe);
			final topLevelThreadSideThreadDiscards = assertTopLevelThreadSideThreadDiscards(testCase, topLevelThreadSideThreadUiSyncs, secretProbe);
			final topLevelThreadSideThreadStarts = assertTopLevelThreadSideThreadStarts(testCase, topLevelThreadSideThreadDiscards, secretProbe);
			final topLevelThreadSideThreadStartupRoutings = assertTopLevelThreadSideThreadStartupRoutings(testCase, topLevelThreadSideThreadStarts, secretProbe);
			final topLevelThreadSideThreadComposerHandoffs = assertTopLevelThreadSideThreadComposerHandoffs(testCase, topLevelThreadSideThreadStarts, topLevelThreadSideThreadStartupRoutings, secretProbe);
			final topLevelThreadSideThreadNavigationCleanups = assertTopLevelThreadSideThreadNavigationCleanups(testCase, topLevelThreadSideThreadComposerHandoffs, secretProbe);
			final topLevelActiveNonPrimaryShutdowns = assertTopLevelActiveNonPrimaryShutdowns(testCase, topLevelThreadSideThreadNavigationCleanups, secretProbe);
			final topLevelClearUiHeaders = assertTopLevelClearUiHeaders(testCase, topLevelActiveNonPrimaryShutdowns, secretProbe);
			final topLevelTerminalResizeReflows = assertTopLevelTerminalResizeReflows(testCase, topLevelClearUiHeaders, secretProbe);
			assertTopLevelResizeReflowSchedulings(testCase, topLevelTerminalResizeReflows, secretProbe);
			assertTopLevelFeedbackSubmissionRoutings(testCase, secretProbe);
			assertTopLevelTuiActiveTurnErrors(testCase, secretProbe);
			assertTopLevelFreshSessionServiceTiers(testCase, secretProbe);
			assertTopLevelFreshSessionPreviousConversationShutdowns(testCase, secretProbe);
			assertTopLevelInterruptWithoutActiveTurns(testCase, secretProbe);
			assertTopLevelOverrideTurnContextSettingsUpdates(testCase, secretProbe);
			assertTopLevelInactiveThreadSettingsNotifications(testCase, secretProbe);
			assertTopLevelClearOnlyUiResets(testCase, secretProbe);
			assertTopLevelClearOnlySkillWarningRerenders(testCase, secretProbe);
			assertTopLevelBacktrackEscVimInsertGuards(testCase, secretProbe);
			assertTopLevelSideConversationBacktrackEscVimGuards(testCase, secretProbe);
			assertTopLevelSideBacktrackUnavailableMessages(testCase, secretProbe);
			assertTopLevelInterruptBacktrackKeymaps(testCase, secretProbe);
			assertTopLevelInterruptQuestionNavigationKeymaps(testCase, secretProbe);
			assertTopLevelPagerTranscriptBacktrackKeymaps(testCase, secretProbe);
			assertTopLevelKeyParserCases(testCase, secretProbe);
			assertTopLevelKeymapAliases(testCase, secretProbe);
			assertTopLevelKeymapShadows(testCase, secretProbe);
			assertTopLevelKeymapBindingInputs(testCase, secretProbe);
			assertTopLevelKeymapDefaultPrunings(testCase, secretProbe);
			assertTopLevelKeymapOverlapConflicts(testCase, secretProbe);
			assertTopLevelKeymapVimOperatorTextObjects(testCase, secretProbe);
			assertTopLevelKeymapVimNormalDefaults(testCase, secretProbe);
			assertTopLevelKeymapInvalidGlobalCopies(testCase, secretProbe);
			assertTopLevelKeymapEditorAssignments(testCase, secretProbe);
			assertTopLevelKeymapMainSurfaceAssignments(testCase, secretProbe);
			assertTopLevelKeymapMainSurfaceConflicts(testCase, secretProbe);
			assertTopLevelKeymapComposerFixedShortcutConflicts(testCase, secretProbe);
			assertTopLevelKeymapEditorConflicts(testCase, secretProbe);
			assertTopLevelKeymapEditorUnbindConflicts(testCase, secretProbe);
			assertTopLevelKeymapPagerConflicts(testCase, secretProbe);
			assertTopLevelKeymapListConflicts(testCase, secretProbe);
			assertTopLevelKeymapApprovalConflicts(testCase, secretProbe);
			assertTopLevelKeymapFixedShortcuts(testCase, secretProbe);
			assertTopLevelBacktrackSelections(testCase, secretProbe);
			assertTopLevelBacktrackRollbacks(testCase, secretProbe);
			assertTopLevelCancelledTurnEdits(testCase, secretProbe);
			assertTopLevelBacktrackResubmits(testCase, secretProbe);
			assertTopLevelQueuedRollbackOverlaySyncs(testCase, secretProbe);
			assertTopLevelThreadRollbackResponseActiveQueueFlushes(testCase, secretProbe);
			assertPatchVerification(testCase, outcome);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>, envelopeRoot:Value, routeRoot:Value):Array<ModelStreamItemReducerRequest> {
		final out:Array<ModelStreamItemReducerRequest> = [];
		for (value in values) {
			final testCase = objectValue(value);
			out.push(new ModelStreamItemReducerRequest(
				stringField(testCase, "requestId", ""),
				routeRequest(testCase, envelopeRoot, routeRoot),
				itemEvents(arrayField(testCase, "events")),
				boolField(testCase, "planMode", false),
				boolField(testCase, "showRawReasoning", false),
				stringField(testCase, "secretProbe", "")
			));
		}
		return out;
	}

	static function routeRequest(testCase:Value, envelopeRoot:Value, routeRoot:Value):ModelStreamRouteRequest {
		final routeFixtureId = stringField(testCase, "routeFixtureId", "");
		if (routeFixtureId.length > 0) {
			for (value in arrayField(routeRoot, "cases")) {
				final routeCase = objectValue(value);
				if (stringField(routeCase, "id", "") == routeFixtureId) return ModelStreamRouteHarness.requests([routeCase], envelopeRoot)[0];
			}
			throw "missing stream route fixture case: " + routeFixtureId;
		}
		final route = objectField(testCase, "route");
		return new ModelStreamRouteRequest(
			stringField(route, "requestId", ""),
			ModelStreamRouteHarness.envelopeRequestById(envelopeRoot, stringField(route, "envelopeFixtureId", "")),
			stringField(route, "upstreamRequestId", ""),
			ModelStreamRouteHarness.events(arrayField(route, "events")),
			stringField(route, "secretProbe", "")
		);
	}

	static function itemEvents(values:Array<Value>):Array<ModelStreamItemFixtureEvent> {
		final out:Array<ModelStreamItemFixtureEvent> = [];
		for (value in values) {
			final event = objectValue(value);
			out.push(new ModelStreamItemFixtureEvent(
				eventKind(stringField(event, "kind", "")),
				outputItem(optionalField(event, "item")),
				stringField(event, "itemId", ""),
				stringField(event, "callId", ""),
				stringField(event, "delta", ""),
				intField(event, "summaryIndex", 0),
				intField(event, "contentIndex", 0),
				stringField(event, "responseId", ""),
				intField(event, "totalTokens", 0),
				boolField(event, "endTurn", false)
			));
		}
		return out;
	}

	static function outputItem(value:Value):ModelStreamOutputItem {
		return switch value {
			case JObject(_, _):
				new ModelStreamOutputItem(
					itemKind(stringField(value, "kind", "")),
					stringField(value, "itemId", ""),
					stringField(value, "role", ""),
					stringField(value, "text", ""),
					stringField(value, "phase", ""),
					stringArrayField(value, "summary"),
					stringArrayField(value, "rawContent"),
					stringField(value, "callId", ""),
					stringField(value, "toolName", ""),
					stringField(value, "namespace", ""),
					stringField(value, "arguments", ""),
					stringField(value, "customInput", ""),
					stringField(value, "status", "")
				);
			case _:
				null;
		}
	}

	static function eventKind(value:String):ModelStreamItemEventKind {
		return switch value {
			case "output_item_added": ModelStreamItemEventKind.OutputItemAdded;
			case "output_item_done": ModelStreamItemEventKind.OutputItemDone;
			case "output_text_delta": ModelStreamItemEventKind.OutputTextDelta;
			case "tool_call_input_delta": ModelStreamItemEventKind.ToolCallInputDelta;
			case "reasoning_summary_delta": ModelStreamItemEventKind.ReasoningSummaryDelta;
			case "reasoning_content_delta": ModelStreamItemEventKind.ReasoningContentDelta;
			case "completed": ModelStreamItemEventKind.Completed;
			case _: throw "invalid stream item event kind: " + value;
		}
	}

	static function itemKind(value:String):ModelStreamOutputItemKind {
		return switch value {
			case "assistant_message": ModelStreamOutputItemKind.AssistantMessage;
			case "reasoning": ModelStreamOutputItemKind.Reasoning;
			case "function_call": ModelStreamOutputItemKind.FunctionCall;
			case "custom_tool_call": ModelStreamOutputItemKind.CustomToolCall;
			case "web_search_call": ModelStreamOutputItemKind.WebSearchCall;
			case "image_generation_call": ModelStreamOutputItemKind.ImageGenerationCall;
			case "tool_output": ModelStreamOutputItemKind.ToolOutput;
			case "unknown": ModelStreamOutputItemKind.Unknown;
			case _: throw "invalid stream output item kind: " + value;
		}
	}

	static function assertReport(root:Value, report:ModelStreamItemReducerReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "toolCallCount", 0)), Std.string(report.toolCallCount()));
		assertEquals(Std.string(intField(expect, "toolInputDeltaCount", 0)), Std.string(report.toolInputDeltaCount()));
		assertEquals(Std.string(intField(expect, "toolInputDeltaIgnoredCount", 0)), Std.string(report.toolInputDeltaIgnoredCount()));
		assertEquals(Std.string(intField(expect, "toolArgumentDiffEventCount", 0)), Std.string(report.toolArgumentDiffEventCount()));
		assertEquals(Std.string(intField(expect, "assistantDeltaCount", 0)), Std.string(report.assistantDeltaCount()));
		assertEquals(Std.string(intField(expect, "reasoningDeltaCount", 0)), Std.string(report.reasoningDeltaCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function assertPatchVerification(testCase:Value, outcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome):Void {
		final verificationValue = optionalField(testCase, "patchVerification");
		switch verificationValue {
			case JObject(_, _):
				final expect = objectField(verificationValue, "expect");
				final beforeFiles = virtualFiles(arrayField(verificationValue, "files"));
				final verification = ModelPatchVerificationPolicy.verify(new ModelPatchVerificationRequest(
					stringField(verificationValue, "requestId", ""),
					outcome,
					stringField(verificationValue, "callId", ""),
					stringField(verificationValue, "turnId", ""),
					boolField(verificationValue, "autoApproved", false),
					patchApplyStatus(stringField(verificationValue, "desiredStatus", "completed")),
					stringField(verificationValue, "stdout", ""),
					stringField(verificationValue, "stderr", ""),
					beforeFiles,
					stringField(verificationValue, "secretProbe", "")
				));
				assertEquals(boolText(boolField(expect, "ok", false)), boolText(verification.ok));
				assertEquals(stringField(expect, "code", ""), verification.code);
				assertEquals(stringField(expect, "requestId", ""), verification.requestId);
				assertEquals(boolText(boolField(expect, "liveNetworkAttempted", false)), boolText(verification.liveNetworkAttempted));
				assertEquals(boolText(boolField(expect, "realFilesystemMutated", false)), boolText(verification.realFilesystemMutated));
				assertEquals(boolText(boolField(expect, "toolExecutedOutsideFixture", false)), boolText(verification.toolExecutedOutsideFixture));
				assertContains(verification.summary(), stringField(expect, "summaryContains", ""));
				final secretProbe = stringField(verificationValue, "secretProbe", "");
				if (secretProbe.length > 0) assertNotContains(verification.summary(), secretProbe);
				final application = assertPatchApplication(verificationValue, verification, beforeFiles, secretProbe);
				final approval = assertPatchApprovalDecision(verificationValue, verification, application, secretProbe);
				final tracker = assertPatchTurnDiffTracker(verificationValue, verification, application, approval, secretProbe);
				final projection = assertPatchProjection(verificationValue, verification, application, approval, tracker, secretProbe);
				final followUp = assertPatchToolFollowUp(verificationValue, outcome, application, projection, secretProbe);
				final responseInput = assertPatchToolResponseInput(verificationValue, followUp, secretProbe);
				final continuation = assertSamplingContinuation(verificationValue, responseInput, secretProbe);
				final assembly = assertSamplingInputAssembly(verificationValue, responseInput, continuation, secretProbe);
				final dispatch = assertSamplingDispatch(verificationValue, assembly, secretProbe);
				final attempts = assertSamplingStreamAttempts(verificationValue, dispatch, secretProbe);
				final handoffs = assertSamplingStreamEventHandoffs(verificationValue, outcome, attempts, secretProbe);
				final drains = assertInFlightToolDrains(verificationValue, responseInput, handoffs, secretProbe);
				final emissions = assertPostDrainEmissions(verificationValue, drains, secretProbe);
				final integrations = assertSamplingResultIntegrations(verificationValue, emissions, outcome, secretProbe);
				final pendingInputDrains = assertPostSamplingPendingInputDrains(verificationValue, integrations, secretProbe);
				final hookRecordings = assertPendingInputHookRecordings(verificationValue, pendingInputDrains, secretProbe);
				final promptPreparations = assertPromptPreparations(verificationValue, hookRecordings, secretProbe);
				final terminalStopHooks = assertTerminalStopHooks(verificationValue, integrations, promptPreparations, secretProbe);
				final samplingErrorTerminals = assertSamplingErrorTerminals(verificationValue, terminalStopHooks, secretProbe);
				final turnLifecycles = assertTurnLifecycles(verificationValue, terminalStopHooks, samplingErrorTerminals, secretProbe);
				final turnTerminalProjections = assertTurnTerminalProjections(verificationValue, turnLifecycles, secretProbe);
				final turnReplayReconstructions = assertTurnReplayReconstructions(verificationValue, turnTerminalProjections, secretProbe);
				final pendingInteractiveReplays = assertPendingInteractiveReplays(verificationValue, turnReplayReconstructions, secretProbe);
				final threadSnapshotReplayDispatches = assertThreadSnapshotReplayDispatches(verificationValue, pendingInteractiveReplays, secretProbe);
				assertThreadSnapshotTurnHistoryReplays(verificationValue, secretProbe);
				assertThreadSnapshotCollabMetadataReplays(verificationValue, secretProbe);
				assertThreadSnapshotSessionRefreshes(verificationValue, secretProbe);
				final replayedServerRequestSurfaces = assertReplayedServerRequestSurfaces(verificationValue, threadSnapshotReplayDispatches, secretProbe);
				final appServerRequestResolutions = assertAppServerRequestResolutions(verificationValue, replayedServerRequestSurfaces, secretProbe);
				final appServerResponseDispatches = assertAppServerResponseDispatches(verificationValue, appServerRequestResolutions, secretProbe);
				final appServerRequestEnqueues = assertAppServerRequestEnqueues(verificationValue, appServerResponseDispatches, secretProbe);
				final appServerQueuedRequestDeliveries = assertAppServerQueuedRequestDeliveries(verificationValue, appServerRequestEnqueues, secretProbe);
				final threadBufferedRequestEvictions = assertThreadBufferedRequestEvictions(verificationValue, appServerQueuedRequestDeliveries, secretProbe);
				final threadSessionRebases = assertThreadSessionRebases(verificationValue, threadBufferedRequestEvictions, secretProbe);
				final threadActiveTurns = assertThreadActiveTurns(verificationValue, threadSessionRebases, secretProbe);
				final threadSideParentPendingStatuses = assertThreadSideParentPendingStatuses(verificationValue, threadActiveTurns, secretProbe);
				final threadSideParentStatusChanges = assertThreadSideParentStatusChanges(verificationValue, threadSideParentPendingStatuses, secretProbe);
				final threadSideThreadUiSyncs = assertThreadSideThreadUiSyncs(verificationValue, threadSideParentStatusChanges, secretProbe);
				final threadSideThreadDiscards = assertThreadSideThreadDiscards(verificationValue, threadSideThreadUiSyncs, secretProbe);
				final threadSideThreadStarts = assertThreadSideThreadStarts(verificationValue, threadSideThreadDiscards, secretProbe);
				final threadSideThreadStartupRoutings = assertThreadSideThreadStartupRoutings(verificationValue, threadSideThreadStarts, secretProbe);
				final threadSideThreadComposerHandoffs = assertThreadSideThreadComposerHandoffs(verificationValue, threadSideThreadStarts, threadSideThreadStartupRoutings, secretProbe);
				final threadSideThreadNavigationCleanups = assertThreadSideThreadNavigationCleanups(verificationValue, threadSideThreadComposerHandoffs, secretProbe);
				final activeNonPrimaryShutdowns = assertActiveNonPrimaryShutdowns(verificationValue, threadSideThreadNavigationCleanups, secretProbe);
				final clearUiHeaders = assertClearUiHeaders(verificationValue, activeNonPrimaryShutdowns, secretProbe);
				final terminalResizeReflows = assertTerminalResizeReflows(verificationValue, clearUiHeaders, secretProbe);
				assertResizeReflowSchedulings(verificationValue, terminalResizeReflows, secretProbe);
				assertFeedbackSubmissionRoutings(verificationValue, secretProbe);
				assertTuiActiveTurnErrors(verificationValue, secretProbe);
				assertFreshSessionServiceTiers(verificationValue, secretProbe);
				assertFreshSessionPreviousConversationShutdowns(verificationValue, secretProbe);
				assertInterruptWithoutActiveTurns(verificationValue, secretProbe);
				assertOverrideTurnContextSettingsUpdates(verificationValue, secretProbe);
				assertInactiveThreadSettingsNotifications(verificationValue, secretProbe);
				assertClearOnlyUiResets(verificationValue, secretProbe);
				assertClearOnlySkillWarningRerenders(verificationValue, secretProbe);
				assertBacktrackEscVimInsertGuards(verificationValue, secretProbe);
				assertSideConversationBacktrackEscVimGuards(verificationValue, secretProbe);
				assertSideBacktrackUnavailableMessages(verificationValue, secretProbe);
				assertInterruptBacktrackKeymaps(verificationValue, secretProbe);
				assertInterruptQuestionNavigationKeymaps(verificationValue, secretProbe);
				assertPagerTranscriptBacktrackKeymaps(verificationValue, secretProbe);
				assertKeyParserCases(verificationValue, secretProbe);
				assertKeymapAliases(verificationValue, secretProbe);
				assertKeymapShadows(verificationValue, secretProbe);
				assertKeymapBindingInputs(verificationValue, secretProbe);
				assertKeymapDefaultPrunings(verificationValue, secretProbe);
				assertKeymapOverlapConflicts(verificationValue, secretProbe);
				assertKeymapVimOperatorTextObjects(verificationValue, secretProbe);
				assertKeymapVimNormalDefaults(verificationValue, secretProbe);
				assertKeymapInvalidGlobalCopies(verificationValue, secretProbe);
				assertKeymapEditorAssignments(verificationValue, secretProbe);
				assertKeymapMainSurfaceAssignments(verificationValue, secretProbe);
				assertKeymapMainSurfaceConflicts(verificationValue, secretProbe);
				assertKeymapComposerFixedShortcutConflicts(verificationValue, secretProbe);
				assertKeymapEditorConflicts(verificationValue, secretProbe);
				assertKeymapEditorUnbindConflicts(verificationValue, secretProbe);
				assertKeymapPagerConflicts(verificationValue, secretProbe);
				assertKeymapListConflicts(verificationValue, secretProbe);
				assertKeymapApprovalConflicts(verificationValue, secretProbe);
				assertKeymapFixedShortcuts(verificationValue, secretProbe);
				assertBacktrackSelections(verificationValue, secretProbe);
				assertBacktrackRollbacks(verificationValue, secretProbe);
				assertCancelledTurnEdits(verificationValue, secretProbe);
				assertBacktrackResubmits(verificationValue, secretProbe);
				assertQueuedRollbackOverlaySyncs(verificationValue, secretProbe);
				assertThreadRollbackResponseActiveQueueFlushes(verificationValue, secretProbe);
			case JNull:
			case _:
				throw "expected object field: patchVerification";
		}
	}

	static function assertPatchApplication(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		beforeFiles:Array<ModelPatchVirtualFile>,
		secretProbe:String
	):ModelPatchApplicationOutcome {
		final applicationExpectValue = optionalField(verificationValue, "applicationExpect");
		switch applicationExpectValue {
			case JObject(_, _):
				final application = ModelPatchApplicationPolicy.apply(new ModelPatchApplicationRequest(
					stringField(applicationExpectValue, "requestId", ""),
					verification,
					beforeFiles,
					secretProbe
				));
				assertEquals(boolText(boolField(applicationExpectValue, "ok", false)), boolText(application.ok));
				assertEquals(stringField(applicationExpectValue, "code", ""), application.code);
				assertEquals(stringField(applicationExpectValue, "requestId", ""), application.requestId);
				assertEquals(stringField(applicationExpectValue, "status", ""), application.status);
				assertEquals(boolText(boolField(applicationExpectValue, "liveNetworkAttempted", false)), boolText(application.liveNetworkAttempted));
				assertEquals(boolText(boolField(applicationExpectValue, "realFilesystemMutated", false)), boolText(application.realFilesystemMutated));
				assertEquals(boolText(boolField(applicationExpectValue, "toolExecutedOutsideFixture", false)), boolText(application.toolExecutedOutsideFixture));
				assertContains(application.summary(), stringField(applicationExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(application.summary(), secretProbe);
				return application;
			case JNull:
				return null;
			case _:
				throw "expected object field: applicationExpect";
		}
	}

	static function assertPatchApprovalDecision(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		secretProbe:String
	):ModelPatchApprovalDecisionOutcome {
		final approvalExpectValue = optionalField(verificationValue, "approvalExpect");
		switch approvalExpectValue {
			case JObject(_, _):
				final approval = ModelPatchApprovalDecisionPolicy.decide(new ModelPatchApprovalDecisionRequest(
					stringField(approvalExpectValue, "requestId", ""),
					verification,
					application,
					stringField(approvalExpectValue, "environmentId", ""),
					approvalRequirement(stringField(approvalExpectValue, "approvalRequirement", "skip")),
					boolField(approvalExpectValue, "permissionsPreapproved", false),
					stringField(approvalExpectValue, "additionalPermissionRoot", ""),
					stringField(approvalExpectValue, "retryReason", ""),
					boolField(approvalExpectValue, "sandboxApprovalAllowed", false),
					sandboxAttempt(stringField(approvalExpectValue, "sandboxAttempt", "none")),
					boolField(approvalExpectValue, "sandboxDenied", false),
					reviewDecision(stringField(approvalExpectValue, "reviewDecision", "denied")),
					secretProbe
				));
				assertEquals(boolText(boolField(approvalExpectValue, "ok", false)), boolText(approval.ok));
				assertEquals(stringField(approvalExpectValue, "code", ""), approval.code);
				assertEquals(stringField(approvalExpectValue, "requestId", ""), approval.requestId);
				assertEquals(boolText(boolField(approvalExpectValue, "approvalRequired", false)), boolText(approval.approvalRequired));
				assertEquals(boolText(boolField(approvalExpectValue, "approvalRequestEmitted", false)), boolText(approval.approvalRequestEmitted));
				assertEquals(boolText(boolField(approvalExpectValue, "canRun", false)), boolText(approval.canRun));
				assertEquals(boolText(boolField(approvalExpectValue, "sandboxRetryRequested", false)), boolText(approval.sandboxRetryRequested));
				assertEquals(boolText(boolField(approvalExpectValue, "liveNetworkAttempted", false)), boolText(approval.liveNetworkAttempted));
				assertEquals(boolText(boolField(approvalExpectValue, "realFilesystemMutated", false)), boolText(approval.realFilesystemMutated));
				assertEquals(boolText(boolField(approvalExpectValue, "toolExecutedOutsideFixture", false)), boolText(approval.toolExecutedOutsideFixture));
				assertContains(approval.summary(), stringField(approvalExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(approval.summary(), secretProbe);
				return approval;
			case JNull:
				return null;
			case _:
				throw "expected object field: approvalExpect";
		}
	}

	static function assertPatchTurnDiffTracker(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		approval:ModelPatchApprovalDecisionOutcome,
		secretProbe:String
	):ModelPatchTurnDiffTrackerOutcome {
		final trackerExpectValue = optionalField(verificationValue, "trackerExpect");
		switch trackerExpectValue {
			case JObject(_, _):
				final tracker = ModelPatchTurnDiffTrackerPolicy.update(new ModelPatchTurnDiffTrackerRequest(
					stringField(trackerExpectValue, "requestId", ""),
					verification,
					application,
					approval,
					stringField(trackerExpectValue, "environmentId", ""),
					toolEventStage(stringField(trackerExpectValue, "stage", "success")),
					new ModelPatchAppliedDelta(
						boolField(trackerExpectValue, "deltaKnown", false),
						boolField(trackerExpectValue, "deltaExact", false),
						boolField(trackerExpectValue, "deltaFromVerification", false) && verification != null && verification.endEvent != null ? verification.endEvent.changes : []
					),
					stringField(trackerExpectValue, "previousUnifiedDiff", ""),
					secretProbe
				));
				assertEquals(boolText(boolField(trackerExpectValue, "ok", false)), boolText(tracker.ok));
				assertEquals(stringField(trackerExpectValue, "code", ""), tracker.code);
				assertEquals(stringField(trackerExpectValue, "requestId", ""), tracker.requestId);
				assertEquals(stringField(trackerExpectValue, "updateKind", ""), tracker.updateKind);
				assertEquals(boolText(boolField(trackerExpectValue, "trackerValid", false)), boolText(tracker.trackerValid));
				assertEquals(boolText(boolField(trackerExpectValue, "shouldEmitTurnDiff", false)), boolText(tracker.shouldEmitTurnDiff));
				assertEquals(boolText(boolField(trackerExpectValue, "liveNetworkAttempted", false)), boolText(tracker.liveNetworkAttempted));
				assertEquals(boolText(boolField(trackerExpectValue, "realFilesystemMutated", false)), boolText(tracker.realFilesystemMutated));
				assertEquals(boolText(boolField(trackerExpectValue, "toolExecutedOutsideFixture", false)), boolText(tracker.toolExecutedOutsideFixture));
				assertContains(tracker.summary(), stringField(trackerExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(tracker.summary(), secretProbe);
				return tracker;
			case JNull:
				return null;
			case _:
				throw "expected object field: trackerExpect";
		}
	}

	static function assertPatchProjection(
		verificationValue:Value,
		verification:ModelPatchVerificationOutcome,
		application:ModelPatchApplicationOutcome,
		approval:ModelPatchApprovalDecisionOutcome,
		tracker:ModelPatchTurnDiffTrackerOutcome,
		secretProbe:String
	):codexhx.runtime.model.streamitem.ModelPatchProjectionOutcome {
		final projectionExpectValue = optionalField(verificationValue, "projectionExpect");
		switch projectionExpectValue {
			case JObject(_, _):
				final projection = ModelPatchProjectionPolicy.project(new ModelPatchProjectionRequest(
					stringField(projectionExpectValue, "requestId", ""),
					verification,
					application,
					approval,
					tracker,
					boolField(projectionExpectValue, "includeLegacyEvents", false),
					secretProbe
				));
				assertEquals(boolText(boolField(projectionExpectValue, "ok", false)), boolText(projection.ok));
				assertEquals(stringField(projectionExpectValue, "code", ""), projection.code);
				assertEquals(stringField(projectionExpectValue, "requestId", ""), projection.requestId);
				assertEquals(stringField(projectionExpectValue, "itemId", ""), projection.itemId);
				assertEquals(boolText(boolField(projectionExpectValue, "fileChangeItemProjected", false)), boolText(projection.fileChangeItemProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "legacyBeginProjected", false)), boolText(projection.legacyBeginProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "legacyEndProjected", false)), boolText(projection.legacyEndProjected));
				assertEquals(boolText(boolField(projectionExpectValue, "turnDiffProjected", false)), boolText(projection.turnDiffProjected));
				assertEquals(stringField(projectionExpectValue, "status", ""), projection.status);
				assertEquals(boolText(boolField(projectionExpectValue, "autoApproved", false)), boolText(projection.autoApproved));
				assertEquals(boolText(boolField(projectionExpectValue, "stdoutVisible", false)), boolText(projection.stdoutVisible));
				assertEquals(boolText(boolField(projectionExpectValue, "stderrVisible", false)), boolText(projection.stderrVisible));
				assertEquals(Std.string(intField(projectionExpectValue, "changeCount", 0)), Std.string(projection.changeCount));
				assertEquals(boolText(boolField(projectionExpectValue, "liveNetworkAttempted", false)), boolText(projection.liveNetworkAttempted));
				assertEquals(boolText(boolField(projectionExpectValue, "realFilesystemMutated", false)), boolText(projection.realFilesystemMutated));
				assertEquals(boolText(boolField(projectionExpectValue, "toolExecutedOutsideFixture", false)), boolText(projection.toolExecutedOutsideFixture));
				assertContains(projection.summary(), stringField(projectionExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(projection.summary(), secretProbe);
				return projection;
			case JNull:
				return null;
			case _:
				throw "expected object field: projectionExpect";
		}
	}

	static function assertPatchToolFollowUp(
		verificationValue:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		application:ModelPatchApplicationOutcome,
		projection:codexhx.runtime.model.streamitem.ModelPatchProjectionOutcome,
		secretProbe:String
	):ModelPatchToolFollowUpOutcome {
		final followUpExpectValue = optionalField(verificationValue, "toolFollowUpExpect");
		switch followUpExpectValue {
			case JObject(_, _):
				final followUp = ModelPatchToolFollowUpPolicy.build(new ModelPatchToolFollowUpRequest(
					stringField(followUpExpectValue, "requestId", ""),
					reducerOutcome,
					application,
					projection,
					secretProbe
				));
				assertEquals(boolText(boolField(followUpExpectValue, "ok", false)), boolText(followUp.ok));
				assertEquals(stringField(followUpExpectValue, "code", ""), followUp.code);
				assertEquals(stringField(followUpExpectValue, "requestId", ""), followUp.requestId);
				assertEquals(stringField(followUpExpectValue, "callId", ""), followUp.callId);
				assertEquals(stringField(followUpExpectValue, "responseKind", ""), followUp.responseKind);
				assertEquals(boolText(boolField(followUpExpectValue, "success", false)), boolText(followUp.success));
				assertEquals(boolText(boolField(followUpExpectValue, "followUpQueued", false)), boolText(followUp.followUpQueued));
				assertEquals(boolText(boolField(followUpExpectValue, "modelNeedsFollowUp", false)), boolText(followUp.modelNeedsFollowUp));
				assertEquals(boolText(boolField(followUpExpectValue, "postToolUseResponseVisible", false)), boolText(followUp.postToolUseResponseVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "stdoutVisible", false)), boolText(followUp.stdoutVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "stderrVisible", false)), boolText(followUp.stderrVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "resultTextVisible", false)), boolText(followUp.resultTextVisible));
				assertEquals(boolText(boolField(followUpExpectValue, "liveNetworkAttempted", false)), boolText(followUp.liveNetworkAttempted));
				assertEquals(boolText(boolField(followUpExpectValue, "realFilesystemMutated", false)), boolText(followUp.realFilesystemMutated));
				assertEquals(boolText(boolField(followUpExpectValue, "toolExecutedOutsideFixture", false)), boolText(followUp.toolExecutedOutsideFixture));
				assertContains(followUp.summary(), stringField(followUpExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(followUp.summary(), secretProbe);
				return followUp;
			case JNull:
				return null;
			case _:
				throw "expected object field: toolFollowUpExpect";
		}
	}

	static function assertPatchToolResponseInput(
		verificationValue:Value,
		followUp:ModelPatchToolFollowUpOutcome,
		secretProbe:String
	):ModelPatchToolResponseInputOutcome {
		final inputExpectValue = optionalField(verificationValue, "toolResponseInputExpect");
		switch inputExpectValue {
			case JObject(_, _):
				final input = ModelPatchToolResponseInputPolicy.admit(new ModelPatchToolResponseInputRequest(
					stringField(inputExpectValue, "requestId", ""),
					followUp,
					intField(inputExpectValue, "previousResponseCount", 0),
					secretProbe
				));
				assertEquals(boolText(boolField(inputExpectValue, "ok", false)), boolText(input.ok));
				assertEquals(stringField(inputExpectValue, "code", ""), input.code);
				assertEquals(stringField(inputExpectValue, "requestId", ""), input.requestId);
				assertEquals(stringField(inputExpectValue, "callId", ""), input.callId);
				assertEquals(stringField(inputExpectValue, "responseKind", ""), input.responseKind);
				assertEquals(stringField(inputExpectValue, "admissionKind", ""), input.admissionKind);
				assertEquals(Std.string(intField(inputExpectValue, "responseOrderIndex", 0)), Std.string(input.responseOrderIndex));
				assertEquals(Std.string(intField(inputExpectValue, "nextInputCount", 0)), Std.string(input.nextInputCount));
				assertEquals(boolText(boolField(inputExpectValue, "success", false)), boolText(input.success));
				assertEquals(boolText(boolField(inputExpectValue, "followUpRequestRequired", false)), boolText(input.followUpRequestRequired));
				assertEquals(boolText(boolField(inputExpectValue, "toolFutureDrained", false)), boolText(input.toolFutureDrained));
				assertEquals(boolText(boolField(inputExpectValue, "conversationItemRecorded", false)), boolText(input.conversationItemRecorded));
				assertEquals(boolText(boolField(inputExpectValue, "liveNetworkAttempted", false)), boolText(input.liveNetworkAttempted));
				assertEquals(boolText(boolField(inputExpectValue, "realFilesystemMutated", false)), boolText(input.realFilesystemMutated));
				assertEquals(boolText(boolField(inputExpectValue, "toolExecutedOutsideFixture", false)), boolText(input.toolExecutedOutsideFixture));
				assertContains(input.summary(), stringField(inputExpectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(input.summary(), secretProbe);
				return input;
			case JNull:
				return null;
			case _:
				throw "expected object field: toolResponseInputExpect";
		}
	}

	static function assertSamplingContinuation(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		secretProbe:String
	):ModelSamplingContinuationOutcome {
		final expectValue = optionalField(verificationValue, "samplingContinuationExpect");
		switch expectValue {
			case JObject(_, _):
				final continuation = ModelSamplingContinuationPolicy.plan(new ModelSamplingContinuationRequest(
					stringField(expectValue, "requestId", ""),
					responseInput,
					boolField(expectValue, "hasPendingInput", false),
					intField(expectValue, "pendingInputCount", 0),
					boolField(expectValue, "tokenLimitReached", false),
					intField(expectValue, "activeContextTokens", 0),
					intField(expectValue, "estimatedTokenCount", 0),
					intField(expectValue, "previousSamplingRequestCount", 0),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(continuation.ok));
				assertEquals(stringField(expectValue, "code", ""), continuation.code);
				assertEquals(stringField(expectValue, "requestId", ""), continuation.requestId);
				assertEquals(stringField(expectValue, "continuationKind", ""), continuation.continuationKind);
				assertEquals(boolText(boolField(expectValue, "modelNeedsFollowUp", false)), boolText(continuation.modelNeedsFollowUp));
				assertEquals(boolText(boolField(expectValue, "hasPendingInput", false)), boolText(continuation.hasPendingInput));
				assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(continuation.needsFollowUp));
				assertEquals(boolText(boolField(expectValue, "nextSamplingRequestRequired", false)), boolText(continuation.nextSamplingRequestRequired));
				assertEquals(boolText(boolField(expectValue, "responseInputCarried", false)), boolText(continuation.responseInputCarried));
				assertEquals(boolText(boolField(expectValue, "pendingInputDrainedBeforeNextRequest", false)), boolText(continuation.pendingInputDrainedBeforeNextRequest));
				assertEquals(boolText(boolField(expectValue, "autoCompactRequired", false)), boolText(continuation.autoCompactRequired));
				assertEquals(boolText(boolField(expectValue, "canDrainPendingInputBeforeNextRequest", false)), boolText(continuation.canDrainPendingInputBeforeNextRequest));
				assertEquals(Std.string(intField(expectValue, "admittedResponseInputCount", 0)), Std.string(continuation.admittedResponseInputCount));
				assertEquals(Std.string(intField(expectValue, "pendingInputCount", 0)), Std.string(continuation.pendingInputCount));
				assertEquals(Std.string(intField(expectValue, "nextSamplingInputCount", 0)), Std.string(continuation.nextSamplingInputCount));
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(continuation.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "activeContextTokens", 0)), Std.string(continuation.activeContextTokens));
				assertEquals(Std.string(intField(expectValue, "estimatedTokenCount", 0)), Std.string(continuation.estimatedTokenCount));
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(continuation.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(continuation.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(continuation.toolExecutedOutsideFixture));
				assertContains(continuation.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(continuation.summary(), secretProbe);
				return continuation;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingContinuationExpect";
		}
	}

	static function assertSamplingInputAssembly(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		continuation:ModelSamplingContinuationOutcome,
		secretProbe:String
	):ModelSamplingInputAssemblyOutcome {
		final expectValue = optionalField(verificationValue, "samplingInputAssemblyExpect");
		switch expectValue {
			case JObject(_, _):
				final assembly = ModelSamplingInputAssemblyPolicy.assemble(new ModelSamplingInputAssemblyRequest(
					stringField(expectValue, "requestId", ""),
					responseInput,
					continuation,
					samplingInputItems(arrayField(expectValue, "pendingInputItems")),
					intField(expectValue, "previousPromptItemCount", 0),
					boolField(expectValue, "modelSupportsImages", false),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(assembly.ok));
				assertEquals(stringField(expectValue, "code", ""), assembly.code);
				assertEquals(stringField(expectValue, "requestId", ""), assembly.requestId);
				assertEquals(stringField(expectValue, "continuationKind", ""), assembly.continuationKind);
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(assembly.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "previousPromptItemCount", 0)), Std.string(assembly.previousPromptItemCount));
				assertEquals(Std.string(intField(expectValue, "assembledItemCount", 0)), Std.string(assembly.assembledItemCount));
				assertEquals(Std.string(intField(expectValue, "nextPromptItemCount", 0)), Std.string(assembly.nextPromptItemCount));
				assertEquals(Std.string(intField(expectValue, "responseInputItemCount", 0)), Std.string(assembly.responseInputItemCount));
				assertEquals(Std.string(intField(expectValue, "pendingInputItemCount", 0)), Std.string(assembly.pendingInputItemCount));
				assertEquals(boolText(boolField(expectValue, "pendingInputDrained", false)), boolText(assembly.pendingInputDrained));
				assertEquals(boolText(boolField(expectValue, "historyClonedForPrompt", false)), boolText(assembly.historyClonedForPrompt));
				assertEquals(boolText(boolField(expectValue, "forPromptNormalized", false)), boolText(assembly.forPromptNormalized));
				assertEquals(boolText(boolField(expectValue, "modelSupportsImages", false)), boolText(assembly.modelSupportsImages));
				assertEquals(stringField(expectValue, "firstItemKind", ""), assembly.firstItemKind);
				assertEquals(stringField(expectValue, "lastItemKind", ""), assembly.lastItemKind);
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(assembly.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(assembly.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(assembly.toolExecutedOutsideFixture));
				assertContains(assembly.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(assembly.summary(), secretProbe);
				return assembly;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingInputAssemblyExpect";
		}
	}

	static function assertSamplingDispatch(
		verificationValue:Value,
		assembly:ModelSamplingInputAssemblyOutcome,
		secretProbe:String
	):ModelSamplingDispatchOutcome {
		final expectValue = optionalField(verificationValue, "samplingDispatchExpect");
		switch expectValue {
			case JObject(_, _):
				final dispatch = ModelSamplingDispatchPolicy.plan(new ModelSamplingDispatchRequest(
					stringField(expectValue, "requestId", ""),
					assembly,
					samplingDispatchTransportKind(stringField(expectValue, "requestedTransportKind", "responses_http")),
					stringField(expectValue, "windowId", ""),
					boolField(expectValue, "turnMetadataHeaderPresent", false),
					intField(expectValue, "maxRetries", 0),
					intField(expectValue, "previousDispatchCount", 0),
					boolField(expectValue, "modelClientSessionReused", false),
					boolField(expectValue, "stickyRoutingTokenPreserved", false),
					boolField(expectValue, "cancellationChildTokenCreated", false),
					boolField(expectValue, "liveProviderEnabled", false),
					secretProbe
				));
				assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(dispatch.ok));
				assertEquals(stringField(expectValue, "code", ""), dispatch.code);
				assertEquals(stringField(expectValue, "requestId", ""), dispatch.requestId);
				assertEquals(stringField(expectValue, "transportKind", ""), dispatch.transportKind);
				assertEquals(stringField(expectValue, "windowId", ""), dispatch.windowId);
				assertEquals(boolText(boolField(expectValue, "turnMetadataHeaderPresent", false)), boolText(dispatch.turnMetadataHeaderPresent));
				assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(dispatch.nextSamplingRequestIndex));
				assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(dispatch.promptItemCount));
				assertEquals(Std.string(intField(expectValue, "assembledItemCount", 0)), Std.string(dispatch.assembledItemCount));
				assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(dispatch.dispatchAttemptIndex));
				assertEquals(Std.string(intField(expectValue, "maxRetries", 0)), Std.string(dispatch.maxRetries));
				assertEquals(boolText(boolField(expectValue, "retryStateInitialized", false)), boolText(dispatch.retryStateInitialized));
				assertEquals(boolText(boolField(expectValue, "modelClientSessionTurnScoped", false)), boolText(dispatch.modelClientSessionTurnScoped));
				assertEquals(boolText(boolField(expectValue, "modelClientSessionReused", false)), boolText(dispatch.modelClientSessionReused));
				assertEquals(boolText(boolField(expectValue, "stickyRoutingTokenPreserved", false)), boolText(dispatch.stickyRoutingTokenPreserved));
				assertEquals(boolText(boolField(expectValue, "cancellationChildTokenCreated", false)), boolText(dispatch.cancellationChildTokenCreated));
				assertEquals(boolText(boolField(expectValue, "promptOrderingPreserved", false)), boolText(dispatch.promptOrderingPreserved));
				assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(dispatch.liveProviderRequestAttempted));
				assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(dispatch.providerStreamOpened));
				assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(dispatch.liveNetworkAttempted));
				assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(dispatch.realFilesystemMutated));
				assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(dispatch.toolExecutedOutsideFixture));
				assertContains(dispatch.summary(), stringField(expectValue, "summaryContains", ""));
				if (secretProbe.length > 0) assertNotContains(dispatch.summary(), secretProbe);
				return dispatch;
			case JNull:
				return null;
			case _:
				throw "expected object field: samplingDispatchExpect";
		}
	}

	static function assertSamplingStreamAttempts(
		verificationValue:Value,
		dispatch:ModelSamplingDispatchOutcome,
		secretProbe:String
	):Array<ModelSamplingStreamAttemptOutcome> {
		final attempts:Array<ModelSamplingStreamAttemptOutcome> = [];
		final values = arrayField(verificationValue, "samplingStreamAttemptExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final attempt = ModelSamplingStreamAttemptPolicy.evaluate(new ModelSamplingStreamAttemptRequest(
				stringField(expectValue, "requestId", ""),
				dispatch,
				samplingStreamErrorKind(stringField(expectValue, "errorKind", "none")),
				intField(expectValue, "currentRetryCount", 0),
				boolField(expectValue, "unauthorizedRecoveryAvailable", false),
				boolField(expectValue, "rateLimitUpdated", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(attempt.ok));
			assertEquals(stringField(expectValue, "code", ""), attempt.code);
			assertEquals(stringField(expectValue, "requestId", ""), attempt.requestId);
			assertEquals(stringField(expectValue, "resultKind", ""), attempt.resultKind);
			assertEquals(stringField(expectValue, "errorKind", ""), attempt.errorKind);
			assertEquals(boolText(boolField(expectValue, "retryable", false)), boolText(attempt.retryable));
			assertEquals(boolText(boolField(expectValue, "retryScheduled", false)), boolText(attempt.retryScheduled));
			assertEquals(Std.string(intField(expectValue, "retryCountBefore", 0)), Std.string(attempt.retryCountBefore));
			assertEquals(Std.string(intField(expectValue, "retryCountAfter", 0)), Std.string(attempt.retryCountAfter));
			assertEquals(Std.string(intField(expectValue, "maxRetries", 0)), Std.string(attempt.maxRetries));
			assertEquals(boolText(boolField(expectValue, "unauthorizedRetryStatePrepared", false)), boolText(attempt.unauthorizedRetryStatePrepared));
			assertEquals(boolText(boolField(expectValue, "contextWindowMarkedFull", false)), boolText(attempt.contextWindowMarkedFull));
			assertEquals(boolText(boolField(expectValue, "usageLimitRateLimitsUpdated", false)), boolText(attempt.usageLimitRateLimitsUpdated));
			assertEquals(boolText(boolField(expectValue, "terminal", false)), boolText(attempt.terminal));
			assertEquals(boolText(boolField(expectValue, "streamOpened", false)), boolText(attempt.streamOpened));
			assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(attempt.dispatchAttemptIndex));
			assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(attempt.promptItemCount));
			assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(attempt.liveProviderRequestAttempted));
			assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(attempt.providerStreamOpened));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(attempt.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(attempt.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(attempt.toolExecutedOutsideFixture));
			assertContains(attempt.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(attempt.summary(), secretProbe);
			attempts.push(attempt);
		}
		return attempts;
	}

	static function assertSamplingStreamEventHandoffs(
		verificationValue:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		attempts:Array<ModelSamplingStreamAttemptOutcome>,
		secretProbe:String
	):Array<ModelSamplingStreamEventHandoffOutcome> {
		final handoffs:Array<ModelSamplingStreamEventHandoffOutcome> = [];
		final values = optionalArrayField(verificationValue, "samplingStreamEventHandoffExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final handoff = ModelSamplingStreamEventHandoffPolicy.model(new ModelSamplingStreamEventHandoffRequest(
				stringField(expectValue, "requestId", ""),
				streamAttemptByRequestId(attempts, stringField(expectValue, "attemptRequestId", "")),
				reducerOutcome,
				boolField(expectValue, "streamClosedBeforeCompleted", false),
				intField(expectValue, "inFlightToolCount", 0),
				boolField(expectValue, "tokenCountPending", false),
				boolField(expectValue, "turnDiffPending", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(handoff.ok));
			assertEquals(stringField(expectValue, "code", ""), handoff.code);
			assertEquals(stringField(expectValue, "requestId", ""), handoff.requestId);
			assertEquals(stringField(expectValue, "handoffKind", ""), handoff.handoffKind);
			assertEquals(stringField(expectValue, "eventClass", ""), handoff.eventClass);
			assertEquals(stringField(expectValue, "attemptResultKind", ""), handoff.attemptResultKind);
			assertEquals(stringField(expectValue, "attemptErrorKind", ""), handoff.attemptErrorKind);
			assertEquals(boolText(boolField(expectValue, "terminal", false)), boolText(handoff.terminal));
			assertEquals(boolText(boolField(expectValue, "turnEnded", false)), boolText(handoff.turnEnded));
			assertEquals(boolText(boolField(expectValue, "continuationRequired", false)), boolText(handoff.continuationRequired));
			assertEquals(boolText(boolField(expectValue, "retryScheduled", false)), boolText(handoff.retryScheduled));
			assertEquals(boolText(boolField(expectValue, "unauthorizedRetryStatePrepared", false)), boolText(handoff.unauthorizedRetryStatePrepared));
			assertEquals(boolText(boolField(expectValue, "streamEventsConsumed", false)), boolText(handoff.streamEventsConsumed));
			assertEquals(boolText(boolField(expectValue, "responseCompleted", false)), boolText(handoff.responseCompleted));
			assertEquals(boolText(boolField(expectValue, "streamClosedBeforeCompleted", false)), boolText(handoff.streamClosedBeforeCompleted));
			assertEquals(boolText(boolField(expectValue, "toolDrainRequired", false)), boolText(handoff.toolDrainRequired));
			assertEquals(boolText(boolField(expectValue, "tokenCountEventDeferredUntilToolDrain", false)), boolText(handoff.tokenCountEventDeferredUntilToolDrain));
			assertEquals(boolText(boolField(expectValue, "turnDiffEventDeferredUntilToolDrain", false)), boolText(handoff.turnDiffEventDeferredUntilToolDrain));
			assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(handoff.needsFollowUp));
			assertEquals(stringField(expectValue, "terminalResponseId", ""), handoff.terminalResponseId);
			assertEquals(Std.string(intField(expectValue, "totalTokens", 0)), Std.string(handoff.totalTokens));
			assertEquals(stringField(expectValue, "lastAgentMessage", ""), handoff.lastAgentMessage);
			assertEquals(Std.string(intField(expectValue, "dispatchAttemptIndex", 0)), Std.string(handoff.dispatchAttemptIndex));
			assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(handoff.promptItemCount));
			assertEquals(boolText(boolField(expectValue, "liveProviderRequestAttempted", false)), boolText(handoff.liveProviderRequestAttempted));
			assertEquals(boolText(boolField(expectValue, "providerStreamOpened", false)), boolText(handoff.providerStreamOpened));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(handoff.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(handoff.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(handoff.toolExecutedOutsideFixture));
			assertContains(handoff.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(handoff.summary(), secretProbe);
			handoffs.push(handoff);
		}
		return handoffs;
	}

	static function streamAttemptByRequestId(attempts:Array<ModelSamplingStreamAttemptOutcome>, requestId:String):ModelSamplingStreamAttemptOutcome {
		for (attempt in attempts) if (attempt.requestId == requestId) return attempt;
		throw "missing stream attempt outcome: " + requestId;
	}

	static function assertInFlightToolDrains(
		verificationValue:Value,
		responseInput:ModelPatchToolResponseInputOutcome,
		handoffs:Array<ModelSamplingStreamEventHandoffOutcome>,
		secretProbe:String
	):Array<ModelInFlightToolDrainOutcome> {
		final drains:Array<ModelInFlightToolDrainOutcome> = [];
		final values = optionalArrayField(verificationValue, "inFlightToolDrainExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final drain = ModelInFlightToolDrainPolicy.drain(new ModelInFlightToolDrainRequest(
				stringField(expectValue, "requestId", ""),
				streamHandoffByRequestId(handoffs, stringField(expectValue, "handoffRequestId", "")),
				responseInput,
				inFlightDrainItems(arrayField(expectValue, "items")),
				boolField(expectValue, "tokenCountPending", false),
				boolField(expectValue, "turnDiffPending", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(drain.ok));
			assertEquals(stringField(expectValue, "code", ""), drain.code);
			assertEquals(stringField(expectValue, "requestId", ""), drain.requestId);
			assertEquals(stringField(expectValue, "drainKind", ""), drain.drainKind);
			assertEquals(Std.string(intField(expectValue, "itemCount", 0)), Std.string(drain.itemCount));
			assertEquals(Std.string(intField(expectValue, "drainedItemCount", 0)), Std.string(drain.drainedItemCount));
			assertEquals(Std.string(intField(expectValue, "convertedFailureCount", 0)), Std.string(drain.convertedFailureCount));
			assertEquals(Std.string(intField(expectValue, "fatalFailureCount", 0)), Std.string(drain.fatalFailureCount));
			assertEquals(boolText(boolField(expectValue, "responseOrderPreserved", false)), boolText(drain.responseOrderPreserved));
			assertEquals(boolText(boolField(expectValue, "conversationItemsRecorded", false)), boolText(drain.conversationItemsRecorded));
			assertEquals(boolText(boolField(expectValue, "memoryModePolluted", false)), boolText(drain.memoryModePolluted));
			assertEquals(boolText(boolField(expectValue, "toolBlockingTimingStarted", false)), boolText(drain.toolBlockingTimingStarted));
			assertEquals(boolText(boolField(expectValue, "drainCompletedBeforeTokenCount", false)), boolText(drain.drainCompletedBeforeTokenCount));
			assertEquals(boolText(boolField(expectValue, "drainCompletedBeforeTurnDiff", false)), boolText(drain.drainCompletedBeforeTurnDiff));
			assertEquals(boolText(boolField(expectValue, "tokenCountEmittedAfterDrain", false)), boolText(drain.tokenCountEmittedAfterDrain));
			assertEquals(boolText(boolField(expectValue, "turnDiffEmittedAfterDrain", false)), boolText(drain.turnDiffEmittedAfterDrain));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(drain.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(drain.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(drain.toolExecutedOutsideFixture));
			assertContains(drain.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(drain.summary(), secretProbe);
			drains.push(drain);
		}
		return drains;
	}

	static function assertPostDrainEmissions(
		verificationValue:Value,
		drains:Array<ModelInFlightToolDrainOutcome>,
		secretProbe:String
	):Array<ModelPostDrainEmissionOutcome> {
		final emissions:Array<ModelPostDrainEmissionOutcome> = [];
		final values = optionalArrayField(verificationValue, "postDrainEmissionExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final emission = ModelPostDrainEmissionPolicy.project(new ModelPostDrainEmissionRequest(
				stringField(expectValue, "requestId", ""),
				drainByRequestId(drains, stringField(expectValue, "drainRequestId", "")),
				boolField(expectValue, "cancellationRequestedAfterDrain", false),
				boolField(expectValue, "unifiedDiffAvailable", false),
				boolField(expectValue, "tokenInfoAvailable", false),
				secretProbe
			));
			assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(emission.ok));
			assertEquals(stringField(expectValue, "code", ""), emission.code);
			assertEquals(stringField(expectValue, "requestId", ""), emission.requestId);
			assertEquals(stringField(expectValue, "emissionKind", ""), emission.emissionKind);
			assertEquals(stringField(expectValue, "cancellationKind", ""), emission.cancellationKind);
			assertEquals(boolText(boolField(expectValue, "tokenCountPending", false)), boolText(emission.tokenCountPending));
			assertEquals(boolText(boolField(expectValue, "tokenCountProjected", false)), boolText(emission.tokenCountProjected));
			assertEquals(boolText(boolField(expectValue, "tokenInfoAvailable", false)), boolText(emission.tokenInfoAvailable));
			assertEquals(boolText(boolField(expectValue, "cancellationCheckedAfterTokenCount", false)), boolText(emission.cancellationCheckedAfterTokenCount));
			assertEquals(boolText(boolField(expectValue, "turnDiffPending", false)), boolText(emission.turnDiffPending));
			assertEquals(boolText(boolField(expectValue, "turnDiffTrackerRead", false)), boolText(emission.turnDiffTrackerRead));
			assertEquals(boolText(boolField(expectValue, "unifiedDiffAvailable", false)), boolText(emission.unifiedDiffAvailable));
			assertEquals(boolText(boolField(expectValue, "turnDiffProjected", false)), boolText(emission.turnDiffProjected));
			assertEquals(boolText(boolField(expectValue, "turnDiffSkippedByCancellation", false)), boolText(emission.turnDiffSkippedByCancellation));
			assertEquals(boolText(boolField(expectValue, "turnDiffSkippedNoDiff", false)), boolText(emission.turnDiffSkippedNoDiff));
			assertEquals(boolText(boolField(expectValue, "samplingOutcomeReturned", false)), boolText(emission.samplingOutcomeReturned));
			assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(emission.liveNetworkAttempted));
			assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(emission.realFilesystemMutated));
			assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(emission.toolExecutedOutsideFixture));
			assertContains(emission.summary(), stringField(expectValue, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(emission.summary(), secretProbe);
			emissions.push(emission);
		}
		return emissions;
	}

	static function drainByRequestId(drains:Array<ModelInFlightToolDrainOutcome>, requestId:String):ModelInFlightToolDrainOutcome {
		for (drain in drains) if (drain.requestId == requestId) return drain;
		throw "missing in-flight tool drain outcome: " + requestId;
	}

	static function assertTopLevelSamplingResultIntegrations(
		testCase:Value,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):Array<ModelSamplingResultIntegrationOutcome> {
		final integrations:Array<ModelSamplingResultIntegrationOutcome> = [];
		final values = optionalArrayField(testCase, "samplingResultIntegrationExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			final syntheticEmission = new ModelPostDrainEmissionOutcome(
				true,
				"post_drain_emission_modeled",
				stringField(expectValue, "postDrainRequestId", "synthetic-post-drain"),
				ModelPostDrainEmissionKind.NoEmission,
				ModelPostDrainCancellationKind.None,
				false,
				false,
				false,
				true,
				false,
				false,
				false,
				false,
				false,
				false,
				boolField(expectValue, "samplingOutcomeReturned", true),
				reducerOutcome.liveNetworkAttempted,
				false,
				false,
				""
			);
			integrations.push(assertSamplingResultIntegration(expectValue, syntheticEmission, reducerOutcome, secretProbe));
		}
		return integrations;
	}

	static function assertSamplingResultIntegrations(
		verificationValue:Value,
		emissions:Array<ModelPostDrainEmissionOutcome>,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):Array<ModelSamplingResultIntegrationOutcome> {
		final integrations:Array<ModelSamplingResultIntegrationOutcome> = [];
		final values = optionalArrayField(verificationValue, "samplingResultIntegrationExpects");
		for (value in values) {
			final expectValue = objectValue(value);
			integrations.push(assertSamplingResultIntegration(expectValue, postDrainEmissionByRequestId(emissions, stringField(expectValue, "postDrainRequestId", "")), reducerOutcome, secretProbe));
		}
		return integrations;
	}

	static function assertSamplingResultIntegration(
		expectValue:Value,
		emission:ModelPostDrainEmissionOutcome,
		reducerOutcome:codexhx.runtime.model.streamitem.ModelStreamItemReducerOutcome,
		secretProbe:String
	):ModelSamplingResultIntegrationOutcome {
		final integration = ModelSamplingResultIntegrationPolicy.integrate(new ModelSamplingResultIntegrationRequest(
			stringField(expectValue, "requestId", ""),
			emission,
			boolField(expectValue, "modelNeedsFollowUp", reducerOutcome.needsFollowUp),
			boolField(expectValue, "hasPendingInput", false),
			intField(expectValue, "pendingInputCount", 0),
			boolField(expectValue, "tokenLimitReached", false),
			stringField(expectValue, "lastAgentMessage", reducerOutcome.lastAgentMessage),
			stringField(expectValue, "previousLastAgentMessage", ""),
			samplingResultStatusKind(stringField(expectValue, "statusKind", "ok")),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(integration.ok));
		assertEquals(stringField(expectValue, "code", ""), integration.code);
		assertEquals(stringField(expectValue, "requestId", ""), integration.requestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), integration.decisionKind);
		assertEquals(stringField(expectValue, "statusKind", ""), integration.statusKind);
		assertEquals(boolText(boolField(expectValue, "needsFollowUp", false)), boolText(integration.needsFollowUp));
		assertEquals(boolText(boolField(expectValue, "pendingInputDrainEnabled", false)), boolText(integration.pendingInputDrainEnabled));
		assertEquals(boolText(boolField(expectValue, "canDrainPendingInputAfterAutoCompact", false)), boolText(integration.canDrainPendingInputAfterAutoCompact));
		assertEquals(boolText(boolField(expectValue, "lastAgentMessageUpdated", false)), boolText(integration.lastAgentMessageUpdated));
		assertEquals(stringField(expectValue, "integratedLastAgentMessage", ""), integration.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "samplingOutcomeReturned", false)), boolText(integration.samplingOutcomeReturned));
		assertEquals(boolText(boolField(expectValue, "stopHooksEligible", false)), boolText(integration.stopHooksEligible));
		assertEquals(boolText(boolField(expectValue, "continueLoop", false)), boolText(integration.continueLoop));
		assertEquals(boolText(boolField(expectValue, "breakTurnLoop", false)), boolText(integration.breakTurnLoop));
		assertEquals(boolText(boolField(expectValue, "bypassedForCancellation", false)), boolText(integration.bypassedForCancellation));
		assertEquals(boolText(boolField(expectValue, "bypassedForError", false)), boolText(integration.bypassedForError));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(integration.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(integration.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(integration.toolExecutedOutsideFixture));
		assertContains(integration.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(integration.summary(), secretProbe);
		return integration;
	}

	static function assertTopLevelPostSamplingPendingInputDrains(
		testCase:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):Array<ModelPostSamplingPendingInputDrainOutcome> {
		final drains:Array<ModelPostSamplingPendingInputDrainOutcome> = [];
		final values = optionalArrayField(testCase, "postSamplingPendingInputDrainExpects");
		for (value in values) drains.push(assertPostSamplingPendingInputDrain(objectValue(value), integrations, secretProbe));
		return drains;
	}

	static function assertPostSamplingPendingInputDrains(
		verificationValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):Array<ModelPostSamplingPendingInputDrainOutcome> {
		final drains:Array<ModelPostSamplingPendingInputDrainOutcome> = [];
		final values = optionalArrayField(verificationValue, "postSamplingPendingInputDrainExpects");
		for (value in values) drains.push(assertPostSamplingPendingInputDrain(objectValue(value), integrations, secretProbe));
		return drains;
	}

	static function assertPostSamplingPendingInputDrain(
		expectValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		secretProbe:String
	):ModelPostSamplingPendingInputDrainOutcome {
		final drain = ModelPostSamplingPendingInputDrainPolicy.drain(new ModelPostSamplingPendingInputDrainRequest(
			stringField(expectValue, "requestId", ""),
			samplingResultIntegrationByRequestId(integrations, stringField(expectValue, "integrationRequestId", "")),
			postSamplingPendingInputItems(optionalArrayField(expectValue, "activeTurnItems")),
			postSamplingPendingInputItems(optionalArrayField(expectValue, "mailboxItems")),
			boolField(expectValue, "acceptsMailboxDelivery", true),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(drain.ok));
		assertEquals(stringField(expectValue, "code", ""), drain.code);
		assertEquals(stringField(expectValue, "requestId", ""), drain.requestId);
		assertEquals(stringField(expectValue, "integrationRequestId", ""), drain.integrationRequestId);
		assertEquals(stringField(expectValue, "drainKind", ""), drain.drainKind);
		assertEquals(boolText(boolField(expectValue, "canDrainPendingInput", false)), boolText(drain.canDrainPendingInput));
		assertEquals(boolText(boolField(expectValue, "acceptsMailboxDelivery", true)), boolText(drain.acceptsMailboxDelivery));
		assertEquals(Std.string(intField(expectValue, "activeTurnItemCount", 0)), Std.string(drain.activeTurnItemCount));
		assertEquals(Std.string(intField(expectValue, "mailboxItemCount", 0)), Std.string(drain.mailboxItemCount));
		assertEquals(Std.string(intField(expectValue, "drainedItemCount", 0)), Std.string(drain.drainedItemCount));
		assertEquals(Std.string(intField(expectValue, "userInputRecordedCount", 0)), Std.string(drain.userInputRecordedCount));
		assertEquals(Std.string(intField(expectValue, "responseItemRecordedCount", 0)), Std.string(drain.responseItemRecordedCount));
		assertEquals(boolText(boolField(expectValue, "mailboxAppendedAfterActiveTurn", true)), boolText(drain.mailboxAppendedAfterActiveTurn));
		assertEquals(boolText(boolField(expectValue, "hookRecordingAttempted", false)), boolText(drain.hookRecordingAttempted));
		assertEquals(boolText(boolField(expectValue, "promptAssemblyAfterHooks", false)), boolText(drain.promptAssemblyAfterHooks));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(drain.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(drain.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(drain.toolExecutedOutsideFixture));
		assertContains(drain.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(drain.summary(), secretProbe);
		return drain;
	}

	static function assertTopLevelPendingInputHookRecordings(
		testCase:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):Array<ModelPendingInputHookRecordingOutcome> {
		final recordings:Array<ModelPendingInputHookRecordingOutcome> = [];
		final values = optionalArrayField(testCase, "pendingInputHookRecordingExpects");
		for (value in values) recordings.push(assertPendingInputHookRecording(objectValue(value), drains, secretProbe));
		return recordings;
	}

	static function assertPendingInputHookRecordings(
		verificationValue:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):Array<ModelPendingInputHookRecordingOutcome> {
		final recordings:Array<ModelPendingInputHookRecordingOutcome> = [];
		final values = optionalArrayField(verificationValue, "pendingInputHookRecordingExpects");
		for (value in values) recordings.push(assertPendingInputHookRecording(objectValue(value), drains, secretProbe));
		return recordings;
	}

	static function assertPendingInputHookRecording(
		expectValue:Value,
		drains:Array<ModelPostSamplingPendingInputDrainOutcome>,
		secretProbe:String
	):ModelPendingInputHookRecordingOutcome {
		final recording = ModelPendingInputHookRecordingPolicy.record(new ModelPendingInputHookRecordingRequest(
			stringField(expectValue, "requestId", ""),
			postSamplingPendingInputDrainByRequestId(drains, stringField(expectValue, "drainRequestId", "")),
			pendingInputHookRecordingItems(optionalArrayField(expectValue, "items")),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(recording.ok));
		assertEquals(stringField(expectValue, "code", ""), recording.code);
		assertEquals(stringField(expectValue, "requestId", ""), recording.requestId);
		assertEquals(stringField(expectValue, "drainRequestId", ""), recording.drainRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), recording.decisionKind);
		assertEquals(Std.string(intField(expectValue, "hookItemCount", 0)), Std.string(recording.hookItemCount));
		assertEquals(boolText(boolField(expectValue, "blockedInput", false)), boolText(recording.blockedInput));
		assertEquals(boolText(boolField(expectValue, "acceptedUserInput", false)), boolText(recording.acceptedUserInput));
		assertEquals(Std.string(intField(expectValue, "userInputRecordedCount", 0)), Std.string(recording.userInputRecordedCount));
		assertEquals(Std.string(intField(expectValue, "responseItemRecordedCount", 0)), Std.string(recording.responseItemRecordedCount));
		assertEquals(Std.string(intField(expectValue, "additionalContextRecordedCount", 0)), Std.string(recording.additionalContextRecordedCount));
		assertEquals(Std.string(intField(expectValue, "blockedAdditionalContextRecordedCount", 0)), Std.string(recording.blockedAdditionalContextRecordedCount));
		assertEquals(boolText(boolField(expectValue, "promptPrepContinues", false)), boolText(recording.promptPrepContinues));
		assertEquals(boolText(boolField(expectValue, "breakBeforePrompt", false)), boolText(recording.breakBeforePrompt));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(recording.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(recording.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(recording.toolExecutedOutsideFixture));
		assertContains(recording.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(recording.summary(), secretProbe);
		return recording;
	}

	static function assertTopLevelPromptPreparations(
		testCase:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):Array<ModelPromptPreparationOutcome> {
		final preparations:Array<ModelPromptPreparationOutcome> = [];
		final values = optionalArrayField(testCase, "promptPreparationExpects");
		for (value in values) preparations.push(assertPromptPreparation(objectValue(value), hookRecordings, secretProbe));
		return preparations;
	}

	static function assertPromptPreparations(
		verificationValue:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):Array<ModelPromptPreparationOutcome> {
		final preparations:Array<ModelPromptPreparationOutcome> = [];
		final values = optionalArrayField(verificationValue, "promptPreparationExpects");
		for (value in values) preparations.push(assertPromptPreparation(objectValue(value), hookRecordings, secretProbe));
		return preparations;
	}

	static function assertPromptPreparation(
		expectValue:Value,
		hookRecordings:Array<ModelPendingInputHookRecordingOutcome>,
		secretProbe:String
	):ModelPromptPreparationOutcome {
		final preparation = ModelPromptPreparationPolicy.prepare(new ModelPromptPreparationRequest(
			stringField(expectValue, "requestId", ""),
			pendingInputHookRecordingByRequestId(hookRecordings, stringField(expectValue, "hookRecordingRequestId", "")),
			intField(expectValue, "historyItemCount", 0),
			intField(expectValue, "imageItemCountBefore", 0),
			boolField(expectValue, "modelSupportsImages", false),
			stringField(expectValue, "windowId", ""),
			boolField(expectValue, "metadataHeaderEnabled", false),
			intField(expectValue, "nextSamplingRequestIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(preparation.ok));
		assertEquals(stringField(expectValue, "code", ""), preparation.code);
		assertEquals(stringField(expectValue, "requestId", ""), preparation.requestId);
		assertEquals(stringField(expectValue, "hookRecordingRequestId", ""), preparation.hookRecordingRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), preparation.decisionKind);
		assertEquals(boolText(boolField(expectValue, "promptPrepared", false)), boolText(preparation.promptPrepared));
		assertEquals(boolText(boolField(expectValue, "historyClonedForPrompt", false)), boolText(preparation.historyClonedForPrompt));
		assertEquals(boolText(boolField(expectValue, "forPromptNormalized", false)), boolText(preparation.forPromptNormalized));
		assertEquals(boolText(boolField(expectValue, "modelSupportsImages", false)), boolText(preparation.modelSupportsImages));
		assertEquals(Std.string(intField(expectValue, "imageItemCountBefore", 0)), Std.string(preparation.imageItemCountBefore));
		assertEquals(Std.string(intField(expectValue, "imageItemCountAfter", 0)), Std.string(preparation.imageItemCountAfter));
		assertEquals(Std.string(intField(expectValue, "promptItemCount", 0)), Std.string(preparation.promptItemCount));
		assertEquals(Std.string(intField(expectValue, "recordedPendingInputCount", 0)), Std.string(preparation.recordedPendingInputCount));
		assertEquals(Std.string(intField(expectValue, "nextSamplingRequestIndex", 0)), Std.string(preparation.nextSamplingRequestIndex));
		assertEquals(boolText(boolField(expectValue, "currentWindowIdRead", false)), boolText(preparation.currentWindowIdRead));
		assertEquals(stringField(expectValue, "expectedWindowId", stringField(expectValue, "windowId", "")), preparation.windowId);
		assertEquals(boolText(boolField(expectValue, "turnMetadataHeaderPresent", false)), boolText(preparation.turnMetadataHeaderPresent));
		assertEquals(boolText(boolField(expectValue, "dispatchPreconditionsMet", false)), boolText(preparation.dispatchPreconditionsMet));
		assertEquals(boolText(boolField(expectValue, "breakBeforePrompt", false)), boolText(preparation.breakBeforePrompt));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(preparation.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(preparation.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(preparation.toolExecutedOutsideFixture));
		assertContains(preparation.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(preparation.summary(), secretProbe);
		return preparation;
	}

	static function assertTopLevelTerminalStopHooks(
		testCase:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):Array<ModelTerminalStopHookOutcome> {
		final outcomes:Array<ModelTerminalStopHookOutcome> = [];
		final values = optionalArrayField(testCase, "terminalStopHookExpects");
		for (value in values) outcomes.push(assertTerminalStopHook(objectValue(value), integrations, promptPreparations, secretProbe));
		return outcomes;
	}

	static function assertTerminalStopHooks(
		verificationValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):Array<ModelTerminalStopHookOutcome> {
		final outcomes:Array<ModelTerminalStopHookOutcome> = [];
		final values = optionalArrayField(verificationValue, "terminalStopHookExpects");
		for (value in values) outcomes.push(assertTerminalStopHook(objectValue(value), integrations, promptPreparations, secretProbe));
		return outcomes;
	}

	static function assertTerminalStopHook(
		expectValue:Value,
		integrations:Array<ModelSamplingResultIntegrationOutcome>,
		promptPreparations:Array<ModelPromptPreparationOutcome>,
		secretProbe:String
	):ModelTerminalStopHookOutcome {
		final promptPrepId = stringField(expectValue, "promptPreparationRequestId", "");
		final outcome = ModelTerminalStopHookPolicy.run(new ModelTerminalStopHookRequest(
			stringField(expectValue, "requestId", ""),
			samplingResultIntegrationByRequestId(integrations, stringField(expectValue, "integrationRequestId", "")),
			promptPrepId.length == 0 ? null : promptPreparationByRequestId(promptPreparations, promptPrepId),
			terminalStopHookTargetKind(stringField(expectValue, "targetKind", "stop")),
			intField(expectValue, "previewRunCount", 0),
			intField(expectValue, "completedRunCount", 0),
			terminalStopHookRunStatusKind(stringField(expectValue, "completedRunStatusKind", "completed")),
			boolField(expectValue, "shouldBlock", false),
			intField(expectValue, "continuationFragmentCount", 0),
			boolField(expectValue, "continuationPromptRenderable", false),
			boolField(expectValue, "shouldStop", false),
			boolField(expectValue, "legacyAfterAgentEnabled", false),
			boolField(expectValue, "legacyAfterAgentAbort", false),
			boolField(expectValue, "stopHookAlreadyActive", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "integrationRequestId", ""), outcome.integrationRequestId);
		assertEquals(promptPrepId, outcome.promptPreparationRequestId);
		assertEquals(stringField(expectValue, "decisionKind", ""), outcome.decisionKind);
		assertEquals(stringField(expectValue, "targetKind", ""), outcome.targetKind);
		assertEquals(boolText(boolField(expectValue, "stopHooksEligible", false)), boolText(outcome.stopHooksEligible));
		assertEquals(boolText(boolField(expectValue, "stopHookDispatched", false)), boolText(outcome.stopHookDispatched));
		assertEquals(boolText(boolField(expectValue, "stopHookAlreadyActive", false)), boolText(outcome.stopHookAlreadyActive));
		assertEquals(Std.string(intField(expectValue, "previewRunCount", 0)), Std.string(outcome.previewRunCount));
		assertEquals(Std.string(intField(expectValue, "completedRunCount", 0)), Std.string(outcome.completedRunCount));
		assertEquals(stringField(expectValue, "completedRunStatusKind", ""), outcome.completedRunStatusKind);
		assertEquals(Std.string(intField(expectValue, "hookStartedEventsProjected", 0)), Std.string(outcome.hookStartedEventsProjected));
		assertEquals(Std.string(intField(expectValue, "hookCompletedEventsProjected", 0)), Std.string(outcome.hookCompletedEventsProjected));
		assertEquals(boolText(boolField(expectValue, "shouldBlock", false)), boolText(outcome.shouldBlock));
		assertEquals(Std.string(intField(expectValue, "continuationFragmentCount", 0)), Std.string(outcome.continuationFragmentCount));
		assertEquals(boolText(boolField(expectValue, "continuationPromptRecorded", false)), boolText(outcome.continuationPromptRecorded));
		assertEquals(boolText(boolField(expectValue, "warningEmitted", false)), boolText(outcome.warningEmitted));
		assertEquals(boolText(boolField(expectValue, "shouldStop", false)), boolText(outcome.shouldStop));
		assertEquals(boolText(boolField(expectValue, "legacyAfterAgentRan", false)), boolText(outcome.legacyAfterAgentRan));
		assertEquals(boolText(boolField(expectValue, "legacyAfterAgentAbort", false)), boolText(outcome.legacyAfterAgentAbort));
		assertEquals(stringField(expectValue, "lastAgentMessage", ""), outcome.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "continueLoop", false)), boolText(outcome.continueLoop));
		assertEquals(boolText(boolField(expectValue, "breakTurnLoop", false)), boolText(outcome.breakTurnLoop));
		assertEquals(boolText(boolField(expectValue, "errorEmitted", false)), boolText(outcome.errorEmitted));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelSamplingErrorTerminals(
		testCase:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		secretProbe:String
	):Array<ModelSamplingErrorTerminalOutcome> {
		final outcomes:Array<ModelSamplingErrorTerminalOutcome> = [];
		final values = optionalArrayField(testCase, "samplingErrorTerminalExpects");
		for (value in values) outcomes.push(assertSamplingErrorTerminal(objectValue(value), terminalStopHooks, secretProbe));
		return outcomes;
	}

	static function assertSamplingErrorTerminals(
		verificationValue:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		secretProbe:String
	):Array<ModelSamplingErrorTerminalOutcome> {
		final outcomes:Array<ModelSamplingErrorTerminalOutcome> = [];
		final values = optionalArrayField(verificationValue, "samplingErrorTerminalExpects");
		for (value in values) outcomes.push(assertSamplingErrorTerminal(objectValue(value), terminalStopHooks, secretProbe));
		return outcomes;
	}

	static function assertSamplingErrorTerminal(
		expectValue:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		secretProbe:String
	):ModelSamplingErrorTerminalOutcome {
		final stopHookId = stringField(expectValue, "terminalStopHookRequestId", "");
		final outcome = ModelSamplingErrorTerminalPolicy.handle(new ModelSamplingErrorTerminalRequest(
			stringField(expectValue, "requestId", ""),
			samplingErrorTerminalKind(stringField(expectValue, "errorKind", "generic_codex_error")),
			stringField(expectValue, "previousLastAgentMessage", ""),
			boolField(expectValue, "historyImagesReplaceable", false),
			stringField(expectValue, "errorMessage", ""),
			stringField(expectValue, "codexErrorInfo", ""),
			stopHookId.length == 0 ? null : terminalStopHookByRequestId(terminalStopHooks, stopHookId),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "errorKind", ""), outcome.errorKind);
		assertEquals(stringField(expectValue, "decisionKind", ""), outcome.decisionKind);
		assertEquals(stopHookId, outcome.terminalStopHookRequestId);
		assertEquals(boolText(boolField(expectValue, "stopHooksBypassed", false)), boolText(outcome.stopHooksBypassed));
		assertEquals(boolText(boolField(expectValue, "turnAborted", false)), boolText(outcome.turnAborted));
		assertEquals(boolText(boolField(expectValue, "invalidImageSanitizationAttempted", false)), boolText(outcome.invalidImageSanitizationAttempted));
		assertEquals(boolText(boolField(expectValue, "historyImagesReplaced", false)), boolText(outcome.historyImagesReplaced));
		assertEquals(boolText(boolField(expectValue, "retrySamplingLoop", false)), boolText(outcome.retrySamplingLoop));
		assertEquals(boolText(boolField(expectValue, "codexErrorTracked", false)), boolText(outcome.codexErrorTracked));
		assertEquals(boolText(boolField(expectValue, "lifecycleErrorEmitted", false)), boolText(outcome.lifecycleErrorEmitted));
		assertEquals(boolText(boolField(expectValue, "errorEventEmitted", false)), boolText(outcome.errorEventEmitted));
		assertEquals(stringField(expectValue, "expectedCodexErrorInfo", stringField(expectValue, "codexErrorInfo", "")), outcome.codexErrorInfo);
		assertEquals(boolText(boolField(expectValue, "lastAgentMessagePreserved", false)), boolText(outcome.lastAgentMessagePreserved));
		assertEquals(stringField(expectValue, "lastAgentMessage", ""), outcome.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "continueLoop", false)), boolText(outcome.continueLoop));
		assertEquals(boolText(boolField(expectValue, "breakTurnLoop", false)), boolText(outcome.breakTurnLoop));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelTurnLifecycles(
		testCase:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		samplingErrorTerminals:Array<ModelSamplingErrorTerminalOutcome>,
		secretProbe:String
	):Array<ModelTurnLifecycleOutcome> {
		final outcomes:Array<ModelTurnLifecycleOutcome> = [];
		final values = optionalArrayField(testCase, "turnLifecycleExpects");
		for (value in values) outcomes.push(assertTurnLifecycle(objectValue(value), terminalStopHooks, samplingErrorTerminals, secretProbe));
		return outcomes;
	}

	static function assertTurnLifecycles(
		verificationValue:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		samplingErrorTerminals:Array<ModelSamplingErrorTerminalOutcome>,
		secretProbe:String
	):Array<ModelTurnLifecycleOutcome> {
		final outcomes:Array<ModelTurnLifecycleOutcome> = [];
		final values = optionalArrayField(verificationValue, "turnLifecycleExpects");
		for (value in values) outcomes.push(assertTurnLifecycle(objectValue(value), terminalStopHooks, samplingErrorTerminals, secretProbe));
		return outcomes;
	}

	static function assertTurnLifecycle(
		expectValue:Value,
		terminalStopHooks:Array<ModelTerminalStopHookOutcome>,
		samplingErrorTerminals:Array<ModelSamplingErrorTerminalOutcome>,
		secretProbe:String
	):ModelTurnLifecycleOutcome {
		final stopHookId = stringField(expectValue, "terminalStopHookRequestId", "");
		final samplingErrorId = stringField(expectValue, "samplingErrorTerminalRequestId", "");
		final outcome = ModelTurnLifecyclePolicy.finish(new ModelTurnLifecycleRequest(
			stringField(expectValue, "requestId", ""),
			stringField(expectValue, "turnId", ""),
			turnLifecycleTerminalKind(stringField(expectValue, "terminalKind", "completed")),
			stopHookId.length == 0 ? null : terminalStopHookByRequestId(terminalStopHooks, stopHookId),
			samplingErrorId.length == 0 ? null : samplingErrorTerminalByRequestId(samplingErrorTerminals, samplingErrorId),
			stringField(expectValue, "lastAgentMessageInput", ""),
			stringField(expectValue, "abortReason", ""),
			boolField(expectValue, "taskCancellationRequested", false),
			boolField(expectValue, "rolloutFlushOk", true),
			boolField(expectValue, "activeTurnMatches", true),
			boolField(expectValue, "hasPendingTriggerMailbox", false),
			boolField(expectValue, "interruptedMarkerEligible", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "turnId", ""), outcome.turnId);
		assertEquals(stringField(expectValue, "terminalKind", ""), outcome.terminalKind);
		assertEquals(stringField(expectValue, "projectedEventKind", ""), outcome.projectedEventKind);
		assertEquals(stopHookId, outcome.terminalStopHookRequestId);
		assertEquals(samplingErrorId, outcome.samplingErrorTerminalRequestId);
		assertEquals(boolText(boolField(expectValue, "rolloutFlushedBeforeTerminal", false)), boolText(outcome.rolloutFlushedBeforeTerminal));
		assertEquals(boolText(boolField(expectValue, "rolloutWarningEmitted", false)), boolText(outcome.rolloutWarningEmitted));
		assertEquals(boolText(boolField(expectValue, "turnStopLifecycleEmitted", false)), boolText(outcome.turnStopLifecycleEmitted));
		assertEquals(boolText(boolField(expectValue, "turnAbortLifecycleEmitted", false)), boolText(outcome.turnAbortLifecycleEmitted));
		assertEquals(boolText(boolField(expectValue, "turnErrorLifecycleAlreadyEmitted", false)), boolText(outcome.turnErrorLifecycleAlreadyEmitted));
		assertEquals(boolText(boolField(expectValue, "turnCompleteEmitted", false)), boolText(outcome.turnCompleteEmitted));
		assertEquals(boolText(boolField(expectValue, "turnAbortedEmitted", false)), boolText(outcome.turnAbortedEmitted));
		assertEquals(boolText(boolField(expectValue, "completionSuppressedForCancellation", false)), boolText(outcome.completionSuppressedForCancellation));
		assertEquals(boolText(boolField(expectValue, "completedAfterError", false)), boolText(outcome.completedAfterError));
		assertEquals(boolText(boolField(expectValue, "interruptedMarkerRecorded", false)), boolText(outcome.interruptedMarkerRecorded));
		assertEquals(boolText(boolField(expectValue, "lastAgentMessageCarried", false)), boolText(outcome.lastAgentMessageCarried));
		assertEquals(stringField(expectValue, "lastAgentMessage", ""), outcome.lastAgentMessage);
		assertEquals(boolText(boolField(expectValue, "activeTurnCleared", false)), boolText(outcome.activeTurnCleared));
		assertEquals(boolText(boolField(expectValue, "threadIdleLifecycleEmitted", false)), boolText(outcome.threadIdleLifecycleEmitted));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelTurnTerminalProjections(
		testCase:Value,
		lifecycles:Array<ModelTurnLifecycleOutcome>,
		secretProbe:String
	):Array<ModelTurnTerminalProjectionOutcome> {
		final outcomes:Array<ModelTurnTerminalProjectionOutcome> = [];
		final values = optionalArrayField(testCase, "turnTerminalProjectionExpects");
		for (value in values) outcomes.push(assertTurnTerminalProjection(objectValue(value), lifecycles, secretProbe));
		return outcomes;
	}

	static function assertTurnTerminalProjections(
		verificationValue:Value,
		lifecycles:Array<ModelTurnLifecycleOutcome>,
		secretProbe:String
	):Array<ModelTurnTerminalProjectionOutcome> {
		final outcomes:Array<ModelTurnTerminalProjectionOutcome> = [];
		final values = optionalArrayField(verificationValue, "turnTerminalProjectionExpects");
		for (value in values) outcomes.push(assertTurnTerminalProjection(objectValue(value), lifecycles, secretProbe));
		return outcomes;
	}

	static function assertTurnTerminalProjection(
		expectValue:Value,
		lifecycles:Array<ModelTurnLifecycleOutcome>,
		secretProbe:String
	):ModelTurnTerminalProjectionOutcome {
		final lifecycleRequestId = stringField(expectValue, "lifecycleRequestId", "");
		final outcome = ModelTurnTerminalProjectionPolicy.project(new ModelTurnTerminalProjectionRequest(
			stringField(expectValue, "requestId", ""),
			stringField(expectValue, "threadId", ""),
			stringField(expectValue, "turnId", ""),
			turnLifecycleByRequestId(lifecycles, lifecycleRequestId),
			turnTerminalProjectionEventKind(stringField(expectValue, "eventKind", "turn_complete")),
			stringField(expectValue, "priorTurnErrorMessage", ""),
			stringField(expectValue, "lastAgentMessageOverride", ""),
			stringField(expectValue, "abortReason", ""),
			boolField(expectValue, "pendingInterruptRequest", false),
			boolField(expectValue, "fromReplay", false),
			boolField(expectValue, "hasQueuedFollowUp", false),
			boolField(expectValue, "activeGoalContinuing", false),
			boolField(expectValue, "sawCopySourceThisTurn", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "threadId", ""), outcome.threadId);
		assertEquals(stringField(expectValue, "turnId", ""), outcome.turnId);
		assertEquals(lifecycleRequestId, outcome.lifecycleRequestId);
		assertEquals(stringField(expectValue, "eventKind", ""), outcome.eventKind);
		assertEquals(stringField(expectValue, "coreAgentStatusKind", ""), outcome.coreAgentStatusKind);
		assertEquals(stringField(expectValue, "appTurnStatusKind", ""), outcome.appTurnStatusKind);
		assertEquals(stringField(expectValue, "appServerNotificationIntentKind", ""), outcome.appServerNotificationIntentKind);
		assertEquals(stringField(expectValue, "tuiNotificationIntentKind", ""), outcome.tuiNotificationIntentKind);
		assertEquals(boolText(boolField(expectValue, "pendingServerRequestsAborted", false)), boolText(outcome.pendingServerRequestsAborted));
		assertEquals(boolText(boolField(expectValue, "pendingInterruptsResolved", false)), boolText(outcome.pendingInterruptsResolved));
		assertEquals(boolText(boolField(expectValue, "threadStatusCleared", false)), boolText(outcome.threadStatusCleared));
		assertEquals(boolText(boolField(expectValue, "threadHistoryTurnClosed", false)), boolText(outcome.threadHistoryTurnClosed));
		assertEquals(boolText(boolField(expectValue, "threadHistoryFailedStatusPreserved", false)), boolText(outcome.threadHistoryFailedStatusPreserved));
		assertEquals(boolText(boolField(expectValue, "turnCompletedNotificationEmitted", false)), boolText(outcome.turnCompletedNotificationEmitted));
		assertEquals(boolText(boolField(expectValue, "appServerTurnFailedRecorded", false)), boolText(outcome.appServerTurnFailedRecorded));
		assertEquals(boolText(boolField(expectValue, "lastAgentMessagePropagatedToCoreStatus", false)), boolText(outcome.lastAgentMessagePropagatedToCoreStatus));
		assertEquals(boolText(boolField(expectValue, "collabAgentStateHasMessage", false)), boolText(outcome.collabAgentStateHasMessage));
		assertEquals(boolText(boolField(expectValue, "tuiReceivesLastAgentMessageFromTurnNotification", false)), boolText(outcome.tuiReceivesLastAgentMessageFromTurnNotification));
		assertEquals(boolText(boolField(expectValue, "tuiNotificationResponseUsesCopySource", false)), boolText(outcome.tuiNotificationResponseUsesCopySource));
		assertEquals(boolText(boolField(expectValue, "tuiTaskCompletionHandled", false)), boolText(outcome.tuiTaskCompletionHandled));
		assertEquals(boolText(boolField(expectValue, "tuiInterruptedHandled", false)), boolText(outcome.tuiInterruptedHandled));
		assertEquals(boolText(boolField(expectValue, "tuiErrorHandled", false)), boolText(outcome.tuiErrorHandled));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelTurnReplayReconstructions(
		testCase:Value,
		projections:Array<ModelTurnTerminalProjectionOutcome>,
		secretProbe:String
	):Array<ModelTurnReplayReconstructionOutcome> {
		final outcomes:Array<ModelTurnReplayReconstructionOutcome> = [];
		final values = optionalArrayField(testCase, "turnReplayReconstructionExpects");
		for (value in values) outcomes.push(assertTurnReplayReconstruction(objectValue(value), projections, secretProbe));
		return outcomes;
	}

	static function assertTurnReplayReconstructions(
		verificationValue:Value,
		projections:Array<ModelTurnTerminalProjectionOutcome>,
		secretProbe:String
	):Array<ModelTurnReplayReconstructionOutcome> {
		final outcomes:Array<ModelTurnReplayReconstructionOutcome> = [];
		final values = optionalArrayField(verificationValue, "turnReplayReconstructionExpects");
		for (value in values) outcomes.push(assertTurnReplayReconstruction(objectValue(value), projections, secretProbe));
		return outcomes;
	}

	static function assertTurnReplayReconstruction(
		expectValue:Value,
		projections:Array<ModelTurnTerminalProjectionOutcome>,
		secretProbe:String
	):ModelTurnReplayReconstructionOutcome {
		final projectionRequestId = stringField(expectValue, "projectionRequestId", "");
		final outcome = ModelTurnReplayReconstructionPolicy.reconstruct(new ModelTurnReplayReconstructionRequest(
			stringField(expectValue, "requestId", ""),
			turnTerminalProjectionByRequestId(projections, projectionRequestId),
			turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")),
			turnReplayTargetKind(stringField(expectValue, "targetKind", "active_exact")),
			stringField(expectValue, "activeTurnId", ""),
			stringField(expectValue, "historicalTurnId", ""),
			stringField(expectValue, "terminalTurnId", ""),
			boolField(expectValue, "activeTurnPresent", false),
			boolField(expectValue, "turnWasInProgress", false),
			boolField(expectValue, "replayTurnHasItems", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(projectionRequestId, outcome.projectionRequestId);
		assertEquals(stringField(expectValue, "replayKind", ""), outcome.replayKind);
		assertEquals(stringField(expectValue, "targetKind", ""), outcome.targetKind);
		assertEquals(stringField(expectValue, "terminalTurnId", ""), outcome.terminalTurnId);
		assertEquals(stringField(expectValue, "reconstructedStatusKind", ""), outcome.reconstructedStatusKind);
		assertEquals(boolText(boolField(expectValue, "currentTurnClosed", false)), boolText(outcome.currentTurnClosed));
		assertEquals(boolText(boolField(expectValue, "currentTurnMarkedTerminal", false)), boolText(outcome.currentTurnMarkedTerminal));
		assertEquals(boolText(boolField(expectValue, "historicalTurnUpdated", false)), boolText(outcome.historicalTurnUpdated));
		assertEquals(boolText(boolField(expectValue, "activeTurnPreserved", false)), boolText(outcome.activeTurnPreserved));
		assertEquals(boolText(boolField(expectValue, "fallbackAppliedToActive", false)), boolText(outcome.fallbackAppliedToActive));
		assertEquals(boolText(boolField(expectValue, "missingTerminalNoop", false)), boolText(outcome.missingTerminalNoop));
		assertEquals(boolText(boolField(expectValue, "failedStatusPreserved", false)), boolText(outcome.failedStatusPreserved));
		assertEquals(boolText(boolField(expectValue, "replayTurnCompletedNotificationSynthesized", false)), boolText(outcome.replayTurnCompletedNotificationSynthesized));
		assertEquals(boolText(boolField(expectValue, "tuiReplayKindAttached", false)), boolText(outcome.tuiReplayKindAttached));
		assertEquals(boolText(boolField(expectValue, "tuiTaskStartedForInProgress", false)), boolText(outcome.tuiTaskStartedForInProgress));
		assertEquals(boolText(boolField(expectValue, "resumeInitialStartSuppressed", false)), boolText(outcome.resumeInitialStartSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveOnlyReplayEffectsSuppressed", false)), boolText(outcome.liveOnlyReplayEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "lastAgentMessageRemainsProjectionOnly", false)), boolText(outcome.lastAgentMessageRemainsProjectionOnly));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelPendingInteractiveReplays(
		testCase:Value,
		reconstructions:Array<ModelTurnReplayReconstructionOutcome>,
		secretProbe:String
	):Array<ModelPendingInteractiveReplayOutcome> {
		final outcomes:Array<ModelPendingInteractiveReplayOutcome> = [];
		final values = optionalArrayField(testCase, "pendingInteractiveReplayExpects");
		for (value in values) outcomes.push(assertPendingInteractiveReplay(objectValue(value), reconstructions, secretProbe));
		return outcomes;
	}

	static function assertPendingInteractiveReplays(
		verificationValue:Value,
		reconstructions:Array<ModelTurnReplayReconstructionOutcome>,
		secretProbe:String
	):Array<ModelPendingInteractiveReplayOutcome> {
		final outcomes:Array<ModelPendingInteractiveReplayOutcome> = [];
		final values = optionalArrayField(verificationValue, "pendingInteractiveReplayExpects");
		for (value in values) outcomes.push(assertPendingInteractiveReplay(objectValue(value), reconstructions, secretProbe));
		return outcomes;
	}

	static function assertPendingInteractiveReplay(
		expectValue:Value,
		reconstructions:Array<ModelTurnReplayReconstructionOutcome>,
		secretProbe:String
	):ModelPendingInteractiveReplayOutcome {
		final reconstructionRequestId = stringField(expectValue, "reconstructionRequestId", "");
		final outcome = ModelPendingInteractiveReplayPolicy.route(new ModelPendingInteractiveReplayRequest(
			stringField(expectValue, "requestId", ""),
			reconstructionRequestId.length == 0 ? null : turnReplayReconstructionByRequestId(reconstructions, reconstructionRequestId),
			pendingInteractiveReplayEventKind(stringField(expectValue, "eventKind", "snapshot")),
			pendingInteractivePromptKind(stringField(expectValue, "promptKind", "none")),
			stringField(expectValue, "turnId", ""),
			stringField(expectValue, "activeTurnIdBefore", ""),
			stringField(expectValue, "restoredInProgressTurnId", ""),
			intField(expectValue, "pendingPromptCountBefore", 0),
			intField(expectValue, "pendingPromptCountForTurnBefore", 0),
			boolField(expectValue, "requestMatchesPendingPrompt", false),
			boolField(expectValue, "outboundOpCanChangeState", false),
			boolField(expectValue, "outboundOpMatchesPrompt", false),
			boolField(expectValue, "terminalMatchesActiveTurn", false),
			boolField(expectValue, "snapshotRequested", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(reconstructionRequestId, outcome.reconstructionRequestId);
		assertEquals(stringField(expectValue, "eventKind", ""), outcome.eventKind);
		assertEquals(stringField(expectValue, "promptKind", ""), outcome.promptKind);
		assertEquals(boolText(boolField(expectValue, "restoredActiveTurnDetected", false)), boolText(outcome.restoredActiveTurnDetected));
		assertEquals(stringField(expectValue, "activeTurnIdAfter", ""), outcome.activeTurnIdAfter);
		assertEquals(boolText(boolField(expectValue, "activeTurnCleared", false)), boolText(outcome.activeTurnCleared));
		assertEquals(boolText(boolField(expectValue, "nonmatchingCompletionPreservedActive", false)), boolText(outcome.nonmatchingCompletionPreservedActive));
		assertEquals(boolText(boolField(expectValue, "promptRecorded", false)), boolText(outcome.promptRecorded));
		assertEquals(boolText(boolField(expectValue, "promptRemovedByTurnCompletion", false)), boolText(outcome.promptRemovedByTurnCompletion));
		assertEquals(boolText(boolField(expectValue, "promptRemovedByOutboundOp", false)), boolText(outcome.promptRemovedByOutboundOp));
		assertEquals(boolText(boolField(expectValue, "promptRemovedByResolution", false)), boolText(outcome.promptRemovedByResolution));
		assertEquals(boolText(boolField(expectValue, "promptRemovedByEviction", false)), boolText(outcome.promptRemovedByEviction));
		assertEquals(boolText(boolField(expectValue, "pendingReplayCleared", false)), boolText(outcome.pendingReplayCleared));
		assertEquals(boolText(boolField(expectValue, "snapshotRequestReplayed", false)), boolText(outcome.snapshotRequestReplayed));
		assertEquals(boolText(boolField(expectValue, "snapshotRequestFiltered", false)), boolText(outcome.snapshotRequestFiltered));
		assertEquals(boolText(boolField(expectValue, "replayedTurnCompletedHandled", false)), boolText(outcome.replayedTurnCompletedHandled));
		assertEquals(boolText(boolField(expectValue, "replayUsesThreadSnapshotKind", false)), boolText(outcome.replayUsesThreadSnapshotKind));
		assertEquals(stringField(expectValue, "sideStatusKind", ""), outcome.sideStatusKind);
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadSnapshotReplayDispatches(
		testCase:Value,
		pendingReplays:Array<ModelPendingInteractiveReplayOutcome>,
		secretProbe:String
	):Array<ModelThreadSnapshotReplayDispatchOutcome> {
		final outcomes:Array<ModelThreadSnapshotReplayDispatchOutcome> = [];
		final values = optionalArrayField(testCase, "threadSnapshotReplayDispatchExpects");
		for (value in values) outcomes.push(assertThreadSnapshotReplayDispatch(objectValue(value), pendingReplays, secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotReplayDispatches(
		verificationValue:Value,
		pendingReplays:Array<ModelPendingInteractiveReplayOutcome>,
		secretProbe:String
	):Array<ModelThreadSnapshotReplayDispatchOutcome> {
		final outcomes:Array<ModelThreadSnapshotReplayDispatchOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSnapshotReplayDispatchExpects");
		for (value in values) outcomes.push(assertThreadSnapshotReplayDispatch(objectValue(value), pendingReplays, secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotReplayDispatch(
		expectValue:Value,
		pendingReplays:Array<ModelPendingInteractiveReplayOutcome>,
		secretProbe:String
	):ModelThreadSnapshotReplayDispatchOutcome {
		final pendingReplayRequestId = stringField(expectValue, "pendingReplayRequestId", "");
		final outcome = ModelThreadSnapshotReplayDispatchPolicy.dispatch(new ModelThreadSnapshotReplayDispatchRequest(
			stringField(expectValue, "requestId", ""),
			pendingReplayRequestId.length == 0 ? null : pendingInteractiveReplayByRequestId(pendingReplays, pendingReplayRequestId),
			turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")),
			threadSnapshotReplayEventKind(stringField(expectValue, "eventKind", "replay_turns")),
			intField(expectValue, "turnCount", 0),
			intField(expectValue, "bufferedEventCount", 0),
			boolField(expectValue, "terminalResizeReflowEnabled", false),
			boolField(expectValue, "inputStateAvailable", false),
			boolField(expectValue, "suppressReplayNotices", false),
			boolField(expectValue, "eventIsNotice", false),
			boolField(expectValue, "snapshotRequestAllowed", false),
			intField(expectValue, "pendingPrimaryEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(pendingReplayRequestId, outcome.pendingReplayRequestId);
		assertEquals(stringField(expectValue, "replayKind", ""), outcome.replayKind);
		assertEquals(stringField(expectValue, "eventKind", ""), outcome.eventKind);
		assertEquals(stringField(expectValue, "dispatchKind", ""), outcome.dispatchKind);
		assertEquals(boolText(boolField(expectValue, "beginReplayBufferEmitted", false)), boolText(outcome.beginReplayBufferEmitted));
		assertEquals(boolText(boolField(expectValue, "endReplayBufferEmitted", false)), boolText(outcome.endReplayBufferEmitted));
		assertEquals(boolText(boolField(expectValue, "initialSubmitSuppressed", false)), boolText(outcome.initialSubmitSuppressed));
		assertEquals(boolText(boolField(expectValue, "queueAutosendSuppressed", false)), boolText(outcome.queueAutosendSuppressed));
		assertEquals(boolText(boolField(expectValue, "inputStateRestored", false)), boolText(outcome.inputStateRestored));
		assertEquals(boolText(boolField(expectValue, "turnsReplayed", false)), boolText(outcome.turnsReplayed));
		assertEquals(boolText(boolField(expectValue, "pendingPrimaryEventsDrained", false)), boolText(outcome.pendingPrimaryEventsDrained));
		assertEquals(boolText(boolField(expectValue, "noticeSuppressed", false)), boolText(outcome.noticeSuppressed));
		assertEquals(boolText(boolField(expectValue, "notificationDeliveredWithReplayKind", false)), boolText(outcome.notificationDeliveredWithReplayKind));
		assertEquals(boolText(boolField(expectValue, "requestDeliveredWithReplayKind", false)), boolText(outcome.requestDeliveredWithReplayKind));
		assertEquals(boolText(boolField(expectValue, "historyEntryDelivered", false)), boolText(outcome.historyEntryDelivered));
		assertEquals(boolText(boolField(expectValue, "feedbackDelivered", false)), boolText(outcome.feedbackDelivered));
		assertEquals(boolText(boolField(expectValue, "replayKindAttached", false)), boolText(outcome.replayKindAttached));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function pendingInteractiveReplayByRequestId(outcomes:Array<ModelPendingInteractiveReplayOutcome>, requestId:String):ModelPendingInteractiveReplayOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing pending interactive replay outcome: " + requestId;
	}

	static function assertTopLevelThreadSnapshotTurnHistoryReplays(
		testCase:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotTurnHistoryReplayOutcome> {
		final outcomes:Array<ModelThreadSnapshotTurnHistoryReplayOutcome> = [];
		final values = optionalArrayField(testCase, "threadSnapshotTurnHistoryReplayExpects");
		for (value in values) outcomes.push(assertThreadSnapshotTurnHistoryReplay(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotTurnHistoryReplays(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotTurnHistoryReplayOutcome> {
		final outcomes:Array<ModelThreadSnapshotTurnHistoryReplayOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSnapshotTurnHistoryReplayExpects");
		for (value in values) outcomes.push(assertThreadSnapshotTurnHistoryReplay(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotTurnHistoryReplay(
		expectValue:Value,
		secretProbe:String
	):ModelThreadSnapshotTurnHistoryReplayOutcome {
		final outcome = ModelThreadSnapshotTurnHistoryReplayPolicy.replay(new ModelThreadSnapshotTurnHistoryReplayRequest({
			requestId: stringField(expectValue, "requestId", ""),
			replayKind: turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")),
			sessionAvailable: boolField(expectValue, "sessionAvailable", false),
			resumeRestoredQueue: boolField(expectValue, "resumeRestoredQueue", false),
			turns: threadSnapshotTurnHistoryTurns(expectValue),
			expectedUserMessages: stringArrayField(expectValue, "expectedUserMessages"),
			expectedAgentMessages: stringArrayField(expectValue, "expectedAgentMessages"),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")), outcome.replayKind);
		assertEquals(threadSnapshotTurnHistoryDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "turnCount", 0)), Std.string(outcome.turnCount));
		assertEquals(Std.string(intField(expectValue, "replayedItemCount", 0)), Std.string(outcome.replayedItemCount));
		assertEquals(Std.string(intField(expectValue, "userMessageCount", 0)), Std.string(outcome.userMessageCount));
		assertEquals(Std.string(intField(expectValue, "agentMessageCount", 0)), Std.string(outcome.agentMessageCount));
		assertEquals(Std.string(intField(expectValue, "terminalTurnCompletedNotificationCount", 0)), Std.string(outcome.terminalTurnCompletedNotificationCount));
		assertStringArraysEqual(stringArrayField(expectValue, "transcriptUserMessages"), outcome.transcriptUserMessages);
		assertStringArraysEqual(stringArrayField(expectValue, "transcriptAgentMessages"), outcome.transcriptAgentMessages);
		assertEquals(boolText(boolField(expectValue, "userMessagesInExpectedOrder", false)), boolText(outcome.userMessagesInExpectedOrder));
		assertEquals(boolText(boolField(expectValue, "agentMessagesInExpectedOrder", false)), boolText(outcome.agentMessagesInExpectedOrder));
		assertEquals(boolText(boolField(expectValue, "turnOrderPreserved", false)), boolText(outcome.turnOrderPreserved));
		assertEquals(boolText(boolField(expectValue, "itemOrderPreserved", false)), boolText(outcome.itemOrderPreserved));
		assertEquals(boolText(boolField(expectValue, "sessionAppliedBeforeTurns", false)), boolText(outcome.sessionAppliedBeforeTurns));
		assertEquals(boolText(boolField(expectValue, "queueAutosendSuppressed", false)), boolText(outcome.queueAutosendSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		for (message in outcome.transcriptUserMessages) if (message.length > 0) assertNotContains(outcome.summary(), message);
		for (message in outcome.transcriptAgentMessages) if (message.length > 0) assertNotContains(outcome.summary(), message);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadSnapshotCollabMetadataReplays(
		testCase:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotCollabMetadataReplayOutcome> {
		final outcomes:Array<ModelThreadSnapshotCollabMetadataReplayOutcome> = [];
		final values = optionalArrayField(testCase, "threadSnapshotCollabMetadataReplayExpects");
		for (value in values) outcomes.push(assertThreadSnapshotCollabMetadataReplay(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotCollabMetadataReplays(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotCollabMetadataReplayOutcome> {
		final outcomes:Array<ModelThreadSnapshotCollabMetadataReplayOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSnapshotCollabMetadataReplayExpects");
		for (value in values) outcomes.push(assertThreadSnapshotCollabMetadataReplay(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotCollabMetadataReplay(
		expectValue:Value,
		secretProbe:String
	):ModelThreadSnapshotCollabMetadataReplayOutcome {
		final outcome = ModelThreadSnapshotCollabMetadataReplayPolicy.replay(new ModelThreadSnapshotCollabMetadataReplayRequest({
			requestId: stringField(expectValue, "requestId", ""),
			replayKind: turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")),
			replacementCreatedBeforeReplay: boolField(expectValue, "replacementCreatedBeforeReplay", false),
			navigationEntries: collabAgentNavigationEntries(expectValue),
			waitItems: collabReplayWaitItems(expectValue),
			expectedAgentNickname: stringField(expectValue, "expectedAgentNickname", ""),
			expectedAgentRole: stringField(expectValue, "expectedAgentRole", ""),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")), outcome.replayKind);
		assertEquals(threadSnapshotCollabMetadataDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "navigationEntryCount", 0)), Std.string(outcome.navigationEntryCount));
		assertEquals(Std.string(intField(expectValue, "reseededMetadataCount", 0)), Std.string(outcome.reseededMetadataCount));
		assertEquals(Std.string(intField(expectValue, "replayedWaitItemCount", 0)), Std.string(outcome.replayedWaitItemCount));
		assertEquals(Std.string(intField(expectValue, "namedWaitItemCount", 0)), Std.string(outcome.namedWaitItemCount));
		assertEquals(boolText(boolField(expectValue, "replacementCreatedBeforeReplay", false)), boolText(outcome.replacementCreatedBeforeReplay));
		assertEquals(boolText(boolField(expectValue, "metadataReseededBeforeReplay", false)), boolText(outcome.metadataReseededBeforeReplay));
		assertEquals(boolText(boolField(expectValue, "agentNicknamePreserved", false)), boolText(outcome.agentNicknamePreserved));
		assertEquals(boolText(boolField(expectValue, "agentRolePreserved", false)), boolText(outcome.agentRolePreserved));
		assertEquals(boolText(boolField(expectValue, "waitItemRendered", false)), boolText(outcome.waitItemRendered));
		assertEquals(boolText(boolField(expectValue, "renderedWaitContainsMetadata", false)), boolText(outcome.renderedWaitContainsMetadata));
		assertEquals(boolText(boolField(expectValue, "fallbackThreadIdRendered", false)), boolText(outcome.fallbackThreadIdRendered));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "renderedWaitSummary", ""), outcome.renderedWaitSummary);
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadSnapshotSessionRefreshes(
		testCase:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotSessionRefreshOutcome> {
		final outcomes:Array<ModelThreadSnapshotSessionRefreshOutcome> = [];
		final values = optionalArrayField(testCase, "threadSnapshotSessionRefreshExpects");
		for (value in values) outcomes.push(assertThreadSnapshotSessionRefresh(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotSessionRefreshes(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelThreadSnapshotSessionRefreshOutcome> {
		final outcomes:Array<ModelThreadSnapshotSessionRefreshOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSnapshotSessionRefreshExpects");
		for (value in values) outcomes.push(assertThreadSnapshotSessionRefresh(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadSnapshotSessionRefresh(
		expectValue:Value,
		secretProbe:String
	):ModelThreadSnapshotSessionRefreshOutcome {
		final outcome = ModelThreadSnapshotSessionRefreshPolicy.apply(new ModelThreadSnapshotSessionRefreshRequest({
			requestId: stringField(expectValue, "requestId", ""),
			threadId: stringField(expectValue, "threadId", ""),
			snapshotSessionCwdBefore: stringField(expectValue, "snapshotSessionCwdBefore", ""),
			storeSessionCwdBefore: stringField(expectValue, "storeSessionCwdBefore", ""),
			refreshedSessionCwd: stringField(expectValue, "refreshedSessionCwd", ""),
			snapshotTurnCountBefore: intField(expectValue, "snapshotTurnCountBefore", 0),
			storeTurnCountBefore: intField(expectValue, "storeTurnCountBefore", 0),
			resumedTurns: threadSnapshotSessionRefreshTurns(expectValue),
			bufferEventCountBefore: intField(expectValue, "bufferEventCountBefore", 0),
			survivingBufferEventCount: intField(expectValue, "survivingBufferEventCount", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(stringField(expectValue, "threadId", ""), outcome.threadId);
		assertEquals(threadSnapshotSessionRefreshDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(stringField(expectValue, "snapshotSessionCwdAfter", ""), outcome.snapshotSessionCwdAfter);
		assertEquals(stringField(expectValue, "storeSessionCwdAfter", ""), outcome.storeSessionCwdAfter);
		assertEquals(Std.string(intField(expectValue, "snapshotTurnCountAfter", 0)), Std.string(outcome.snapshotTurnCountAfter));
		assertEquals(Std.string(intField(expectValue, "storeTurnCountAfter", 0)), Std.string(outcome.storeTurnCountAfter));
		assertEquals(Std.string(intField(expectValue, "resumedTurnCount", 0)), Std.string(outcome.resumedTurnCount));
		assertEquals(Std.string(intField(expectValue, "userMessageCount", 0)), Std.string(outcome.userMessageCount));
		assertEquals(stringField(expectValue, "activeTurnIdAfter", ""), outcome.activeTurnIdAfter);
		assertEquals(boolText(boolField(expectValue, "snapshotSessionReplaced", false)), boolText(outcome.snapshotSessionReplaced));
		assertEquals(boolText(boolField(expectValue, "snapshotTurnsReplaced", false)), boolText(outcome.snapshotTurnsReplaced));
		assertEquals(boolText(boolField(expectValue, "storeSessionReplaced", false)), boolText(outcome.storeSessionReplaced));
		assertEquals(boolText(boolField(expectValue, "storeTurnsReplaced", false)), boolText(outcome.storeTurnsReplaced));
		assertEquals(boolText(boolField(expectValue, "storeSnapshotMatchesRefreshedSnapshot", false)), boolText(outcome.storeSnapshotMatchesRefreshedSnapshot));
		assertEquals(boolText(boolField(expectValue, "bufferRebasedAfterRefresh", false)), boolText(outcome.bufferRebasedAfterRefresh));
		assertEquals(boolText(boolField(expectValue, "refreshedCwdPreserved", false)), boolText(outcome.refreshedCwdPreserved));
		assertEquals(boolText(boolField(expectValue, "resumedTurnsPersisted", false)), boolText(outcome.resumedTurnsPersisted));
		assertEquals(boolText(boolField(expectValue, "activeTurnRestoredFromResumedTurns", false)), boolText(outcome.activeTurnRestoredFromResumedTurns));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		assertNotContains(outcome.summary(), stringField(expectValue, "refreshedSessionCwd", ""));
		for (turn in threadSnapshotSessionRefreshTurns(expectValue)) if (turn.userText.length > 0) assertNotContains(outcome.summary(), turn.userText);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelReplayedServerRequestSurfaces(
		testCase:Value,
		dispatches:Array<ModelThreadSnapshotReplayDispatchOutcome>,
		secretProbe:String
	):Array<ModelReplayedServerRequestSurfaceOutcome> {
		final outcomes:Array<ModelReplayedServerRequestSurfaceOutcome> = [];
		final values = optionalArrayField(testCase, "replayedServerRequestSurfaceExpects");
		for (value in values) outcomes.push(assertReplayedServerRequestSurface(objectValue(value), dispatches, secretProbe));
		return outcomes;
	}

	static function assertReplayedServerRequestSurfaces(
		verificationValue:Value,
		dispatches:Array<ModelThreadSnapshotReplayDispatchOutcome>,
		secretProbe:String
	):Array<ModelReplayedServerRequestSurfaceOutcome> {
		final outcomes:Array<ModelReplayedServerRequestSurfaceOutcome> = [];
		final values = optionalArrayField(verificationValue, "replayedServerRequestSurfaceExpects");
		for (value in values) outcomes.push(assertReplayedServerRequestSurface(objectValue(value), dispatches, secretProbe));
		return outcomes;
	}

	static function assertReplayedServerRequestSurface(
		expectValue:Value,
		dispatches:Array<ModelThreadSnapshotReplayDispatchOutcome>,
		secretProbe:String
	):ModelReplayedServerRequestSurfaceOutcome {
		final dispatchRequestId = stringField(expectValue, "dispatchRequestId", "");
		final outcome = ModelReplayedServerRequestSurfacePolicy.surface(new ModelReplayedServerRequestSurfaceRequest(
			stringField(expectValue, "requestId", ""),
			dispatchRequestId.length == 0 ? null : threadSnapshotReplayDispatchByRequestId(dispatches, dispatchRequestId),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			turnReplayKind(stringField(expectValue, "replayKind", "thread_snapshot")),
			boolField(expectValue, "snapshotRequestAllowed", false),
			boolField(expectValue, "liveRequest", false),
			boolField(expectValue, "elicitationUrlRequest", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(dispatchRequestId, outcome.dispatchRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(stringField(expectValue, "surfaceKind", ""), outcome.surfaceKind);
		assertEquals(stringField(expectValue, "replayKind", ""), outcome.replayKind);
		assertEquals(boolText(boolField(expectValue, "replayKindAttached", false)), boolText(outcome.replayKindAttached));
		assertEquals(boolText(boolField(expectValue, "snapshotRequestAllowed", false)), boolText(outcome.snapshotRequestAllowed));
		assertEquals(boolText(boolField(expectValue, "chatWidgetRequestHandled", false)), boolText(outcome.chatWidgetRequestHandled));
		assertEquals(boolText(boolField(expectValue, "execApprovalRendered", false)), boolText(outcome.execApprovalRendered));
		assertEquals(boolText(boolField(expectValue, "fileChangeApprovalRendered", false)), boolText(outcome.fileChangeApprovalRendered));
		assertEquals(boolText(boolField(expectValue, "elicitationRendered", false)), boolText(outcome.elicitationRendered));
		assertEquals(boolText(boolField(expectValue, "elicitationUrlDeclined", false)), boolText(outcome.elicitationUrlDeclined));
		assertEquals(boolText(boolField(expectValue, "permissionsRendered", false)), boolText(outcome.permissionsRendered));
		assertEquals(boolText(boolField(expectValue, "userInputRendered", false)), boolText(outcome.userInputRendered));
		assertEquals(boolText(boolField(expectValue, "unsupportedStubErrorEmitted", false)), boolText(outcome.unsupportedStubErrorEmitted));
		assertEquals(boolText(boolField(expectValue, "unsupportedReplayStubSuppressed", false)), boolText(outcome.unsupportedReplayStubSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSnapshotReplayDispatchByRequestId(outcomes:Array<ModelThreadSnapshotReplayDispatchOutcome>, requestId:String):ModelThreadSnapshotReplayDispatchOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread snapshot replay dispatch outcome: " + requestId;
	}

	static function assertTopLevelAppServerRequestResolutions(
		testCase:Value,
		surfaces:Array<ModelReplayedServerRequestSurfaceOutcome>,
		secretProbe:String
	):Array<ModelAppServerRequestResolutionOutcome> {
		final outcomes:Array<ModelAppServerRequestResolutionOutcome> = [];
		final values = optionalArrayField(testCase, "appServerRequestResolutionExpects");
		for (value in values) outcomes.push(assertAppServerRequestResolution(objectValue(value), surfaces, secretProbe));
		return outcomes;
	}

	static function assertAppServerRequestResolutions(
		verificationValue:Value,
		surfaces:Array<ModelReplayedServerRequestSurfaceOutcome>,
		secretProbe:String
	):Array<ModelAppServerRequestResolutionOutcome> {
		final outcomes:Array<ModelAppServerRequestResolutionOutcome> = [];
		final values = optionalArrayField(verificationValue, "appServerRequestResolutionExpects");
		for (value in values) outcomes.push(assertAppServerRequestResolution(objectValue(value), surfaces, secretProbe));
		return outcomes;
	}

	static function assertAppServerRequestResolution(
		expectValue:Value,
		surfaces:Array<ModelReplayedServerRequestSurfaceOutcome>,
		secretProbe:String
	):ModelAppServerRequestResolutionOutcome {
		final surfaceRequestId = stringField(expectValue, "surfaceRequestId", "");
		final outcome = ModelAppServerRequestResolutionPolicy.resolve(new ModelAppServerRequestResolutionRequest(
			stringField(expectValue, "requestId", ""),
			replayedServerRequestSurfaceByRequestId(surfaces, surfaceRequestId),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			appServerRequestResolutionCommandKind(stringField(expectValue, "commandKind", "user_input_answer")),
			stringField(expectValue, "appServerRequestId", ""),
			stringField(expectValue, "requestKey", ""),
			stringField(expectValue, "commandKey", ""),
			stringField(expectValue, "serverName", ""),
			stringField(expectValue, "commandServerName", ""),
			stringField(expectValue, "mcpRequestId", ""),
			stringField(expectValue, "commandMcpRequestId", ""),
			stringField(expectValue, "pendingItemId", ""),
			intField(expectValue, "pendingRequestCountBefore", 0),
			intField(expectValue, "userInputQueueLengthBefore", 0),
			intField(expectValue, "userInputQueuePosition", -1),
			boolField(expectValue, "duplicateResponse", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(surfaceRequestId, outcome.surfaceRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(stringField(expectValue, "commandKind", ""), outcome.commandKind);
		assertEquals(stringField(expectValue, "payloadKind", ""), outcome.payloadKind);
		assertEquals(stringField(expectValue, "appServerRequestId", ""), outcome.appServerRequestId);
		assertEquals(stringField(expectValue, "requestKey", ""), outcome.requestKey);
		assertEquals(stringField(expectValue, "commandKey", ""), outcome.commandKey);
		assertEquals(boolText(boolField(expectValue, "pendingRequestRecorded", false)), boolText(outcome.pendingRequestRecorded));
		assertEquals(boolText(boolField(expectValue, "commandMatchedPendingRequest", false)), boolText(outcome.commandMatchedPendingRequest));
		assertEquals(boolText(boolField(expectValue, "requestRemovedFromPending", false)), boolText(outcome.requestRemovedFromPending));
		assertEquals(boolText(boolField(expectValue, "serializedResponseIntentEmitted", false)), boolText(outcome.serializedResponseIntentEmitted));
		assertEquals(boolText(boolField(expectValue, "execApprovalResolved", false)), boolText(outcome.execApprovalResolved));
		assertEquals(boolText(boolField(expectValue, "fileChangeApprovalResolved", false)), boolText(outcome.fileChangeApprovalResolved));
		assertEquals(boolText(boolField(expectValue, "permissionsResolved", false)), boolText(outcome.permissionsResolved));
		assertEquals(boolText(boolField(expectValue, "userInputQueuePopped", false)), boolText(outcome.userInputQueuePopped));
		assertEquals(Std.string(intField(expectValue, "userInputQueueLengthAfter", 0)), Std.string(outcome.userInputQueueLengthAfter));
		assertEquals(stringField(expectValue, "resolvedUserInputItemId", ""), outcome.resolvedUserInputItemId);
		assertEquals(boolText(boolField(expectValue, "mcpElicitationResolved", false)), boolText(outcome.mcpElicitationResolved));
		assertEquals(boolText(boolField(expectValue, "requestRemovedByNotification", false)), boolText(outcome.requestRemovedByNotification));
		assertEquals(boolText(boolField(expectValue, "duplicateOrMissingNoop", false)), boolText(outcome.duplicateOrMissingNoop));
		assertEquals(boolText(boolField(expectValue, "unsupportedRequestRejected", false)), boolText(outcome.unsupportedRequestRejected));
		assertEquals(boolText(boolField(expectValue, "liveAppServerFanoutSuppressed", false)), boolText(outcome.liveAppServerFanoutSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function replayedServerRequestSurfaceByRequestId(outcomes:Array<ModelReplayedServerRequestSurfaceOutcome>, requestId:String):ModelReplayedServerRequestSurfaceOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing replayed server request surface outcome: " + requestId;
	}

	static function assertTopLevelAppServerResponseDispatches(
		testCase:Value,
		resolutions:Array<ModelAppServerRequestResolutionOutcome>,
		secretProbe:String
	):Array<ModelAppServerResponseDispatchOutcome> {
		final outcomes:Array<ModelAppServerResponseDispatchOutcome> = [];
		final values = optionalArrayField(testCase, "appServerResponseDispatchExpects");
		for (value in values) outcomes.push(assertAppServerResponseDispatch(objectValue(value), resolutions, secretProbe));
		return outcomes;
	}

	static function assertAppServerResponseDispatches(
		verificationValue:Value,
		resolutions:Array<ModelAppServerRequestResolutionOutcome>,
		secretProbe:String
	):Array<ModelAppServerResponseDispatchOutcome> {
		final outcomes:Array<ModelAppServerResponseDispatchOutcome> = [];
		final values = optionalArrayField(verificationValue, "appServerResponseDispatchExpects");
		for (value in values) outcomes.push(assertAppServerResponseDispatch(objectValue(value), resolutions, secretProbe));
		return outcomes;
	}

	static function assertAppServerResponseDispatch(
		expectValue:Value,
		resolutions:Array<ModelAppServerRequestResolutionOutcome>,
		secretProbe:String
	):ModelAppServerResponseDispatchOutcome {
		final resolutionRequestId = stringField(expectValue, "resolutionRequestId", "");
		final outcome = ModelAppServerResponseDispatchPolicy.dispatch(new ModelAppServerResponseDispatchRequest(
			stringField(expectValue, "requestId", ""),
			appServerRequestResolutionByRequestId(resolutions, resolutionRequestId),
			appServerResponseDispatchKind(stringField(expectValue, "dispatchKind", "resolve_response")),
			boolField(expectValue, "appServerSessionAvailable", false),
			boolField(expectValue, "serializedPayloadAvailable", false),
			boolField(expectValue, "transportSendSucceeds", false),
			stringField(expectValue, "unsupportedRejectReason", ""),
			intField(expectValue, "previousDispatchCount", 0),
			intField(expectValue, "responseOrderIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(resolutionRequestId, outcome.resolutionRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(stringField(expectValue, "dispatchKind", ""), outcome.dispatchKind);
		assertEquals(stringField(expectValue, "appServerRequestId", ""), outcome.appServerRequestId);
		assertEquals(stringField(expectValue, "payloadKind", ""), outcome.payloadKind);
		assertEquals(boolText(boolField(expectValue, "appServerSessionAvailable", false)), boolText(outcome.appServerSessionAvailable));
		assertEquals(boolText(boolField(expectValue, "serializedPayloadAvailable", false)), boolText(outcome.serializedPayloadAvailable));
		assertEquals(boolText(boolField(expectValue, "dispatchIntentRecorded", false)), boolText(outcome.dispatchIntentRecorded));
		assertEquals(boolText(boolField(expectValue, "resolveServerRequestIntent", false)), boolText(outcome.resolveServerRequestIntent));
		assertEquals(boolText(boolField(expectValue, "rejectServerRequestIntent", false)), boolText(outcome.rejectServerRequestIntent));
		assertEquals(boolText(boolField(expectValue, "jsonRpcErrorPayloadBuilt", false)), boolText(outcome.jsonRpcErrorPayloadBuilt));
		assertEquals(boolText(boolField(expectValue, "responseOrderingPreserved", false)), boolText(outcome.responseOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "pendingReplayStateRefreshRequested", false)), boolText(outcome.pendingReplayStateRefreshRequested));
		assertEquals(boolText(boolField(expectValue, "missingSessionNoop", false)), boolText(outcome.missingSessionNoop));
		assertEquals(boolText(boolField(expectValue, "serializationRefused", false)), boolText(outcome.serializationRefused));
		assertEquals(boolText(boolField(expectValue, "dispatchFailureRecorded", false)), boolText(outcome.dispatchFailureRecorded));
		assertEquals(boolText(boolField(expectValue, "liveTransportAttempted", false)), boolText(outcome.liveTransportAttempted));
		assertEquals(boolText(boolField(expectValue, "liveTransportSuppressed", false)), boolText(outcome.liveTransportSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function appServerRequestResolutionByRequestId(outcomes:Array<ModelAppServerRequestResolutionOutcome>, requestId:String):ModelAppServerRequestResolutionOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing app-server request resolution outcome: " + requestId;
	}

	static function assertTopLevelAppServerRequestEnqueues(
		testCase:Value,
		dispatches:Array<ModelAppServerResponseDispatchOutcome>,
		secretProbe:String
	):Array<ModelAppServerRequestEnqueueOutcome> {
		final outcomes:Array<ModelAppServerRequestEnqueueOutcome> = [];
		final values = optionalArrayField(testCase, "appServerRequestEnqueueExpects");
		for (value in values) outcomes.push(assertAppServerRequestEnqueue(objectValue(value), dispatches, secretProbe));
		return outcomes;
	}

	static function assertAppServerRequestEnqueues(
		verificationValue:Value,
		dispatches:Array<ModelAppServerResponseDispatchOutcome>,
		secretProbe:String
	):Array<ModelAppServerRequestEnqueueOutcome> {
		final outcomes:Array<ModelAppServerRequestEnqueueOutcome> = [];
		final values = optionalArrayField(verificationValue, "appServerRequestEnqueueExpects");
		for (value in values) outcomes.push(assertAppServerRequestEnqueue(objectValue(value), dispatches, secretProbe));
		return outcomes;
	}

	static function assertAppServerRequestEnqueue(
		expectValue:Value,
		dispatches:Array<ModelAppServerResponseDispatchOutcome>,
		secretProbe:String
	):ModelAppServerRequestEnqueueOutcome {
		final responseDispatchRequestId = stringField(expectValue, "responseDispatchRequestId", "");
		final outcome = ModelAppServerRequestEnqueuePolicy.enqueue(new ModelAppServerRequestEnqueueRequest(
			stringField(expectValue, "requestId", ""),
			responseDispatchRequestId.length == 0 ? null : appServerResponseDispatchByRequestId(dispatches, responseDispatchRequestId),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			stringField(expectValue, "threadId", ""),
			stringField(expectValue, "primaryThreadId", ""),
			boolField(expectValue, "primaryThreadKnown", false),
			stringField(expectValue, "activeThreadId", ""),
			boolField(expectValue, "threadIdAvailable", false),
			boolField(expectValue, "pendingRequestRecorded", false),
			boolField(expectValue, "queueActive", false),
			boolField(expectValue, "enqueueSucceeds", false),
			intField(expectValue, "pendingPrimaryEventCountBefore", 0),
			intField(expectValue, "threadQueueEventCountBefore", 0),
			intField(expectValue, "previousRequestCount", 0),
			intField(expectValue, "requestOrderIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(responseDispatchRequestId, outcome.responseDispatchRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(stringField(expectValue, "routeKind", ""), outcome.routeKind);
		assertEquals(stringField(expectValue, "threadId", ""), outcome.threadId);
		assertEquals(stringField(expectValue, "primaryThreadId", ""), outcome.primaryThreadId);
		assertEquals(boolText(boolField(expectValue, "requestRecordedPending", false)), boolText(outcome.requestRecordedPending));
		assertEquals(boolText(boolField(expectValue, "primaryPendingEventQueued", false)), boolText(outcome.primaryPendingEventQueued));
		assertEquals(boolText(boolField(expectValue, "primaryThreadRequestQueued", false)), boolText(outcome.primaryThreadRequestQueued));
		assertEquals(boolText(boolField(expectValue, "backgroundThreadRequestQueued", false)), boolText(outcome.backgroundThreadRequestQueued));
		assertEquals(boolText(boolField(expectValue, "threadlessRequestIgnored", false)), boolText(outcome.threadlessRequestIgnored));
		assertEquals(boolText(boolField(expectValue, "unsupportedAlreadyRejectedSkipped", false)), boolText(outcome.unsupportedAlreadyRejectedSkipped));
		assertEquals(boolText(boolField(expectValue, "enqueueFailureRecorded", false)), boolText(outcome.enqueueFailureRecorded));
		assertEquals(boolText(boolField(expectValue, "pendingInteractiveReplayRecordingIntended", false)), boolText(outcome.pendingInteractiveReplayRecordingIntended));
		assertEquals(boolText(boolField(expectValue, "chatWidgetDeliveryIntended", false)), boolText(outcome.chatWidgetDeliveryIntended));
		assertEquals(boolText(boolField(expectValue, "sideParentStatusRefreshIntended", false)), boolText(outcome.sideParentStatusRefreshIntended));
		assertEquals(boolText(boolField(expectValue, "refreshPendingApprovalsIntended", false)), boolText(outcome.refreshPendingApprovalsIntended));
		assertEquals(boolText(boolField(expectValue, "requestOrderingPreserved", false)), boolText(outcome.requestOrderingPreserved));
		assertEquals(Std.string(intField(expectValue, "pendingPrimaryEventCountAfter", 0)), Std.string(outcome.pendingPrimaryEventCountAfter));
		assertEquals(Std.string(intField(expectValue, "threadQueueEventCountAfter", 0)), Std.string(outcome.threadQueueEventCountAfter));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function appServerResponseDispatchByRequestId(outcomes:Array<ModelAppServerResponseDispatchOutcome>, requestId:String):ModelAppServerResponseDispatchOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing app-server response dispatch outcome: " + requestId;
	}

	static function assertTopLevelAppServerQueuedRequestDeliveries(
		testCase:Value,
		enqueues:Array<ModelAppServerRequestEnqueueOutcome>,
		secretProbe:String
	):Array<ModelAppServerQueuedRequestDeliveryOutcome> {
		final outcomes:Array<ModelAppServerQueuedRequestDeliveryOutcome> = [];
		final values = optionalArrayField(testCase, "appServerQueuedRequestDeliveryExpects");
		for (value in values) outcomes.push(assertAppServerQueuedRequestDelivery(objectValue(value), enqueues, secretProbe));
		return outcomes;
	}

	static function assertAppServerQueuedRequestDeliveries(
		verificationValue:Value,
		enqueues:Array<ModelAppServerRequestEnqueueOutcome>,
		secretProbe:String
	):Array<ModelAppServerQueuedRequestDeliveryOutcome> {
		final outcomes:Array<ModelAppServerQueuedRequestDeliveryOutcome> = [];
		final values = optionalArrayField(verificationValue, "appServerQueuedRequestDeliveryExpects");
		for (value in values) outcomes.push(assertAppServerQueuedRequestDelivery(objectValue(value), enqueues, secretProbe));
		return outcomes;
	}

	static function assertAppServerQueuedRequestDelivery(
		expectValue:Value,
		enqueues:Array<ModelAppServerRequestEnqueueOutcome>,
		secretProbe:String
	):ModelAppServerQueuedRequestDeliveryOutcome {
		final enqueueRequestId = stringField(expectValue, "enqueueRequestId", "");
		final outcome = ModelAppServerQueuedRequestDeliveryPolicy.deliver(new ModelAppServerQueuedRequestDeliveryRequest(
			stringField(expectValue, "requestId", ""),
			appServerRequestEnqueueByRequestId(enqueues, enqueueRequestId),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			boolField(expectValue, "requestStillPending", false),
			boolField(expectValue, "activeThreadEvent", false),
			boolField(expectValue, "replayDelivery", false),
			boolField(expectValue, "pendingPrimaryDrained", false),
			intField(expectValue, "previousDeliveryCount", 0),
			intField(expectValue, "deliveryOrderIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(enqueueRequestId, outcome.enqueueRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(appServerQueuedRequestDeliveryKind(stringField(expectValue, "deliveryKind", "")), outcome.deliveryKind);
		assertEquals(boolText(boolField(expectValue, "requestStillPending", false)), boolText(outcome.requestStillPending));
		assertEquals(boolText(boolField(expectValue, "activeThreadEvent", false)), boolText(outcome.activeThreadEvent));
		assertEquals(boolText(boolField(expectValue, "replayKindAttached", false)), boolText(outcome.replayKindAttached));
		assertEquals(boolText(boolField(expectValue, "chatWidgetRequestHandled", false)), boolText(outcome.chatWidgetRequestHandled));
		assertEquals(boolText(boolField(expectValue, "pendingCheckApplied", false)), boolText(outcome.pendingCheckApplied));
		assertEquals(boolText(boolField(expectValue, "nonPendingSkipped", false)), boolText(outcome.nonPendingSkipped));
		assertEquals(boolText(boolField(expectValue, "pendingPrimaryStillDeferred", false)), boolText(outcome.pendingPrimaryStillDeferred));
		assertEquals(boolText(boolField(expectValue, "replayStatePreserved", false)), boolText(outcome.replayStatePreserved));
		assertEquals(boolText(boolField(expectValue, "deliveryOrderingPreserved", false)), boolText(outcome.deliveryOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function appServerRequestEnqueueByRequestId(outcomes:Array<ModelAppServerRequestEnqueueOutcome>, requestId:String):ModelAppServerRequestEnqueueOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing app-server request enqueue outcome: " + requestId;
	}

	static function assertTopLevelThreadBufferedRequestEvictions(
		testCase:Value,
		deliveries:Array<ModelAppServerQueuedRequestDeliveryOutcome>,
		secretProbe:String
	):Array<ModelThreadBufferedRequestEvictionOutcome> {
		final outcomes:Array<ModelThreadBufferedRequestEvictionOutcome> = [];
		final values = optionalArrayField(testCase, "threadBufferedRequestEvictionExpects");
		for (value in values) outcomes.push(assertThreadBufferedRequestEviction(objectValue(value), deliveries, secretProbe));
		return outcomes;
	}

	static function assertThreadBufferedRequestEvictions(
		verificationValue:Value,
		deliveries:Array<ModelAppServerQueuedRequestDeliveryOutcome>,
		secretProbe:String
	):Array<ModelThreadBufferedRequestEvictionOutcome> {
		final outcomes:Array<ModelThreadBufferedRequestEvictionOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadBufferedRequestEvictionExpects");
		for (value in values) outcomes.push(assertThreadBufferedRequestEviction(objectValue(value), deliveries, secretProbe));
		return outcomes;
	}

	static function assertThreadBufferedRequestEviction(
		expectValue:Value,
		deliveries:Array<ModelAppServerQueuedRequestDeliveryOutcome>,
		secretProbe:String
	):ModelThreadBufferedRequestEvictionOutcome {
		final deliveryRequestId = stringField(expectValue, "deliveryRequestId", "");
		final outcome = ModelThreadBufferedRequestEvictionPolicy.model(new ModelThreadBufferedRequestEvictionRequest(
			stringField(expectValue, "requestId", ""),
			appServerQueuedRequestDeliveryByRequestId(deliveries, deliveryRequestId),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			threadBufferedEventKind(stringField(expectValue, "incomingEventKind", "request")),
			threadBufferedEventKind(stringField(expectValue, "evictedEventKind", "notification")),
			intField(expectValue, "bufferCapacity", 0),
			intField(expectValue, "bufferEventCountBefore", 0),
			intField(expectValue, "incomingOrderIndex", 0),
			intField(expectValue, "evictedOrderIndex", 0),
			boolField(expectValue, "targetRequestEvicted", false),
			boolField(expectValue, "targetRequestWasPendingInteractive", false),
			boolField(expectValue, "pendingReplayRecordedBefore", false),
			boolField(expectValue, "snapshotFilterChecked", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(deliveryRequestId, outcome.deliveryRequestId);
		assertEquals(stringField(expectValue, "requestKind", ""), outcome.requestKind);
		assertEquals(threadBufferedRequestEvictionKind(stringField(expectValue, "evictionKind", "")), outcome.evictionKind);
		assertEquals(threadBufferedEventKind(stringField(expectValue, "incomingEventKind", "request")), outcome.incomingEventKind);
		assertEquals(threadBufferedEventKind(stringField(expectValue, "evictedEventKind", "notification")), outcome.evictedEventKind);
		assertEquals(boolText(boolField(expectValue, "overCapacity", false)), boolText(outcome.overCapacity));
		assertEquals(boolText(boolField(expectValue, "evictedRequestObserved", false)), boolText(outcome.evictedRequestObserved));
		assertEquals(boolText(boolField(expectValue, "pendingPromptRemoved", false)), boolText(outcome.pendingPromptRemoved));
		assertEquals(boolText(boolField(expectValue, "pendingReplayRecordedAfter", false)), boolText(outcome.pendingReplayRecordedAfter));
		assertEquals(boolText(boolField(expectValue, "snapshotRequestReplayed", false)), boolText(outcome.snapshotRequestReplayed));
		assertEquals(boolText(boolField(expectValue, "replaySkippedAfterEviction", false)), boolText(outcome.replaySkippedAfterEviction));
		assertEquals(Std.string(intField(expectValue, "bufferCountAfter", 0)), Std.string(outcome.bufferCountAfter));
		assertEquals(boolText(boolField(expectValue, "capacityPreserved", false)), boolText(outcome.capacityPreserved));
		assertEquals(boolText(boolField(expectValue, "orderingPreserved", false)), boolText(outcome.orderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function appServerQueuedRequestDeliveryByRequestId(outcomes:Array<ModelAppServerQueuedRequestDeliveryOutcome>, requestId:String):ModelAppServerQueuedRequestDeliveryOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing app-server queued request delivery outcome: " + requestId;
	}

	static function assertTopLevelThreadSessionRebases(
		testCase:Value,
		evictions:Array<ModelThreadBufferedRequestEvictionOutcome>,
		secretProbe:String
	):Array<ModelThreadSessionRebaseOutcome> {
		final outcomes:Array<ModelThreadSessionRebaseOutcome> = [];
		final values = optionalArrayField(testCase, "threadSessionRebaseExpects");
		for (value in values) outcomes.push(assertThreadSessionRebase(objectValue(value), evictions, secretProbe));
		return outcomes;
	}

	static function assertThreadSessionRebases(
		verificationValue:Value,
		evictions:Array<ModelThreadBufferedRequestEvictionOutcome>,
		secretProbe:String
	):Array<ModelThreadSessionRebaseOutcome> {
		final outcomes:Array<ModelThreadSessionRebaseOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSessionRebaseExpects");
		for (value in values) outcomes.push(assertThreadSessionRebase(objectValue(value), evictions, secretProbe));
		return outcomes;
	}

	static function assertThreadSessionRebase(
		expectValue:Value,
		evictions:Array<ModelThreadBufferedRequestEvictionOutcome>,
		secretProbe:String
	):ModelThreadSessionRebaseOutcome {
		final evictionRequestId = stringField(expectValue, "evictionRequestId", "");
		final outcome = ModelThreadSessionRebasePolicy.rebase(new ModelThreadSessionRebaseRequest(
			stringField(expectValue, "requestId", ""),
			threadBufferedRequestEvictionByRequestId(evictions, evictionRequestId),
			threadSessionRebaseEventKind(stringField(expectValue, "rebaseEventKind", "request")),
			intField(expectValue, "bufferEventCountBefore", 0),
			intField(expectValue, "eventOrderIndexBefore", 0),
			intField(expectValue, "expectedOrderIndexAfter", 0),
			boolField(expectValue, "pendingReplayRecordedBefore", false),
			boolField(expectValue, "serverResolutionRecordedBefore", false),
			boolField(expectValue, "snapshotFilterChecked", false),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(evictionRequestId, outcome.evictionRequestId);
		assertEquals(threadSessionRebaseKind(stringField(expectValue, "rebaseKind", "")), outcome.rebaseKind);
		assertEquals(threadSessionRebaseEventKind(stringField(expectValue, "rebaseEventKind", "request")), outcome.rebaseEventKind);
		assertEquals(boolText(boolField(expectValue, "eventSurvivesRebase", false)), boolText(outcome.eventSurvivesRebase));
		assertEquals(boolText(boolField(expectValue, "eventDroppedByRebase", false)), boolText(outcome.eventDroppedByRebase));
		assertEquals(boolText(boolField(expectValue, "pendingReplayStatePreserved", false)), boolText(outcome.pendingReplayStatePreserved));
		assertEquals(boolText(boolField(expectValue, "snapshotRequestReplayed", false)), boolText(outcome.snapshotRequestReplayed));
		assertEquals(boolText(boolField(expectValue, "resolvedRequestFilteredAfterRebase", false)), boolText(outcome.resolvedRequestFilteredAfterRebase));
		assertEquals(Std.string(intField(expectValue, "bufferEventCountAfter", 0)), Std.string(outcome.bufferEventCountAfter));
		assertEquals(boolText(boolField(expectValue, "orderingPreserved", false)), boolText(outcome.orderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadBufferedRequestEvictionByRequestId(outcomes:Array<ModelThreadBufferedRequestEvictionOutcome>, requestId:String):ModelThreadBufferedRequestEvictionOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread buffered request eviction outcome: " + requestId;
	}

	static function assertTopLevelThreadActiveTurns(
		testCase:Value,
		rebases:Array<ModelThreadSessionRebaseOutcome>,
		secretProbe:String
	):Array<ModelThreadActiveTurnOutcome> {
		final outcomes:Array<ModelThreadActiveTurnOutcome> = [];
		final values = optionalArrayField(testCase, "threadActiveTurnExpects");
		for (value in values) outcomes.push(assertThreadActiveTurn(objectValue(value), rebases, secretProbe));
		return outcomes;
	}

	static function assertThreadActiveTurns(
		verificationValue:Value,
		rebases:Array<ModelThreadSessionRebaseOutcome>,
		secretProbe:String
	):Array<ModelThreadActiveTurnOutcome> {
		final outcomes:Array<ModelThreadActiveTurnOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadActiveTurnExpects");
		for (value in values) outcomes.push(assertThreadActiveTurn(objectValue(value), rebases, secretProbe));
		return outcomes;
	}

	static function assertThreadActiveTurn(
		expectValue:Value,
		rebases:Array<ModelThreadSessionRebaseOutcome>,
		secretProbe:String
	):ModelThreadActiveTurnOutcome {
		final rebaseRequestId = stringField(expectValue, "rebaseRequestId", "");
		final outcome = ModelThreadActiveTurnPolicy.apply(new ModelThreadActiveTurnRequest(
			stringField(expectValue, "requestId", ""),
			threadSessionRebaseByRequestId(rebases, rebaseRequestId),
			threadActiveTurnEventKind(stringField(expectValue, "eventKind", "turns_restored")),
			stringField(expectValue, "activeTurnIdBefore", ""),
			stringField(expectValue, "eventTurnId", ""),
			stringField(expectValue, "latestInProgressTurnId", ""),
			boolField(expectValue, "turnsRestoredInOrder", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(rebaseRequestId, outcome.rebaseRequestId);
		assertEquals(threadActiveTurnEventKind(stringField(expectValue, "eventKind", "turns_restored")), outcome.eventKind);
		assertEquals(threadActiveTurnDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(stringField(expectValue, "activeTurnIdBefore", ""), outcome.activeTurnIdBefore);
		assertEquals(stringField(expectValue, "eventTurnId", ""), outcome.eventTurnId);
		assertEquals(stringField(expectValue, "activeTurnIdAfter", ""), outcome.activeTurnIdAfter);
		assertEquals(boolText(boolField(expectValue, "activeTurnChanged", false)), boolText(outcome.activeTurnChanged));
		assertEquals(boolText(boolField(expectValue, "restoredFromTurns", false)), boolText(outcome.restoredFromTurns));
		assertEquals(boolText(boolField(expectValue, "nonmatchingCompletionIgnored", false)), boolText(outcome.nonmatchingCompletionIgnored));
		assertEquals(boolText(boolField(expectValue, "threadClosedCleared", false)), boolText(outcome.threadClosedCleared));
		assertEquals(boolText(boolField(expectValue, "explicitClearApplied", false)), boolText(outcome.explicitClearApplied));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSessionRebaseByRequestId(outcomes:Array<ModelThreadSessionRebaseOutcome>, requestId:String):ModelThreadSessionRebaseOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread session rebase outcome: " + requestId;
	}

	static function assertTopLevelThreadSideParentPendingStatuses(
		testCase:Value,
		activeTurns:Array<ModelThreadActiveTurnOutcome>,
		secretProbe:String
	):Array<ModelThreadSideParentPendingOutcome> {
		final outcomes:Array<ModelThreadSideParentPendingOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideParentPendingStatusExpects");
		for (value in values) outcomes.push(assertThreadSideParentPendingStatus(objectValue(value), activeTurns, secretProbe));
		return outcomes;
	}

	static function assertThreadSideParentPendingStatuses(
		verificationValue:Value,
		activeTurns:Array<ModelThreadActiveTurnOutcome>,
		secretProbe:String
	):Array<ModelThreadSideParentPendingOutcome> {
		final outcomes:Array<ModelThreadSideParentPendingOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideParentPendingStatusExpects");
		for (value in values) outcomes.push(assertThreadSideParentPendingStatus(objectValue(value), activeTurns, secretProbe));
		return outcomes;
	}

	static function assertThreadSideParentPendingStatus(
		expectValue:Value,
		activeTurns:Array<ModelThreadActiveTurnOutcome>,
		secretProbe:String
	):ModelThreadSideParentPendingOutcome {
		final activeTurnRequestId = stringField(expectValue, "activeTurnRequestId", "");
		final outcome = ModelThreadSideParentPendingPolicy.apply(new ModelThreadSideParentPendingRequest(
			stringField(expectValue, "requestId", ""),
			threadActiveTurnByRequestId(activeTurns, activeTurnRequestId),
			threadSideParentPendingEventKind(stringField(expectValue, "eventKind", "status_refresh")),
			replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")),
			intField(expectValue, "pendingUserInputCountBefore", 0),
			intField(expectValue, "pendingApprovalCountBefore", 0),
			boolField(expectValue, "requestAddsUserInput", false),
			boolField(expectValue, "requestAddsApproval", false),
			boolField(expectValue, "requestRemovesUserInput", false),
			boolField(expectValue, "requestRemovesApproval", false),
			boolField(expectValue, "requestStatusFallbackAllowed", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(activeTurnRequestId, outcome.activeTurnRequestId);
		assertEquals(threadSideParentPendingEventKind(stringField(expectValue, "eventKind", "status_refresh")), outcome.eventKind);
		assertEquals(threadSideParentPendingDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(replayedServerRequestKind(stringField(expectValue, "requestKind", "user_input")), outcome.requestKind);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "sideParentStatusAfter", "none")), outcome.sideParentStatusAfter);
		assertEquals(Std.string(intField(expectValue, "pendingUserInputCountAfter", 0)), Std.string(outcome.pendingUserInputCountAfter));
		assertEquals(Std.string(intField(expectValue, "pendingApprovalCountAfter", 0)), Std.string(outcome.pendingApprovalCountAfter));
		assertEquals(boolText(boolField(expectValue, "pendingThreadApprovalsAfter", false)), boolText(outcome.pendingThreadApprovalsAfter));
		assertEquals(boolText(boolField(expectValue, "userInputPriorityApplied", false)), boolText(outcome.userInputPriorityApplied));
		assertEquals(boolText(boolField(expectValue, "requestStatusFallbackApplied", false)), boolText(outcome.requestStatusFallbackApplied));
		assertEquals(boolText(boolField(expectValue, "resolvedRequestRemoved", false)), boolText(outcome.resolvedRequestRemoved));
		assertEquals(boolText(boolField(expectValue, "evictedRequestRemoved", false)), boolText(outcome.evictedRequestRemoved));
		assertEquals(boolText(boolField(expectValue, "threadClosedCleared", false)), boolText(outcome.threadClosedCleared));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadSideParentStatusChanges(
		testCase:Value,
		pendingStatuses:Array<ModelThreadSideParentPendingOutcome>,
		secretProbe:String
	):Array<ModelThreadSideParentStatusChangeOutcome> {
		final outcomes:Array<ModelThreadSideParentStatusChangeOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideParentStatusChangeExpects");
		for (value in values) outcomes.push(assertThreadSideParentStatusChange(objectValue(value), pendingStatuses, secretProbe));
		return outcomes;
	}

	static function assertThreadSideParentStatusChanges(
		verificationValue:Value,
		pendingStatuses:Array<ModelThreadSideParentPendingOutcome>,
		secretProbe:String
	):Array<ModelThreadSideParentStatusChangeOutcome> {
		final outcomes:Array<ModelThreadSideParentStatusChangeOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideParentStatusChangeExpects");
		for (value in values) outcomes.push(assertThreadSideParentStatusChange(objectValue(value), pendingStatuses, secretProbe));
		return outcomes;
	}

	static function assertThreadSideParentStatusChange(
		expectValue:Value,
		pendingStatuses:Array<ModelThreadSideParentPendingOutcome>,
		secretProbe:String
	):ModelThreadSideParentStatusChangeOutcome {
		final pendingRequestId = stringField(expectValue, "pendingRequestId", "");
		final outcome = ModelThreadSideParentStatusChangePolicy.apply(new ModelThreadSideParentStatusChangeRequest(
			stringField(expectValue, "requestId", ""),
			threadSideParentPendingStatusByRequestId(pendingStatuses, pendingRequestId),
			threadSideParentStatusChangeEventKind(stringField(expectValue, "eventKind", "other_notification")),
			threadSideParentTurnStatusKind(stringField(expectValue, "turnStatus", "none")),
			threadSideParentStatusKind(stringField(expectValue, "sideParentStatusBefore", "none")),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(pendingRequestId, outcome.pendingRequestId);
		assertEquals(threadSideParentStatusChangeEventKind(stringField(expectValue, "eventKind", "other_notification")), outcome.eventKind);
		assertEquals(threadSideParentTurnStatusKind(stringField(expectValue, "turnStatus", "none")), outcome.turnStatus);
		assertEquals(threadSideParentStatusChangeDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "sideParentStatusBefore", "none")), outcome.sideParentStatusBefore);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "pendingStatusAfter", "none")), outcome.pendingStatusAfter);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "sideParentStatusAfter", "none")), outcome.sideParentStatusAfter);
		assertEquals(boolText(boolField(expectValue, "pendingStatusTookPrecedence", false)), boolText(outcome.pendingStatusTookPrecedence));
		assertEquals(boolText(boolField(expectValue, "notificationStatusChangeApplied", false)), boolText(outcome.notificationStatusChangeApplied));
		assertEquals(boolText(boolField(expectValue, "actionableStatusCleared", false)), boolText(outcome.actionableStatusCleared));
		assertEquals(boolText(boolField(expectValue, "terminalStatusSet", false)), boolText(outcome.terminalStatusSet));
		assertEquals(boolText(boolField(expectValue, "terminalStatusPreserved", false)), boolText(outcome.terminalStatusPreserved));
		assertEquals(boolText(boolField(expectValue, "ignoredInProgressTurn", false)), boolText(outcome.ignoredInProgressTurn));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSideParentPendingStatusByRequestId(
		outcomes:Array<ModelThreadSideParentPendingOutcome>,
		requestId:String
	):ModelThreadSideParentPendingOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-parent pending status outcome: " + requestId;
	}

	static function assertTopLevelThreadSideThreadUiSyncs(
		testCase:Value,
		statusChanges:Array<ModelThreadSideParentStatusChangeOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadUiSyncOutcome> {
		final outcomes:Array<ModelThreadSideThreadUiSyncOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadUiSyncExpects");
		for (value in values) outcomes.push(assertThreadSideThreadUiSync(objectValue(value), statusChanges, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadUiSyncs(
		verificationValue:Value,
		statusChanges:Array<ModelThreadSideParentStatusChangeOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadUiSyncOutcome> {
		final outcomes:Array<ModelThreadSideThreadUiSyncOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadUiSyncExpects");
		for (value in values) outcomes.push(assertThreadSideThreadUiSync(objectValue(value), statusChanges, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadUiSync(
		expectValue:Value,
		statusChanges:Array<ModelThreadSideParentStatusChangeOutcome>,
		secretProbe:String
	):ModelThreadSideThreadUiSyncOutcome {
		final statusChangeRequestId = stringField(expectValue, "statusChangeRequestId", "");
		final outcome = ModelThreadSideThreadUiSyncPolicy.apply(new ModelThreadSideThreadUiSyncRequest(
			stringField(expectValue, "requestId", ""),
			threadSideParentStatusChangeByRequestId(statusChanges, statusChangeRequestId),
			boolField(expectValue, "activeThreadDisplayed", false),
			boolField(expectValue, "sideThreadKnown", false),
			boolField(expectValue, "parentIsMain", false),
			stringField(expectValue, "parentThreadLabel", ""),
			threadSideParentStatusKind(stringField(expectValue, "storedParentStatusBefore", "none")),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(statusChangeRequestId, outcome.statusChangeRequestId);
		assertEquals(threadSideThreadUiSyncDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "storedParentStatusBefore", "none")), outcome.storedParentStatusBefore);
		assertEquals(threadSideParentStatusKind(stringField(expectValue, "storedParentStatusAfter", "none")), outcome.storedParentStatusAfter);
		assertEquals(boolText(boolField(expectValue, "statusChanged", false)), boolText(outcome.statusChanged));
		assertEquals(boolText(boolField(expectValue, "syncTriggered", false)), boolText(outcome.syncTriggered));
		assertEquals(boolText(boolField(expectValue, "sideUiCleared", false)), boolText(outcome.sideUiCleared));
		assertEquals(boolText(boolField(expectValue, "sideConversationActive", false)), boolText(outcome.sideConversationActive));
		assertEquals(stringField(expectValue, "contextLabel", ""), outcome.contextLabel);
		assertEquals(boolText(boolField(expectValue, "renameBlocked", false)), boolText(outcome.renameBlocked));
		assertEquals(boolText(boolField(expectValue, "interruptedTurnNoticeSuppressed", false)), boolText(outcome.interruptedTurnNoticeSuppressed));
		assertEquals(boolText(boolField(expectValue, "interruptedTurnNoticeDefaultRestored", false)), boolText(outcome.interruptedTurnNoticeDefaultRestored));
		assertEquals(boolText(boolField(expectValue, "statusLabelApplied", false)), boolText(outcome.statusLabelApplied));
		assertEquals(boolText(boolField(expectValue, "statusClearApplied", false)), boolText(outcome.statusClearApplied));
		assertEquals(boolText(boolField(expectValue, "repeatedSameStatusNoop", false)), boolText(outcome.repeatedSameStatusNoop));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSideParentStatusChangeByRequestId(
		outcomes:Array<ModelThreadSideParentStatusChangeOutcome>,
		requestId:String
	):ModelThreadSideParentStatusChangeOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-parent status-change outcome: " + requestId;
	}

	static function assertTopLevelThreadSideThreadDiscards(
		testCase:Value,
		uiSyncs:Array<ModelThreadSideThreadUiSyncOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadDiscardOutcome> {
		final outcomes:Array<ModelThreadSideThreadDiscardOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadDiscardExpects");
		for (value in values) outcomes.push(assertThreadSideThreadDiscard(objectValue(value), uiSyncs, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadDiscards(
		verificationValue:Value,
		uiSyncs:Array<ModelThreadSideThreadUiSyncOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadDiscardOutcome> {
		final outcomes:Array<ModelThreadSideThreadDiscardOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadDiscardExpects");
		for (value in values) outcomes.push(assertThreadSideThreadDiscard(objectValue(value), uiSyncs, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadDiscard(
		expectValue:Value,
		uiSyncs:Array<ModelThreadSideThreadUiSyncOutcome>,
		secretProbe:String
	):ModelThreadSideThreadDiscardOutcome {
		final uiSyncRequestId = stringField(expectValue, "uiSyncRequestId", "");
		final outcome = ModelThreadSideThreadDiscardPolicy.apply(new ModelThreadSideThreadDiscardRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadUiSyncByRequestId(uiSyncs, uiSyncRequestId),
			boolField(expectValue, "maybeReturnRequested", false),
			boolField(expectValue, "overlayActive", false),
			boolField(expectValue, "modalOrPopupActive", false),
			boolField(expectValue, "composerEmpty", false),
			boolField(expectValue, "activeSideParentKnown", false),
			boolField(expectValue, "selectionSucceeded", false),
			boolField(expectValue, "activeSideParentAfterSelectionKnown", false),
			boolField(expectValue, "currentThreadDisplayed", false),
			boolField(expectValue, "currentThreadIsSideThread", false),
			boolField(expectValue, "targetIsCurrentThread", false),
			boolField(expectValue, "sideThreadHasActiveTurn", false),
			boolField(expectValue, "interruptSucceeded", false),
			boolField(expectValue, "unsubscribeSucceeded", false),
			boolField(expectValue, "discardedThreadWasActive", false),
			boolField(expectValue, "closedSideThread", false),
			boolField(expectValue, "keepVisibleAfterCleanupFailure", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(uiSyncRequestId, outcome.uiSyncRequestId);
		assertEquals(threadSideThreadDiscardDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "maybeReturnEligible", false)), boolText(outcome.maybeReturnEligible));
		assertEquals(boolText(boolField(expectValue, "returnFromSideAttempted", false)), boolText(outcome.returnFromSideAttempted));
		assertEquals(boolText(boolField(expectValue, "returnFromSideSucceeded", false)), boolText(outcome.returnFromSideSucceeded));
		assertEquals(boolText(boolField(expectValue, "discardTargetSelected", false)), boolText(outcome.discardTargetSelected));
		assertEquals(threadSideThreadInterruptKind(stringField(expectValue, "interruptKind", "none")), outcome.interruptKind);
		assertEquals(boolText(boolField(expectValue, "interruptAttempted", false)), boolText(outcome.interruptAttempted));
		assertEquals(boolText(boolField(expectValue, "unsubscribeAttempted", false)), boolText(outcome.unsubscribeAttempted));
		assertEquals(boolText(boolField(expectValue, "localStateRemoved", false)), boolText(outcome.localStateRemoved));
		assertEquals(boolText(boolField(expectValue, "activeThreadCleared", false)), boolText(outcome.activeThreadCleared));
		assertEquals(boolText(boolField(expectValue, "pendingApprovalsRefreshed", false)), boolText(outcome.pendingApprovalsRefreshed));
		assertEquals(boolText(boolField(expectValue, "activeAgentLabelSynced", false)), boolText(outcome.activeAgentLabelSynced));
		assertEquals(boolText(boolField(expectValue, "cleanupFailureKeptVisible", false)), boolText(outcome.cleanupFailureKeptVisible));
		assertEquals(boolText(boolField(expectValue, "surfacePendingInactiveRequests", false)), boolText(outcome.surfacePendingInactiveRequests));
		assertEquals(boolText(boolField(expectValue, "serverRpcAttempted", false)), boolText(outcome.serverRpcAttempted));
		assertEquals(boolText(boolField(expectValue, "closedSideThreadLocalOnly", false)), boolText(outcome.closedSideThreadLocalOnly));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSideThreadUiSyncByRequestId(
		outcomes:Array<ModelThreadSideThreadUiSyncOutcome>,
		requestId:String
	):ModelThreadSideThreadUiSyncOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread UI sync outcome: " + requestId;
	}

	static function assertTopLevelThreadSideThreadStarts(
		testCase:Value,
		discards:Array<ModelThreadSideThreadDiscardOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadStartOutcome> {
		final outcomes:Array<ModelThreadSideThreadStartOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadStartExpects");
		for (value in values) outcomes.push(assertThreadSideThreadStart(objectValue(value), discards, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadStarts(
		verificationValue:Value,
		discards:Array<ModelThreadSideThreadDiscardOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadStartOutcome> {
		final outcomes:Array<ModelThreadSideThreadStartOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadStartExpects");
		for (value in values) outcomes.push(assertThreadSideThreadStart(objectValue(value), discards, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadStart(
		expectValue:Value,
		discards:Array<ModelThreadSideThreadDiscardOutcome>,
		secretProbe:String
	):ModelThreadSideThreadStartOutcome {
		final cleanupRequestId = stringField(expectValue, "cleanupRequestId", "");
		final outcome = ModelThreadSideThreadStartPolicy.apply(new ModelThreadSideThreadStartRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadDiscardByRequestId(discards, cleanupRequestId),
			boolField(expectValue, "primaryThreadAvailable", false),
			boolField(expectValue, "sideThreadAlreadyOpen", false),
			stringField(expectValue, "parentModel", ""),
			stringField(expectValue, "parentReasoningEffort", ""),
			stringField(expectValue, "parentServiceTier", ""),
			stringField(expectValue, "parentApprovalPolicy", ""),
			stringField(expectValue, "parentPermissionProfile", ""),
			stringField(expectValue, "parentApprovalsReviewer", ""),
			stringField(expectValue, "existingDeveloperInstructions", ""),
			boolField(expectValue, "userMessageProvided", false),
			boolField(expectValue, "forkSucceeded", false),
			stringField(expectValue, "forkErrorMessage", ""),
			boolField(expectValue, "injectBoundarySucceeded", false),
			boolField(expectValue, "switchSucceeded", false),
			boolField(expectValue, "activeChildAfterSwitch", false),
			boolField(expectValue, "discardCleanupSucceeded", false),
			boolField(expectValue, "activeThreadRestoredToParent", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(cleanupRequestId, outcome.cleanupRequestId);
		assertEquals(threadSideThreadStartDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(threadSideThreadStartFailureKind(stringField(expectValue, "failureKind", "none")), outcome.failureKind);
		assertEquals(boolText(boolField(expectValue, "startBlocked", false)), boolText(outcome.startBlocked));
		assertEquals(boolText(boolField(expectValue, "userMessageRestored", false)), boolText(outcome.userMessageRestored));
		assertEquals(boolText(boolField(expectValue, "sideUiSynced", false)), boolText(outcome.sideUiSynced));
		assertEquals(boolText(boolField(expectValue, "contextLabelCleared", false)), boolText(outcome.contextLabelCleared));
		assertEquals(boolText(boolField(expectValue, "telemetryRecorded", false)), boolText(outcome.telemetryRecorded));
		assertEquals(boolText(boolField(expectValue, "configRefreshAttempted", false)), boolText(outcome.configRefreshAttempted));
		assertEquals(boolText(boolField(expectValue, "forkAttempted", false)), boolText(outcome.forkAttempted));
		assertEquals(boolText(boolField(expectValue, "forkConfigEphemeral", false)), boolText(outcome.forkConfigEphemeral));
		assertEquals(boolText(boolField(expectValue, "parentModelApplied", false)), boolText(outcome.parentModelApplied));
		assertEquals(boolText(boolField(expectValue, "inheritedRuntimeSettings", false)), boolText(outcome.inheritedRuntimeSettings));
		assertEquals(boolText(boolField(expectValue, "developerInstructionsAppended", false)), boolText(outcome.developerInstructionsAppended));
		assertEquals(boolText(boolField(expectValue, "developerGuardrailsApplied", false)), boolText(outcome.developerGuardrailsApplied));
		assertEquals(boolText(boolField(expectValue, "boundaryPromptItemBuilt", false)), boolText(outcome.boundaryPromptItemBuilt));
		assertEquals(boolText(boolField(expectValue, "boundaryPromptInjected", false)), boolText(outcome.boundaryPromptInjected));
		assertEquals(boolText(boolField(expectValue, "snapshotInstalled", false)), boolText(outcome.snapshotInstalled));
		assertEquals(boolText(boolField(expectValue, "forkedParentTranscriptHidden", false)), boolText(outcome.forkedParentTranscriptHidden));
		assertEquals(boolText(boolField(expectValue, "sideThreadRegistered", false)), boolText(outcome.sideThreadRegistered));
		final expectedSwitchAttempted = boolText(boolField(expectValue, "switchAttempted", false));
		final actualSwitchAttempted = boolText(outcome.switchAttempted);
		if (expectedSwitchAttempted != actualSwitchAttempted) {
			throw "thread side-thread start " + stringField(expectValue, "requestId", "") + " expected switchAttempted `" + expectedSwitchAttempted + "` but got `" + actualSwitchAttempted + "`";
		}
		assertEquals(boolText(boolField(expectValue, "discardCleanupAttempted", false)), boolText(outcome.discardCleanupAttempted));
		assertEquals(boolText(boolField(expectValue, "parentRestoreAttempted", false)), boolText(outcome.parentRestoreAttempted));
		assertEquals(boolText(boolField(expectValue, "userMessageSubmitted", false)), boolText(outcome.userMessageSubmitted));
		assertEquals(boolText(boolField(expectValue, "errorMessageAdded", false)), boolText(outcome.errorMessageAdded));
		assertEquals(boolText(boolField(expectValue, "runControlContinue", false)), boolText(outcome.runControlContinue));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadSideThreadStartupRoutings(
		testCase:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadStartupRoutingOutcome> {
		final outcomes:Array<ModelThreadSideThreadStartupRoutingOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadStartupRoutingExpects");
		for (value in values) outcomes.push(assertThreadSideThreadStartupRouting(objectValue(value), starts, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadStartupRoutings(
		verificationValue:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadStartupRoutingOutcome> {
		final outcomes:Array<ModelThreadSideThreadStartupRoutingOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadStartupRoutingExpects");
		for (value in values) outcomes.push(assertThreadSideThreadStartupRouting(objectValue(value), starts, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadStartupRouting(
		expectValue:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		secretProbe:String
	):ModelThreadSideThreadStartupRoutingOutcome {
		final startRequestId = stringField(expectValue, "startRequestId", "");
		final outcome = ModelThreadSideThreadStartupRoutingPolicy.apply(new ModelThreadSideThreadStartupRoutingRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadStartByRequestId(starts, startRequestId),
			boolField(expectValue, "notificationThreadScoped", false),
			boolField(expectValue, "notificationTargetsVisibleThread", false),
			boolField(expectValue, "notificationTargetsPrimaryThread", false),
			boolField(expectValue, "targetThreadIsSideThread", false),
			boolField(expectValue, "visibleThreadIsSideThread", false),
			boolField(expectValue, "activeThreadChannel", false),
			boolField(expectValue, "snapshotReplay", false),
			boolField(expectValue, "snapshotSessionIsSideThread", false),
			stringField(expectValue, "mcpServerName", ""),
			threadSideThreadStartupEventKind(stringField(expectValue, "startupEventKind", "starting")),
			stringField(expectValue, "startupErrorMessage", ""),
			boolField(expectValue, "expectedServerConfigured", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(startRequestId, outcome.startRequestId);
		assertEquals(threadSideThreadStartupRoutingDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(threadSideThreadStartupEventKind(stringField(expectValue, "startupEventKind", "starting")), outcome.startupEventKind);
		assertEquals(boolText(boolField(expectValue, "expectedServersRefreshed", false)), boolText(outcome.expectedServersRefreshed));
		assertEquals(boolText(boolField(expectValue, "appScopedIgnored", false)), boolText(outcome.appScopedIgnored));
		assertEquals(boolText(boolField(expectValue, "misroutedVisibleThreadIgnored", false)), boolText(outcome.misroutedVisibleThreadIgnored));
		assertEquals(boolText(boolField(expectValue, "childThreadChannelEnsured", false)), boolText(outcome.childThreadChannelEnsured));
		assertEquals(boolText(boolField(expectValue, "notificationBuffered", false)), boolText(outcome.notificationBuffered));
		assertEquals(boolText(boolField(expectValue, "notificationSentToActiveReceiver", false)), boolText(outcome.notificationSentToActiveReceiver));
		assertEquals(boolText(boolField(expectValue, "sideThreadSessionHandled", false)), boolText(outcome.sideThreadSessionHandled));
		assertEquals(boolText(boolField(expectValue, "sideConversationDisplayMode", false)), boolText(outcome.sideConversationDisplayMode));
		assertEquals(boolText(boolField(expectValue, "contextLabelPreserved", false)), boolText(outcome.contextLabelPreserved));
		assertEquals(boolText(boolField(expectValue, "startupStatusRendered", false)), boolText(outcome.startupStatusRendered));
		assertEquals(boolText(boolField(expectValue, "startupFailureWarningRendered", false)), boolText(outcome.startupFailureWarningRendered));
		assertEquals(boolText(boolField(expectValue, "loginErrorRendered", false)), boolText(outcome.loginErrorRendered));
		assertEquals(boolText(boolField(expectValue, "activeTranscriptMutated", false)), boolText(outcome.activeTranscriptMutated));
		assertEquals(boolText(boolField(expectValue, "appEventRendered", false)), boolText(outcome.appEventRendered));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSideThreadStartByRequestId(
		outcomes:Array<ModelThreadSideThreadStartOutcome>,
		requestId:String
	):ModelThreadSideThreadStartOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread start outcome: " + requestId;
	}

	static function assertTopLevelThreadSideThreadComposerHandoffs(
		testCase:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		startupRoutings:Array<ModelThreadSideThreadStartupRoutingOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadComposerHandoffOutcome> {
		final outcomes:Array<ModelThreadSideThreadComposerHandoffOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadComposerHandoffExpects");
		for (value in values) outcomes.push(assertThreadSideThreadComposerHandoff(objectValue(value), starts, startupRoutings, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadComposerHandoffs(
		verificationValue:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		startupRoutings:Array<ModelThreadSideThreadStartupRoutingOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadComposerHandoffOutcome> {
		final outcomes:Array<ModelThreadSideThreadComposerHandoffOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadComposerHandoffExpects");
		for (value in values) outcomes.push(assertThreadSideThreadComposerHandoff(objectValue(value), starts, startupRoutings, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadComposerHandoff(
		expectValue:Value,
		starts:Array<ModelThreadSideThreadStartOutcome>,
		startupRoutings:Array<ModelThreadSideThreadStartupRoutingOutcome>,
		secretProbe:String
	):ModelThreadSideThreadComposerHandoffOutcome {
		final startRequestId = stringField(expectValue, "startRequestId", "");
		final startupRoutingRequestId = stringField(expectValue, "startupRoutingRequestId", "");
		final outcome = ModelThreadSideThreadComposerHandoffPolicy.apply(new ModelThreadSideThreadComposerHandoffRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadStartByRequestId(starts, startRequestId),
			threadSideThreadStartupRoutingByRequestIdOrNull(startupRoutings, startupRoutingRequestId),
			boolField(expectValue, "userMessageProvided", false),
			stringField(expectValue, "inlineUserMessageText", ""),
			boolField(expectValue, "composerInitiallyEmpty", false),
			stringField(expectValue, "sideContextLabelBefore", ""),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(startRequestId, outcome.startRequestId);
		assertEquals(startupRoutingRequestId, outcome.startupRoutingRequestId);
		assertEquals(threadSideThreadComposerHandoffDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "userMessagePreserved", false)), boolText(outcome.userMessagePreserved));
		assertEquals(boolText(boolField(expectValue, "restoreAttempted", false)), boolText(outcome.restoreAttempted));
		assertEquals(boolText(boolField(expectValue, "composerMutated", false)), boolText(outcome.composerMutated));
		assertEquals(stringField(expectValue, "composerTextAfter", ""), outcome.composerTextAfter);
		assertEquals(boolText(boolField(expectValue, "submittedAsPlainUserTurn", false)), boolText(outcome.submittedAsPlainUserTurn));
		assertEquals(boolText(boolField(expectValue, "duplicateSubmissionPrevented", false)), boolText(outcome.duplicateSubmissionPrevented));
		assertEquals(boolText(boolField(expectValue, "sideUiSynced", false)), boolText(outcome.sideUiSynced));
		assertEquals(boolText(boolField(expectValue, "contextLabelCleared", false)), boolText(outcome.contextLabelCleared));
		assertEquals(boolText(boolField(expectValue, "errorMessageDisplayed", false)), boolText(outcome.errorMessageDisplayed));
		assertEquals(boolText(boolField(expectValue, "runControlContinue", false)), boolText(outcome.runControlContinue));
		assertEquals(boolText(boolField(expectValue, "startupRoutingComposed", false)), boolText(outcome.startupRoutingComposed));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function threadSideThreadStartupRoutingByRequestIdOrNull(
		outcomes:Array<ModelThreadSideThreadStartupRoutingOutcome>,
		requestId:String
	):ModelThreadSideThreadStartupRoutingOutcome {
		if (requestId.length == 0) return null;
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread startup routing outcome: " + requestId;
	}

	static function assertTopLevelThreadSideThreadNavigationCleanups(
		testCase:Value,
		composerHandoffs:Array<ModelThreadSideThreadComposerHandoffOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadNavigationCleanupOutcome> {
		final outcomes:Array<ModelThreadSideThreadNavigationCleanupOutcome> = [];
		final values = optionalArrayField(testCase, "threadSideThreadNavigationCleanupExpects");
		for (value in values) outcomes.push(assertThreadSideThreadNavigationCleanup(objectValue(value), composerHandoffs, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadNavigationCleanups(
		verificationValue:Value,
		composerHandoffs:Array<ModelThreadSideThreadComposerHandoffOutcome>,
		secretProbe:String
	):Array<ModelThreadSideThreadNavigationCleanupOutcome> {
		final outcomes:Array<ModelThreadSideThreadNavigationCleanupOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadSideThreadNavigationCleanupExpects");
		for (value in values) outcomes.push(assertThreadSideThreadNavigationCleanup(objectValue(value), composerHandoffs, secretProbe));
		return outcomes;
	}

	static function assertThreadSideThreadNavigationCleanup(
		expectValue:Value,
		composerHandoffs:Array<ModelThreadSideThreadComposerHandoffOutcome>,
		secretProbe:String
	):ModelThreadSideThreadNavigationCleanupOutcome {
		final composerHandoffRequestId = stringField(expectValue, "composerHandoffRequestId", "");
		final outcome = ModelThreadSideThreadNavigationCleanupPolicy.apply(new ModelThreadSideThreadNavigationCleanupRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadComposerHandoffByRequestId(composerHandoffs, composerHandoffRequestId),
			boolField(expectValue, "currentDisplayedThreadIsSide", false),
			boolField(expectValue, "targetIsCurrentSideThread", false),
			boolField(expectValue, "targetIsParentThread", false),
			boolField(expectValue, "selectedByParentSwitch", false),
			boolField(expectValue, "selectTargetSucceeded", false),
			boolField(expectValue, "discardClosedNotification", false),
			boolField(expectValue, "activeThreadWasSideBeforeSwitch", false),
			boolField(expectValue, "activeThreadIsDiscardTarget", false),
			boolField(expectValue, "activeTurnPresent", false),
			boolField(expectValue, "interruptSucceeded", false),
			boolField(expectValue, "unsubscribeSucceeded", false),
			boolField(expectValue, "threadEventChannelBefore", false),
			boolField(expectValue, "sideThreadLocalStateBefore", false),
			boolField(expectValue, "agentNavigationEntryBefore", false),
			boolField(expectValue, "pendingInactiveRequests", false),
			boolField(expectValue, "keepVisibleSelectSucceeded", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(composerHandoffRequestId, outcome.composerHandoffRequestId);
		assertEquals(threadSideThreadNavigationCleanupDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "discardTargetSelected", false)), boolText(outcome.discardTargetSelected));
		assertEquals(boolText(boolField(expectValue, "parentSwitchAttempted", false)), boolText(outcome.parentSwitchAttempted));
		assertEquals(boolText(boolField(expectValue, "selectTargetSucceeded", false)), boolText(outcome.selectTargetSucceeded));
		assertEquals(boolText(boolField(expectValue, "interruptAttempted", false)), boolText(outcome.interruptAttempted));
		assertEquals(boolText(boolField(expectValue, "startupInterruptAttempted", false)), boolText(outcome.startupInterruptAttempted));
		assertEquals(boolText(boolField(expectValue, "turnInterruptAttempted", false)), boolText(outcome.turnInterruptAttempted));
		assertEquals(boolText(boolField(expectValue, "unsubscribeAttempted", false)), boolText(outcome.unsubscribeAttempted));
		assertEquals(boolText(boolField(expectValue, "serverRpcAttempted", false)), boolText(outcome.serverRpcAttempted));
		assertEquals(boolText(boolField(expectValue, "localStateRemoved", false)), boolText(outcome.localStateRemoved));
		assertEquals(boolText(boolField(expectValue, "localStateRetained", false)), boolText(outcome.localStateRetained));
		assertEquals(boolText(boolField(expectValue, "threadEventChannelRemoved", false)), boolText(outcome.threadEventChannelRemoved));
		assertEquals(boolText(boolField(expectValue, "sideThreadStateRemoved", false)), boolText(outcome.sideThreadStateRemoved));
		assertEquals(boolText(boolField(expectValue, "agentNavigationEntryRemoved", false)), boolText(outcome.agentNavigationEntryRemoved));
		assertEquals(boolText(boolField(expectValue, "activeThreadCleared", false)), boolText(outcome.activeThreadCleared));
		assertEquals(boolText(boolField(expectValue, "pendingApprovalsRefreshed", false)), boolText(outcome.pendingApprovalsRefreshed));
		assertEquals(boolText(boolField(expectValue, "activeAgentLabelSynced", false)), boolText(outcome.activeAgentLabelSynced));
		assertEquals(boolText(boolField(expectValue, "pendingInactiveRequestsSurfaced", false)), boolText(outcome.pendingInactiveRequestsSurfaced));
		assertEquals(boolText(boolField(expectValue, "cleanupFailureKeptVisible", false)), boolText(outcome.cleanupFailureKeptVisible));
		assertEquals(boolText(boolField(expectValue, "closedSideThreadLocalOnly", false)), boolText(outcome.closedSideThreadLocalOnly));
		assertEquals(boolText(boolField(expectValue, "errorMessageDisplayed", false)), boolText(outcome.errorMessageDisplayed));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelActiveNonPrimaryShutdowns(
		testCase:Value,
		navigationCleanups:Array<ModelThreadSideThreadNavigationCleanupOutcome>,
		secretProbe:String
	):Array<ModelActiveNonPrimaryShutdownOutcome> {
		final outcomes:Array<ModelActiveNonPrimaryShutdownOutcome> = [];
		final values = optionalArrayField(testCase, "activeNonPrimaryShutdownExpects");
		for (value in values) outcomes.push(assertActiveNonPrimaryShutdown(objectValue(value), navigationCleanups, secretProbe));
		return outcomes;
	}

	static function assertActiveNonPrimaryShutdowns(
		verificationValue:Value,
		navigationCleanups:Array<ModelThreadSideThreadNavigationCleanupOutcome>,
		secretProbe:String
	):Array<ModelActiveNonPrimaryShutdownOutcome> {
		final outcomes:Array<ModelActiveNonPrimaryShutdownOutcome> = [];
		final values = optionalArrayField(verificationValue, "activeNonPrimaryShutdownExpects");
		for (value in values) outcomes.push(assertActiveNonPrimaryShutdown(objectValue(value), navigationCleanups, secretProbe));
		return outcomes;
	}

	static function assertActiveNonPrimaryShutdown(
		expectValue:Value,
		navigationCleanups:Array<ModelThreadSideThreadNavigationCleanupOutcome>,
		secretProbe:String
	):ModelActiveNonPrimaryShutdownOutcome {
		final navigationCleanupRequestId = stringField(expectValue, "navigationCleanupRequestId", "");
		final outcome = ModelActiveNonPrimaryShutdownPolicy.apply(new ModelActiveNonPrimaryShutdownRequest(
			stringField(expectValue, "requestId", ""),
			threadSideThreadNavigationCleanupByRequestId(navigationCleanups, navigationCleanupRequestId),
			activeNonPrimaryShutdownEventKind(stringField(expectValue, "eventKind", "")),
			stringField(expectValue, "activeThreadId", ""),
			stringField(expectValue, "primaryThreadId", ""),
			stringField(expectValue, "pendingShutdownExitThreadId", ""),
			boolField(expectValue, "closedThreadIsSideThread", false),
			boolField(expectValue, "primarySelectSucceeded", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(navigationCleanupRequestId, outcome.navigationCleanupRequestId);
		assertEquals(activeNonPrimaryShutdownDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(activeNonPrimaryShutdownEventKind(stringField(expectValue, "eventKind", "")), outcome.eventKind);
		assertEquals(stringField(expectValue, "activeThreadId", ""), outcome.activeThreadId);
		assertEquals(stringField(expectValue, "primaryThreadId", ""), outcome.primaryThreadId);
		assertEquals(stringField(expectValue, "pendingShutdownExitThreadId", ""), outcome.pendingShutdownExitThreadId);
		assertEquals(stringField(expectValue, "closedThreadId", ""), outcome.closedThreadId);
		assertEquals(stringField(expectValue, "selectedPrimaryThreadId", ""), outcome.selectedPrimaryThreadId);
		assertEquals(boolText(boolField(expectValue, "failoverTargetSelected", false)), boolText(outcome.failoverTargetSelected));
		assertEquals(boolText(boolField(expectValue, "nonShutdownIgnored", false)), boolText(outcome.nonShutdownIgnored));
		assertEquals(boolText(boolField(expectValue, "primaryShutdownIgnored", false)), boolText(outcome.primaryShutdownIgnored));
		assertEquals(boolText(boolField(expectValue, "missingThreadIdsIgnored", false)), boolText(outcome.missingThreadIdsIgnored));
		assertEquals(boolText(boolField(expectValue, "pendingShutdownExitIgnored", false)), boolText(outcome.pendingShutdownExitIgnored));
		assertEquals(boolText(boolField(expectValue, "otherPendingExitStillSwitches", false)), boolText(outcome.otherPendingExitStillSwitches));
		assertEquals(boolText(boolField(expectValue, "markAgentPickerClosed", false)), boolText(outcome.markAgentPickerClosed));
		assertEquals(boolText(boolField(expectValue, "sideClosedLocalCleanupAttempted", false)), boolText(outcome.sideClosedLocalCleanupAttempted));
		assertEquals(boolText(boolField(expectValue, "discardVisibleSideAttempted", false)), boolText(outcome.discardVisibleSideAttempted));
		assertEquals(boolText(boolField(expectValue, "selectPrimaryThreadAttempted", false)), boolText(outcome.selectPrimaryThreadAttempted));
		assertEquals(boolText(boolField(expectValue, "primarySelectSucceeded", false)), boolText(outcome.primarySelectSucceeded));
		assertEquals(boolText(boolField(expectValue, "infoMessageIntended", false)), boolText(outcome.infoMessageIntended));
		assertEquals(boolText(boolField(expectValue, "errorMessageDisplayed", false)), boolText(outcome.errorMessageDisplayed));
		assertEquals(boolText(boolField(expectValue, "activeThreadClearedAfterFailedSwitch", false)), boolText(outcome.activeThreadClearedAfterFailedSwitch));
		assertEquals(boolText(boolField(expectValue, "pendingShutdownExitMarkerCleared", false)), boolText(outcome.pendingShutdownExitMarkerCleared));
		assertEquals(boolText(boolField(expectValue, "activeEventForwarded", false)), boolText(outcome.activeEventForwarded));
		assertEquals(boolText(boolField(expectValue, "failoverBeforePendingExitClear", false)), boolText(outcome.failoverBeforePendingExitClear));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelClearUiHeaders(
		testCase:Value,
		activeShutdowns:Array<ModelActiveNonPrimaryShutdownOutcome>,
		secretProbe:String
	):Array<ModelClearUiHeaderOutcome> {
		final outcomes:Array<ModelClearUiHeaderOutcome> = [];
		final values = optionalArrayField(testCase, "clearUiHeaderExpects");
		for (value in values) outcomes.push(assertClearUiHeader(objectValue(value), activeShutdowns, secretProbe));
		return outcomes;
	}

	static function assertClearUiHeaders(
		verificationValue:Value,
		activeShutdowns:Array<ModelActiveNonPrimaryShutdownOutcome>,
		secretProbe:String
	):Array<ModelClearUiHeaderOutcome> {
		final outcomes:Array<ModelClearUiHeaderOutcome> = [];
		final values = optionalArrayField(verificationValue, "clearUiHeaderExpects");
		for (value in values) outcomes.push(assertClearUiHeader(objectValue(value), activeShutdowns, secretProbe));
		return outcomes;
	}

	static function assertClearUiHeader(
		expectValue:Value,
		activeShutdowns:Array<ModelActiveNonPrimaryShutdownOutcome>,
		secretProbe:String
	):ModelClearUiHeaderOutcome {
		final activeShutdownRequestId = stringField(expectValue, "activeShutdownRequestId", "");
		final outcome = ModelClearUiHeaderPolicy.apply(new ModelClearUiHeaderRequest(
			stringField(expectValue, "requestId", ""),
			activeNonPrimaryShutdownByRequestId(activeShutdowns, activeShutdownRequestId),
			clearUiHeaderRequestKind(stringField(expectValue, "requestKind", "")),
			stringField(expectValue, "model", ""),
			stringField(expectValue, "reasoningEffort", ""),
			stringField(expectValue, "cwd", ""),
			stringField(expectValue, "version", ""),
			intField(expectValue, "width", 0),
			boolField(expectValue, "redrawHeader", false),
			boolField(expectValue, "altScreenActive", false),
			intField(expectValue, "viewportYBefore", 0),
			intField(expectValue, "transcriptCellCountBefore", 0),
			intField(expectValue, "pendingHistoryLineCountBefore", 0),
			stringField(expectValue, "staleNoticeProbe", ""),
			stringField(expectValue, "staleTranscriptProbe", ""),
			boolField(expectValue, "fastStatusEligible", false),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(activeShutdownRequestId, outcome.activeShutdownRequestId);
		assertEquals(clearUiHeaderDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(clearUiHeaderRequestKind(stringField(expectValue, "requestKind", "")), outcome.requestKind);
		assertEquals(stringField(expectValue, "titleLine", ""), outcome.titleLine);
		assertEquals(stringField(expectValue, "modelLine", ""), outcome.modelLine);
		assertEquals(stringField(expectValue, "directoryLine", ""), outcome.directoryLine);
		assertEquals(Std.string(intField(expectValue, "lineCount", 0)), Std.string(outcome.lineCount));
		assertEquals(Std.string(intField(expectValue, "width", 0)), Std.string(outcome.width));
		assertEquals(stringField(expectValue, "version", ""), outcome.version);
		assertEquals(boolText(boolField(expectValue, "headerRendered", false)), boolText(outcome.headerRendered));
		assertEquals(boolText(boolField(expectValue, "clearPendingHistoryLines", false)), boolText(outcome.clearPendingHistoryLines));
		assertEquals(boolText(boolField(expectValue, "visibleScreenCleared", false)), boolText(outcome.visibleScreenCleared));
		assertEquals(boolText(boolField(expectValue, "scrollbackCleared", false)), boolText(outcome.scrollbackCleared));
		assertEquals(boolText(boolField(expectValue, "viewportAnchoredToTop", false)), boolText(outcome.viewportAnchoredToTop));
		assertEquals(boolText(boolField(expectValue, "queuedHeaderInserted", false)), boolText(outcome.queuedHeaderInserted));
		assertEquals(boolText(boolField(expectValue, "hasEmittedHistoryLinesAfter", false)), boolText(outcome.hasEmittedHistoryLinesAfter));
		assertEquals(boolText(boolField(expectValue, "transcriptStateReset", false)), boolText(outcome.transcriptStateReset));
		assertEquals(boolText(boolField(expectValue, "staleNoticeSuppressed", false)), boolText(outcome.staleNoticeSuppressed));
		assertEquals(boolText(boolField(expectValue, "staleTranscriptSuppressed", false)), boolText(outcome.staleTranscriptSuppressed));
		assertEquals(boolText(boolField(expectValue, "ctrlLReusedClearHeader", false)), boolText(outcome.ctrlLReusedClearHeader));
		assertEquals(boolText(boolField(expectValue, "fastStatusShown", false)), boolText(outcome.fastStatusShown));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		final staleNotice = stringField(expectValue, "staleNoticeProbe", "");
		final staleTranscript = stringField(expectValue, "staleTranscriptProbe", "");
		if (staleNotice.length > 0) assertNotContains(outcome.summary(), staleNotice);
		if (staleTranscript.length > 0) assertNotContains(outcome.summary(), staleTranscript);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelTerminalResizeReflows(
		testCase:Value,
		clearUiHeaders:Array<ModelClearUiHeaderOutcome>,
		secretProbe:String
	):Array<ModelTerminalResizeReflowOutcome> {
		final outcomes:Array<ModelTerminalResizeReflowOutcome> = [];
		final values = optionalArrayField(testCase, "terminalResizeReflowExpects");
		for (value in values) outcomes.push(assertTerminalResizeReflow(objectValue(value), clearUiHeaders, secretProbe));
		return outcomes;
	}

	static function assertTerminalResizeReflows(
		verificationValue:Value,
		clearUiHeaders:Array<ModelClearUiHeaderOutcome>,
		secretProbe:String
	):Array<ModelTerminalResizeReflowOutcome> {
		final outcomes:Array<ModelTerminalResizeReflowOutcome> = [];
		final values = optionalArrayField(verificationValue, "terminalResizeReflowExpects");
		for (value in values) outcomes.push(assertTerminalResizeReflow(objectValue(value), clearUiHeaders, secretProbe));
		return outcomes;
	}

	static function assertTerminalResizeReflow(
		expectValue:Value,
		clearUiHeaders:Array<ModelClearUiHeaderOutcome>,
		secretProbe:String
	):ModelTerminalResizeReflowOutcome {
		final clearUiHeaderRequestId = stringField(expectValue, "clearUiHeaderRequestId", "");
		final outcome = ModelTerminalResizeReflowPolicy.apply(new ModelTerminalResizeReflowRequest(
			stringField(expectValue, "requestId", ""),
			clearUiHeaderByRequestId(clearUiHeaders, clearUiHeaderRequestId),
			terminalResizeReflowRequestKind(stringField(expectValue, "requestKind", "")),
			terminalResizeReflowMaxRowsKind(stringField(expectValue, "maxRowsKind", "")),
			intField(expectValue, "maxRows", 0),
			boolField(expectValue, "terminalResizeReflowEnabled", false),
			boolField(expectValue, "overlayActive", false),
			intField(expectValue, "terminalWidth", 0),
			intField(expectValue, "petReservedColumns", 0),
			stringArrayField(expectValue, "transcriptRows"),
			stringArrayField(expectValue, "replayRows"),
			intField(expectValue, "eventOrderIndex", 0),
			intField(expectValue, "previousEventCount", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(clearUiHeaderRequestId, outcome.clearUiHeaderRequestId);
		assertEquals(terminalResizeReflowDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(terminalResizeReflowRequestKind(stringField(expectValue, "requestKind", "")), outcome.requestKind);
		assertEquals(terminalResizeReflowMaxRowsKind(stringField(expectValue, "maxRowsKind", "")), outcome.maxRowsKind);
		assertEquals(Std.string(intField(expectValue, "maxRows", 0)), Std.string(outcome.maxRows));
		assertEquals(Std.string(intField(expectValue, "terminalWidth", 0)), Std.string(outcome.terminalWidth));
		assertEquals(Std.string(intField(expectValue, "historyWrapWidth", 0)), Std.string(outcome.historyWrapWidth));
		assertEquals(Std.string(intField(expectValue, "petReservedColumns", 0)), Std.string(outcome.petReservedColumns));
		assertEquals(Std.string(intField(expectValue, "transcriptCellCount", 0)), Std.string(outcome.transcriptCellCount));
		assertStringArraysEqual(stringArrayField(expectValue, "renderedLines"), outcome.renderedLines);
		assertStringArraysEqual(stringArrayField(expectValue, "retainedReplayRows"), outcome.retainedReplayRows);
		assertEquals(Std.string(intField(expectValue, "renderedLineCount", 0)), Std.string(outcome.renderedLineCount));
		assertEquals(Std.string(intField(expectValue, "trimmedLineCount", 0)), Std.string(outcome.trimmedLineCount));
		assertEquals(boolText(boolField(expectValue, "rowCapApplied", false)), boolText(outcome.rowCapApplied));
		assertEquals(boolText(boolField(expectValue, "recentSuffixOnly", false)), boolText(outcome.recentSuffixOnly));
		assertEquals(boolText(boolField(expectValue, "allCellsRendered", false)), boolText(outcome.allCellsRendered));
		assertEquals(boolText(boolField(expectValue, "petReservedWidthApplied", false)), boolText(outcome.petReservedWidthApplied));
		assertEquals(boolText(boolField(expectValue, "petWrappedEarlier", false)), boolText(outcome.petWrappedEarlier));
		assertEquals(boolText(boolField(expectValue, "initialReplayBufferStarted", false)), boolText(outcome.initialReplayBufferStarted));
		assertEquals(boolText(boolField(expectValue, "initialReplayRowsTrimmed", false)), boolText(outcome.initialReplayRowsTrimmed));
		assertEquals(boolText(boolField(expectValue, "threadSwitchTailMode", false)), boolText(outcome.threadSwitchTailMode));
		assertEquals(boolText(boolField(expectValue, "threadSwitchBufferDisabled", false)), boolText(outcome.threadSwitchBufferDisabled));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function clearUiHeaderByRequestId(outcomes:Array<ModelClearUiHeaderOutcome>, requestId:String):ModelClearUiHeaderOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing clear UI header outcome: " + requestId;
	}

	static function assertTopLevelResizeReflowSchedulings(
		testCase:Value,
		resizeReflows:Array<ModelTerminalResizeReflowOutcome>,
		secretProbe:String
	):Array<ModelResizeReflowSchedulingOutcome> {
		final outcomes:Array<ModelResizeReflowSchedulingOutcome> = [];
		final values = optionalArrayField(testCase, "resizeReflowSchedulingExpects");
		for (value in values) outcomes.push(assertResizeReflowScheduling(objectValue(value), resizeReflows, secretProbe));
		return outcomes;
	}

	static function assertResizeReflowSchedulings(
		verificationValue:Value,
		resizeReflows:Array<ModelTerminalResizeReflowOutcome>,
		secretProbe:String
	):Array<ModelResizeReflowSchedulingOutcome> {
		final outcomes:Array<ModelResizeReflowSchedulingOutcome> = [];
		final values = optionalArrayField(verificationValue, "resizeReflowSchedulingExpects");
		for (value in values) outcomes.push(assertResizeReflowScheduling(objectValue(value), resizeReflows, secretProbe));
		return outcomes;
	}

	static function assertResizeReflowScheduling(
		expectValue:Value,
		resizeReflows:Array<ModelTerminalResizeReflowOutcome>,
		secretProbe:String
	):ModelResizeReflowSchedulingOutcome {
		final resizeReflowRequestId = stringField(expectValue, "resizeReflowRequestId", "");
		final outcome = ModelResizeReflowSchedulingPolicy.apply(new ModelResizeReflowSchedulingRequest(
			stringField(expectValue, "requestId", ""),
			terminalResizeReflowByRequestId(resizeReflows, resizeReflowRequestId),
			boolField(expectValue, "terminalResizeReflowEnabled", false),
			intField(expectValue, "currentWidth", 0),
			intField(expectValue, "currentHeight", 0),
			intField(expectValue, "lastKnownWidth", 0),
			intField(expectValue, "lastKnownHeight", 0),
			intField(expectValue, "previousObservedWidth", -1),
			intField(expectValue, "previousReflowWidth", -1),
			intField(expectValue, "previousPendingWidth", -1),
			boolField(expectValue, "streamTimeSensitive", false),
			intField(expectValue, "previousEventCount", 0),
			intField(expectValue, "eventOrderIndex", 0),
			secretProbe
		));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(resizeReflowRequestId, outcome.resizeReflowRequestId);
		assertEquals(resizeReflowSchedulingDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "currentWidth", 0)), Std.string(outcome.currentWidth));
		assertEquals(Std.string(intField(expectValue, "currentHeight", 0)), Std.string(outcome.currentHeight));
		assertEquals(Std.string(intField(expectValue, "lastKnownWidth", 0)), Std.string(outcome.lastKnownWidth));
		assertEquals(Std.string(intField(expectValue, "lastKnownHeight", 0)), Std.string(outcome.lastKnownHeight));
		assertEquals(boolText(boolField(expectValue, "widthInitialized", false)), boolText(outcome.widthInitialized));
		assertEquals(boolText(boolField(expectValue, "widthChanged", false)), boolText(outcome.widthChanged));
		assertEquals(boolText(boolField(expectValue, "reflowNeededForWidth", false)), boolText(outcome.reflowNeededForWidth));
		assertEquals(boolText(boolField(expectValue, "heightChanged", false)), boolText(outcome.heightChanged));
		assertEquals(boolText(boolField(expectValue, "shouldRebuildTranscript", false)), boolText(outcome.shouldRebuildTranscript));
		assertEquals(boolText(boolField(expectValue, "pendingReflowSet", false)), boolText(outcome.pendingReflowSet));
		assertEquals(Std.string(intField(expectValue, "pendingTargetWidth", -1)), Std.string(outcome.pendingTargetWidth));
		assertEquals(Std.string(intField(expectValue, "debounceMs", 0)), Std.string(outcome.debounceMs));
		assertEquals(boolText(boolField(expectValue, "immediateFrameRequested", false)), boolText(outcome.immediateFrameRequested));
		assertEquals(boolText(boolField(expectValue, "delayedFrameRequested", false)), boolText(outcome.delayedFrameRequested));
		assertEquals(boolText(boolField(expectValue, "statusLineRefreshNeeded", false)), boolText(outcome.statusLineRefreshNeeded));
		assertEquals(boolText(boolField(expectValue, "streamResizeMarked", false)), boolText(outcome.streamResizeMarked));
		assertEquals(boolText(boolField(expectValue, "reflowStateCleared", false)), boolText(outcome.reflowStateCleared));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function terminalResizeReflowByRequestId(
		outcomes:Array<ModelTerminalResizeReflowOutcome>,
		requestId:String
	):ModelTerminalResizeReflowOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing terminal resize reflow outcome: " + requestId;
	}

	static function assertTopLevelFeedbackSubmissionRoutings(
		testCase:Value,
		secretProbe:String
	):Array<ModelFeedbackSubmissionRoutingOutcome> {
		final outcomes:Array<ModelFeedbackSubmissionRoutingOutcome> = [];
		final values = optionalArrayField(testCase, "feedbackSubmissionRoutingExpects");
		for (value in values) outcomes.push(assertFeedbackSubmissionRouting(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFeedbackSubmissionRoutings(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelFeedbackSubmissionRoutingOutcome> {
		final outcomes:Array<ModelFeedbackSubmissionRoutingOutcome> = [];
		final values = optionalArrayField(verificationValue, "feedbackSubmissionRoutingExpects");
		for (value in values) outcomes.push(assertFeedbackSubmissionRouting(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFeedbackSubmissionRouting(
		expectValue:Value,
		secretProbe:String
	):ModelFeedbackSubmissionRoutingOutcome {
		final outcome = ModelFeedbackSubmissionRoutingPolicy.route(new ModelFeedbackSubmissionRoutingRequest({
			requestId: stringField(expectValue, "requestId", ""),
			requestKind: feedbackSubmissionRequestKind(stringField(expectValue, "requestKind", "")),
			category: feedbackSubmissionCategory(stringField(expectValue, "category", "")),
			includeLogs: boolField(expectValue, "includeLogs", false),
			resultOk: boolField(expectValue, "resultOk", false),
			resultThreadId: stringField(expectValue, "resultThreadId", ""),
			resultErrorMessage: stringField(expectValue, "resultErrorMessage", ""),
			originThreadProvided: boolField(expectValue, "originThreadProvided", false),
			originThreadActive: boolField(expectValue, "originThreadActive", false),
			snapshotReplay: boolField(expectValue, "snapshotReplay", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(feedbackSubmissionRequestKind(stringField(expectValue, "requestKind", "")), outcome.requestKind);
		assertEquals(feedbackSubmissionDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(feedbackSubmissionCategory(stringField(expectValue, "category", "")), outcome.category);
		assertEquals(boolText(boolField(expectValue, "includeLogs", false)), boolText(outcome.includeLogs));
		assertEquals(boolText(boolField(expectValue, "feedbackSucceeded", false)), boolText(outcome.feedbackSucceeded));
		assertEquals(stringField(expectValue, "resultThreadId", ""), outcome.resultThreadId);
		assertEquals(stringField(expectValue, "resultErrorMessage", ""), outcome.resultErrorMessage);
		assertEquals(boolText(boolField(expectValue, "originThreadProvided", false)), boolText(outcome.originThreadProvided));
		assertEquals(boolText(boolField(expectValue, "originThreadActive", false)), boolText(outcome.originThreadActive));
		assertEquals(boolText(boolField(expectValue, "originThreadBuffered", false)), boolText(outcome.originThreadBuffered));
		assertEquals(boolText(boolField(expectValue, "activeThreadSendAttempted", false)), boolText(outcome.activeThreadSendAttempted));
		assertEquals(boolText(boolField(expectValue, "currentHistoryRendered", false)), boolText(outcome.currentHistoryRendered));
		assertEquals(boolText(boolField(expectValue, "snapshotReplayRendered", false)), boolText(outcome.snapshotReplayRendered));
		assertEquals(feedbackSubmissionHistoryCellKind(stringField(expectValue, "historyCellKind", "")), outcome.historyCellKind);
		assertEquals(stringField(expectValue, "historyCellText", ""), outcome.historyCellText);
		assertEquals(boolText(boolField(expectValue, "appEventEmittedImmediately", false)), boolText(outcome.appEventEmittedImmediately));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveFeedbackUploadAttempted", false)), boolText(outcome.liveFeedbackUploadAttempted));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.historyCellText, secretProbe);
		}
		return outcome;
	}

	static function assertTopLevelTuiActiveTurnErrors(
		testCase:Value,
		secretProbe:String
	):Array<ModelTuiActiveTurnErrorOutcome> {
		final outcomes:Array<ModelTuiActiveTurnErrorOutcome> = [];
		final values = optionalArrayField(testCase, "tuiActiveTurnErrorExpects");
		for (value in values) outcomes.push(assertTuiActiveTurnError(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertTuiActiveTurnErrors(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelTuiActiveTurnErrorOutcome> {
		final outcomes:Array<ModelTuiActiveTurnErrorOutcome> = [];
		final values = optionalArrayField(verificationValue, "tuiActiveTurnErrorExpects");
		for (value in values) outcomes.push(assertTuiActiveTurnError(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertTuiActiveTurnError(
		expectValue:Value,
		secretProbe:String
	):ModelTuiActiveTurnErrorOutcome {
		final outcome = ModelTuiActiveTurnErrorPolicy.classify(new ModelTuiActiveTurnErrorRequest({
			requestId: stringField(expectValue, "requestId", ""),
			requestKind: tuiActiveTurnErrorRequestKind(stringField(expectValue, "requestKind", "")),
			method: stringField(expectValue, "method", ""),
			message: stringField(expectValue, "message", ""),
			hasStructuredTurnError: boolField(expectValue, "hasStructuredTurnError", false),
			structuredNotSteerable: boolField(expectValue, "structuredNotSteerable", false),
			turnKind: tuiActiveTurnErrorTurnKind(stringField(expectValue, "turnKind", "none")),
			sessionAction: stringField(expectValue, "sessionAction", ""),
			targetThreadId: stringField(expectValue, "targetThreadId", ""),
			targetRolloutPath: stringField(expectValue, "targetRolloutPath", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(tuiActiveTurnErrorRequestKind(stringField(expectValue, "requestKind", "")), outcome.requestKind);
		assertEquals(tuiActiveTurnErrorDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(stringField(expectValue, "method", ""), outcome.method);
		assertEquals(tuiActiveTurnErrorTurnKind(stringField(expectValue, "outcomeTurnKind", "none")), outcome.turnKind);
		assertEquals(stringField(expectValue, "userVisibleMessage", ""), outcome.userVisibleMessage);
		assertEquals(stringField(expectValue, "sanitizedSessionMessage", ""), outcome.sanitizedSessionMessage);
		assertEquals(stringField(expectValue, "actualTurnId", ""), outcome.actualTurnId);
		assertEquals(boolText(boolField(expectValue, "structuredTurnErrorExtracted", false)), boolText(outcome.structuredTurnErrorExtracted));
		assertEquals(boolText(boolField(expectValue, "steerRaceDetected", false)), boolText(outcome.steerRaceDetected));
		assertEquals(boolText(boolField(expectValue, "interruptRaceDetected", false)), boolText(outcome.interruptRaceDetected));
		assertEquals(boolText(boolField(expectValue, "archivedGuidanceDetected", false)), boolText(outcome.archivedGuidanceDetected));
		assertEquals(boolText(boolField(expectValue, "shouldClearCachedActiveTurn", false)), boolText(outcome.shouldClearCachedActiveTurn));
		assertEquals(boolText(boolField(expectValue, "shouldStartNewTurn", false)), boolText(outcome.shouldStartNewTurn));
		assertEquals(boolText(boolField(expectValue, "shouldRetryWithActualTurn", false)), boolText(outcome.shouldRetryWithActualTurn));
		assertEquals(boolText(boolField(expectValue, "shouldQueueRejectedSteer", false)), boolText(outcome.shouldQueueRejectedSteer));
		assertEquals(boolText(boolField(expectValue, "shouldDisplayErrorMessage", false)), boolText(outcome.shouldDisplayErrorMessage));
		assertEquals(boolText(boolField(expectValue, "rolloutPathLeaked", false)), boolText(outcome.rolloutPathLeaked));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.sanitizedSessionMessage, secretProbe);
			assertNotContains(outcome.userVisibleMessage, secretProbe);
		}
		return outcome;
	}

	static function assertTopLevelFreshSessionServiceTiers(
		testCase:Value,
		secretProbe:String
	):Array<ModelFreshSessionServiceTierOutcome> {
		final outcomes:Array<ModelFreshSessionServiceTierOutcome> = [];
		final values = optionalArrayField(testCase, "freshSessionServiceTierExpects");
		for (value in values) outcomes.push(assertFreshSessionServiceTier(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFreshSessionServiceTiers(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelFreshSessionServiceTierOutcome> {
		final outcomes:Array<ModelFreshSessionServiceTierOutcome> = [];
		final values = optionalArrayField(verificationValue, "freshSessionServiceTierExpects");
		for (value in values) outcomes.push(assertFreshSessionServiceTier(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFreshSessionServiceTier(
		expectValue:Value,
		secretProbe:String
	):ModelFreshSessionServiceTierOutcome {
		final outcome = ModelFreshSessionServiceTierPolicy.apply(new ModelFreshSessionServiceTierRequest({
			requestId: stringField(expectValue, "requestId", ""),
			baseConfigServiceTier: freshSessionServiceTierValue(stringField(expectValue, "baseConfigServiceTier", "")),
			configuredServiceTier: freshSessionServiceTierValue(stringField(expectValue, "configuredServiceTier", "")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(freshSessionServiceTierDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(freshSessionServiceTierValue(stringField(expectValue, "baseConfigServiceTier", "")), outcome.baseConfigServiceTier);
		assertEquals(freshSessionServiceTierValue(stringField(expectValue, "configuredServiceTier", "")), outcome.configuredServiceTier);
		assertEquals(freshSessionServiceTierValue(stringField(expectValue, "freshConfigServiceTier", "")), outcome.freshConfigServiceTier);
		assertEquals(boolText(boolField(expectValue, "serviceTierOverrodeBaseConfig", false)), boolText(outcome.serviceTierOverrodeBaseConfig));
		assertEquals(boolText(boolField(expectValue, "serviceTierClearedFromBaseConfig", false)), boolText(outcome.serviceTierClearedFromBaseConfig));
		assertEquals(boolText(boolField(expectValue, "baseConfigOtherwisePreserved", false)), boolText(outcome.baseConfigOtherwisePreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelFreshSessionPreviousConversationShutdowns(
		testCase:Value,
		secretProbe:String
	):Array<ModelFreshSessionPreviousConversationShutdownOutcome> {
		final outcomes:Array<ModelFreshSessionPreviousConversationShutdownOutcome> = [];
		final values = optionalArrayField(testCase, "freshSessionPreviousConversationShutdownExpects");
		for (value in values) outcomes.push(assertFreshSessionPreviousConversationShutdown(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFreshSessionPreviousConversationShutdowns(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelFreshSessionPreviousConversationShutdownOutcome> {
		final outcomes:Array<ModelFreshSessionPreviousConversationShutdownOutcome> = [];
		final values = optionalArrayField(verificationValue, "freshSessionPreviousConversationShutdownExpects");
		for (value in values) outcomes.push(assertFreshSessionPreviousConversationShutdown(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertFreshSessionPreviousConversationShutdown(
		expectValue:Value,
		secretProbe:String
	):ModelFreshSessionPreviousConversationShutdownOutcome {
		final outcome = ModelFreshSessionPreviousConversationShutdownPolicy.apply(new ModelFreshSessionPreviousConversationShutdownRequest({
			requestId: stringField(expectValue, "requestId", ""),
			previousThreadId: stringField(expectValue, "previousThreadId", ""),
			newSessionRequested: boolField(expectValue, "newSessionRequested", false),
			chatWidgetThreadKnown: boolField(expectValue, "chatWidgetThreadKnown", false),
			appServerSessionAvailable: boolField(expectValue, "appServerSessionAvailable", false),
			threadChannelTracked: boolField(expectValue, "threadChannelTracked", false),
			listenerTaskTracked: boolField(expectValue, "listenerTaskTracked", false),
			pendingRollbackBefore: boolField(expectValue, "pendingRollbackBefore", false),
			unsubscribeSucceeded: boolField(expectValue, "unsubscribeSucceeded", false),
			opQueueLengthBefore: intField(expectValue, "opQueueLengthBefore", 0),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(freshSessionPreviousConversationShutdownDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "previousConversationPresent", false)), boolText(outcome.previousConversationPresent));
		assertEquals(boolText(boolField(expectValue, "shutdownCurrentThreadAttempted", false)), boolText(outcome.shutdownCurrentThreadAttempted));
		assertEquals(boolText(boolField(expectValue, "pendingRollbackCleared", false)), boolText(outcome.pendingRollbackCleared));
		assertEquals(boolText(boolField(expectValue, "threadUnsubscribeAttempted", false)), boolText(outcome.threadUnsubscribeAttempted));
		assertEquals(boolText(boolField(expectValue, "threadUnsubscribeSucceeded", false)), boolText(outcome.threadUnsubscribeSucceeded));
		assertEquals(boolText(boolField(expectValue, "listenerAbortAttempted", false)), boolText(outcome.listenerAbortAttempted));
		assertEquals(boolText(boolField(expectValue, "listenerTaskRemoved", false)), boolText(outcome.listenerTaskRemoved));
		assertEquals(boolText(boolField(expectValue, "opShutdownSubmitted", false)), boolText(outcome.opShutdownSubmitted));
		assertEquals(Std.string(intField(expectValue, "opQueueLengthBefore", 0)), Std.string(outcome.opQueueLengthBefore));
		assertEquals(Std.string(intField(expectValue, "opQueueLengthAfter", 0)), Std.string(outcome.opQueueLengthAfter));
		assertEquals(boolText(boolField(expectValue, "duplicateShutdownSuppressed", false)), boolText(outcome.duplicateShutdownSuppressed));
		assertEquals(boolText(boolField(expectValue, "newSessionMayStartAfterShutdown", false)), boolText(outcome.newSessionMayStartAfterShutdown));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "previousThreadId", ""));
		}
		return outcome;
	}

	static function assertTopLevelInterruptWithoutActiveTurns(
		testCase:Value,
		secretProbe:String
	):Array<ModelInterruptWithoutActiveTurnOutcome> {
		final outcomes:Array<ModelInterruptWithoutActiveTurnOutcome> = [];
		final values = optionalArrayField(testCase, "interruptWithoutActiveTurnExpects");
		for (value in values) outcomes.push(assertInterruptWithoutActiveTurn(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptWithoutActiveTurns(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelInterruptWithoutActiveTurnOutcome> {
		final outcomes:Array<ModelInterruptWithoutActiveTurnOutcome> = [];
		final values = optionalArrayField(verificationValue, "interruptWithoutActiveTurnExpects");
		for (value in values) outcomes.push(assertInterruptWithoutActiveTurn(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptWithoutActiveTurn(
		expectValue:Value,
		secretProbe:String
	):ModelInterruptWithoutActiveTurnOutcome {
		final outcome = ModelInterruptWithoutActiveTurnPolicy.apply(new ModelInterruptWithoutActiveTurnRequest({
			requestId: stringField(expectValue, "requestId", ""),
			threadId: stringField(expectValue, "threadId", ""),
			appCommandInterrupt: boolField(expectValue, "appCommandInterrupt", false),
			primaryThreadRegistered: boolField(expectValue, "primaryThreadRegistered", false),
			appServerSessionAvailable: boolField(expectValue, "appServerSessionAvailable", false),
			activeTurnId: stringField(expectValue, "activeTurnId", ""),
			startupInterruptSucceeded: boolField(expectValue, "startupInterruptSucceeded", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(interruptWithoutActiveTurnDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "primaryThreadRegistered", false)), boolText(outcome.primaryThreadRegistered));
		assertEquals(boolText(boolField(expectValue, "activeTurnPresent", false)), boolText(outcome.activeTurnPresent));
		assertEquals(boolText(boolField(expectValue, "turnInterruptSubmitted", false)), boolText(outcome.turnInterruptSubmitted));
		assertEquals(boolText(boolField(expectValue, "startupInterruptSubmitted", false)), boolText(outcome.startupInterruptSubmitted));
		assertEquals(boolText(boolField(expectValue, "startupInterruptSucceeded", false)), boolText(outcome.startupInterruptSucceeded));
		assertEquals(boolText(boolField(expectValue, "handled", false)), boolText(outcome.handled));
		assertEquals(boolText(boolField(expectValue, "retryAttempted", false)), boolText(outcome.retryAttempted));
		assertEquals(boolText(boolField(expectValue, "activeTurnRaceRetryUsed", false)), boolText(outcome.activeTurnRaceRetryUsed));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "threadId", ""));
			final activeTurnId = stringField(expectValue, "activeTurnId", "");
			if (activeTurnId.length > 0) assertNotContains(outcome.summary(), activeTurnId);
		}
		return outcome;
	}

	static function assertTopLevelOverrideTurnContextSettingsUpdates(
		testCase:Value,
		secretProbe:String
	):Array<ModelOverrideTurnContextSettingsUpdateOutcome> {
		final outcomes:Array<ModelOverrideTurnContextSettingsUpdateOutcome> = [];
		final values = optionalArrayField(testCase, "overrideTurnContextSettingsUpdateExpects");
		for (value in values) outcomes.push(assertOverrideTurnContextSettingsUpdate(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertOverrideTurnContextSettingsUpdates(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelOverrideTurnContextSettingsUpdateOutcome> {
		final outcomes:Array<ModelOverrideTurnContextSettingsUpdateOutcome> = [];
		final values = optionalArrayField(verificationValue, "overrideTurnContextSettingsUpdateExpects");
		for (value in values) outcomes.push(assertOverrideTurnContextSettingsUpdate(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertOverrideTurnContextSettingsUpdate(
		expectValue:Value,
		secretProbe:String
	):ModelOverrideTurnContextSettingsUpdateOutcome {
		final outcome = ModelOverrideTurnContextSettingsUpdatePolicy.apply(new ModelOverrideTurnContextSettingsUpdateRequest({
			requestId: stringField(expectValue, "requestId", ""),
			threadId: stringField(expectValue, "threadId", ""),
			appCommandOverrideTurnContext: boolField(expectValue, "appCommandOverrideTurnContext", false),
			primaryThreadRegistered: boolField(expectValue, "primaryThreadRegistered", false),
			appServerSessionAvailable: boolField(expectValue, "appServerSessionAvailable", false),
			hasSettingsChanges: boolField(expectValue, "hasSettingsChanges", false),
			initialModel: stringField(expectValue, "initialModel", ""),
			initialEffort: stringField(expectValue, "initialEffort", ""),
			requestedModel: stringField(expectValue, "requestedModel", ""),
			requestedEffort: stringField(expectValue, "requestedEffort", ""),
			requestedServiceTier: stringField(expectValue, "requestedServiceTier", ""),
			requestedApprovalPolicy: stringField(expectValue, "requestedApprovalPolicy", ""),
			requestedApprovalsReviewer: stringField(expectValue, "requestedApprovalsReviewer", ""),
			requestedActivePermissionProfile: stringField(expectValue, "requestedActivePermissionProfile", ""),
			requestedCollaborationMode: stringField(expectValue, "requestedCollaborationMode", ""),
			requestedCollaborationModel: stringField(expectValue, "requestedCollaborationModel", ""),
			requestedCollaborationEffort: stringField(expectValue, "requestedCollaborationEffort", ""),
			requestedPersonality: stringField(expectValue, "requestedPersonality", ""),
			notificationReceived: boolField(expectValue, "notificationReceived", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(overrideTurnContextSettingsUpdateDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "handled", false)), boolText(outcome.handled));
		assertEquals(boolText(boolField(expectValue, "threadSettingsUpdateSubmitted", false)), boolText(outcome.threadSettingsUpdateSubmitted));
		assertEquals(boolText(boolField(expectValue, "updateParamsCarriedRequestedSettings", false)), boolText(outcome.updateParamsCarriedRequestedSettings));
		assertEquals(boolText(boolField(expectValue, "cachedPrimarySessionUnchangedBeforeNotification", false)), boolText(outcome.cachedPrimarySessionUnchangedBeforeNotification));
		assertEquals(boolText(boolField(expectValue, "notificationReceived", false)), boolText(outcome.notificationReceived));
		assertEquals(boolText(boolField(expectValue, "notificationAppliedToCache", false)), boolText(outcome.notificationAppliedToCache));
		assertEquals(boolText(boolField(expectValue, "primarySessionModelPreserved", false)), boolText(outcome.primarySessionModelPreserved));
		assertEquals(boolText(boolField(expectValue, "primarySessionEffortPreserved", false)), boolText(outcome.primarySessionEffortPreserved));
		assertEquals(boolText(boolField(expectValue, "collaborationModeCached", false)), boolText(outcome.collaborationModeCached));
		assertEquals(boolText(boolField(expectValue, "collaborationSettingsRebasedToNotification", false)), boolText(outcome.collaborationSettingsRebasedToNotification));
		assertEquals(boolText(boolField(expectValue, "serviceTierCached", false)), boolText(outcome.serviceTierCached));
		assertEquals(boolText(boolField(expectValue, "approvalPolicyCached", false)), boolText(outcome.approvalPolicyCached));
		assertEquals(boolText(boolField(expectValue, "approvalsReviewerCached", false)), boolText(outcome.approvalsReviewerCached));
		assertEquals(boolText(boolField(expectValue, "activePermissionProfileSubmitted", false)), boolText(outcome.activePermissionProfileSubmitted));
		assertEquals(boolText(boolField(expectValue, "personalityCached", false)), boolText(outcome.personalityCached));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "threadId", ""));
		}
		return outcome;
	}

	static function assertTopLevelInactiveThreadSettingsNotifications(
		testCase:Value,
		secretProbe:String
	):Array<ModelInactiveThreadSettingsNotificationOutcome> {
		final outcomes:Array<ModelInactiveThreadSettingsNotificationOutcome> = [];
		final values = optionalArrayField(testCase, "inactiveThreadSettingsNotificationExpects");
		for (value in values) outcomes.push(assertInactiveThreadSettingsNotification(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInactiveThreadSettingsNotifications(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelInactiveThreadSettingsNotificationOutcome> {
		final outcomes:Array<ModelInactiveThreadSettingsNotificationOutcome> = [];
		final values = optionalArrayField(verificationValue, "inactiveThreadSettingsNotificationExpects");
		for (value in values) outcomes.push(assertInactiveThreadSettingsNotification(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInactiveThreadSettingsNotification(
		expectValue:Value,
		secretProbe:String
	):ModelInactiveThreadSettingsNotificationOutcome {
		final outcome = ModelInactiveThreadSettingsNotificationPolicy.apply(new ModelInactiveThreadSettingsNotificationRequest({
			requestId: stringField(expectValue, "requestId", ""),
			primaryThreadId: stringField(expectValue, "primaryThreadId", ""),
			inactiveThreadId: stringField(expectValue, "inactiveThreadId", ""),
			activeThreadId: stringField(expectValue, "activeThreadId", ""),
			primaryThreadRegistered: boolField(expectValue, "primaryThreadRegistered", false),
			inactiveThreadChannelPresent: boolField(expectValue, "inactiveThreadChannelPresent", false),
			inactiveSessionCached: boolField(expectValue, "inactiveSessionCached", false),
			notificationKindThreadSettingsUpdated: boolField(expectValue, "notificationKindThreadSettingsUpdated", false),
			notificationThreadMatchesInactive: boolField(expectValue, "notificationThreadMatchesInactive", false),
			initialPrimaryModel: stringField(expectValue, "initialPrimaryModel", ""),
			initialPrimaryEffort: stringField(expectValue, "initialPrimaryEffort", ""),
			initialInactiveModel: stringField(expectValue, "initialInactiveModel", ""),
			initialInactiveEffort: stringField(expectValue, "initialInactiveEffort", ""),
			notificationModel: stringField(expectValue, "notificationModel", ""),
			notificationEffort: stringField(expectValue, "notificationEffort", ""),
			notificationModelProvider: stringField(expectValue, "notificationModelProvider", ""),
			notificationServiceTier: stringField(expectValue, "notificationServiceTier", ""),
			notificationApprovalPolicy: stringField(expectValue, "notificationApprovalPolicy", ""),
			notificationApprovalsReviewer: stringField(expectValue, "notificationApprovalsReviewer", ""),
			notificationSandboxPolicy: stringField(expectValue, "notificationSandboxPolicy", ""),
			notificationActivePermissionProfile: stringField(expectValue, "notificationActivePermissionProfile", ""),
			notificationCollaborationMode: stringField(expectValue, "notificationCollaborationMode", ""),
			notificationCollaborationModel: stringField(expectValue, "notificationCollaborationModel", ""),
			notificationCollaborationEffort: stringField(expectValue, "notificationCollaborationEffort", ""),
			notificationPersonality: stringField(expectValue, "notificationPersonality", ""),
			handoffToChatWidget: boolField(expectValue, "handoffToChatWidget", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(inactiveThreadSettingsNotificationDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "notificationAccepted", false)), boolText(outcome.notificationAccepted));
		assertEquals(boolText(boolField(expectValue, "inactiveChannelRetained", false)), boolText(outcome.inactiveChannelRetained));
		assertEquals(boolText(boolField(expectValue, "inactiveSessionUpdated", false)), boolText(outcome.inactiveSessionUpdated));
		assertEquals(boolText(boolField(expectValue, "primarySessionUnchanged", false)), boolText(outcome.primarySessionUnchanged));
		assertEquals(boolText(boolField(expectValue, "inactiveSessionModelPreserved", false)), boolText(outcome.inactiveSessionModelPreserved));
		assertEquals(boolText(boolField(expectValue, "inactiveSessionEffortPreserved", false)), boolText(outcome.inactiveSessionEffortPreserved));
		assertEquals(boolText(boolField(expectValue, "collaborationModeCached", false)), boolText(outcome.collaborationModeCached));
		assertEquals(boolText(boolField(expectValue, "collaborationSettingsRebasedToNotification", false)), boolText(outcome.collaborationSettingsRebasedToNotification));
		assertEquals(boolText(boolField(expectValue, "modelProviderCached", false)), boolText(outcome.modelProviderCached));
		assertEquals(boolText(boolField(expectValue, "serviceTierCached", false)), boolText(outcome.serviceTierCached));
		assertEquals(boolText(boolField(expectValue, "approvalPolicyCached", false)), boolText(outcome.approvalPolicyCached));
		assertEquals(boolText(boolField(expectValue, "approvalsReviewerCached", false)), boolText(outcome.approvalsReviewerCached));
		assertEquals(boolText(boolField(expectValue, "permissionProfileCached", false)), boolText(outcome.permissionProfileCached));
		assertEquals(boolText(boolField(expectValue, "activePermissionProfileCached", false)), boolText(outcome.activePermissionProfileCached));
		assertEquals(boolText(boolField(expectValue, "personalityCached", false)), boolText(outcome.personalityCached));
		assertEquals(boolText(boolField(expectValue, "notificationBuffered", false)), boolText(outcome.notificationBuffered));
		assertEquals(boolText(boolField(expectValue, "chatWidgetHandoffApplied", false)), boolText(outcome.chatWidgetHandoffApplied));
		assertEquals(boolText(boolField(expectValue, "chatWidgetCollaborationModeActive", false)), boolText(outcome.chatWidgetCollaborationModeActive));
		assertEquals(boolText(boolField(expectValue, "chatWidgetCurrentModelFromCollaborationSettings", false)), boolText(outcome.chatWidgetCurrentModelFromCollaborationSettings));
		assertEquals(boolText(boolField(expectValue, "chatWidgetCurrentCollaborationModeModelPreservesSessionModel", false)), boolText(outcome.chatWidgetCurrentCollaborationModeModelPreservesSessionModel));
		assertEquals(boolText(boolField(expectValue, "chatWidgetCurrentEffortFromNotification", false)), boolText(outcome.chatWidgetCurrentEffortFromNotification));
		assertEquals(boolText(boolField(expectValue, "chatWidgetPersonalityApplied", false)), boolText(outcome.chatWidgetPersonalityApplied));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "primaryThreadId", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "inactiveThreadId", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "activeThreadId", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "notificationModel", ""));
		}
		return outcome;
	}

	static function assertTopLevelClearOnlyUiResets(
		testCase:Value,
		secretProbe:String
	):Array<ModelClearOnlyUiResetOutcome> {
		final outcomes:Array<ModelClearOnlyUiResetOutcome> = [];
		final values = optionalArrayField(testCase, "clearOnlyUiResetExpects");
		for (value in values) outcomes.push(assertClearOnlyUiReset(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertClearOnlyUiResets(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelClearOnlyUiResetOutcome> {
		final outcomes:Array<ModelClearOnlyUiResetOutcome> = [];
		final values = optionalArrayField(verificationValue, "clearOnlyUiResetExpects");
		for (value in values) outcomes.push(assertClearOnlyUiReset(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertClearOnlyUiReset(
		expectValue:Value,
		secretProbe:String
	):ModelClearOnlyUiResetOutcome {
		final outcome = ModelClearOnlyUiResetPolicy.apply(new ModelClearOnlyUiResetRequest({
			requestId: stringField(expectValue, "requestId", ""),
			threadId: stringField(expectValue, "threadId", ""),
			resetInvoked: boolField(expectValue, "resetInvoked", false),
			overlayPresentBefore: boolField(expectValue, "overlayPresentBefore", false),
			transcriptCellCountBefore: intField(expectValue, "transcriptCellCountBefore", 0),
			deferredHistoryLineCountBefore: intField(expectValue, "deferredHistoryLineCountBefore", 0),
			hasEmittedHistoryLinesBefore: boolField(expectValue, "hasEmittedHistoryLinesBefore", false),
			transcriptReflowEntryCountBefore: intField(expectValue, "transcriptReflowEntryCountBefore", 0),
			initialHistoryReplayBufferPresentBefore: boolField(expectValue, "initialHistoryReplayBufferPresentBefore", false),
			backtrackPrimedBefore: boolField(expectValue, "backtrackPrimedBefore", false),
			backtrackOverlayPreviewActiveBefore: boolField(expectValue, "backtrackOverlayPreviewActiveBefore", false),
			backtrackPendingRollbackBefore: boolField(expectValue, "backtrackPendingRollbackBefore", false),
			backtrackRenderPendingBefore: boolField(expectValue, "backtrackRenderPendingBefore", false),
			skillWarningCountBefore: intField(expectValue, "skillWarningCountBefore", 0),
			chatSessionThreadPresentBefore: boolField(expectValue, "chatSessionThreadPresentBefore", false),
			composerDraftBefore: stringField(expectValue, "composerDraftBefore", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(clearOnlyUiResetDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "resetInvoked", false)), boolText(outcome.resetInvoked));
		assertEquals(boolText(boolField(expectValue, "overlayCleared", false)), boolText(outcome.overlayCleared));
		assertEquals(boolText(boolField(expectValue, "transcriptCleared", false)), boolText(outcome.transcriptCleared));
		assertEquals(boolText(boolField(expectValue, "deferredHistoryCleared", false)), boolText(outcome.deferredHistoryCleared));
		assertEquals(boolText(boolField(expectValue, "historyEmittedFlagReset", false)), boolText(outcome.historyEmittedFlagReset));
		assertEquals(boolText(boolField(expectValue, "transcriptReflowCleared", false)), boolText(outcome.transcriptReflowCleared));
		assertEquals(boolText(boolField(expectValue, "initialHistoryReplayBufferCleared", false)), boolText(outcome.initialHistoryReplayBufferCleared));
		assertEquals(boolText(boolField(expectValue, "backtrackPrimedCleared", false)), boolText(outcome.backtrackPrimedCleared));
		assertEquals(boolText(boolField(expectValue, "backtrackPreviewCleared", false)), boolText(outcome.backtrackPreviewCleared));
		assertEquals(boolText(boolField(expectValue, "backtrackPendingRollbackCleared", false)), boolText(outcome.backtrackPendingRollbackCleared));
		assertEquals(boolText(boolField(expectValue, "backtrackRenderPendingCleared", false)), boolText(outcome.backtrackRenderPendingCleared));
		assertEquals(boolText(boolField(expectValue, "skillWarningsCleared", false)), boolText(outcome.skillWarningsCleared));
		assertEquals(boolText(boolField(expectValue, "chatSessionThreadPreserved", false)), boolText(outcome.chatSessionThreadPreserved));
		assertEquals(boolText(boolField(expectValue, "composerDraftPreserved", false)), boolText(outcome.composerDraftPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "threadId", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "composerDraftBefore", ""));
		}
		return outcome;
	}

	static function assertTopLevelClearOnlySkillWarningRerenders(
		testCase:Value,
		secretProbe:String
	):Array<ModelClearOnlySkillWarningRerenderOutcome> {
		final outcomes:Array<ModelClearOnlySkillWarningRerenderOutcome> = [];
		final values = optionalArrayField(testCase, "clearOnlySkillWarningRerenderExpects");
		for (value in values) outcomes.push(assertClearOnlySkillWarningRerender(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertClearOnlySkillWarningRerenders(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelClearOnlySkillWarningRerenderOutcome> {
		final outcomes:Array<ModelClearOnlySkillWarningRerenderOutcome> = [];
		final values = optionalArrayField(verificationValue, "clearOnlySkillWarningRerenderExpects");
		for (value in values) outcomes.push(assertClearOnlySkillWarningRerender(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertClearOnlySkillWarningRerender(
		expectValue:Value,
		secretProbe:String
	):ModelClearOnlySkillWarningRerenderOutcome {
		final outcome = ModelClearOnlySkillWarningRerenderPolicy.apply(new ModelClearOnlySkillWarningRerenderRequest({
			requestId: stringField(expectValue, "requestId", ""),
			warningPath: stringField(expectValue, "warningPath", ""),
			warningMessage: stringField(expectValue, "warningMessage", ""),
			firstScanInputCount: intField(expectValue, "firstScanInputCount", 0),
			repeatedScanInputCount: intField(expectValue, "repeatedScanInputCount", 0),
			postResetScanInputCount: intField(expectValue, "postResetScanInputCount", 0),
			resetInvoked: boolField(expectValue, "resetInvoked", false),
			clearOnlyResetClearsWarnings: boolField(expectValue, "clearOnlyResetClearsWarnings", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(clearOnlySkillWarningRerenderDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "warningKeyPresent", false)), boolText(outcome.warningKeyPresent));
		assertEquals(boolText(boolField(expectValue, "firstWarningRendered", false)), boolText(outcome.firstWarningRendered));
		assertEquals(boolText(boolField(expectValue, "repeatedWarningSuppressed", false)), boolText(outcome.repeatedWarningSuppressed));
		assertEquals(boolText(boolField(expectValue, "resetClearedWarningMemory", false)), boolText(outcome.resetClearedWarningMemory));
		assertEquals(boolText(boolField(expectValue, "postResetWarningRenderedAgain", false)), boolText(outcome.postResetWarningRenderedAgain));
		assertEquals(boolText(boolField(expectValue, "sameWarningKeyReused", false)), boolText(outcome.sameWarningKeyReused));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "warningPath", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "warningMessage", ""));
		}
		return outcome;
	}

	static function assertTopLevelBacktrackEscVimInsertGuards(
		testCase:Value,
		secretProbe:String
	):Array<ModelBacktrackEscVimInsertGuardOutcome> {
		final outcomes:Array<ModelBacktrackEscVimInsertGuardOutcome> = [];
		final values = optionalArrayField(testCase, "backtrackEscVimInsertGuardExpects");
		for (value in values) outcomes.push(assertBacktrackEscVimInsertGuard(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackEscVimInsertGuards(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelBacktrackEscVimInsertGuardOutcome> {
		final outcomes:Array<ModelBacktrackEscVimInsertGuardOutcome> = [];
		final values = optionalArrayField(verificationValue, "backtrackEscVimInsertGuardExpects");
		for (value in values) outcomes.push(assertBacktrackEscVimInsertGuard(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackEscVimInsertGuard(
		expectValue:Value,
		secretProbe:String
	):ModelBacktrackEscVimInsertGuardOutcome {
		final outcome = ModelBacktrackEscVimInsertGuardPolicy.apply(new ModelBacktrackEscVimInsertGuardRequest({
			requestId: stringField(expectValue, "requestId", ""),
			keyIsEsc: boolField(expectValue, "keyIsEsc", false),
			sideConversationActive: boolField(expectValue, "sideConversationActive", false),
			normalBacktrackMode: boolField(expectValue, "normalBacktrackMode", false),
			composerEmptyInitially: boolField(expectValue, "composerEmptyInitially", false),
			vimModeEnabled: boolField(expectValue, "vimModeEnabled", false),
			vimInsertModeActiveBeforeEsc: boolField(expectValue, "vimInsertModeActiveBeforeEsc", false),
			vimInsertEscHandled: boolField(expectValue, "vimInsertEscHandled", false),
			vimInsertModeActiveAfterEsc: boolField(expectValue, "vimInsertModeActiveAfterEsc", false),
			backtrackPrimedAfterVimEsc: boolField(expectValue, "backtrackPrimedAfterVimEsc", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(backtrackEscVimInsertGuardDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "initialBacktrackEscAllowed", false)), boolText(outcome.initialBacktrackEscAllowed));
		assertEquals(boolText(boolField(expectValue, "vimNormalBacktrackEscAllowed", false)), boolText(outcome.vimNormalBacktrackEscAllowed));
		assertEquals(boolText(boolField(expectValue, "vimInsertEscTakesPrecedence", false)), boolText(outcome.vimInsertEscTakesPrecedence));
		assertEquals(boolText(boolField(expectValue, "backtrackEscSuppressedDuringVimInsert", false)), boolText(outcome.backtrackEscSuppressedDuringVimInsert));
		assertEquals(boolText(boolField(expectValue, "vimEscHandled", false)), boolText(outcome.vimEscHandled));
		assertEquals(boolText(boolField(expectValue, "backtrackNotPrimedByVimEsc", false)), boolText(outcome.backtrackNotPrimedByVimEsc));
		assertEquals(boolText(boolField(expectValue, "vimInsertClearedAfterEsc", false)), boolText(outcome.vimInsertClearedAfterEsc));
		assertEquals(boolText(boolField(expectValue, "backtrackEscAllowedAfterVimEsc", false)), boolText(outcome.backtrackEscAllowedAfterVimEsc));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelSideConversationBacktrackEscVimGuards(
		testCase:Value,
		secretProbe:String
	):Array<ModelSideConversationBacktrackEscVimGuardOutcome> {
		final outcomes:Array<ModelSideConversationBacktrackEscVimGuardOutcome> = [];
		final values = optionalArrayField(testCase, "sideConversationBacktrackEscVimGuardExpects");
		for (value in values) outcomes.push(assertSideConversationBacktrackEscVimGuard(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertSideConversationBacktrackEscVimGuards(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelSideConversationBacktrackEscVimGuardOutcome> {
		final outcomes:Array<ModelSideConversationBacktrackEscVimGuardOutcome> = [];
		final values = optionalArrayField(verificationValue, "sideConversationBacktrackEscVimGuardExpects");
		for (value in values) outcomes.push(assertSideConversationBacktrackEscVimGuard(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertSideConversationBacktrackEscVimGuard(
		expectValue:Value,
		secretProbe:String
	):ModelSideConversationBacktrackEscVimGuardOutcome {
		final outcome = ModelSideConversationBacktrackEscVimGuardPolicy.apply(new ModelSideConversationBacktrackEscVimGuardRequest({
			requestId: stringField(expectValue, "requestId", ""),
			keyIsEsc: boolField(expectValue, "keyIsEsc", false),
			sideConversationActive: boolField(expectValue, "sideConversationActive", false),
			normalBacktrackMode: boolField(expectValue, "normalBacktrackMode", false),
			composerEmptyInitially: boolField(expectValue, "composerEmptyInitially", false),
			vimModeEnabled: boolField(expectValue, "vimModeEnabled", false),
			vimInsertModeActiveBeforeSideEsc: boolField(expectValue, "vimInsertModeActiveBeforeSideEsc", false),
			vimInsertModeActiveAfterInsertKey: boolField(expectValue, "vimInsertModeActiveAfterInsertKey", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(sideConversationBacktrackEscVimGuardDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "initialBacktrackEscHandled", false)), boolText(outcome.initialBacktrackEscHandled));
		assertEquals(boolText(boolField(expectValue, "initialSideBacktrackEscRejected", false)), boolText(outcome.initialSideBacktrackEscRejected));
		assertEquals(boolText(boolField(expectValue, "vimInsertEscTakesPrecedence", false)), boolText(outcome.vimInsertEscTakesPrecedence));
		assertEquals(boolText(boolField(expectValue, "backtrackEscSuppressedDuringVimInsert", false)), boolText(outcome.backtrackEscSuppressedDuringVimInsert));
		assertEquals(boolText(boolField(expectValue, "sideRejectionSuppressedDuringVimInsert", false)), boolText(outcome.sideRejectionSuppressedDuringVimInsert));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelSideBacktrackUnavailableMessages(
		testCase:Value,
		secretProbe:String
	):Array<ModelSideBacktrackUnavailableMessageOutcome> {
		final outcomes:Array<ModelSideBacktrackUnavailableMessageOutcome> = [];
		final values = optionalArrayField(testCase, "sideBacktrackUnavailableMessageExpects");
		for (value in values) outcomes.push(assertSideBacktrackUnavailableMessage(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertSideBacktrackUnavailableMessages(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelSideBacktrackUnavailableMessageOutcome> {
		final outcomes:Array<ModelSideBacktrackUnavailableMessageOutcome> = [];
		final values = optionalArrayField(verificationValue, "sideBacktrackUnavailableMessageExpects");
		for (value in values) outcomes.push(assertSideBacktrackUnavailableMessage(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertSideBacktrackUnavailableMessage(
		expectValue:Value,
		secretProbe:String
	):ModelSideBacktrackUnavailableMessageOutcome {
		final outcome = ModelSideBacktrackUnavailableMessagePolicy.apply(new ModelSideBacktrackUnavailableMessageRequest({
			requestId: stringField(expectValue, "requestId", ""),
			backtrackPrimedBefore: boolField(expectValue, "backtrackPrimedBefore", false),
			rejectInvoked: boolField(expectValue, "rejectInvoked", false),
			unavailableMessage: stringField(expectValue, "unavailableMessage", ""),
			renderedWidth: intField(expectValue, "renderedWidth", 0),
			expectedSnapshotName: stringField(expectValue, "expectedSnapshotName", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(sideBacktrackUnavailableMessageDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "backtrackPrimedAfter", false)), boolText(outcome.backtrackPrimedAfter));
		assertEquals(boolText(boolField(expectValue, "backtrackReset", false)), boolText(outcome.backtrackReset));
		assertEquals(boolText(boolField(expectValue, "errorHistoryCellInserted", false)), boolText(outcome.errorHistoryCellInserted));
		assertEquals(boolText(boolField(expectValue, "insertHistoryCellIntentRecorded", false)), boolText(outcome.insertHistoryCellIntentRecorded));
		assertEquals(stringField(expectValue, "renderedLine", ""), outcome.renderedLine);
		assertEquals(boolText(boolField(expectValue, "snapshotNamePreserved", false)), boolText(outcome.snapshotNamePreserved));
		assertEquals(boolText(boolField(expectValue, "widthStableSnapshot", false)), boolText(outcome.widthStableSnapshot));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) {
			assertNotContains(outcome.summary(), secretProbe);
			assertNotContains(outcome.summary(), stringField(expectValue, "unavailableMessage", ""));
			assertNotContains(outcome.summary(), stringField(expectValue, "renderedLine", ""));
		}
		return outcome;
	}

	static function assertTopLevelInterruptBacktrackKeymaps(
		testCase:Value,
		secretProbe:String
	):Array<ModelInterruptBacktrackKeymapOutcome> {
		final outcomes:Array<ModelInterruptBacktrackKeymapOutcome> = [];
		final values = optionalArrayField(testCase, "interruptBacktrackKeymapExpects");
		for (value in values) outcomes.push(assertInterruptBacktrackKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptBacktrackKeymaps(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelInterruptBacktrackKeymapOutcome> {
		final outcomes:Array<ModelInterruptBacktrackKeymapOutcome> = [];
		final values = optionalArrayField(verificationValue, "interruptBacktrackKeymapExpects");
		for (value in values) outcomes.push(assertInterruptBacktrackKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptBacktrackKeymap(
		expectValue:Value,
		secretProbe:String
	):ModelInterruptBacktrackKeymapOutcome {
		final outcome = ModelInterruptBacktrackKeymapPolicy.apply(new ModelInterruptBacktrackKeymapRequest({
			requestId: stringField(expectValue, "requestId", ""),
			defaultInterruptBinding: stringField(expectValue, "defaultInterruptBinding", ""),
			fixedBacktrackBinding: stringField(expectValue, "fixedBacktrackBinding", ""),
			remappedInterruptBinding: stringField(expectValue, "remappedInterruptBinding", ""),
			unboundInterruptCount: intField(expectValue, "unboundInterruptCount", -1),
			fixedPasteImageBinding: stringField(expectValue, "fixedPasteImageBinding", ""),
			conflictingInterruptBinding: stringField(expectValue, "conflictingInterruptBinding", ""),
			conflictOuterAction: interruptBacktrackFixedShortcutActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: interruptBacktrackFixedShortcutActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(interruptBacktrackKeymapDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "defaultEscInterruptPreserved", false)), boolText(outcome.defaultEscInterruptPreserved));
		assertEquals(boolText(boolField(expectValue, "fixedBacktrackEscPreserved", false)), boolText(outcome.fixedBacktrackEscPreserved));
		assertEquals(boolText(boolField(expectValue, "backtrackOverlapAllowed", false)), boolText(outcome.backtrackOverlapAllowed));
		assertEquals(boolText(boolField(expectValue, "remapToF12Accepted", false)), boolText(outcome.remapToF12Accepted));
		assertEquals(boolText(boolField(expectValue, "unbindAccepted", false)), boolText(outcome.unbindAccepted));
		assertEquals(boolText(boolField(expectValue, "otherFixedShortcutRejected", false)), boolText(outcome.otherFixedShortcutRejected));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamePreserved", false)), boolText(outcome.conflictActionNamePreserved));
		assertEquals(boolText(boolField(expectValue, "dispatchGatingDeferredToHandler", false)), boolText(outcome.dispatchGatingDeferredToHandler));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelInterruptQuestionNavigationKeymaps(
		testCase:Value,
		secretProbe:String
	):Array<ModelInterruptQuestionNavigationKeymapOutcome> {
		final outcomes:Array<ModelInterruptQuestionNavigationKeymapOutcome> = [];
		final values = optionalArrayField(testCase, "interruptQuestionNavigationKeymapExpects");
		for (value in values) outcomes.push(assertInterruptQuestionNavigationKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptQuestionNavigationKeymaps(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelInterruptQuestionNavigationKeymapOutcome> {
		final outcomes:Array<ModelInterruptQuestionNavigationKeymapOutcome> = [];
		final values = optionalArrayField(verificationValue, "interruptQuestionNavigationKeymapExpects");
		for (value in values) outcomes.push(assertInterruptQuestionNavigationKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertInterruptQuestionNavigationKeymap(
		expectValue:Value,
		secretProbe:String
	):ModelInterruptQuestionNavigationKeymapOutcome {
		final outcome = ModelInterruptQuestionNavigationKeymapPolicy.apply(new ModelInterruptQuestionNavigationKeymapRequest({
			requestId: stringField(expectValue, "requestId", ""),
			interruptActionName: stringField(expectValue, "interruptActionName", ""),
			questionNavigationActionName: stringField(expectValue, "questionNavigationActionName", ""),
			interruptBinding: stringField(expectValue, "interruptBinding", ""),
			questionNavigationBinding: stringField(expectValue, "questionNavigationBinding", ""),
			fixedBacktrackActionName: stringField(expectValue, "fixedBacktrackActionName", ""),
			fixedBacktrackBinding: stringField(expectValue, "fixedBacktrackBinding", ""),
			allowedOverlapBinding: stringField(expectValue, "allowedOverlapBinding", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(interruptQuestionNavigationKeymapDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "interruptActionNamePreserved", false)), boolText(outcome.interruptActionNamePreserved));
		assertEquals(boolText(boolField(expectValue, "questionNavigationActionNamePreserved", false)), boolText(outcome.questionNavigationActionNamePreserved));
		assertEquals(boolText(boolField(expectValue, "interruptRemapAcceptedBeforeValidation", false)), boolText(outcome.interruptRemapAcceptedBeforeValidation));
		assertEquals(boolText(boolField(expectValue, "questionNavigationBindingPreserved", false)), boolText(outcome.questionNavigationBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictingBindingDetected", false)), boolText(outcome.conflictingBindingDetected));
		assertEquals(boolText(boolField(expectValue, "fixedBacktrackOverlapStillAllowed", false)), boolText(outcome.fixedBacktrackOverlapStillAllowed));
		assertEquals(boolText(boolField(expectValue, "conflictRejected", false)), boolText(outcome.conflictRejected));
		assertEquals(boolText(boolField(expectValue, "noFalseBacktrackConflict", false)), boolText(outcome.noFalseBacktrackConflict));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelPagerTranscriptBacktrackKeymaps(
		testCase:Value,
		secretProbe:String
	):Array<ModelPagerTranscriptBacktrackKeymapOutcome> {
		final outcomes:Array<ModelPagerTranscriptBacktrackKeymapOutcome> = [];
		final values = optionalArrayField(testCase, "pagerTranscriptBacktrackKeymapExpects");
		for (value in values) outcomes.push(assertPagerTranscriptBacktrackKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertPagerTranscriptBacktrackKeymaps(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelPagerTranscriptBacktrackKeymapOutcome> {
		final outcomes:Array<ModelPagerTranscriptBacktrackKeymapOutcome> = [];
		final values = optionalArrayField(verificationValue, "pagerTranscriptBacktrackKeymapExpects");
		for (value in values) outcomes.push(assertPagerTranscriptBacktrackKeymap(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertPagerTranscriptBacktrackKeymap(
		expectValue:Value,
		secretProbe:String
	):ModelPagerTranscriptBacktrackKeymapOutcome {
		final outcome = ModelPagerTranscriptBacktrackKeymapPolicy.apply(new ModelPagerTranscriptBacktrackKeymapRequest({
			requestId: stringField(expectValue, "requestId", ""),
			pagerActionName: stringField(expectValue, "pagerActionName", ""),
			pagerBinding: stringField(expectValue, "pagerBinding", ""),
			transcriptBacktrackActionName: stringField(expectValue, "transcriptBacktrackActionName", ""),
			transcriptBacktrackBinding: stringField(expectValue, "transcriptBacktrackBinding", ""),
			interruptActionName: stringField(expectValue, "interruptActionName", ""),
			fixedBacktrackActionName: stringField(expectValue, "fixedBacktrackActionName", ""),
			allowedBacktrackOverlapBinding: stringField(expectValue, "allowedBacktrackOverlapBinding", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(pagerTranscriptBacktrackKeymapDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "pagerActionNamePreserved", false)), boolText(outcome.pagerActionNamePreserved));
		assertEquals(boolText(boolField(expectValue, "pagerBindingPreserved", false)), boolText(outcome.pagerBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "transcriptBacktrackActionNamePreserved", false)), boolText(outcome.transcriptBacktrackActionNamePreserved));
		assertEquals(boolText(boolField(expectValue, "transcriptLeftBindingPreserved", false)), boolText(outcome.transcriptLeftBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "reservedCollisionDetected", false)), boolText(outcome.reservedCollisionDetected));
		assertEquals(boolText(boolField(expectValue, "conflictRejected", false)), boolText(outcome.conflictRejected));
		assertEquals(boolText(boolField(expectValue, "fixedBacktrackOverlapStillAllowed", false)), boolText(outcome.fixedBacktrackOverlapStillAllowed));
		assertEquals(boolText(boolField(expectValue, "noFalseInterruptBacktrackConflict", false)), boolText(outcome.noFalseInterruptBacktrackConflict));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeyParserCases(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeyParserOutcome> {
		final outcomes:Array<ModelKeyParserOutcome> = [];
		final values = optionalArrayField(testCase, "keyParserExpects");
		for (value in values) outcomes.push(assertKeyParserCaseSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeyParserCases(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeyParserOutcome> {
		final outcomes:Array<ModelKeyParserOutcome> = [];
		final values = optionalArrayField(verificationValue, "keyParserExpects");
		for (value in values) outcomes.push(assertKeyParserCaseSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeyParserCaseSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeyParserOutcome {
		final cases:Array<ModelKeyParserCase> = [];
		for (caseValue in arrayField(expectValue, "cases")) {
			final caseObject = objectValue(caseValue);
			cases.push(new ModelKeyParserCase({
				spec: stringField(caseObject, "spec", ""),
				expectedAccepted: boolField(caseObject, "expectedAccepted", false),
				expectedKind: parsedKeyKind(stringField(caseObject, "expectedKind", "")),
				expectedKeyName: stringField(caseObject, "expectedKeyName", ""),
				expectedFunctionNumber: intField(caseObject, "expectedFunctionNumber", -1),
				expectedCtrlModifier: boolField(caseObject, "expectedCtrlModifier", false),
				expectedAltModifier: boolField(caseObject, "expectedAltModifier", false),
				expectedShiftModifier: boolField(caseObject, "expectedShiftModifier", false)
			}));
		}
		final outcome = ModelKeyParserPolicy.apply(new ModelKeyParserRequest({
			requestId: stringField(expectValue, "requestId", ""),
			maxFunctionKey: intField(expectValue, "maxFunctionKey", 0),
			cases: cases,
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "key parser expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keyParserDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "acceptedFunctionKeyCount", 0)), Std.string(outcome.acceptedFunctionKeyCount));
		assertEquals(Std.string(intField(expectValue, "rejectedFunctionKeyCount", 0)), Std.string(outcome.rejectedFunctionKeyCount));
		assertEquals(Std.string(intField(expectValue, "namedKeyCount", 0)), Std.string(outcome.namedKeyCount));
		assertEquals(boolText(boolField(expectValue, "spaceAliasPreserved", false)), boolText(outcome.spaceAliasPreserved));
		assertEquals(boolText(boolField(expectValue, "minusAliasPreserved", false)), boolText(outcome.minusAliasPreserved));
		assertEquals(boolText(boolField(expectValue, "modifierOnlyRejected", false)), boolText(outcome.modifierOnlyRejected));
		assertEquals(boolText(boolField(expectValue, "nonnumericFunctionRejected", false)), boolText(outcome.nonnumericFunctionRejected));
		assertEquals(boolText(boolField(expectValue, "altMinusAliasPreserved", false)), boolText(outcome.altMinusAliasPreserved));
		assertEquals(boolText(boolField(expectValue, "legacyAltLiteralMinusPreserved", false)), boolText(outcome.legacyAltLiteralMinusPreserved));
		assertEquals(boolText(boolField(expectValue, "literalMinusPreserved", false)), boolText(outcome.literalMinusPreserved));
		assertEquals(boolText(boolField(expectValue, "allExpectedCasesMatched", false)), boolText(outcome.allExpectedCasesMatched));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapAliases(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapAliasOutcome> {
		final outcomes:Array<ModelKeymapAliasOutcome> = [];
		final values = optionalArrayField(testCase, "keymapAliasExpects");
		for (value in values) outcomes.push(assertKeymapAliasSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapAliases(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapAliasOutcome> {
		final outcomes:Array<ModelKeymapAliasOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapAliasExpects");
		for (value in values) outcomes.push(assertKeymapAliasSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapAliasSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapAliasOutcome {
		final outcome = ModelKeymapAliasPolicy.apply(new ModelKeymapAliasRequest({
			requestId: stringField(expectValue, "requestId", ""),
			composerToggleShortcutsConfiguredEmpty: boolField(expectValue, "composerToggleShortcutsConfiguredEmpty", false),
			composerToggleShortcutCount: intField(expectValue, "composerToggleShortcutCount", -1),
			defaultRawOutputToggle: keymapBinding(objectField(expectValue, "defaultRawOutputToggle")),
			remappedRawOutputToggle: keymapBinding(objectField(expectValue, "remappedRawOutputToggle")),
			editorInsertNewlineBindings: keymapBindings(expectValue, "editorInsertNewlineBindings"),
			editorDeleteForwardWordBindings: keymapBindings(expectValue, "editorDeleteForwardWordBindings"),
			editorDeleteBackwardBindings: keymapBindings(expectValue, "editorDeleteBackwardBindings"),
			editorDeleteForwardBindings: keymapBindings(expectValue, "editorDeleteForwardBindings"),
			editorDeleteBackwardWordBindings: keymapBindings(expectValue, "editorDeleteBackwardWordBindings"),
			composerToggleShortcutBindings: keymapBindings(expectValue, "composerToggleShortcutBindings"),
			approvalOpenFullscreenBindings: keymapBindings(expectValue, "approvalOpenFullscreenBindings"),
			primaryBindingCandidates: keymapBindings(expectValue, "primaryBindingCandidates"),
			primaryBindingExpected: keymapBinding(objectField(expectValue, "primaryBindingExpected")),
			primaryEmptyCandidateCount: intField(expectValue, "primaryEmptyCandidateCount", -1),
			defaultsConflictValidationPassed: boolField(expectValue, "defaultsConflictValidationPassed", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap alias expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapAliasDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "emptyArrayUnbindPreserved", false)), boolText(outcome.emptyArrayUnbindPreserved));
		assertEquals(boolText(boolField(expectValue, "rawOutputDefaultAltRPreserved", false)), boolText(outcome.rawOutputDefaultAltRPreserved));
		assertEquals(boolText(boolField(expectValue, "rawOutputRemapF12Preserved", false)), boolText(outcome.rawOutputRemapF12Preserved));
		assertEquals(boolText(boolField(expectValue, "editorNewlineAliasesPreserved", false)), boolText(outcome.editorNewlineAliasesPreserved));
		assertEquals(boolText(boolField(expectValue, "deleteForwardWordAltDPreserved", false)), boolText(outcome.deleteForwardWordAltDPreserved));
		assertEquals(boolText(boolField(expectValue, "modifiedDeletionAliasesPreserved", false)), boolText(outcome.modifiedDeletionAliasesPreserved));
		assertEquals(boolText(boolField(expectValue, "composerToggleShiftQuestionPreserved", false)), boolText(outcome.composerToggleShiftQuestionPreserved));
		assertEquals(boolText(boolField(expectValue, "approvalOpenFullscreenCtrlShiftAPreserved", false)), boolText(outcome.approvalOpenFullscreenCtrlShiftAPreserved));
		assertEquals(boolText(boolField(expectValue, "primaryBindingFirstPreserved", false)), boolText(outcome.primaryBindingFirstPreserved));
		assertEquals(boolText(boolField(expectValue, "primaryBindingEmptyNonePreserved", false)), boolText(outcome.primaryBindingEmptyNonePreserved));
		assertEquals(boolText(boolField(expectValue, "defaultsConflictValidationPreserved", false)), boolText(outcome.defaultsConflictValidationPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function keymapBindings(expectValue:Value, fieldName:String):Array<ModelKeymapBinding> {
		final bindings:Array<ModelKeymapBinding> = [];
		for (bindingValue in arrayField(expectValue, fieldName)) {
			bindings.push(keymapBinding(objectValue(bindingValue)));
		}
		return bindings;
	}

	static function keymapBinding(value:Value):ModelKeymapBinding {
		return new ModelKeymapBinding({
			kind: parsedKeyKind(stringField(value, "kind", "")),
			keyName: stringField(value, "keyName", ""),
			functionNumber: intField(value, "functionNumber", -1),
			ctrlModifier: boolField(value, "ctrlModifier", false),
			altModifier: boolField(value, "altModifier", false),
			shiftModifier: boolField(value, "shiftModifier", false)
		});
	}

	static function assertTopLevelKeymapShadows(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapShadowOutcome> {
		final outcomes:Array<ModelKeymapShadowOutcome> = [];
		final values = optionalArrayField(testCase, "keymapShadowExpects");
		for (value in values) outcomes.push(assertKeymapShadowSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapShadows(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapShadowOutcome> {
		final outcomes:Array<ModelKeymapShadowOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapShadowExpects");
		for (value in values) outcomes.push(assertKeymapShadowSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapShadowSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapShadowOutcome {
		final shadowCases:Array<ModelKeymapShadowCase> = [];
		for (caseValue in arrayField(expectValue, "shadowCases")) {
			final caseObject = objectValue(caseValue);
			shadowCases.push(new ModelKeymapShadowCase({
				scope: ModelKeymapShadowScopeKind.fromString(stringField(caseObject, "scope", "")),
				outerActionName: stringField(caseObject, "outerActionName", ""),
				innerActionName: stringField(caseObject, "innerActionName", ""),
				binding: keymapBinding(objectField(caseObject, "binding"))
			}));
		}
		final outcome = ModelKeymapShadowPolicy.apply(new ModelKeymapShadowRequest({
			requestId: stringField(expectValue, "requestId", ""),
			canonicalBinding: keymapBinding(objectField(expectValue, "canonicalBinding")),
			shadowCases: shadowCases,
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap shadow expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapShadowDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "canonicalBindingPreserved", false)), boolText(outcome.canonicalBindingPreserved));
		assertEquals(Std.string(intField(expectValue, "shadowConflictCount", 0)), Std.string(outcome.shadowConflictCount));
		assertEquals(boolText(boolField(expectValue, "composerShadowRejected", false)), boolText(outcome.composerShadowRejected));
		assertEquals(boolText(boolField(expectValue, "editorShadowRejected", false)), boolText(outcome.editorShadowRejected));
		assertEquals(boolText(boolField(expectValue, "approvalShadowRejected", false)), boolText(outcome.approvalShadowRejected));
		assertEquals(boolText(boolField(expectValue, "listShadowRejected", false)), boolText(outcome.listShadowRejected));
		assertEquals(boolText(boolField(expectValue, "actionNamesPreserved", false)), boolText(outcome.actionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapBindingInputs(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapBindingInputOutcome> {
		final outcomes:Array<ModelKeymapBindingInputOutcome> = [];
		final values = optionalArrayField(testCase, "keymapBindingInputExpects");
		for (value in values) outcomes.push(assertKeymapBindingInputSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapBindingInputs(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapBindingInputOutcome> {
		final outcomes:Array<ModelKeymapBindingInputOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapBindingInputExpects");
		for (value in values) outcomes.push(assertKeymapBindingInputSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapBindingInputSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapBindingInputOutcome {
		final defaultMainSurfaceActions:Array<ModelKeymapDefaultActionCase> = [];
		for (actionValue in arrayField(expectValue, "defaultMainSurfaceActions")) {
			final actionObject = objectValue(actionValue);
			defaultMainSurfaceActions.push(new ModelKeymapDefaultActionCase({
				actionKind: ModelKeymapMainSurfaceActionKind.fromString(stringField(actionObject, "actionKind", "")),
				bindings: keymapBindings(actionObject, "bindings")
			}));
		}
		final outcome = ModelKeymapBindingInputPolicy.apply(new ModelKeymapBindingInputRequest({
			requestId: stringField(expectValue, "requestId", ""),
			invalidMultiBindingPath: stringField(expectValue, "invalidMultiBindingPath", ""),
			invalidModifierRejected: boolField(expectValue, "invalidModifierRejected", false),
			validMultiBindings: keymapBindings(expectValue, "validMultiBindings"),
			dedupeInputBindings: keymapBindings(expectValue, "dedupeInputBindings"),
			dedupeExpectedBindings: keymapBindings(expectValue, "dedupeExpectedBindings"),
			globalQueueBinding: keymapBinding(objectField(expectValue, "globalQueueBinding")),
			composerQueueResolved: keymapBinding(objectField(expectValue, "composerQueueResolved")),
			invalidGlobalOpenTranscriptPath: stringField(expectValue, "invalidGlobalOpenTranscriptPath", ""),
			invalidGlobalOpenExternalEditorPath: stringField(expectValue, "invalidGlobalOpenExternalEditorPath", ""),
			defaultCopyBinding: keymapBinding(objectField(expectValue, "defaultCopyBinding")),
			defaultMainSurfaceActions: defaultMainSurfaceActions,
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap binding input expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapBindingInputDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "stringOrArrayInputValidated", false)), boolText(outcome.stringOrArrayInputValidated));
		assertEquals(boolText(boolField(expectValue, "invalidModifierPathPreserved", false)), boolText(outcome.invalidModifierPathPreserved));
		assertEquals(Std.string(intField(expectValue, "validMultiBindingCount", 0)), Std.string(outcome.validMultiBindingCount));
		assertEquals(boolText(boolField(expectValue, "dedupeOrderPreserved", false)), boolText(outcome.dedupeOrderPreserved));
		assertEquals(boolText(boolField(expectValue, "contextFallbackPreserved", false)), boolText(outcome.contextFallbackPreserved));
		assertEquals(boolText(boolField(expectValue, "invalidGlobalPathsPreserved", false)), boolText(outcome.invalidGlobalPathsPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultCopyBindingPreserved", false)), boolText(outcome.defaultCopyBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultMainSurfaceActionsPreserved", false)), boolText(outcome.defaultMainSurfaceActionsPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapDefaultPrunings(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapDefaultPruningOutcome> {
		final outcomes:Array<ModelKeymapDefaultPruningOutcome> = [];
		final values = optionalArrayField(testCase, "keymapDefaultPruningExpects");
		for (value in values) outcomes.push(assertKeymapDefaultPruningSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapDefaultPrunings(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapDefaultPruningOutcome> {
		final outcomes:Array<ModelKeymapDefaultPruningOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapDefaultPruningExpects");
		for (value in values) outcomes.push(assertKeymapDefaultPruningSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapDefaultPruningSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapDefaultPruningOutcome {
		final outcome = ModelKeymapDefaultPruningPolicy.apply(new ModelKeymapDefaultPruningRequest({
			requestId: stringField(expectValue, "requestId", ""),
			tailMainSurfaceDefaults: keymapDefaultPruningCases(expectValue, "tailMainSurfaceDefaults"),
			listPageAndJumpDefaults: keymapDefaultPruningCases(expectValue, "listPageAndJumpDefaults"),
			configuredEditorMoveUp: keymapBinding(objectField(expectValue, "configuredEditorMoveUp")),
			configuredVimTextObjectWord: keymapBinding(objectField(expectValue, "configuredVimTextObjectWord")),
			prunedDecreaseReasoningBindings: keymapBindings(expectValue, "prunedDecreaseReasoningBindings"),
			prunedIncreaseReasoningBindings: keymapBindings(expectValue, "prunedIncreaseReasoningBindings"),
			explicitConflictOuterAction: keymapDefaultPruningActionKind(stringField(expectValue, "explicitConflictOuterAction", "")),
			explicitConflictInnerAction: keymapDefaultPruningActionKind(stringField(expectValue, "explicitConflictInnerAction", "")),
			explicitConflictBinding: keymapBinding(objectField(expectValue, "explicitConflictBinding")),
			legacyListMoveUpConfigured: keymapBinding(objectField(expectValue, "legacyListMoveUpConfigured")),
			legacyListMoveDownConfigured: keymapBinding(objectField(expectValue, "legacyListMoveDownConfigured")),
			legacyListPageUpPruned: keymapBindings(expectValue, "legacyListPageUpPruned"),
			legacyListPageDownPruned: keymapBindings(expectValue, "legacyListPageDownPruned"),
			legacyListPruneAllMoveUpConfigured: keymapBindings(expectValue, "legacyListPruneAllMoveUpConfigured"),
			legacyListPruneAllRuntimeMoveUp: keymapBindings(expectValue, "legacyListPruneAllRuntimeMoveUp"),
			legacyListPruneAllPageUpPruned: keymapBindings(expectValue, "legacyListPruneAllPageUpPruned"),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap default pruning expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapDefaultPruningDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "tailMainSurfaceDefaultsPreserved", false)), boolText(outcome.tailMainSurfaceDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "listPageAndJumpDefaultsPreserved", false)), boolText(outcome.listPageAndJumpDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "reasoningFallbackPruningPreserved", false)), boolText(outcome.reasoningFallbackPruningPreserved));
		assertEquals(boolText(boolField(expectValue, "explicitReasoningEditorConflictPreserved", false)), boolText(outcome.explicitReasoningEditorConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "legacyListOverlapPruningPreserved", false)), boolText(outcome.legacyListOverlapPruningPreserved));
		assertEquals(boolText(boolField(expectValue, "legacyListPruneAllDefaultsPreserved", false)), boolText(outcome.legacyListPruneAllDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function keymapDefaultPruningCases(value:Value, fieldName:String):Array<ModelKeymapDefaultPruningCase> {
		final cases:Array<ModelKeymapDefaultPruningCase> = [];
		for (caseValue in arrayField(value, fieldName)) {
			final caseObject = objectValue(caseValue);
			cases.push(new ModelKeymapDefaultPruningCase({
				actionKind: keymapDefaultPruningActionKind(stringField(caseObject, "actionKind", "")),
				bindings: keymapBindings(caseObject, "bindings")
			}));
		}
		return cases;
	}

	static function assertTopLevelKeymapOverlapConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapOverlapConflictOutcome> {
		final outcomes:Array<ModelKeymapOverlapConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapOverlapConflictExpects");
		for (value in values) outcomes.push(assertKeymapOverlapConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapOverlapConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapOverlapConflictOutcome> {
		final outcomes:Array<ModelKeymapOverlapConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapOverlapConflictExpects");
		for (value in values) outcomes.push(assertKeymapOverlapConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapOverlapConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapOverlapConflictOutcome {
		final outcome = ModelKeymapOverlapConflictPolicy.apply(new ModelKeymapOverlapConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			explicitListLegacyOuterAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitListLegacyOuterAction", "")),
			explicitListLegacyInnerAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitListLegacyInnerAction", "")),
			explicitListLegacyBinding: keymapBinding(objectField(expectValue, "explicitListLegacyBinding")),
			configuredAppCopy: keymapBinding(objectField(expectValue, "configuredAppCopy")),
			prunedListPageDownAfterApp: keymapBindings(expectValue, "prunedListPageDownAfterApp"),
			configuredApprovalApprove: keymapBinding(objectField(expectValue, "configuredApprovalApprove")),
			prunedListJumpTopAfterApproval: keymapBindings(expectValue, "prunedListJumpTopAfterApproval"),
			explicitListApprovalOuterAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitListApprovalOuterAction", "")),
			explicitListApprovalInnerAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitListApprovalInnerAction", "")),
			explicitListApprovalBinding: keymapBinding(objectField(expectValue, "explicitListApprovalBinding")),
			configuredLegacyVimMoveLeftForChange: keymapBinding(objectField(expectValue, "configuredLegacyVimMoveLeftForChange")),
			prunedVimStartChangeOperator: keymapBindings(expectValue, "prunedVimStartChangeOperator"),
			explicitVimChangeOuterAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitVimChangeOuterAction", "")),
			explicitVimChangeInnerAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitVimChangeInnerAction", "")),
			explicitVimChangeBinding: keymapBinding(objectField(expectValue, "explicitVimChangeBinding")),
			configuredLegacyVimMoveLeftForSubstitute: keymapBinding(objectField(expectValue, "configuredLegacyVimMoveLeftForSubstitute")),
			prunedVimSubstituteChar: keymapBindings(expectValue, "prunedVimSubstituteChar"),
			explicitVimSubstituteOuterAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitVimSubstituteOuterAction", "")),
			explicitVimSubstituteInnerAction: keymapOverlapConflictActionKind(stringField(expectValue, "explicitVimSubstituteInnerAction", "")),
			explicitVimSubstituteBinding: keymapBinding(objectField(expectValue, "explicitVimSubstituteBinding")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap overlap conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapOverlapConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "explicitListLegacyConflictPreserved", false)), boolText(outcome.explicitListLegacyConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "appBindingPrunesListDefaultPreserved", false)), boolText(outcome.appBindingPrunesListDefaultPreserved));
		assertEquals(boolText(boolField(expectValue, "approvalBindingPrunesListDefaultPreserved", false)), boolText(outcome.approvalBindingPrunesListDefaultPreserved));
		assertEquals(boolText(boolField(expectValue, "explicitListApprovalConflictPreserved", false)), boolText(outcome.explicitListApprovalConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "legacyVimChangePruningPreserved", false)), boolText(outcome.legacyVimChangePruningPreserved));
		assertEquals(boolText(boolField(expectValue, "explicitVimChangeConflictPreserved", false)), boolText(outcome.explicitVimChangeConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "legacyVimSubstitutePruningPreserved", false)), boolText(outcome.legacyVimSubstitutePruningPreserved));
		assertEquals(boolText(boolField(expectValue, "explicitVimSubstituteConflictPreserved", false)), boolText(outcome.explicitVimSubstituteConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapVimOperatorTextObjects(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapVimOperatorTextObjectOutcome> {
		final outcomes:Array<ModelKeymapVimOperatorTextObjectOutcome> = [];
		final values = optionalArrayField(testCase, "keymapVimOperatorTextObjectExpects");
		for (value in values) outcomes.push(assertKeymapVimOperatorTextObjectSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapVimOperatorTextObjects(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapVimOperatorTextObjectOutcome> {
		final outcomes:Array<ModelKeymapVimOperatorTextObjectOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapVimOperatorTextObjectExpects");
		for (value in values) outcomes.push(assertKeymapVimOperatorTextObjectSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapVimOperatorTextObjectSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapVimOperatorTextObjectOutcome {
		final outcome = ModelKeymapVimOperatorTextObjectPolicy.apply(new ModelKeymapVimOperatorTextObjectRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredMotionLeft: keymapBinding(objectField(expectValue, "configuredMotionLeft")),
			configuredMotionRight: keymapBinding(objectField(expectValue, "configuredMotionRight")),
			prunedSelectInnerTextObject: keymapBindings(expectValue, "prunedSelectInnerTextObject"),
			prunedSelectAroundTextObject: keymapBindings(expectValue, "prunedSelectAroundTextObject"),
			explicitConflictOuterAction: keymapVimOperatorTextObjectActionKind(stringField(expectValue, "explicitConflictOuterAction", "")),
			explicitConflictInnerAction: keymapVimOperatorTextObjectActionKind(stringField(expectValue, "explicitConflictInnerAction", "")),
			explicitConflictBinding: keymapBinding(objectField(expectValue, "explicitConflictBinding")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap vim-operator text-object expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapVimOperatorTextObjectDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "legacyMotionPruningPreserved", false)), boolText(outcome.legacyMotionPruningPreserved));
		assertEquals(boolText(boolField(expectValue, "explicitTextObjectConflictPreserved", false)), boolText(outcome.explicitTextObjectConflictPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapVimNormalDefaults(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapVimNormalDefaultsOutcome> {
		final outcomes:Array<ModelKeymapVimNormalDefaultsOutcome> = [];
		final values = optionalArrayField(testCase, "keymapVimNormalDefaultExpects");
		for (value in values) outcomes.push(assertKeymapVimNormalDefaultSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapVimNormalDefaults(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapVimNormalDefaultsOutcome> {
		final outcomes:Array<ModelKeymapVimNormalDefaultsOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapVimNormalDefaultExpects");
		for (value in values) outcomes.push(assertKeymapVimNormalDefaultSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapVimNormalDefaultSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapVimNormalDefaultsOutcome {
		final outcome = ModelKeymapVimNormalDefaultsPolicy.apply(new ModelKeymapVimNormalDefaultsRequest({
			requestId: stringField(expectValue, "requestId", ""),
			enterInsert: keymapBindings(expectValue, "enterInsert"),
			moveLeft: keymapBindings(expectValue, "moveLeft"),
			moveRight: keymapBindings(expectValue, "moveRight"),
			moveUp: keymapBindings(expectValue, "moveUp"),
			moveDown: keymapBindings(expectValue, "moveDown"),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap vim-normal default expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapVimNormalDefaultsDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "enterInsertDefaultsPreserved", false)), boolText(outcome.enterInsertDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "moveLeftDefaultsPreserved", false)), boolText(outcome.moveLeftDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "moveRightDefaultsPreserved", false)), boolText(outcome.moveRightDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "moveUpDefaultsPreserved", false)), boolText(outcome.moveUpDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "moveDownDefaultsPreserved", false)), boolText(outcome.moveDownDefaultsPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapInvalidGlobalCopies(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapInvalidGlobalCopyOutcome> {
		final outcomes:Array<ModelKeymapInvalidGlobalCopyOutcome> = [];
		final values = optionalArrayField(testCase, "keymapInvalidGlobalCopyExpects");
		for (value in values) outcomes.push(assertKeymapInvalidGlobalCopySet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapInvalidGlobalCopies(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapInvalidGlobalCopyOutcome> {
		final outcomes:Array<ModelKeymapInvalidGlobalCopyOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapInvalidGlobalCopyExpects");
		for (value in values) outcomes.push(assertKeymapInvalidGlobalCopySet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapInvalidGlobalCopySet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapInvalidGlobalCopyOutcome {
		final outcome = ModelKeymapInvalidGlobalCopyPolicy.apply(new ModelKeymapInvalidGlobalCopyRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredGlobalCopy: keymapBinding(objectField(expectValue, "configuredGlobalCopy")),
			expectedErrorPath: stringField(expectValue, "expectedErrorPath", ""),
			parseFailed: boolField(expectValue, "parseFailed", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap invalid global copy expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapInvalidGlobalCopyDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "invalidBindingPreserved", false)), boolText(outcome.invalidBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "errorPathPreserved", false)), boolText(outcome.errorPathPreserved));
		assertEquals(boolText(boolField(expectValue, "parseFailurePreserved", false)), boolText(outcome.parseFailurePreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapEditorAssignments(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapEditorAssignmentOutcome> {
		final outcomes:Array<ModelKeymapEditorAssignmentOutcome> = [];
		final values = optionalArrayField(testCase, "keymapEditorAssignmentExpects");
		for (value in values) outcomes.push(assertKeymapEditorAssignmentSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorAssignments(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapEditorAssignmentOutcome> {
		final outcomes:Array<ModelKeymapEditorAssignmentOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapEditorAssignmentExpects");
		for (value in values) outcomes.push(assertKeymapEditorAssignmentSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorAssignmentSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapEditorAssignmentOutcome {
		final outcome = ModelKeymapEditorAssignmentPolicy.apply(new ModelKeymapEditorAssignmentRequest({
			requestId: stringField(expectValue, "requestId", ""),
			actionKind: keymapEditorAssignmentActionKind(stringField(expectValue, "actionKind", "")),
			defaultBindings: keymapBindings(expectValue, "defaultBindings"),
			configuredBinding: keymapBinding(objectField(expectValue, "configuredBinding")),
			runtimeBinding: keymapBinding(objectField(expectValue, "runtimeBinding")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap editor assignment expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapEditorAssignmentDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "actionKindPreserved", false)), boolText(outcome.actionKindPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultBindingEmptyPreserved", false)), boolText(outcome.defaultBindingEmptyPreserved));
		assertEquals(boolText(boolField(expectValue, "configuredBindingPreserved", false)), boolText(outcome.configuredBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "runtimeBindingPreserved", false)), boolText(outcome.runtimeBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapMainSurfaceAssignments(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapMainSurfaceAssignmentOutcome> {
		final outcomes:Array<ModelKeymapMainSurfaceAssignmentOutcome> = [];
		final values = optionalArrayField(testCase, "keymapMainSurfaceAssignmentExpects");
		for (value in values) outcomes.push(assertKeymapMainSurfaceAssignmentSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapMainSurfaceAssignments(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapMainSurfaceAssignmentOutcome> {
		final outcomes:Array<ModelKeymapMainSurfaceAssignmentOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapMainSurfaceAssignmentExpects");
		for (value in values) outcomes.push(assertKeymapMainSurfaceAssignmentSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapMainSurfaceAssignmentSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapMainSurfaceAssignmentOutcome {
		final outcome = ModelKeymapMainSurfaceAssignmentPolicy.apply(new ModelKeymapMainSurfaceAssignmentRequest({
			requestId: stringField(expectValue, "requestId", ""),
			actionKind: keymapMainSurfaceAssignmentActionKind(stringField(expectValue, "actionKind", "")),
			defaultBindings: keymapBindings(expectValue, "defaultBindings"),
			configuredBinding: keymapBinding(objectField(expectValue, "configuredBinding")),
			runtimeBinding: keymapBinding(objectField(expectValue, "runtimeBinding")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap main-surface assignment expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapMainSurfaceAssignmentDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "actionKindPreserved", false)), boolText(outcome.actionKindPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultBindingEmptyPreserved", false)), boolText(outcome.defaultBindingEmptyPreserved));
		assertEquals(boolText(boolField(expectValue, "configuredBindingPreserved", false)), boolText(outcome.configuredBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "runtimeBindingPreserved", false)), boolText(outcome.runtimeBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapMainSurfaceConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapMainSurfaceConflictOutcome> {
		final outcomes:Array<ModelKeymapMainSurfaceConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapMainSurfaceConflictExpects");
		for (value in values) outcomes.push(assertKeymapMainSurfaceConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapMainSurfaceConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapMainSurfaceConflictOutcome> {
		final outcomes:Array<ModelKeymapMainSurfaceConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapMainSurfaceConflictExpects");
		for (value in values) outcomes.push(assertKeymapMainSurfaceConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapMainSurfaceConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapMainSurfaceConflictOutcome {
		final outcome = ModelKeymapMainSurfaceConflictPolicy.apply(new ModelKeymapMainSurfaceConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredToggleFastModeBinding: keymapBinding(objectField(expectValue, "configuredToggleFastModeBinding")),
			defaultClearTerminalBinding: keymapBinding(objectField(expectValue, "defaultClearTerminalBinding")),
			conflictOuterAction: ModelKeymapMainSurfaceActionKind.fromString(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: ModelKeymapMainSurfaceActionKind.fromString(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap main-surface conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapMainSurfaceConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "configuredToggleFastModeBindingPreserved", false)), boolText(outcome.configuredToggleFastModeBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultClearTerminalBindingPreserved", false)), boolText(outcome.defaultClearTerminalBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapComposerFixedShortcutConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapComposerFixedShortcutConflictOutcome> {
		final outcomes:Array<ModelKeymapComposerFixedShortcutConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapComposerFixedShortcutConflictExpects");
		for (value in values) outcomes.push(assertKeymapComposerFixedShortcutConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapComposerFixedShortcutConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapComposerFixedShortcutConflictOutcome> {
		final outcomes:Array<ModelKeymapComposerFixedShortcutConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapComposerFixedShortcutConflictExpects");
		for (value in values) outcomes.push(assertKeymapComposerFixedShortcutConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapComposerFixedShortcutConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapComposerFixedShortcutConflictOutcome {
		final outcome = ModelKeymapComposerFixedShortcutConflictPolicy.apply(new ModelKeymapComposerFixedShortcutConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredComposerSubmitBinding: keymapBinding(objectField(expectValue, "configuredComposerSubmitBinding")),
			fixedPasteImageBinding: keymapBinding(objectField(expectValue, "fixedPasteImageBinding")),
			conflictOuterAction: keymapComposerFixedShortcutConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapComposerFixedShortcutConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap composer/fixed-shortcut conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapComposerFixedShortcutConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "configuredComposerSubmitBindingPreserved", false)), boolText(outcome.configuredComposerSubmitBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "fixedPasteImageBindingPreserved", false)), boolText(outcome.fixedPasteImageBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapEditorConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapEditorConflictOutcome> {
		final outcomes:Array<ModelKeymapEditorConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapEditorConflictExpects");
		for (value in values) outcomes.push(assertKeymapEditorConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapEditorConflictOutcome> {
		final outcomes:Array<ModelKeymapEditorConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapEditorConflictExpects");
		for (value in values) outcomes.push(assertKeymapEditorConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapEditorConflictOutcome {
		final outcome = ModelKeymapEditorConflictPolicy.apply(new ModelKeymapEditorConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredMoveLeft: keymapBinding(objectField(expectValue, "configuredMoveLeft")),
			configuredMoveRight: keymapBinding(objectField(expectValue, "configuredMoveRight")),
			conflictOuterAction: keymapEditorConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapEditorConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap editor conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapEditorConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "moveLeftBindingPreserved", false)), boolText(outcome.moveLeftBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "moveRightBindingPreserved", false)), boolText(outcome.moveRightBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapEditorUnbindConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapEditorUnbindConflictOutcome> {
		final outcomes:Array<ModelKeymapEditorUnbindConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapEditorUnbindConflictExpects");
		for (value in values) outcomes.push(assertKeymapEditorUnbindConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorUnbindConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapEditorUnbindConflictOutcome> {
		final outcomes:Array<ModelKeymapEditorUnbindConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapEditorUnbindConflictExpects");
		for (value in values) outcomes.push(assertKeymapEditorUnbindConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapEditorUnbindConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapEditorUnbindConflictOutcome {
		final outcome = ModelKeymapEditorUnbindConflictPolicy.apply(new ModelKeymapEditorUnbindConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredKillWholeLine: keymapBinding(objectField(expectValue, "configuredKillWholeLine")),
			defaultKillLineStart: keymapBinding(objectField(expectValue, "defaultKillLineStart")),
			conflictOuterAction: keymapEditorUnbindConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapEditorUnbindConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			killLineStartUnbound: boolField(expectValue, "killLineStartUnbound", false),
			runtimeAcceptedAfterUnbind: boolField(expectValue, "runtimeAcceptedAfterUnbind", false),
			runtimeKillWholeLine: keymapBinding(objectField(expectValue, "runtimeKillWholeLine")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap editor unbind conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapEditorUnbindConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "configuredKillWholeLinePreserved", false)), boolText(outcome.configuredKillWholeLinePreserved));
		assertEquals(boolText(boolField(expectValue, "defaultKillLineStartPreserved", false)), boolText(outcome.defaultKillLineStartPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "originalActionUnboundPreserved", false)), boolText(outcome.originalActionUnboundPreserved));
		assertEquals(boolText(boolField(expectValue, "runtimeKillWholeLinePreserved", false)), boolText(outcome.runtimeKillWholeLinePreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapPagerConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapPagerConflictOutcome> {
		final outcomes:Array<ModelKeymapPagerConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapPagerConflictExpects");
		for (value in values) outcomes.push(assertKeymapPagerConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapPagerConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapPagerConflictOutcome> {
		final outcomes:Array<ModelKeymapPagerConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapPagerConflictExpects");
		for (value in values) outcomes.push(assertKeymapPagerConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapPagerConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapPagerConflictOutcome {
		final outcome = ModelKeymapPagerConflictPolicy.apply(new ModelKeymapPagerConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredScrollUp: keymapBinding(objectField(expectValue, "configuredScrollUp")),
			configuredScrollDown: keymapBinding(objectField(expectValue, "configuredScrollDown")),
			conflictOuterAction: keymapPagerConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapPagerConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap pager conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapPagerConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "scrollUpBindingPreserved", false)), boolText(outcome.scrollUpBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "scrollDownBindingPreserved", false)), boolText(outcome.scrollDownBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapListConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapListConflictOutcome> {
		final outcomes:Array<ModelKeymapListConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapListConflictExpects");
		for (value in values) outcomes.push(assertKeymapListConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapListConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapListConflictOutcome> {
		final outcomes:Array<ModelKeymapListConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapListConflictExpects");
		for (value in values) outcomes.push(assertKeymapListConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapListConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapListConflictOutcome {
		final outcome = ModelKeymapListConflictPolicy.apply(new ModelKeymapListConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredOuterBinding: keymapBinding(objectField(expectValue, "configuredOuterBinding")),
			configuredInnerBinding: keymapBinding(objectField(expectValue, "configuredInnerBinding")),
			conflictOuterAction: keymapListConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapListConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap list conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapListConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "outerBindingPreserved", false)), boolText(outcome.outerBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "innerBindingPreserved", false)), boolText(outcome.innerBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapApprovalConflicts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapApprovalConflictOutcome> {
		final outcomes:Array<ModelKeymapApprovalConflictOutcome> = [];
		final values = optionalArrayField(testCase, "keymapApprovalConflictExpects");
		for (value in values) outcomes.push(assertKeymapApprovalConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapApprovalConflicts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapApprovalConflictOutcome> {
		final outcomes:Array<ModelKeymapApprovalConflictOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapApprovalConflictExpects");
		for (value in values) outcomes.push(assertKeymapApprovalConflictSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapApprovalConflictSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapApprovalConflictOutcome {
		final outcome = ModelKeymapApprovalConflictPolicy.apply(new ModelKeymapApprovalConflictRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredApprove: optionalKeymapBinding(expectValue, "configuredApprove"),
			configuredDecline: optionalKeymapBinding(expectValue, "configuredDecline"),
			configuredDeny: optionalKeymapBinding(expectValue, "configuredDeny"),
			configuredListAccept: optionalKeymapBinding(expectValue, "configuredListAccept"),
			configuredListCancel: optionalKeymapBinding(expectValue, "configuredListCancel"),
			conflictOuterAction: keymapApprovalConflictActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapApprovalConflictActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap approval conflict expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapApprovalConflictDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "approveBindingPreserved", false)), boolText(outcome.approveBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "declineBindingPreserved", false)), boolText(outcome.declineBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "denyBindingPreserved", false)), boolText(outcome.denyBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "listAcceptBindingPreserved", false)), boolText(outcome.listAcceptBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "listCancelBindingPreserved", false)), boolText(outcome.listCancelBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelKeymapFixedShortcuts(
		testCase:Value,
		secretProbe:String
	):Array<ModelKeymapFixedShortcutOutcome> {
		final outcomes:Array<ModelKeymapFixedShortcutOutcome> = [];
		final values = optionalArrayField(testCase, "keymapFixedShortcutExpects");
		for (value in values) outcomes.push(assertKeymapFixedShortcutSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapFixedShortcuts(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelKeymapFixedShortcutOutcome> {
		final outcomes:Array<ModelKeymapFixedShortcutOutcome> = [];
		final values = optionalArrayField(verificationValue, "keymapFixedShortcutExpects");
		for (value in values) outcomes.push(assertKeymapFixedShortcutSet(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertKeymapFixedShortcutSet(
		expectValue:Value,
		secretProbe:String
	):ModelKeymapFixedShortcutOutcome {
		final outcome = ModelKeymapFixedShortcutPolicy.apply(new ModelKeymapFixedShortcutRequest({
			requestId: stringField(expectValue, "requestId", ""),
			configuredCopyBinding: keymapBinding(objectField(expectValue, "configuredCopyBinding")),
			defaultIncreaseReasoningBinding: keymapBinding(objectField(expectValue, "defaultIncreaseReasoningBinding")),
			conflictOuterAction: keymapFixedShortcutActionKind(stringField(expectValue, "conflictOuterAction", "")),
			conflictInnerAction: keymapFixedShortcutActionKind(stringField(expectValue, "conflictInnerAction", "")),
			expectedOuterActionName: stringField(expectValue, "expectedOuterActionName", ""),
			expectedInnerActionName: stringField(expectValue, "expectedInnerActionName", ""),
			conflictRejected: boolField(expectValue, "conflictRejected", false),
			increaseReasoningUnbound: boolField(expectValue, "increaseReasoningUnbound", false),
			runtimeAcceptedAfterUnbind: boolField(expectValue, "runtimeAcceptedAfterUnbind", false),
			runtimeCopyBinding: keymapBinding(objectField(expectValue, "runtimeCopyBinding")),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		if (boolText(boolField(expectValue, "ok", false)) != boolText(outcome.ok)) {
			throw "keymap fixed shortcut expectation failed: " + outcome.summary();
		}
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(keymapFixedShortcutDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(boolText(boolField(expectValue, "configuredCopyBindingPreserved", false)), boolText(outcome.configuredCopyBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "defaultIncreaseReasoningBindingPreserved", false)), boolText(outcome.defaultIncreaseReasoningBindingPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictActionNamesPreserved", false)), boolText(outcome.conflictActionNamesPreserved));
		assertEquals(boolText(boolField(expectValue, "conflictRejectionPreserved", false)), boolText(outcome.conflictRejectionPreserved));
		assertEquals(boolText(boolField(expectValue, "originalActionUnboundPreserved", false)), boolText(outcome.originalActionUnboundPreserved));
		assertEquals(boolText(boolField(expectValue, "runtimeCopyRemapPreserved", false)), boolText(outcome.runtimeCopyRemapPreserved));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelBacktrackSelections(
		testCase:Value,
		secretProbe:String
	):Array<ModelBacktrackSelectionOutcome> {
		final outcomes:Array<ModelBacktrackSelectionOutcome> = [];
		final values = optionalArrayField(testCase, "backtrackSelectionExpects");
		for (value in values) outcomes.push(assertBacktrackSelection(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackSelections(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelBacktrackSelectionOutcome> {
		final outcomes:Array<ModelBacktrackSelectionOutcome> = [];
		final values = optionalArrayField(verificationValue, "backtrackSelectionExpects");
		for (value in values) outcomes.push(assertBacktrackSelection(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackSelection(
		expectValue:Value,
		secretProbe:String
	):ModelBacktrackSelectionOutcome {
		final outcome = ModelBacktrackSelectionPolicy.apply(new ModelBacktrackSelectionRequest({
			requestId: stringField(expectValue, "requestId", ""),
			primed: boolField(expectValue, "primed", false),
			hasBaseThread: boolField(expectValue, "hasBaseThread", false),
			pendingRollback: boolField(expectValue, "pendingRollback", false),
			nthUserMessage: intField(expectValue, "nthUserMessage", 0),
			transcriptCells: backtrackTranscriptCells(expectValue),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(backtrackSelectionDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "userCountSinceLastSession", 0)), Std.string(outcome.userCountSinceLastSession));
		assertEquals(Std.string(intField(expectValue, "selectedNthUserMessage", -1)), Std.string(outcome.selectedNthUserMessage));
		assertEquals(stringField(expectValue, "selectedPrefill", ""), outcome.selectedPrefill);
		assertEquals(Std.string(intField(expectValue, "selectedTextElementCount", 0)), Std.string(outcome.selectedTextElementCount));
		assertEquals(Std.string(intField(expectValue, "selectedLocalImageCount", 0)), Std.string(outcome.selectedLocalImageCount));
		assertEquals(Std.string(intField(expectValue, "selectedRemoteImageCount", 0)), Std.string(outcome.selectedRemoteImageCount));
		assertEquals(stringField(expectValue, "selectedLocalImagePath", ""), outcome.selectedLocalImagePath);
		assertEquals(stringField(expectValue, "selectedRemoteImageUrl", ""), outcome.selectedRemoteImageUrl);
		assertEquals(Std.string(intField(expectValue, "rollbackTurnCount", 0)), Std.string(outcome.rollbackTurnCount));
		assertEquals(boolText(boolField(expectValue, "remoteImagesApplied", false)), boolText(outcome.remoteImagesApplied));
		assertEquals(boolText(boolField(expectValue, "composerPrefilled", false)), boolText(outcome.composerPrefilled));
		assertEquals(boolText(boolField(expectValue, "pendingRollbackRecorded", false)), boolText(outcome.pendingRollbackRecorded));
		assertEquals(boolText(boolField(expectValue, "threadRollbackSubmitted", false)), boolText(outcome.threadRollbackSubmitted));
		assertEquals(boolText(boolField(expectValue, "duplicateHistoryIgnoredBeforeLastSession", false)), boolText(outcome.duplicateHistoryIgnoredBeforeLastSession));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		assertNotContains(outcome.summary(), outcome.selectedPrefill);
		assertNotContains(outcome.summary(), outcome.selectedLocalImagePath);
		assertNotContains(outcome.summary(), outcome.selectedRemoteImageUrl);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelBacktrackRollbacks(
		testCase:Value,
		secretProbe:String
	):Array<ModelBacktrackRollbackOutcome> {
		final outcomes:Array<ModelBacktrackRollbackOutcome> = [];
		final values = optionalArrayField(testCase, "backtrackRollbackExpects");
		for (value in values) outcomes.push(assertBacktrackRollback(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackRollbacks(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelBacktrackRollbackOutcome> {
		final outcomes:Array<ModelBacktrackRollbackOutcome> = [];
		final values = optionalArrayField(verificationValue, "backtrackRollbackExpects");
		for (value in values) outcomes.push(assertBacktrackRollback(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackRollback(
		expectValue:Value,
		secretProbe:String
	):ModelBacktrackRollbackOutcome {
		final outcome = ModelBacktrackRollbackPolicy.apply(new ModelBacktrackRollbackRequest({
			requestId: stringField(expectValue, "requestId", ""),
			pendingRollback: boolField(expectValue, "pendingRollback", false),
			nthUserMessage: intField(expectValue, "nthUserMessage", 0),
			selectionPrefill: stringField(expectValue, "selectionPrefill", ""),
			selectedTextElementCount: intField(expectValue, "selectedTextElementCount", 0),
			selectedLocalImageCount: intField(expectValue, "selectedLocalImageCount", 0),
			selectedRemoteImageCount: intField(expectValue, "selectedRemoteImageCount", 0),
			selectedRemoteImageUrl: stringField(expectValue, "selectedRemoteImageUrl", ""),
			transcriptCells: backtrackTranscriptCells(expectValue),
			composerDraftBefore: stringField(expectValue, "composerDraftBefore", ""),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(backtrackRollbackDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "userCountSinceLastSession", 0)), Std.string(outcome.userCountSinceLastSession));
		assertEquals(Std.string(intField(expectValue, "selectedNthUserMessage", -1)), Std.string(outcome.selectedNthUserMessage));
		assertEquals(boolText(boolField(expectValue, "prefillEmpty", false)), boolText(outcome.prefillEmpty));
		assertEquals(boolText(boolField(expectValue, "remoteImageOnlySelection", false)), boolText(outcome.remoteImageOnlySelection));
		assertEquals(Std.string(intField(expectValue, "selectedTextElementCount", 0)), Std.string(outcome.selectedTextElementCount));
		assertEquals(Std.string(intField(expectValue, "selectedLocalImageCount", 0)), Std.string(outcome.selectedLocalImageCount));
		assertEquals(Std.string(intField(expectValue, "selectedRemoteImageCount", 0)), Std.string(outcome.selectedRemoteImageCount));
		assertEquals(stringField(expectValue, "selectedRemoteImageUrl", ""), outcome.selectedRemoteImageUrl);
		assertEquals(Std.string(intField(expectValue, "rollbackTurnCount", 0)), Std.string(outcome.rollbackTurnCount));
		assertEquals(stringField(expectValue, "composerDraftBefore", ""), outcome.composerDraftBefore);
		assertEquals(stringField(expectValue, "composerDraftAfter", ""), outcome.composerDraftAfter);
		assertEquals(boolText(boolField(expectValue, "staleComposerDraftCleared", false)), boolText(outcome.staleComposerDraftCleared));
		assertEquals(boolText(boolField(expectValue, "remoteImagesApplied", false)), boolText(outcome.remoteImagesApplied));
		assertEquals(boolText(boolField(expectValue, "pendingRollbackRecorded", false)), boolText(outcome.pendingRollbackRecorded));
		assertEquals(boolText(boolField(expectValue, "threadRollbackSubmitted", false)), boolText(outcome.threadRollbackSubmitted));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (outcome.composerDraftBefore.length > 0) assertNotContains(outcome.summary(), outcome.composerDraftBefore);
		if (outcome.composerDraftAfter.length > 0) assertNotContains(outcome.summary(), outcome.composerDraftAfter);
		if (outcome.selectedRemoteImageUrl.length > 0) assertNotContains(outcome.summary(), outcome.selectedRemoteImageUrl);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelCancelledTurnEdits(
		testCase:Value,
		secretProbe:String
	):Array<ModelCancelledTurnEditOutcome> {
		final outcomes:Array<ModelCancelledTurnEditOutcome> = [];
		final values = optionalArrayField(testCase, "cancelledTurnEditExpects");
		for (value in values) outcomes.push(assertCancelledTurnEdit(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertCancelledTurnEdits(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelCancelledTurnEditOutcome> {
		final outcomes:Array<ModelCancelledTurnEditOutcome> = [];
		final values = optionalArrayField(verificationValue, "cancelledTurnEditExpects");
		for (value in values) outcomes.push(assertCancelledTurnEdit(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertCancelledTurnEdit(
		expectValue:Value,
		secretProbe:String
	):ModelCancelledTurnEditOutcome {
		final outcome = ModelCancelledTurnEditPolicy.apply(new ModelCancelledTurnEditRequest({
			requestId: stringField(expectValue, "requestId", ""),
			pendingRollback: boolField(expectValue, "pendingRollback", false),
			promptText: stringField(expectValue, "promptText", ""),
			promptTextElementCount: intField(expectValue, "promptTextElementCount", 0),
			promptLocalImageCount: intField(expectValue, "promptLocalImageCount", 0),
			promptRemoteImageCount: intField(expectValue, "promptRemoteImageCount", 0),
			promptRemoteImageUrl: stringField(expectValue, "promptRemoteImageUrl", ""),
			transcriptCells: backtrackTranscriptCells(expectValue),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(cancelledTurnEditDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "userCountSinceLastSession", 0)), Std.string(outcome.userCountSinceLastSession));
		assertEquals(Std.string(intField(expectValue, "selectedNthUserMessage", -1)), Std.string(outcome.selectedNthUserMessage));
		assertEquals(Std.string(intField(expectValue, "rollbackTurnCount", 0)), Std.string(outcome.rollbackTurnCount));
		assertEquals(boolText(boolField(expectValue, "usedBacktrackRollbackPath", false)), boolText(outcome.usedBacktrackRollbackPath));
		assertEquals(boolText(boolField(expectValue, "usedFirstPromptRollbackPath", false)), boolText(outcome.usedFirstPromptRollbackPath));
		assertEquals(stringField(expectValue, "promptText", ""), outcome.promptText);
		assertEquals(Std.string(intField(expectValue, "promptTextElementCount", 0)), Std.string(outcome.promptTextElementCount));
		assertEquals(Std.string(intField(expectValue, "promptLocalImageCount", 0)), Std.string(outcome.promptLocalImageCount));
		assertEquals(Std.string(intField(expectValue, "promptRemoteImageCount", 0)), Std.string(outcome.promptRemoteImageCount));
		assertEquals(stringField(expectValue, "promptRemoteImageUrl", ""), outcome.promptRemoteImageUrl);
		assertEquals(stringField(expectValue, "composerTextAfter", ""), outcome.composerTextAfter);
		assertEquals(boolText(boolField(expectValue, "remoteImagesApplied", false)), boolText(outcome.remoteImagesApplied));
		assertEquals(boolText(boolField(expectValue, "pendingRollbackRecorded", false)), boolText(outcome.pendingRollbackRecorded));
		assertEquals(boolText(boolField(expectValue, "threadRollbackSubmitted", false)), boolText(outcome.threadRollbackSubmitted));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (outcome.promptText.length > 0) assertNotContains(outcome.summary(), outcome.promptText);
		if (outcome.composerTextAfter.length > 0) assertNotContains(outcome.summary(), outcome.composerTextAfter);
		if (outcome.promptRemoteImageUrl.length > 0) assertNotContains(outcome.summary(), outcome.promptRemoteImageUrl);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelBacktrackResubmits(
		testCase:Value,
		secretProbe:String
	):Array<ModelBacktrackResubmitOutcome> {
		final outcomes:Array<ModelBacktrackResubmitOutcome> = [];
		final values = optionalArrayField(testCase, "backtrackResubmitExpects");
		for (value in values) outcomes.push(assertBacktrackResubmit(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackResubmits(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelBacktrackResubmitOutcome> {
		final outcomes:Array<ModelBacktrackResubmitOutcome> = [];
		final values = optionalArrayField(verificationValue, "backtrackResubmitExpects");
		for (value in values) outcomes.push(assertBacktrackResubmit(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertBacktrackResubmit(
		expectValue:Value,
		secretProbe:String
	):ModelBacktrackResubmitOutcome {
		final outcome = ModelBacktrackResubmitPolicy.apply(new ModelBacktrackResubmitRequest({
			requestId: stringField(expectValue, "requestId", ""),
			sessionConfigured: boolField(expectValue, "sessionConfigured", false),
			modelSupportsImages: boolField(expectValue, "modelSupportsImages", false),
			nthUserMessage: intField(expectValue, "nthUserMessage", 0),
			selectionPrefill: stringField(expectValue, "selectionPrefill", ""),
			selectedRemoteImageCount: intField(expectValue, "selectedRemoteImageCount", 0),
			selectedRemoteImageUrl: stringField(expectValue, "selectedRemoteImageUrl", ""),
			transcriptCells: backtrackTranscriptCells(expectValue),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(backtrackResubmitDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "userCountSinceLastSession", 0)), Std.string(outcome.userCountSinceLastSession));
		assertEquals(Std.string(intField(expectValue, "selectedNthUserMessage", -1)), Std.string(outcome.selectedNthUserMessage));
		assertEquals(Std.string(intField(expectValue, "rollbackTurnCount", 0)), Std.string(outcome.rollbackTurnCount));
		assertEquals(stringField(expectValue, "composerTextAfterRollback", ""), outcome.composerTextAfterRollback);
		assertEquals(Std.string(intField(expectValue, "composerRemoteImageCountAfterRollback", 0)), Std.string(outcome.composerRemoteImageCountAfterRollback));
		assertEquals(Std.string(intField(expectValue, "submittedImageItemCount", 0)), Std.string(outcome.submittedImageItemCount));
		assertEquals(Std.string(intField(expectValue, "submittedTextItemCount", 0)), Std.string(outcome.submittedTextItemCount));
		assertEquals(stringField(expectValue, "submittedImageUrl", ""), outcome.submittedImageUrl);
		assertEquals(boolText(boolField(expectValue, "dataImageUrlPreserved", false)), boolText(outcome.dataImageUrlPreserved));
		assertEquals(boolText(boolField(expectValue, "imageItemBeforeTextItem", false)), boolText(outcome.imageItemBeforeTextItem));
		assertEquals(boolText(boolField(expectValue, "rollbackSubmitted", false)), boolText(outcome.rollbackSubmitted));
		assertEquals(boolText(boolField(expectValue, "userTurnSubmitted", false)), boolText(outcome.userTurnSubmitted));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		if (outcome.composerTextAfterRollback.length > 0) assertNotContains(outcome.summary(), outcome.composerTextAfterRollback);
		if (outcome.submittedImageUrl.length > 0) assertNotContains(outcome.summary(), outcome.submittedImageUrl);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelQueuedRollbackOverlaySyncs(
		testCase:Value,
		secretProbe:String
	):Array<ModelQueuedRollbackOverlaySyncOutcome> {
		final outcomes:Array<ModelQueuedRollbackOverlaySyncOutcome> = [];
		final values = optionalArrayField(testCase, "queuedRollbackOverlaySyncExpects");
		for (value in values) outcomes.push(assertQueuedRollbackOverlaySync(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertQueuedRollbackOverlaySyncs(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelQueuedRollbackOverlaySyncOutcome> {
		final outcomes:Array<ModelQueuedRollbackOverlaySyncOutcome> = [];
		final values = optionalArrayField(verificationValue, "queuedRollbackOverlaySyncExpects");
		for (value in values) outcomes.push(assertQueuedRollbackOverlaySync(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertQueuedRollbackOverlaySync(
		expectValue:Value,
		secretProbe:String
	):ModelQueuedRollbackOverlaySyncOutcome {
		final outcome = ModelQueuedRollbackOverlaySyncPolicy.apply(new ModelQueuedRollbackOverlaySyncRequest({
			requestId: stringField(expectValue, "requestId", ""),
			numTurns: intField(expectValue, "numTurns", 0),
			overlayActive: boolField(expectValue, "overlayActive", false),
			overlayPreviewActive: boolField(expectValue, "overlayPreviewActive", false),
			nthUserMessageBefore: intField(expectValue, "nthUserMessageBefore", -1),
			deferredHistoryLineCountBefore: intField(expectValue, "deferredHistoryLineCountBefore", 0),
			transcriptCells: backtrackTranscriptCells(expectValue),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(queuedRollbackOverlaySyncDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "numTurns", 0)), Std.string(outcome.numTurns));
		assertEquals(Std.string(intField(expectValue, "transcriptCellCountBefore", 0)), Std.string(outcome.transcriptCellCountBefore));
		assertEquals(Std.string(intField(expectValue, "transcriptCellCountAfter", 0)), Std.string(outcome.transcriptCellCountAfter));
		assertEquals(Std.string(intField(expectValue, "userCountBefore", 0)), Std.string(outcome.userCountBefore));
		assertEquals(Std.string(intField(expectValue, "userCountAfter", 0)), Std.string(outcome.userCountAfter));
		assertStringArraysEqual(stringArrayField(expectValue, "userMessagesAfter"), outcome.userMessagesAfter);
		assertEquals(boolText(boolField(expectValue, "overlayActive", false)), boolText(outcome.overlayActive));
		assertEquals(Std.string(intField(expectValue, "overlayCommittedCellCountBefore", 0)), Std.string(outcome.overlayCommittedCellCountBefore));
		assertEquals(Std.string(intField(expectValue, "overlayCommittedCellCountAfter", 0)), Std.string(outcome.overlayCommittedCellCountAfter));
		assertEquals(boolText(boolField(expectValue, "overlayCommittedCountSynced", false)), boolText(outcome.overlayCommittedCountSynced));
		assertEquals(Std.string(intField(expectValue, "deferredHistoryLineCountBefore", 0)), Std.string(outcome.deferredHistoryLineCountBefore));
		assertEquals(Std.string(intField(expectValue, "deferredHistoryLineCountAfter", 0)), Std.string(outcome.deferredHistoryLineCountAfter));
		assertEquals(boolText(boolField(expectValue, "deferredHistoryCleared", false)), boolText(outcome.deferredHistoryCleared));
		assertEquals(Std.string(intField(expectValue, "previewSelectionBefore", -1)), Std.string(outcome.previewSelectionBefore));
		assertEquals(Std.string(intField(expectValue, "previewSelectionAfter", -1)), Std.string(outcome.previewSelectionAfter));
		assertEquals(boolText(boolField(expectValue, "previewSelectionClamped", false)), boolText(outcome.previewSelectionClamped));
		assertEquals(Std.string(intField(expectValue, "agentCopyHistoryUserCountAfter", 0)), Std.string(outcome.agentCopyHistoryUserCountAfter));
		assertEquals(boolText(boolField(expectValue, "agentCopyHistoryTruncated", false)), boolText(outcome.agentCopyHistoryTruncated));
		assertEquals(boolText(boolField(expectValue, "backtrackRenderPending", false)), boolText(outcome.backtrackRenderPending));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		for (message in outcome.userMessagesAfter) if (message.length > 0) assertNotContains(outcome.summary(), message);
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertTopLevelThreadRollbackResponseActiveQueueFlushes(
		testCase:Value,
		secretProbe:String
	):Array<ModelThreadRollbackResponseActiveQueueFlushOutcome> {
		final outcomes:Array<ModelThreadRollbackResponseActiveQueueFlushOutcome> = [];
		final values = optionalArrayField(testCase, "threadRollbackResponseActiveQueueFlushExpects");
		for (value in values) outcomes.push(assertThreadRollbackResponseActiveQueueFlush(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadRollbackResponseActiveQueueFlushes(
		verificationValue:Value,
		secretProbe:String
	):Array<ModelThreadRollbackResponseActiveQueueFlushOutcome> {
		final outcomes:Array<ModelThreadRollbackResponseActiveQueueFlushOutcome> = [];
		final values = optionalArrayField(verificationValue, "threadRollbackResponseActiveQueueFlushExpects");
		for (value in values) outcomes.push(assertThreadRollbackResponseActiveQueueFlush(objectValue(value), secretProbe));
		return outcomes;
	}

	static function assertThreadRollbackResponseActiveQueueFlush(
		expectValue:Value,
		secretProbe:String
	):ModelThreadRollbackResponseActiveQueueFlushOutcome {
		final outcome = ModelThreadRollbackResponseActiveQueueFlushPolicy.apply(new ModelThreadRollbackResponseActiveQueueFlushRequest({
			requestId: stringField(expectValue, "requestId", ""),
			activeThreadId: stringField(expectValue, "activeThreadId", ""),
			rollbackThreadId: stringField(expectValue, "rollbackThreadId", ""),
			numTurns: intField(expectValue, "numTurns", 0),
			threadChannelKnown: boolField(expectValue, "threadChannelKnown", false),
			receiverAttachedBefore: boolField(expectValue, "receiverAttachedBefore", false),
			receiverDisconnectedDuringDrain: boolField(expectValue, "receiverDisconnectedDuringDrain", false),
			queuedActiveEventCountBefore: intField(expectValue, "queuedActiveEventCountBefore", 0),
			queuedStaleNotificationCountBefore: intField(expectValue, "queuedStaleNotificationCountBefore", 0),
			pendingBacktrackRollback: boolField(expectValue, "pendingBacktrackRollback", false),
			previousEventCount: intField(expectValue, "previousEventCount", 0),
			eventOrderIndex: intField(expectValue, "eventOrderIndex", 0),
			secretProbe: secretProbe
		}));
		assertEquals(boolText(boolField(expectValue, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expectValue, "code", ""), outcome.code);
		assertEquals(stringField(expectValue, "requestId", ""), outcome.requestId);
		assertEquals(threadRollbackResponseActiveQueueFlushDecisionKind(stringField(expectValue, "decisionKind", "")), outcome.decisionKind);
		assertEquals(Std.string(intField(expectValue, "numTurns", 0)), Std.string(outcome.numTurns));
		assertEquals(boolText(boolField(expectValue, "activeThreadMatched", false)), boolText(outcome.activeThreadMatched));
		assertEquals(boolText(boolField(expectValue, "threadStoreRollbackApplied", false)), boolText(outcome.threadStoreRollbackApplied));
		assertEquals(boolText(boolField(expectValue, "receiverAttachedBefore", false)), boolText(outcome.receiverAttachedBefore));
		assertEquals(boolText(boolField(expectValue, "receiverAttachedAfter", false)), boolText(outcome.receiverAttachedAfter));
		assertEquals(boolText(boolField(expectValue, "receiverClearedAfterDisconnect", false)), boolText(outcome.receiverClearedAfterDisconnect));
		assertEquals(Std.string(intField(expectValue, "queuedActiveEventCountBefore", 0)), Std.string(outcome.queuedActiveEventCountBefore));
		assertEquals(Std.string(intField(expectValue, "drainedActiveEventCount", 0)), Std.string(outcome.drainedActiveEventCount));
		assertEquals(Std.string(intField(expectValue, "queuedActiveEventCountAfter", 0)), Std.string(outcome.queuedActiveEventCountAfter));
		assertEquals(boolText(boolField(expectValue, "staleNotificationDiscarded", false)), boolText(outcome.staleNotificationDiscarded));
		assertEquals(boolText(boolField(expectValue, "applyThreadRollbackEventQueued", false)), boolText(outcome.applyThreadRollbackEventQueued));
		assertEquals(boolText(boolField(expectValue, "pendingBacktrackFinished", false)), boolText(outcome.pendingBacktrackFinished));
		assertEquals(boolText(boolField(expectValue, "eventOrderingPreserved", false)), boolText(outcome.eventOrderingPreserved));
		assertEquals(boolText(boolField(expectValue, "liveOnlyEffectsSuppressed", false)), boolText(outcome.liveOnlyEffectsSuppressed));
		assertEquals(boolText(boolField(expectValue, "liveNetworkAttempted", false)), boolText(outcome.liveNetworkAttempted));
		assertEquals(boolText(boolField(expectValue, "realFilesystemMutated", false)), boolText(outcome.realFilesystemMutated));
		assertEquals(boolText(boolField(expectValue, "toolExecutedOutsideFixture", false)), boolText(outcome.toolExecutedOutsideFixture));
		assertEquals(stringField(expectValue, "errorMessage", ""), outcome.errorMessage);
		assertContains(outcome.summary(), stringField(expectValue, "summaryContains", ""));
		assertNotContains(outcome.summary(), stringField(expectValue, "staleNotificationSummary", ""));
		assertNotContains(outcome.summary(), stringField(expectValue, "activeThreadId", ""));
		assertNotContains(outcome.summary(), stringField(expectValue, "rollbackThreadId", ""));
		if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
		return outcome;
	}

	static function assertStringArraysEqual(expected:Array<String>, actual:Array<String>):Void {
		assertEquals(expected.join("\n"), actual.join("\n"));
	}

	static function activeNonPrimaryShutdownByRequestId(
		outcomes:Array<ModelActiveNonPrimaryShutdownOutcome>,
		requestId:String
	):ModelActiveNonPrimaryShutdownOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing active non-primary shutdown outcome: " + requestId;
	}

	static function threadSideThreadNavigationCleanupByRequestId(
		outcomes:Array<ModelThreadSideThreadNavigationCleanupOutcome>,
		requestId:String
	):ModelThreadSideThreadNavigationCleanupOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread navigation cleanup outcome: " + requestId;
	}

	static function threadSideThreadComposerHandoffByRequestId(
		outcomes:Array<ModelThreadSideThreadComposerHandoffOutcome>,
		requestId:String
	):ModelThreadSideThreadComposerHandoffOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread composer handoff outcome: " + requestId;
	}

	static function threadSideThreadDiscardByRequestId(
		outcomes:Array<ModelThreadSideThreadDiscardOutcome>,
		requestId:String
	):ModelThreadSideThreadDiscardOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread side-thread discard outcome: " + requestId;
	}

	static function threadActiveTurnByRequestId(outcomes:Array<ModelThreadActiveTurnOutcome>, requestId:String):ModelThreadActiveTurnOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing thread active-turn outcome: " + requestId;
	}

	static function turnReplayReconstructionByRequestId(outcomes:Array<ModelTurnReplayReconstructionOutcome>, requestId:String):ModelTurnReplayReconstructionOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing turn replay reconstruction outcome: " + requestId;
	}

	static function turnTerminalProjectionByRequestId(outcomes:Array<ModelTurnTerminalProjectionOutcome>, requestId:String):ModelTurnTerminalProjectionOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing turn terminal projection outcome: " + requestId;
	}

	static function turnLifecycleByRequestId(outcomes:Array<ModelTurnLifecycleOutcome>, requestId:String):ModelTurnLifecycleOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing turn lifecycle outcome: " + requestId;
	}

	static function samplingResultIntegrationByRequestId(integrations:Array<ModelSamplingResultIntegrationOutcome>, requestId:String):ModelSamplingResultIntegrationOutcome {
		for (integration in integrations) if (integration.requestId == requestId) return integration;
		throw "missing sampling result integration outcome: " + requestId;
	}

	static function terminalStopHookByRequestId(outcomes:Array<ModelTerminalStopHookOutcome>, requestId:String):ModelTerminalStopHookOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing terminal stop hook outcome: " + requestId;
	}

	static function samplingErrorTerminalByRequestId(outcomes:Array<ModelSamplingErrorTerminalOutcome>, requestId:String):ModelSamplingErrorTerminalOutcome {
		for (outcome in outcomes) if (outcome.requestId == requestId) return outcome;
		throw "missing sampling error terminal outcome: " + requestId;
	}

	static function promptPreparationByRequestId(
		preparations:Array<ModelPromptPreparationOutcome>,
		requestId:String
	):ModelPromptPreparationOutcome {
		for (preparation in preparations) if (preparation.requestId == requestId) return preparation;
		throw "missing prompt preparation outcome: " + requestId;
	}

	static function pendingInputHookRecordingByRequestId(
		recordings:Array<ModelPendingInputHookRecordingOutcome>,
		requestId:String
	):ModelPendingInputHookRecordingOutcome {
		for (recording in recordings) if (recording.requestId == requestId) return recording;
		throw "missing pending input hook recording outcome: " + requestId;
	}

	static function postSamplingPendingInputDrainByRequestId(drains:Array<ModelPostSamplingPendingInputDrainOutcome>, requestId:String):ModelPostSamplingPendingInputDrainOutcome {
		for (drain in drains) if (drain.requestId == requestId) return drain;
		throw "missing post-sampling pending input drain outcome: " + requestId;
	}

	static function postDrainEmissionByRequestId(emissions:Array<ModelPostDrainEmissionOutcome>, requestId:String):ModelPostDrainEmissionOutcome {
		for (emission in emissions) if (emission.requestId == requestId) return emission;
		throw "missing post-drain emission outcome: " + requestId;
	}

	static function samplingResultStatusKind(value:String):ModelSamplingResultIntegrationStatusKind {
		return switch value {
			case "ok": ModelSamplingResultIntegrationStatusKind.Ok;
			case "cancelled": ModelSamplingResultIntegrationStatusKind.Cancelled;
			case "error": ModelSamplingResultIntegrationStatusKind.Error;
			case _: throw "unknown sampling result integration status kind: " + value;
		}
	}

	static function streamHandoffByRequestId(handoffs:Array<ModelSamplingStreamEventHandoffOutcome>, requestId:String):ModelSamplingStreamEventHandoffOutcome {
		for (handoff in handoffs) if (handoff.requestId == requestId) return handoff;
		throw "missing stream handoff outcome: " + requestId;
	}

	static function inFlightDrainItems(values:Array<Value>):Array<ModelInFlightToolDrainItem> {
		final out:Array<ModelInFlightToolDrainItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelInFlightToolDrainItem(
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				intField(item, "orderIndex", 0),
				stringField(item, "outputText", ""),
				boolField(item, "success", false),
				inFlightFailureKind(stringField(item, "failureKind", "none")),
				boolField(item, "fromResponseInput", false),
				boolField(item, "externalContext", false)
			));
		}
		return out;
	}

	static function inFlightFailureKind(value:String):ModelInFlightToolDrainFailureKind {
		return switch value {
			case "none": ModelInFlightToolDrainFailureKind.None;
			case "converted_tool_failure": ModelInFlightToolDrainFailureKind.ConvertedToolFailure;
			case "fatal_tool_future": ModelInFlightToolDrainFailureKind.FatalToolFuture;
			case _: throw "unknown in-flight tool drain failure kind: " + value;
		}
	}

	static function samplingStreamErrorKind(value:String):ModelSamplingStreamErrorKind {
		return switch value {
			case "none": ModelSamplingStreamErrorKind.None;
			case "stream_disconnected": ModelSamplingStreamErrorKind.StreamDisconnected;
			case "unauthorized": ModelSamplingStreamErrorKind.Unauthorized;
			case "context_window_exceeded": ModelSamplingStreamErrorKind.ContextWindowExceeded;
			case "usage_limit_reached": ModelSamplingStreamErrorKind.UsageLimitReached;
			case "non_retryable_api_error": ModelSamplingStreamErrorKind.NonRetryableApiError;
			case _: throw "unknown sampling stream error kind: " + value;
		}
	}

	static function samplingDispatchTransportKind(value:String):ModelSamplingDispatchTransportKind {
		return switch value {
			case "responses_http": ModelSamplingDispatchTransportKind.ResponsesHttp;
			case "responses_websocket": ModelSamplingDispatchTransportKind.ResponsesWebsocket;
			case "fixture_disabled": ModelSamplingDispatchTransportKind.FixtureDisabled;
			case _: throw "unknown sampling dispatch transport kind: " + value;
		}
	}

	static function samplingInputItems(values:Array<Value>):Array<ModelSamplingInputItem> {
		final out:Array<ModelSamplingInputItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelSamplingInputItem(
				samplingInputItemKind(stringField(item, "kind", "")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", ""),
				boolField(item, "fromPendingInput", false),
				boolField(item, "recordedInHistory", false)
			));
		}
		return out;
	}

	static function postSamplingPendingInputItems(values:Array<Value>):Array<ModelPostSamplingPendingInputDrainItem> {
		final out:Array<ModelPostSamplingPendingInputDrainItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelPostSamplingPendingInputDrainItem(
				postSamplingPendingInputSourceKind(stringField(item, "sourceKind", "active_turn")),
				samplingInputItemKind(stringField(item, "inputKind", "pending_user_input")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", "")
			));
		}
		return out;
	}

	static function pendingInputHookRecordingItems(values:Array<Value>):Array<ModelPendingInputHookRecordingItem> {
		final out:Array<ModelPendingInputHookRecordingItem> = [];
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelPendingInputHookRecordingItem(
				postSamplingPendingInputSourceKind(stringField(item, "sourceKind", "active_turn")),
				samplingInputItemKind(stringField(item, "inputKind", "pending_user_input")),
				intField(item, "orderIndex", 0),
				stringField(item, "callId", ""),
				toolOutputItemKind(stringField(item, "responseKind", "function_call_output")),
				stringField(item, "text", ""),
				pendingInputHookActionKind(stringField(item, "hookActionKind", "continue_input")),
				intField(item, "additionalContextCount", 0)
			));
		}
		return out;
	}

	static function pendingInputHookActionKind(value:String):ModelPendingInputHookActionKind {
		return switch value {
			case "continue_input": ModelPendingInputHookActionKind.ContinueInput;
			case "stop_input": ModelPendingInputHookActionKind.StopInput;
			case _: throw "unknown pending input hook action kind: " + value;
		}
	}

	static function terminalStopHookTargetKind(value:String):ModelTerminalStopHookTargetKind {
		return switch value {
			case "stop": ModelTerminalStopHookTargetKind.Stop;
			case "subagent_stop": ModelTerminalStopHookTargetKind.SubagentStop;
			case "internal_subagent_skip": ModelTerminalStopHookTargetKind.InternalSubagentSkip;
			case _: throw "unknown terminal stop hook target kind: " + value;
		}
	}

	static function terminalStopHookRunStatusKind(value:String):ModelTerminalStopHookRunStatusKind {
		return switch value {
			case "running": ModelTerminalStopHookRunStatusKind.Running;
			case "completed": ModelTerminalStopHookRunStatusKind.Completed;
			case "failed": ModelTerminalStopHookRunStatusKind.Failed;
			case "blocked": ModelTerminalStopHookRunStatusKind.Blocked;
			case "stopped": ModelTerminalStopHookRunStatusKind.Stopped;
			case _: throw "unknown terminal stop hook run status kind: " + value;
		}
	}

	static function samplingErrorTerminalKind(value:String):ModelSamplingErrorTerminalKind {
		return switch value {
			case "turn_aborted": ModelSamplingErrorTerminalKind.TurnAborted;
			case "invalid_image_request": ModelSamplingErrorTerminalKind.InvalidImageRequest;
			case "generic_codex_error": ModelSamplingErrorTerminalKind.GenericCodexError;
			case _: throw "unknown sampling error terminal kind: " + value;
		}
	}

	static function turnLifecycleTerminalKind(value:String):ModelTurnLifecycleTerminalKind {
		return switch value {
			case "completed": ModelTurnLifecycleTerminalKind.Completed;
			case "completed_after_error": ModelTurnLifecycleTerminalKind.CompletedAfterError;
			case "aborted": ModelTurnLifecycleTerminalKind.Aborted;
			case _: throw "unknown turn lifecycle terminal kind: " + value;
		}
	}

	static function turnTerminalProjectionEventKind(value:String):ModelTurnTerminalProjectionEventKind {
		return switch value {
			case "turn_complete": ModelTurnTerminalProjectionEventKind.TurnComplete;
			case "turn_aborted": ModelTurnTerminalProjectionEventKind.TurnAborted;
			case _: throw "unknown turn terminal projection event kind: " + value;
		}
	}

	static function turnTerminalProjectedStatusKind(value:String):ModelTurnTerminalProjectedStatusKind {
		return switch value {
			case "completed": ModelTurnTerminalProjectedStatusKind.Completed;
			case "interrupted": ModelTurnTerminalProjectedStatusKind.Interrupted;
			case "failed": ModelTurnTerminalProjectedStatusKind.Failed;
			case "errored": ModelTurnTerminalProjectedStatusKind.Errored;
			case _: throw "unknown turn terminal projected status kind: " + value;
		}
	}

	static function turnTerminalNotificationIntentKind(value:String):ModelTurnTerminalNotificationIntentKind {
		return switch value {
			case "none": ModelTurnTerminalNotificationIntentKind.None;
			case "app_server_turn_completed": ModelTurnTerminalNotificationIntentKind.AppServerTurnCompleted;
			case "tui_agent_turn_complete": ModelTurnTerminalNotificationIntentKind.TuiAgentTurnComplete;
			case "tui_interrupted_turn": ModelTurnTerminalNotificationIntentKind.TuiInterruptedTurn;
			case "tui_error_surface": ModelTurnTerminalNotificationIntentKind.TuiErrorSurface;
			case _: throw "unknown turn terminal notification intent kind: " + value;
		}
	}

	static function turnReplayKind(value:String):ModelTurnReplayKind {
		return switch value {
			case "resume_initial_messages": ModelTurnReplayKind.ResumeInitialMessages;
			case "thread_snapshot": ModelTurnReplayKind.ThreadSnapshot;
			case _: throw "unknown turn replay kind: " + value;
		}
	}

	static function threadSnapshotTurnHistoryDecisionKind(value:String):ModelThreadSnapshotTurnHistoryDecisionKind {
		return switch value {
			case "turn_history_replayed_in_order": ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayedInOrder;
			case "turn_history_replay_blocked": ModelThreadSnapshotTurnHistoryDecisionKind.TurnHistoryReplayBlocked;
			case _: throw "unknown thread snapshot turn history decision kind: " + value;
		}
	}

	static function threadSnapshotTurnHistoryItemKind(value:String):ModelThreadSnapshotTurnHistoryItemKind {
		return switch value {
			case "user_message": ModelThreadSnapshotTurnHistoryItemKind.UserMessage;
			case "agent_message": ModelThreadSnapshotTurnHistoryItemKind.AgentMessage;
			case "other": ModelThreadSnapshotTurnHistoryItemKind.Other;
			case _: throw "unknown thread snapshot turn history item kind: " + value;
		}
	}

	static function threadSnapshotTurnStatusKind(value:String):ModelThreadSnapshotTurnStatusKind {
		return switch value {
			case "completed": ModelThreadSnapshotTurnStatusKind.Completed;
			case "failed": ModelThreadSnapshotTurnStatusKind.Failed;
			case "interrupted": ModelThreadSnapshotTurnStatusKind.Interrupted;
			case "in_progress": ModelThreadSnapshotTurnStatusKind.InProgress;
			case _: throw "unknown thread snapshot turn status kind: " + value;
		}
	}

	static function threadSnapshotCollabMetadataDecisionKind(value:String):ModelThreadSnapshotCollabMetadataReplayDecisionKind {
		return switch value {
			case "metadata_reseeded_for_replay": ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReseededForReplay;
			case "metadata_replay_blocked": ModelThreadSnapshotCollabMetadataReplayDecisionKind.MetadataReplayBlocked;
			case _: throw "unknown thread snapshot collab metadata decision kind: " + value;
		}
	}

	static function collabReplayWaitStatusKind(value:String):ModelCollabReplayWaitStatusKind {
		return switch value {
			case "in_progress": ModelCollabReplayWaitStatusKind.InProgress;
			case "completed": ModelCollabReplayWaitStatusKind.Completed;
			case "failed": ModelCollabReplayWaitStatusKind.Failed;
			case _: throw "unknown collab replay wait status kind: " + value;
		}
	}

	static function threadSnapshotSessionRefreshDecisionKind(value:String):ModelThreadSnapshotSessionRefreshDecisionKind {
		return switch value {
			case "refreshed_snapshot_persisted": ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotPersisted;
			case "refreshed_snapshot_blocked": ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotBlocked;
			case _: throw "unknown thread snapshot session refresh decision kind: " + value;
		}
	}

	static function turnReplayTargetKind(value:String):ModelTurnReplayTargetKind {
		return switch value {
			case "active_exact": ModelTurnReplayTargetKind.ActiveExact;
			case "historical_exact": ModelTurnReplayTargetKind.HistoricalExact;
			case "active_fallback": ModelTurnReplayTargetKind.ActiveFallback;
			case "missing_noop": ModelTurnReplayTargetKind.MissingNoop;
			case _: throw "unknown turn replay target kind: " + value;
		}
	}

	static function pendingInteractiveReplayEventKind(value:String):ModelPendingInteractiveReplayEventKind {
		return switch value {
			case "set_turns": ModelPendingInteractiveReplayEventKind.SetTurns;
			case "server_request": ModelPendingInteractiveReplayEventKind.ServerRequest;
			case "turn_completed": ModelPendingInteractiveReplayEventKind.TurnCompleted;
			case "server_request_resolved": ModelPendingInteractiveReplayEventKind.ServerRequestResolved;
			case "evicted_server_request": ModelPendingInteractiveReplayEventKind.EvictedServerRequest;
			case "outbound_op": ModelPendingInteractiveReplayEventKind.OutboundOp;
			case "snapshot": ModelPendingInteractiveReplayEventKind.Snapshot;
			case "thread_closed": ModelPendingInteractiveReplayEventKind.ThreadClosed;
			case "rollback": ModelPendingInteractiveReplayEventKind.Rollback;
			case _: throw "unknown pending interactive replay event kind: " + value;
		}
	}

	static function pendingInteractivePromptKind(value:String):ModelPendingInteractivePromptKind {
		return switch value {
			case "none": ModelPendingInteractivePromptKind.None;
			case "exec_approval": ModelPendingInteractivePromptKind.ExecApproval;
			case "patch_approval": ModelPendingInteractivePromptKind.PatchApproval;
			case "elicitation": ModelPendingInteractivePromptKind.Elicitation;
			case "request_permissions": ModelPendingInteractivePromptKind.RequestPermissions;
			case "request_user_input": ModelPendingInteractivePromptKind.RequestUserInput;
			case _: throw "unknown pending interactive prompt kind: " + value;
		}
	}

	static function pendingInteractiveSideStatusKind(value:String):ModelPendingInteractiveSideStatusKind {
		return switch value {
			case "none": ModelPendingInteractiveSideStatusKind.None;
			case "needs_approval": ModelPendingInteractiveSideStatusKind.NeedsApproval;
			case "needs_input": ModelPendingInteractiveSideStatusKind.NeedsInput;
			case _: throw "unknown pending interactive side status kind: " + value;
		}
	}

	static function threadSnapshotReplayEventKind(value:String):ModelThreadSnapshotReplayEventKind {
		return switch value {
			case "replay_turns": ModelThreadSnapshotReplayEventKind.ReplayTurns;
			case "buffered_notification": ModelThreadSnapshotReplayEventKind.BufferedNotification;
			case "buffered_request": ModelThreadSnapshotReplayEventKind.BufferedRequest;
			case "history_entry_response": ModelThreadSnapshotReplayEventKind.HistoryEntryResponse;
			case "feedback_submission": ModelThreadSnapshotReplayEventKind.FeedbackSubmission;
			case _: throw "unknown thread snapshot replay event kind: " + value;
		}
	}

	static function threadSnapshotReplayDispatchKind(value:String):ModelThreadSnapshotReplayDispatchKind {
		return switch value {
			case "turns_replayed": ModelThreadSnapshotReplayDispatchKind.TurnsReplayed;
			case "chat_notification": ModelThreadSnapshotReplayDispatchKind.ChatNotification;
			case "chat_request": ModelThreadSnapshotReplayDispatchKind.ChatRequest;
			case "history_entry_response": ModelThreadSnapshotReplayDispatchKind.HistoryEntryResponse;
			case "feedback_submission": ModelThreadSnapshotReplayDispatchKind.FeedbackSubmission;
			case "notice_suppressed": ModelThreadSnapshotReplayDispatchKind.NoticeSuppressed;
			case "request_filtered": ModelThreadSnapshotReplayDispatchKind.RequestFiltered;
			case _: throw "unknown thread snapshot replay dispatch kind: " + value;
		}
	}

	static function replayedServerRequestKind(value:String):ModelReplayedServerRequestKind {
		return switch value {
			case "exec_approval": ModelReplayedServerRequestKind.ExecApproval;
			case "file_change_approval": ModelReplayedServerRequestKind.FileChangeApproval;
			case "mcp_elicitation": ModelReplayedServerRequestKind.McpElicitation;
			case "permissions_approval": ModelReplayedServerRequestKind.PermissionsApproval;
			case "user_input": ModelReplayedServerRequestKind.UserInput;
			case "dynamic_tool_call": ModelReplayedServerRequestKind.DynamicToolCall;
			case "attestation_generate": ModelReplayedServerRequestKind.AttestationGenerate;
			case "chatgpt_auth_tokens_refresh": ModelReplayedServerRequestKind.ChatgptAuthTokensRefresh;
			case "legacy_apply_patch_approval": ModelReplayedServerRequestKind.LegacyApplyPatchApproval;
			case "legacy_exec_command_approval": ModelReplayedServerRequestKind.LegacyExecCommandApproval;
			case _: throw "unknown replayed server request kind: " + value;
		}
	}

	static function replayedServerRequestSurfaceKind(value:String):ModelReplayedServerRequestSurfaceKind {
		return switch value {
			case "exec_approval_prompt": ModelReplayedServerRequestSurfaceKind.ExecApprovalPrompt;
			case "file_change_approval_prompt": ModelReplayedServerRequestSurfaceKind.FileChangeApprovalPrompt;
			case "mcp_elicitation_prompt": ModelReplayedServerRequestSurfaceKind.McpElicitationPrompt;
			case "permissions_prompt": ModelReplayedServerRequestSurfaceKind.PermissionsPrompt;
			case "user_input_prompt": ModelReplayedServerRequestSurfaceKind.UserInputPrompt;
			case "unsupported_stub_error": ModelReplayedServerRequestSurfaceKind.UnsupportedStubError;
			case "unsupported_replay_suppressed": ModelReplayedServerRequestSurfaceKind.UnsupportedReplaySuppressed;
			case "request_filtered": ModelReplayedServerRequestSurfaceKind.RequestFiltered;
			case _: throw "unknown replayed server request surface kind: " + value;
		}
	}

	static function appServerRequestResolutionCommandKind(value:String):ModelAppServerRequestResolutionCommandKind {
		return switch value {
			case "exec_approval_response": ModelAppServerRequestResolutionCommandKind.ExecApprovalResponse;
			case "file_change_approval_response": ModelAppServerRequestResolutionCommandKind.FileChangeApprovalResponse;
			case "permissions_response": ModelAppServerRequestResolutionCommandKind.PermissionsResponse;
			case "user_input_answer": ModelAppServerRequestResolutionCommandKind.UserInputAnswer;
			case "mcp_elicitation_response": ModelAppServerRequestResolutionCommandKind.McpElicitationResponse;
			case "server_request_resolved_notification": ModelAppServerRequestResolutionCommandKind.ServerRequestResolvedNotification;
			case _: throw "unknown app-server request resolution command kind: " + value;
		}
	}

	static function appServerRequestResolutionPayloadKind(value:String):ModelAppServerRequestResolutionPayloadKind {
		return switch value {
			case "none": ModelAppServerRequestResolutionPayloadKind.None;
			case "command_execution_approval_response": ModelAppServerRequestResolutionPayloadKind.CommandExecutionApprovalResponse;
			case "file_change_approval_response": ModelAppServerRequestResolutionPayloadKind.FileChangeApprovalResponse;
			case "permissions_approval_response": ModelAppServerRequestResolutionPayloadKind.PermissionsApprovalResponse;
			case "tool_request_user_input_response": ModelAppServerRequestResolutionPayloadKind.ToolRequestUserInputResponse;
			case "mcp_elicitation_response": ModelAppServerRequestResolutionPayloadKind.McpElicitationResponse;
			case _: throw "unknown app-server request resolution payload kind: " + value;
		}
	}

	static function appServerResponseDispatchKind(value:String):ModelAppServerResponseDispatchKind {
		return switch value {
			case "resolve_response": ModelAppServerResponseDispatchKind.ResolveResponse;
			case "reject_unsupported": ModelAppServerResponseDispatchKind.RejectUnsupported;
			case "serialization_refusal": ModelAppServerResponseDispatchKind.SerializationRefusal;
			case "missing_session_noop": ModelAppServerResponseDispatchKind.MissingSessionNoop;
			case _: throw "unknown app-server response dispatch kind: " + value;
		}
	}

	static function appServerRequestEnqueueRouteKind(value:String):ModelAppServerRequestEnqueueRouteKind {
		return switch value {
			case "primary_pending_queue": ModelAppServerRequestEnqueueRouteKind.PrimaryPendingQueue;
			case "primary_thread_queue": ModelAppServerRequestEnqueueRouteKind.PrimaryThreadQueue;
			case "background_thread_queue": ModelAppServerRequestEnqueueRouteKind.BackgroundThreadQueue;
			case "threadless_ignored": ModelAppServerRequestEnqueueRouteKind.ThreadlessIgnored;
			case "unsupported_rejected_skip": ModelAppServerRequestEnqueueRouteKind.UnsupportedRejectedSkip;
			case "enqueue_failure": ModelAppServerRequestEnqueueRouteKind.EnqueueFailure;
			case _: throw "unknown app-server request enqueue route kind: " + value;
		}
	}

	static function appServerQueuedRequestDeliveryKind(value:String):ModelAppServerQueuedRequestDeliveryKind {
		return switch value {
			case "active_thread_delivered": ModelAppServerQueuedRequestDeliveryKind.ActiveThreadDelivered;
			case "background_buffered_delivered": ModelAppServerQueuedRequestDeliveryKind.BackgroundBufferedDelivered;
			case "pending_primary_deferred": ModelAppServerQueuedRequestDeliveryKind.PendingPrimaryDeferred;
			case "non_pending_skipped": ModelAppServerQueuedRequestDeliveryKind.NonPendingSkipped;
			case "replay_delivered": ModelAppServerQueuedRequestDeliveryKind.ReplayDelivered;
			case "not_queued_skipped": ModelAppServerQueuedRequestDeliveryKind.NotQueuedSkipped;
			case _: throw "unknown app-server queued request delivery kind: " + value;
		}
	}

	static function threadBufferedEventKind(value:String):ModelThreadBufferedEventKind {
		return switch value {
			case "request": ModelThreadBufferedEventKind.Request;
			case "notification": ModelThreadBufferedEventKind.Notification;
			case "history_entry_response": ModelThreadBufferedEventKind.HistoryEntryResponse;
			case "feedback_submission": ModelThreadBufferedEventKind.FeedbackSubmission;
			case _: throw "unknown thread buffered event kind: " + value;
		}
	}

	static function threadBufferedRequestEvictionKind(value:String):ModelThreadBufferedRequestEvictionKind {
		return switch value {
			case "buffered_request_retained": ModelThreadBufferedRequestEvictionKind.BufferedRequestRetained;
			case "pending_prompt_removed": ModelThreadBufferedRequestEvictionKind.PendingPromptRemoved;
			case "replay_skipped_after_eviction": ModelThreadBufferedRequestEvictionKind.ReplaySkippedAfterEviction;
			case "non_request_eviction_ignored": ModelThreadBufferedRequestEvictionKind.NonRequestEvictionIgnored;
			case "invalid_capacity_refused": ModelThreadBufferedRequestEvictionKind.InvalidCapacityRefused;
			case _: throw "unknown thread buffered request eviction kind: " + value;
		}
	}

	static function threadSessionRebaseEventKind(value:String):ModelThreadSessionRebaseEventKind {
		return switch value {
			case "request": ModelThreadSessionRebaseEventKind.Request;
			case "hook_started_notification": ModelThreadSessionRebaseEventKind.HookStartedNotification;
			case "hook_completed_notification": ModelThreadSessionRebaseEventKind.HookCompletedNotification;
			case "mcp_server_status_updated_notification": ModelThreadSessionRebaseEventKind.McpServerStatusUpdatedNotification;
			case "feedback_submission": ModelThreadSessionRebaseEventKind.FeedbackSubmission;
			case "ordinary_notification": ModelThreadSessionRebaseEventKind.OrdinaryNotification;
			case "history_entry_response": ModelThreadSessionRebaseEventKind.HistoryEntryResponse;
			case _: throw "unknown thread session rebase event kind: " + value;
		}
	}

	static function threadSessionRebaseKind(value:String):ModelThreadSessionRebaseKind {
		return switch value {
			case "survived_request": ModelThreadSessionRebaseKind.SurvivedRequest;
			case "survived_hook_notification": ModelThreadSessionRebaseKind.SurvivedHookNotification;
			case "survived_mcp_status_notification": ModelThreadSessionRebaseKind.SurvivedMcpStatusNotification;
			case "survived_feedback_submission": ModelThreadSessionRebaseKind.SurvivedFeedbackSubmission;
			case "dropped_ordinary_notification": ModelThreadSessionRebaseKind.DroppedOrdinaryNotification;
			case "dropped_history_entry_response": ModelThreadSessionRebaseKind.DroppedHistoryEntryResponse;
			case "filtered_resolved_request": ModelThreadSessionRebaseKind.FilteredResolvedRequest;
			case _: throw "unknown thread session rebase kind: " + value;
		}
	}

	static function threadActiveTurnEventKind(value:String):ModelThreadActiveTurnEventKind {
		return switch value {
			case "turns_restored": ModelThreadActiveTurnEventKind.TurnsRestored;
			case "turn_started": ModelThreadActiveTurnEventKind.TurnStarted;
			case "turn_completed": ModelThreadActiveTurnEventKind.TurnCompleted;
			case "thread_closed": ModelThreadActiveTurnEventKind.ThreadClosed;
			case "clear_active_turn": ModelThreadActiveTurnEventKind.ClearActiveTurn;
			case _: throw "unknown thread active-turn event kind: " + value;
		}
	}

	static function threadActiveTurnDecisionKind(value:String):ModelThreadActiveTurnDecisionKind {
		return switch value {
			case "restored_latest_in_progress": ModelThreadActiveTurnDecisionKind.RestoredLatestInProgress;
			case "set_from_turn_started": ModelThreadActiveTurnDecisionKind.SetFromTurnStarted;
			case "preserved_nonmatching_completion": ModelThreadActiveTurnDecisionKind.PreservedNonmatchingCompletion;
			case "cleared_matching_completion": ModelThreadActiveTurnDecisionKind.ClearedMatchingCompletion;
			case "cleared_thread_closed": ModelThreadActiveTurnDecisionKind.ClearedThreadClosed;
			case "cleared_explicit": ModelThreadActiveTurnDecisionKind.ClearedExplicit;
			case "unchanged_no_active_turn": ModelThreadActiveTurnDecisionKind.UnchangedNoActiveTurn;
			case _: throw "unknown thread active-turn decision kind: " + value;
		}
	}

	static function threadSideParentPendingEventKind(value:String):ModelThreadSideParentPendingEventKind {
		return switch value {
			case "request_queued": ModelThreadSideParentPendingEventKind.RequestQueued;
			case "server_request_resolved": ModelThreadSideParentPendingEventKind.ServerRequestResolved;
			case "request_evicted": ModelThreadSideParentPendingEventKind.RequestEvicted;
			case "thread_closed": ModelThreadSideParentPendingEventKind.ThreadClosed;
			case "status_refresh": ModelThreadSideParentPendingEventKind.StatusRefresh;
			case _: throw "unknown thread side-parent pending event kind: " + value;
		}
	}

	static function threadSideParentPendingDecisionKind(value:String):ModelThreadSideParentPendingDecisionKind {
		return switch value {
			case "set_needs_input": ModelThreadSideParentPendingDecisionKind.SetNeedsInput;
			case "set_needs_approval": ModelThreadSideParentPendingDecisionKind.SetNeedsApproval;
			case "cleared_no_pending": ModelThreadSideParentPendingDecisionKind.ClearedNoPending;
			case "used_request_status_fallback": ModelThreadSideParentPendingDecisionKind.UsedRequestStatusFallback;
			case "preserved_no_pending": ModelThreadSideParentPendingDecisionKind.PreservedNoPending;
			case _: throw "unknown thread side-parent pending decision kind: " + value;
		}
	}

	static function threadSideParentStatusKind(value:String):ModelThreadSideParentStatusKind {
		return switch value {
			case "none": ModelThreadSideParentStatusKind.None;
			case "needs_input": ModelThreadSideParentStatusKind.NeedsInput;
			case "needs_approval": ModelThreadSideParentStatusKind.NeedsApproval;
			case "finished": ModelThreadSideParentStatusKind.Finished;
			case "interrupted": ModelThreadSideParentStatusKind.Interrupted;
			case "failed": ModelThreadSideParentStatusKind.Failed;
			case "closed": ModelThreadSideParentStatusKind.Closed;
			case _: throw "unknown thread side-parent status kind: " + value;
		}
	}

	static function threadSideParentStatusChangeEventKind(value:String):ModelThreadSideParentStatusChangeEventKind {
		return switch value {
			case "turn_started": ModelThreadSideParentStatusChangeEventKind.TurnStarted;
			case "turn_completed": ModelThreadSideParentStatusChangeEventKind.TurnCompleted;
			case "thread_closed": ModelThreadSideParentStatusChangeEventKind.ThreadClosed;
			case "item_started": ModelThreadSideParentStatusChangeEventKind.ItemStarted;
			case "server_request_resolved": ModelThreadSideParentStatusChangeEventKind.ServerRequestResolved;
			case "other_notification": ModelThreadSideParentStatusChangeEventKind.OtherNotification;
			case _: throw "unknown thread side-parent status-change event kind: " + value;
		}
	}

	static function threadSideParentTurnStatusKind(value:String):ModelThreadSideParentTurnStatusKind {
		return switch value {
			case "none": ModelThreadSideParentTurnStatusKind.None;
			case "completed": ModelThreadSideParentTurnStatusKind.Completed;
			case "interrupted": ModelThreadSideParentTurnStatusKind.Interrupted;
			case "failed": ModelThreadSideParentTurnStatusKind.Failed;
			case "in_progress": ModelThreadSideParentTurnStatusKind.InProgress;
			case _: throw "unknown thread side-parent turn status kind: " + value;
		}
	}

	static function threadSideParentStatusChangeDecisionKind(value:String):ModelThreadSideParentStatusChangeDecisionKind {
		return switch value {
			case "pending_status_precedence": ModelThreadSideParentStatusChangeDecisionKind.PendingStatusPrecedence;
			case "cleared_turn_started": ModelThreadSideParentStatusChangeDecisionKind.ClearedTurnStarted;
			case "set_finished": ModelThreadSideParentStatusChangeDecisionKind.SetFinished;
			case "set_interrupted": ModelThreadSideParentStatusChangeDecisionKind.SetInterrupted;
			case "set_failed": ModelThreadSideParentStatusChangeDecisionKind.SetFailed;
			case "set_closed": ModelThreadSideParentStatusChangeDecisionKind.SetClosed;
			case "cleared_actionable": ModelThreadSideParentStatusChangeDecisionKind.ClearedActionable;
			case "preserved_terminal": ModelThreadSideParentStatusChangeDecisionKind.PreservedTerminal;
			case "preserved_no_change": ModelThreadSideParentStatusChangeDecisionKind.PreservedNoChange;
			case "ignored_in_progress_turn": ModelThreadSideParentStatusChangeDecisionKind.IgnoredInProgressTurn;
			case _: throw "unknown thread side-parent status-change decision kind: " + value;
		}
	}

	static function threadSideThreadUiSyncDecisionKind(value:String):ModelThreadSideThreadUiSyncDecisionKind {
		return switch value {
			case "cleared_no_active_thread": ModelThreadSideThreadUiSyncDecisionKind.ClearedNoActiveThread;
			case "cleared_no_side_thread": ModelThreadSideThreadUiSyncDecisionKind.ClearedNoSideThread;
			case "synced_changed_status": ModelThreadSideThreadUiSyncDecisionKind.SyncedChangedStatus;
			case "skipped_same_status": ModelThreadSideThreadUiSyncDecisionKind.SkippedSameStatus;
			case _: throw "unknown thread side-thread UI sync decision kind: " + value;
		}
	}

	static function threadSideThreadDiscardDecisionKind(value:String):ModelThreadSideThreadDiscardDecisionKind {
		return switch value {
			case "returned_from_side": ModelThreadSideThreadDiscardDecisionKind.ReturnedFromSide;
			case "return_blocked": ModelThreadSideThreadDiscardDecisionKind.ReturnBlocked;
			case "return_selection_failed": ModelThreadSideThreadDiscardDecisionKind.ReturnSelectionFailed;
			case "no_discard_same_target": ModelThreadSideThreadDiscardDecisionKind.NoDiscardSameTarget;
			case "no_discard_no_side_thread": ModelThreadSideThreadDiscardDecisionKind.NoDiscardNoSideThread;
			case "discarded_active_turn": ModelThreadSideThreadDiscardDecisionKind.DiscardedActiveTurn;
			case "discarded_startup": ModelThreadSideThreadDiscardDecisionKind.DiscardedStartup;
			case "discard_failed_interrupt": ModelThreadSideThreadDiscardDecisionKind.DiscardFailedInterrupt;
			case "discard_failed_unsubscribe": ModelThreadSideThreadDiscardDecisionKind.DiscardFailedUnsubscribe;
			case "discarded_closed_local_state": ModelThreadSideThreadDiscardDecisionKind.DiscardedClosedLocalState;
			case _: throw "unknown thread side-thread discard decision kind: " + value;
		}
	}

	static function threadSideThreadInterruptKind(value:String):ModelThreadSideThreadInterruptKind {
		return switch value {
			case "none": ModelThreadSideThreadInterruptKind.None;
			case "turn_interrupt": ModelThreadSideThreadInterruptKind.TurnInterrupt;
			case "startup_interrupt": ModelThreadSideThreadInterruptKind.StartupInterrupt;
			case _: throw "unknown thread side-thread interrupt kind: " + value;
		}
	}

	static function threadSideThreadStartDecisionKind(value:String):ModelThreadSideThreadStartDecisionKind {
		return switch value {
			case "start_blocked_main_unavailable": ModelThreadSideThreadStartDecisionKind.StartBlockedMainUnavailable;
			case "start_blocked_side_open": ModelThreadSideThreadStartDecisionKind.StartBlockedSideOpen;
			case "fork_failed_no_started_conversation": ModelThreadSideThreadStartDecisionKind.ForkFailedNoStartedConversation;
			case "fork_failed_generic": ModelThreadSideThreadStartDecisionKind.ForkFailedGeneric;
			case "inject_failed_cleanup": ModelThreadSideThreadStartDecisionKind.InjectFailedCleanup;
			case "switch_failed_cleanup": ModelThreadSideThreadStartDecisionKind.SwitchFailedCleanup;
			case "switched_and_submitted_user_message": ModelThreadSideThreadStartDecisionKind.SwitchedAndSubmittedUserMessage;
			case "switched_without_user_message": ModelThreadSideThreadStartDecisionKind.SwitchedWithoutUserMessage;
			case "switched_inactive_cleanup": ModelThreadSideThreadStartDecisionKind.SwitchedInactiveCleanup;
			case _: throw "unknown thread side-thread start decision kind: " + value;
		}
	}

	static function threadSideThreadStartFailureKind(value:String):ModelThreadSideThreadStartFailureKind {
		return switch value {
			case "none": ModelThreadSideThreadStartFailureKind.None;
			case "main_thread_unavailable": ModelThreadSideThreadStartFailureKind.MainThreadUnavailable;
			case "side_already_open": ModelThreadSideThreadStartFailureKind.SideAlreadyOpen;
			case "fork_no_started_conversation": ModelThreadSideThreadStartFailureKind.ForkNoStartedConversation;
			case "fork_generic": ModelThreadSideThreadStartFailureKind.ForkGeneric;
			case "inject_boundary": ModelThreadSideThreadStartFailureKind.InjectBoundary;
			case "switch_failed": ModelThreadSideThreadStartFailureKind.SwitchFailed;
			case "active_child_missing": ModelThreadSideThreadStartFailureKind.ActiveChildMissing;
			case _: throw "unknown thread side-thread start failure kind: " + value;
		}
	}

	static function threadSideThreadStartupEventKind(value:String):ModelThreadSideThreadStartupEventKind {
		return switch value {
			case "starting": ModelThreadSideThreadStartupEventKind.Starting;
			case "failed": ModelThreadSideThreadStartupEventKind.Failed;
			case "ready": ModelThreadSideThreadStartupEventKind.Ready;
			case _: throw "unknown thread side-thread startup event kind: " + value;
		}
	}

	static function threadSideThreadStartupRoutingDecisionKind(value:String):ModelThreadSideThreadStartupRoutingDecisionKind {
		return switch value {
			case "buffered_for_child_thread": ModelThreadSideThreadStartupRoutingDecisionKind.BufferedForChildThread;
			case "app_scoped_ignored": ModelThreadSideThreadStartupRoutingDecisionKind.AppScopedIgnored;
			case "rendered_active_side_thread": ModelThreadSideThreadStartupRoutingDecisionKind.RenderedActiveSideThread;
			case "replayed_buffered_child_thread": ModelThreadSideThreadStartupRoutingDecisionKind.ReplayedBufferedChildThread;
			case "side_session_configured": ModelThreadSideThreadStartupRoutingDecisionKind.SideSessionConfigured;
			case "misrouted_visible_thread_ignored": ModelThreadSideThreadStartupRoutingDecisionKind.MisroutedVisibleThreadIgnored;
			case _: throw "unknown thread side-thread startup routing decision kind: " + value;
		}
	}

	static function threadSideThreadComposerHandoffDecisionKind(value:String):ModelThreadSideThreadComposerHandoffDecisionKind {
		return switch value {
			case "no_user_message_noop": ModelThreadSideThreadComposerHandoffDecisionKind.NoUserMessageNoop;
			case "restored_after_start_blocked": ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterStartBlocked;
			case "restored_after_fork_failure": ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterForkFailure;
			case "restored_after_prepare_failure": ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterPrepareFailure;
			case "restored_after_switch_failure": ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterSwitchFailure;
			case "restored_after_inactive_child_cleanup": ModelThreadSideThreadComposerHandoffDecisionKind.RestoredAfterInactiveChildCleanup;
			case "submitted_after_switch": ModelThreadSideThreadComposerHandoffDecisionKind.SubmittedAfterSwitch;
			case _: throw "unknown thread side-thread composer handoff decision kind: " + value;
		}
	}

	static function threadSideThreadNavigationCleanupDecisionKind(value:String):ModelThreadSideThreadNavigationCleanupDecisionKind {
		return switch value {
			case "no_discard_same_target": ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardSameTarget;
			case "no_discard_no_visible_side_thread": ModelThreadSideThreadNavigationCleanupDecisionKind.NoDiscardNoVisibleSideThread;
			case "discarded_server_closed": ModelThreadSideThreadNavigationCleanupDecisionKind.DiscardedServerClosed;
			case "kept_local_state_interrupt_failed": ModelThreadSideThreadNavigationCleanupDecisionKind.KeptLocalStateInterruptFailed;
			case "kept_local_state_unsubscribe_failed": ModelThreadSideThreadNavigationCleanupDecisionKind.KeptLocalStateUnsubscribeFailed;
			case "discarded_closed_local_state_only": ModelThreadSideThreadNavigationCleanupDecisionKind.DiscardedClosedLocalStateOnly;
			case "selected_parent_and_discarded": ModelThreadSideThreadNavigationCleanupDecisionKind.SelectedParentAndDiscarded;
			case "selected_parent_cleanup_failed_kept_visible": ModelThreadSideThreadNavigationCleanupDecisionKind.SelectedParentCleanupFailedKeptVisible;
			case _: throw "unknown thread side-thread navigation cleanup decision kind: " + value;
		}
	}

	static function activeNonPrimaryShutdownEventKind(value:String):ModelActiveNonPrimaryShutdownEventKind {
		return switch value {
			case "other": ModelActiveNonPrimaryShutdownEventKind.Other;
			case "thread_closed": ModelActiveNonPrimaryShutdownEventKind.ThreadClosed;
			case _: throw "unknown active non-primary shutdown event kind: " + value;
		}
	}

	static function activeNonPrimaryShutdownDecisionKind(value:String):ModelActiveNonPrimaryShutdownDecisionKind {
		return switch value {
			case "ignored_non_shutdown_event": ModelActiveNonPrimaryShutdownDecisionKind.IgnoredNonShutdownEvent;
			case "ignored_missing_thread_ids": ModelActiveNonPrimaryShutdownDecisionKind.IgnoredMissingThreadIds;
			case "ignored_primary_thread_shutdown": ModelActiveNonPrimaryShutdownDecisionKind.IgnoredPrimaryThreadShutdown;
			case "ignored_pending_shutdown_exit": ModelActiveNonPrimaryShutdownDecisionKind.IgnoredPendingShutdownExit;
			case "switched_to_primary": ModelActiveNonPrimaryShutdownDecisionKind.SwitchedToPrimary;
			case "switched_to_primary_with_other_pending_exit": ModelActiveNonPrimaryShutdownDecisionKind.SwitchedToPrimaryWithOtherPendingExit;
			case _: throw "unknown active non-primary shutdown decision kind: " + value;
		}
	}

	static function clearUiHeaderRequestKind(value:String):ModelClearUiHeaderRequestKind {
		return switch value {
			case "slash_clear": ModelClearUiHeaderRequestKind.SlashClear;
			case "ctrl_l": ModelClearUiHeaderRequestKind.CtrlL;
			case _: throw "unknown clear UI header request kind: " + value;
		}
	}

	static function clearUiHeaderDecisionKind(value:String):ModelClearUiHeaderDecisionKind {
		return switch value {
			case "rendered_fresh_header": ModelClearUiHeaderDecisionKind.RenderedFreshHeader;
			case "reused_clear_header_for_ctrl_l": ModelClearUiHeaderDecisionKind.ReusedClearHeaderForCtrlL;
			case "rendered_fast_status_header": ModelClearUiHeaderDecisionKind.RenderedFastStatusHeader;
			case "skipped_no_redraw": ModelClearUiHeaderDecisionKind.SkippedNoRedraw;
			case _: throw "unknown clear UI header decision kind: " + value;
		}
	}

	static function terminalResizeReflowRequestKind(value:String):ModelTerminalResizeReflowRequestKind {
		return switch value {
			case "render_transcript": ModelTerminalResizeReflowRequestKind.RenderTranscript;
			case "initial_replay_buffer": ModelTerminalResizeReflowRequestKind.InitialReplayBuffer;
			case "thread_switch_replay_buffer": ModelTerminalResizeReflowRequestKind.ThreadSwitchReplayBuffer;
			case _: throw "unknown terminal resize reflow request kind: " + value;
		}
	}

	static function terminalResizeReflowMaxRowsKind(value:String):ModelTerminalResizeReflowMaxRowsKind {
		return switch value {
			case "limit": ModelTerminalResizeReflowMaxRowsKind.Limit;
			case "disabled": ModelTerminalResizeReflowMaxRowsKind.Disabled;
			case _: throw "unknown terminal resize reflow max rows kind: " + value;
		}
	}

	static function terminalResizeReflowDecisionKind(value:String):ModelTerminalResizeReflowDecisionKind {
		return switch value {
			case "capped_recent_suffix": ModelTerminalResizeReflowDecisionKind.CappedRecentSuffix;
			case "uncapped_all_cells": ModelTerminalResizeReflowDecisionKind.UncappedAllCells;
			case "pet_wrapped_earlier": ModelTerminalResizeReflowDecisionKind.PetWrappedEarlier;
			case "under_limit_all_cells": ModelTerminalResizeReflowDecisionKind.UnderLimitAllCells;
			case "initial_replay_buffer_tail": ModelTerminalResizeReflowDecisionKind.InitialReplayBufferTail;
			case "thread_switch_tail_mode": ModelTerminalResizeReflowDecisionKind.ThreadSwitchTailMode;
			case "thread_switch_buffer_disabled": ModelTerminalResizeReflowDecisionKind.ThreadSwitchBufferDisabled;
			case _: throw "unknown terminal resize reflow decision kind: " + value;
		}
	}

	static function resizeReflowSchedulingDecisionKind(value:String):ModelResizeReflowSchedulingDecisionKind {
		return switch value {
			case "unchanged_size_no_op": ModelResizeReflowSchedulingDecisionKind.UnchangedSizeNoOp;
			case "height_change_scheduled": ModelResizeReflowSchedulingDecisionKind.HeightChangeScheduled;
			case "width_change_scheduled": ModelResizeReflowSchedulingDecisionKind.WidthChangeScheduled;
			case "disabled_width_change_cleared": ModelResizeReflowSchedulingDecisionKind.DisabledWidthChangeCleared;
			case _: throw "unknown resize reflow scheduling decision kind: " + value;
		}
	}

	static function feedbackSubmissionRequestKind(value:String):ModelFeedbackSubmissionRequestKind {
		return switch value {
			case "submitted": ModelFeedbackSubmissionRequestKind.Submitted;
			case "snapshot_replay": ModelFeedbackSubmissionRequestKind.SnapshotReplay;
			case _: throw "unknown feedback submission request kind: " + value;
		}
	}

	static function feedbackSubmissionCategory(value:String):ModelFeedbackSubmissionCategory {
		return switch value {
			case "bug": ModelFeedbackSubmissionCategory.Bug;
			case "bad_result": ModelFeedbackSubmissionCategory.BadResult;
			case "good_result": ModelFeedbackSubmissionCategory.GoodResult;
			case "safety_check": ModelFeedbackSubmissionCategory.SafetyCheck;
			case "other": ModelFeedbackSubmissionCategory.Other;
			case _: throw "unknown feedback submission category: " + value;
		}
	}

	static function feedbackSubmissionDecisionKind(value:String):ModelFeedbackSubmissionDecisionKind {
		return switch value {
			case "current_history_rendered": ModelFeedbackSubmissionDecisionKind.CurrentHistoryRendered;
			case "origin_thread_buffered": ModelFeedbackSubmissionDecisionKind.OriginThreadBuffered;
			case "active_origin_thread_delivered": ModelFeedbackSubmissionDecisionKind.ActiveOriginThreadDelivered;
			case "snapshot_replay_rendered": ModelFeedbackSubmissionDecisionKind.SnapshotReplayRendered;
			case _: throw "unknown feedback submission decision kind: " + value;
		}
	}

	static function feedbackSubmissionHistoryCellKind(value:String):ModelFeedbackSubmissionHistoryCellKind {
		return switch value {
			case "none": ModelFeedbackSubmissionHistoryCellKind.None;
			case "success": ModelFeedbackSubmissionHistoryCellKind.Success;
			case "error": ModelFeedbackSubmissionHistoryCellKind.Error;
			case _: throw "unknown feedback submission history cell kind: " + value;
		}
	}

	static function tuiActiveTurnErrorRequestKind(value:String):ModelTuiActiveTurnErrorRequestKind {
		return switch value {
			case "active_turn_not_steerable": ModelTuiActiveTurnErrorRequestKind.ActiveTurnNotSteerable;
			case "steer_race": ModelTuiActiveTurnErrorRequestKind.SteerRace;
			case "interrupt_race": ModelTuiActiveTurnErrorRequestKind.InterruptRace;
			case "session_start": ModelTuiActiveTurnErrorRequestKind.SessionStart;
			case _: throw "unknown TUI active-turn error request kind: " + value;
		}
	}

	static function tuiActiveTurnErrorDecisionKind(value:String):ModelTuiActiveTurnErrorDecisionKind {
		return switch value {
			case "structured_not_steerable": ModelTuiActiveTurnErrorDecisionKind.StructuredNotSteerable;
			case "steer_missing_active_turn": ModelTuiActiveTurnErrorDecisionKind.SteerMissingActiveTurn;
			case "steer_expected_turn_mismatch": ModelTuiActiveTurnErrorDecisionKind.SteerExpectedTurnMismatch;
			case "interrupt_expected_turn_mismatch": ModelTuiActiveTurnErrorDecisionKind.InterruptExpectedTurnMismatch;
			case "archived_session_guidance": ModelTuiActiveTurnErrorDecisionKind.ArchivedSessionGuidance;
			case "no_match": ModelTuiActiveTurnErrorDecisionKind.NoMatch;
			case _: throw "unknown TUI active-turn error decision kind: " + value;
		}
	}

	static function tuiActiveTurnErrorTurnKind(value:String):ModelTuiActiveTurnErrorTurnKind {
		return switch value {
			case "none": ModelTuiActiveTurnErrorTurnKind.None;
			case "review": ModelTuiActiveTurnErrorTurnKind.Review;
			case "other": ModelTuiActiveTurnErrorTurnKind.Other;
			case _: throw "unknown TUI active-turn error turn kind: " + value;
		}
	}

	static function freshSessionServiceTierDecisionKind(value:String):ModelFreshSessionServiceTierDecisionKind {
		return switch value {
			case "configured_service_tier_propagated": ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierPropagated;
			case "configured_service_tier_cleared": ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierCleared;
			case _: throw "unknown fresh-session service-tier decision kind: " + value;
		}
	}

	static function freshSessionServiceTierValue(value:String):ModelFreshSessionServiceTierValue {
		return switch value {
			case "": ModelFreshSessionServiceTierValue.None;
			case "priority": ModelFreshSessionServiceTierValue.Priority;
			case "flex": ModelFreshSessionServiceTierValue.Flex;
			case "default": ModelFreshSessionServiceTierValue.Default;
			case _: throw "unknown fresh-session service-tier value: " + value;
		}
	}

	static function freshSessionPreviousConversationShutdownDecisionKind(value:String):ModelFreshSessionPreviousConversationShutdownDecisionKind {
		return switch value {
			case "previous_conversation_shutdown_requested": ModelFreshSessionPreviousConversationShutdownDecisionKind.PreviousConversationShutdownRequested;
			case "no_previous_conversation_noop": ModelFreshSessionPreviousConversationShutdownDecisionKind.NoPreviousConversationNoop;
			case "previous_conversation_unsubscribe_failed": ModelFreshSessionPreviousConversationShutdownDecisionKind.PreviousConversationUnsubscribeFailed;
			case _: throw "unknown fresh-session previous-conversation shutdown decision kind: " + value;
		}
	}

	static function interruptWithoutActiveTurnDecisionKind(value:String):ModelInterruptWithoutActiveTurnDecisionKind {
		return switch value {
			case "startup_interrupt_submitted": ModelInterruptWithoutActiveTurnDecisionKind.StartupInterruptSubmitted;
			case "active_turn_interrupt_submitted": ModelInterruptWithoutActiveTurnDecisionKind.ActiveTurnInterruptSubmitted;
			case "interrupt_not_handled": ModelInterruptWithoutActiveTurnDecisionKind.InterruptNotHandled;
			case _: throw "unknown interrupt without active turn decision kind: " + value;
		}
	}

	static function overrideTurnContextSettingsUpdateDecisionKind(value:String):ModelOverrideTurnContextSettingsUpdateDecisionKind {
		return switch value {
			case "thread_settings_update_submitted": ModelOverrideTurnContextSettingsUpdateDecisionKind.ThreadSettingsUpdateSubmitted;
			case "no_settings_changes_noop": ModelOverrideTurnContextSettingsUpdateDecisionKind.NoSettingsChangesNoop;
			case "override_turn_context_not_handled": ModelOverrideTurnContextSettingsUpdateDecisionKind.OverrideTurnContextNotHandled;
			case _: throw "unknown override-turn-context settings update decision kind: " + value;
		}
	}

	static function inactiveThreadSettingsNotificationDecisionKind(value:String):ModelInactiveThreadSettingsNotificationDecisionKind {
		return switch value {
			case "inactive_thread_settings_notification_cached": ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationCached;
			case "inactive_thread_settings_notification_ignored": ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationIgnored;
			case "inactive_thread_settings_notification_unavailable": ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationUnavailable;
			case _: throw "unknown inactive-thread settings notification decision kind: " + value;
		}
	}

	static function clearOnlyUiResetDecisionKind(value:String):ModelClearOnlyUiResetDecisionKind {
		return switch value {
			case "clear_only_ui_reset_applied": ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetApplied;
			case "clear_only_ui_reset_skipped": ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetSkipped;
			case "clear_only_ui_reset_unavailable": ModelClearOnlyUiResetDecisionKind.ClearOnlyUiResetUnavailable;
			case _: throw "unknown clear-only UI reset decision kind: " + value;
		}
	}

	static function clearOnlySkillWarningRerenderDecisionKind(value:String):ModelClearOnlySkillWarningRerenderDecisionKind {
		return switch value {
			case "skill_warning_rerender_enabled": ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningRerenderEnabled;
			case "skill_warning_still_suppressed": ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningStillSuppressed;
			case "skill_warning_unavailable": ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningUnavailable;
			case _: throw "unknown clear-only skill warning rerender decision kind: " + value;
		}
	}

	static function backtrackEscVimInsertGuardDecisionKind(value:String):ModelBacktrackEscVimInsertGuardDecisionKind {
		return switch value {
			case "backtrack_esc_guard_preserved": ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardPreserved;
			case "vim_insert_esc_stolen": ModelBacktrackEscVimInsertGuardDecisionKind.VimInsertEscStolen;
			case "backtrack_esc_guard_unavailable": ModelBacktrackEscVimInsertGuardDecisionKind.BacktrackEscGuardUnavailable;
			case _: throw "unknown backtrack Esc Vim-insert guard decision kind: " + value;
		}
	}

	static function sideConversationBacktrackEscVimGuardDecisionKind(value:String):ModelSideConversationBacktrackEscVimGuardDecisionKind {
		return switch value {
			case "side_backtrack_rejection_guard_preserved": ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionGuardPreserved;
			case "vim_insert_esc_takes_precedence": ModelSideConversationBacktrackEscVimGuardDecisionKind.VimInsertEscTakesPrecedence;
			case "side_backtrack_rejection_unavailable": ModelSideConversationBacktrackEscVimGuardDecisionKind.SideBacktrackRejectionUnavailable;
			case _: throw "unknown side-conversation backtrack Esc Vim guard decision kind: " + value;
		}
	}

	static function sideBacktrackUnavailableMessageDecisionKind(value:String):ModelSideBacktrackUnavailableMessageDecisionKind {
		return switch value {
			case "side_backtrack_unavailable_message_inserted": ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageInserted;
			case "side_backtrack_unavailable_message_unavailable": ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageUnavailable;
			case _: throw "unknown side-backtrack unavailable message decision kind: " + value;
		}
	}

	static function interruptBacktrackKeymapDecisionKind(value:String):ModelInterruptBacktrackKeymapDecisionKind {
		return switch value {
			case "interrupt_backtrack_keymap_accepted": ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapAccepted;
			case "interrupt_backtrack_keymap_rejected": ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapRejected;
			case _: throw "unknown interrupt/backtrack keymap decision kind: " + value;
		}
	}

	static function interruptBacktrackFixedShortcutActionKind(value:String):ModelInterruptBacktrackFixedShortcutActionKind {
		return ModelInterruptBacktrackFixedShortcutActionKind.fromString(value);
	}

	static function interruptQuestionNavigationKeymapDecisionKind(value:String):ModelInterruptQuestionNavigationKeymapDecisionKind {
		return switch value {
			case "interrupt_question_navigation_conflict_rejected": ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictRejected;
			case "interrupt_question_navigation_conflict_missed": ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictMissed;
			case _: throw "unknown interrupt/question-navigation keymap decision kind: " + value;
		}
	}

	static function pagerTranscriptBacktrackKeymapDecisionKind(value:String):ModelPagerTranscriptBacktrackKeymapDecisionKind {
		return switch value {
			case "pager_transcript_backtrack_conflict_rejected": ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictRejected;
			case "pager_transcript_backtrack_conflict_missed": ModelPagerTranscriptBacktrackKeymapDecisionKind.PagerTranscriptBacktrackConflictMissed;
			case _: throw "unknown pager/transcript-backtrack keymap decision kind: " + value;
		}
	}

	static function keyParserDecisionKind(value:String):ModelKeyParserDecisionKind {
		return switch value {
			case "key_parser_cases_preserved": ModelKeyParserDecisionKind.KeyParserCasesPreserved;
			case "key_parser_cases_rejected": ModelKeyParserDecisionKind.KeyParserCasesRejected;
			case _: throw "unknown key parser decision kind: " + value;
		}
	}

	static function keymapAliasDecisionKind(value:String):ModelKeymapAliasDecisionKind {
		return switch value {
			case "keymap_aliases_preserved": ModelKeymapAliasDecisionKind.KeymapAliasesPreserved;
			case "keymap_aliases_rejected": ModelKeymapAliasDecisionKind.KeymapAliasesRejected;
			case _: throw "unknown keymap alias decision kind: " + value;
		}
	}

	static function keymapShadowDecisionKind(value:String):ModelKeymapShadowDecisionKind {
		return switch value {
			case "keymap_shadow_conflicts_rejected": ModelKeymapShadowDecisionKind.KeymapShadowConflictsRejected;
			case "keymap_shadow_conflicts_missed": ModelKeymapShadowDecisionKind.KeymapShadowConflictsMissed;
			case _: throw "unknown keymap shadow decision kind: " + value;
		}
	}

	static function keymapBindingInputDecisionKind(value:String):ModelKeymapBindingInputDecisionKind {
		return switch value {
			case "keymap_binding_inputs_preserved": ModelKeymapBindingInputDecisionKind.KeymapBindingInputsPreserved;
			case "keymap_binding_inputs_rejected": ModelKeymapBindingInputDecisionKind.KeymapBindingInputsRejected;
			case _: throw "unknown keymap binding input decision kind: " + value;
		}
	}

	static function keymapDefaultPruningDecisionKind(value:String):ModelKeymapDefaultPruningDecisionKind {
		return switch value {
			case "keymap_default_pruning_preserved": ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningPreserved;
			case "keymap_default_pruning_rejected": ModelKeymapDefaultPruningDecisionKind.KeymapDefaultPruningRejected;
			case _: throw "unknown keymap default pruning decision kind: " + value;
		}
	}

	static function keymapDefaultPruningActionKind(value:String):ModelKeymapDefaultPruningActionKind {
		return ModelKeymapDefaultPruningActionKind.fromString(value);
	}

	static function keymapOverlapConflictDecisionKind(value:String):ModelKeymapOverlapConflictDecisionKind {
		return switch value {
			case "keymap_overlap_conflicts_preserved": ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsPreserved;
			case "keymap_overlap_conflicts_rejected": ModelKeymapOverlapConflictDecisionKind.KeymapOverlapConflictsRejected;
			case _: throw "unknown keymap overlap conflict decision kind: " + value;
		}
	}

	static function keymapOverlapConflictActionKind(value:String):ModelKeymapOverlapConflictActionKind {
		return ModelKeymapOverlapConflictActionKind.fromString(value);
	}

	static function keymapVimOperatorTextObjectDecisionKind(value:String):ModelKeymapVimOperatorTextObjectDecisionKind {
		return switch value {
			case "keymap_vim_operator_text_objects_preserved": ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsPreserved;
			case "keymap_vim_operator_text_objects_rejected": ModelKeymapVimOperatorTextObjectDecisionKind.KeymapVimOperatorTextObjectsRejected;
			case _: throw "unknown keymap vim-operator text-object decision kind: " + value;
		}
	}

	static function keymapVimOperatorTextObjectActionKind(value:String):ModelKeymapVimOperatorTextObjectActionKind {
		return ModelKeymapVimOperatorTextObjectActionKind.fromString(value);
	}

	static function keymapVimNormalDefaultsDecisionKind(value:String):ModelKeymapVimNormalDefaultsDecisionKind {
		return switch value {
			case "keymap_vim_normal_defaults_preserved": ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsPreserved;
			case "keymap_vim_normal_defaults_rejected": ModelKeymapVimNormalDefaultsDecisionKind.KeymapVimNormalDefaultsRejected;
			case _: throw "unknown keymap vim-normal defaults decision kind: " + value;
		}
	}

	static function keymapInvalidGlobalCopyDecisionKind(value:String):ModelKeymapInvalidGlobalCopyDecisionKind {
		return switch value {
			case "keymap_invalid_global_copy_path_preserved": ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathPreserved;
			case "keymap_invalid_global_copy_path_rejected": ModelKeymapInvalidGlobalCopyDecisionKind.KeymapInvalidGlobalCopyPathRejected;
			case _: throw "unknown keymap invalid global copy decision kind: " + value;
		}
	}

	static function keymapEditorAssignmentDecisionKind(value:String):ModelKeymapEditorAssignmentDecisionKind {
		return switch value {
			case "keymap_editor_assignment_preserved": ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentPreserved;
			case "keymap_editor_assignment_rejected": ModelKeymapEditorAssignmentDecisionKind.KeymapEditorAssignmentRejected;
			case _: throw "unknown keymap editor assignment decision kind: " + value;
		}
	}

	static function keymapEditorAssignmentActionKind(value:String):ModelKeymapEditorAssignmentActionKind {
		return ModelKeymapEditorAssignmentActionKind.fromString(value);
	}

	static function keymapMainSurfaceAssignmentDecisionKind(value:String):ModelKeymapMainSurfaceAssignmentDecisionKind {
		return switch value {
			case "keymap_main_surface_assignment_preserved": ModelKeymapMainSurfaceAssignmentDecisionKind.KeymapMainSurfaceAssignmentPreserved;
			case "keymap_main_surface_assignment_rejected": ModelKeymapMainSurfaceAssignmentDecisionKind.KeymapMainSurfaceAssignmentRejected;
			case _: throw "unknown keymap main-surface assignment decision kind: " + value;
		}
	}

	static function keymapMainSurfaceAssignmentActionKind(value:String):ModelKeymapMainSurfaceAssignmentActionKind {
		return ModelKeymapMainSurfaceAssignmentActionKind.fromString(value);
	}

	static function keymapMainSurfaceConflictDecisionKind(value:String):ModelKeymapMainSurfaceConflictDecisionKind {
		return switch value {
			case "keymap_main_surface_conflict_rejected": ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictRejected;
			case "keymap_main_surface_conflict_missed": ModelKeymapMainSurfaceConflictDecisionKind.KeymapMainSurfaceConflictMissed;
			case _: throw "unknown keymap main-surface conflict decision kind: " + value;
		}
	}

	static function keymapComposerFixedShortcutConflictDecisionKind(value:String):ModelKeymapComposerFixedShortcutConflictDecisionKind {
		return switch value {
			case "keymap_composer_fixed_shortcut_conflict_rejected": ModelKeymapComposerFixedShortcutConflictDecisionKind.KeymapComposerFixedShortcutConflictRejected;
			case "keymap_composer_fixed_shortcut_conflict_missed": ModelKeymapComposerFixedShortcutConflictDecisionKind.KeymapComposerFixedShortcutConflictMissed;
			case _: throw "unknown keymap composer/fixed-shortcut conflict decision kind: " + value;
		}
	}

	static function keymapComposerFixedShortcutConflictActionKind(value:String):ModelKeymapComposerFixedShortcutConflictActionKind {
		return ModelKeymapComposerFixedShortcutConflictActionKind.fromString(value);
	}

	static function keymapEditorConflictDecisionKind(value:String):ModelKeymapEditorConflictDecisionKind {
		return switch value {
			case "keymap_editor_conflict_rejected": ModelKeymapEditorConflictDecisionKind.KeymapEditorConflictRejected;
			case "keymap_editor_conflict_missed": ModelKeymapEditorConflictDecisionKind.KeymapEditorConflictMissed;
			case _: throw "unknown keymap editor conflict decision kind: " + value;
		}
	}

	static function keymapEditorConflictActionKind(value:String):ModelKeymapEditorConflictActionKind {
		return ModelKeymapEditorConflictActionKind.fromString(value);
	}

	static function keymapEditorUnbindConflictDecisionKind(value:String):ModelKeymapEditorUnbindConflictDecisionKind {
		return switch value {
			case "keymap_editor_unbind_conflict_preserved": ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictPreserved;
			case "keymap_editor_unbind_conflict_rejected": ModelKeymapEditorUnbindConflictDecisionKind.KeymapEditorUnbindConflictRejected;
			case _: throw "unknown keymap editor unbind conflict decision kind: " + value;
		}
	}

	static function keymapEditorUnbindConflictActionKind(value:String):ModelKeymapEditorUnbindConflictActionKind {
		return ModelKeymapEditorUnbindConflictActionKind.fromString(value);
	}

	static function keymapPagerConflictDecisionKind(value:String):ModelKeymapPagerConflictDecisionKind {
		return switch value {
			case "keymap_pager_conflict_rejected": ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictRejected;
			case "keymap_pager_conflict_missed": ModelKeymapPagerConflictDecisionKind.KeymapPagerConflictMissed;
			case _: throw "unknown keymap pager conflict decision kind: " + value;
		}
	}

	static function keymapPagerConflictActionKind(value:String):ModelKeymapPagerConflictActionKind {
		return ModelKeymapPagerConflictActionKind.fromString(value);
	}

	static function keymapListConflictDecisionKind(value:String):ModelKeymapListConflictDecisionKind {
		return switch value {
			case "keymap_list_conflict_rejected": ModelKeymapListConflictDecisionKind.KeymapListConflictRejected;
			case "keymap_list_conflict_missed": ModelKeymapListConflictDecisionKind.KeymapListConflictMissed;
			case _: throw "unknown keymap list conflict decision kind: " + value;
		}
	}

	static function keymapListConflictActionKind(value:String):ModelKeymapListConflictActionKind {
		return ModelKeymapListConflictActionKind.fromString(value);
	}

	static function keymapApprovalConflictDecisionKind(value:String):ModelKeymapApprovalConflictDecisionKind {
		return switch value {
			case "keymap_approval_conflict_rejected": ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictRejected;
			case "keymap_approval_conflict_missed": ModelKeymapApprovalConflictDecisionKind.KeymapApprovalConflictMissed;
			case _: throw "unknown keymap approval conflict decision kind: " + value;
		}
	}

	static function keymapApprovalConflictActionKind(value:String):ModelKeymapApprovalConflictActionKind {
		return ModelKeymapApprovalConflictActionKind.fromString(value);
	}

	static function keymapFixedShortcutDecisionKind(value:String):ModelKeymapFixedShortcutDecisionKind {
		return switch value {
			case "keymap_fixed_shortcut_conflict_preserved": ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictPreserved;
			case "keymap_fixed_shortcut_conflict_rejected": ModelKeymapFixedShortcutDecisionKind.KeymapFixedShortcutConflictRejected;
			case _: throw "unknown keymap fixed shortcut decision kind: " + value;
		}
	}

	static function keymapFixedShortcutActionKind(value:String):ModelKeymapFixedShortcutActionKind {
		return ModelKeymapFixedShortcutActionKind.fromString(value);
	}

	static function parsedKeyKind(value:String):ModelParsedKeyKind {
		return switch value {
			case "function": ModelParsedKeyKind.Function;
			case "named": ModelParsedKeyKind.Named;
			case "character": ModelParsedKeyKind.Character;
			case "invalid": ModelParsedKeyKind.Invalid;
			case _: throw "unknown parsed key kind: " + value;
		}
	}

	static function backtrackSelectionDecisionKind(value:String):ModelBacktrackSelectionDecisionKind {
		return switch value {
			case "edited_duplicate_user_turn_selected": ModelBacktrackSelectionDecisionKind.EditedDuplicateUserTurnSelected;
			case "selection_unavailable": ModelBacktrackSelectionDecisionKind.SelectionUnavailable;
			case _: throw "unknown backtrack selection decision kind: " + value;
		}
	}

	static function backtrackRollbackDecisionKind(value:String):ModelBacktrackRollbackDecisionKind {
		return switch value {
			case "remote_image_only_cleared_composer": ModelBacktrackRollbackDecisionKind.RemoteImageOnlyClearedComposer;
			case "rollback_applied": ModelBacktrackRollbackDecisionKind.RollbackApplied;
			case "rollback_unavailable": ModelBacktrackRollbackDecisionKind.RollbackUnavailable;
			case _: throw "unknown backtrack rollback decision kind: " + value;
		}
	}

	static function cancelledTurnEditDecisionKind(value:String):ModelCancelledTurnEditDecisionKind {
		return switch value {
			case "restored_prompt_with_local_rollback": ModelCancelledTurnEditDecisionKind.RestoredPromptWithLocalRollback;
			case "restored_first_prompt_without_local_history": ModelCancelledTurnEditDecisionKind.RestoredFirstPromptWithoutLocalHistory;
			case "pending_rollback_rejected": ModelCancelledTurnEditDecisionKind.PendingRollbackRejected;
			case _: throw "unknown cancelled-turn edit decision kind: " + value;
		}
	}

	static function backtrackResubmitDecisionKind(value:String):ModelBacktrackResubmitDecisionKind {
		return switch value {
			case "data_image_url_preserved": ModelBacktrackResubmitDecisionKind.DataImageUrlPreserved;
			case "resubmit_blocked": ModelBacktrackResubmitDecisionKind.ResubmitBlocked;
			case _: throw "unknown backtrack resubmit decision kind: " + value;
		}
	}

	static function queuedRollbackOverlaySyncDecisionKind(value:String):ModelQueuedRollbackOverlaySyncDecisionKind {
		return switch value {
			case "rollback_applied": ModelQueuedRollbackOverlaySyncDecisionKind.RollbackApplied;
			case "rollback_unchanged": ModelQueuedRollbackOverlaySyncDecisionKind.RollbackUnchanged;
			case _: throw "unknown queued rollback overlay sync decision kind: " + value;
		}
	}

	static function threadRollbackResponseActiveQueueFlushDecisionKind(value:String):ModelThreadRollbackResponseActiveQueueFlushDecisionKind {
		return switch value {
			case "active_queue_flushed": ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueFlushed;
			case "active_queue_unchanged": ModelThreadRollbackResponseActiveQueueFlushDecisionKind.ActiveQueueUnchanged;
			case _: throw "unknown rollback response active queue flush decision kind: " + value;
		}
	}

	static function backtrackTranscriptCellKind(value:String):ModelBacktrackTranscriptCellKind {
		return switch value {
			case "session_header": ModelBacktrackTranscriptCellKind.SessionHeader;
			case "user": ModelBacktrackTranscriptCellKind.User;
			case "agent": ModelBacktrackTranscriptCellKind.Agent;
			case _: throw "unknown backtrack transcript cell kind: " + value;
		}
	}

	static function postSamplingPendingInputSourceKind(value:String):ModelPostSamplingPendingInputSourceKind {
		return switch value {
			case "active_turn": ModelPostSamplingPendingInputSourceKind.ActiveTurn;
			case "mailbox": ModelPostSamplingPendingInputSourceKind.Mailbox;
			case _: throw "unknown post-sampling pending input source kind: " + value;
		}
	}

	static function samplingInputItemKind(value:String):ModelSamplingInputItemKind {
		return switch value {
			case "tool_response_output": ModelSamplingInputItemKind.ToolResponseOutput;
			case "pending_user_input": ModelSamplingInputItemKind.PendingUserInput;
			case "pending_response_item": ModelSamplingInputItemKind.PendingResponseItem;
			case _: throw "unknown sampling input item kind: " + value;
		}
	}

	static function toolOutputItemKind(value:String):ModelPatchToolOutputItemKind {
		return switch value {
			case "custom_tool_call_output": ModelPatchToolOutputItemKind.CustomToolCallOutput;
			case "function_call_output": ModelPatchToolOutputItemKind.FunctionCallOutput;
			case _: throw "unknown tool output item kind: " + value;
		}
	}

	static function virtualFiles(values:Array<Value>):Array<ModelPatchVirtualFile> {
		final out:Array<ModelPatchVirtualFile> = [];
		for (value in values) {
			final file = objectValue(value);
			out.push(new ModelPatchVirtualFile(stringField(file, "path", ""), stringField(file, "content", "")));
		}
		return out;
	}

	static function threadSnapshotTurnHistoryTurns(expectValue:Value):Array<ModelThreadSnapshotTurnHistoryTurn> {
		final out:Array<ModelThreadSnapshotTurnHistoryTurn> = [];
		final values = optionalArrayField(expectValue, "turns");
		for (value in values) {
			final turn = objectValue(value);
			final items:Array<ModelThreadSnapshotTurnHistoryItem> = [];
			final itemValues = optionalArrayField(turn, "items");
			for (itemValue in itemValues) {
				final item = objectValue(itemValue);
				items.push(new ModelThreadSnapshotTurnHistoryItem({
					itemKind: threadSnapshotTurnHistoryItemKind(stringField(item, "itemKind", "other")),
					itemId: stringField(item, "itemId", ""),
					text: stringField(item, "text", "")
				}));
			}
			out.push(new ModelThreadSnapshotTurnHistoryTurn({
				turnId: stringField(turn, "turnId", ""),
				statusKind: threadSnapshotTurnStatusKind(stringField(turn, "statusKind", "completed")),
				items: items
			}));
		}
		return out;
	}

	static function collabAgentNavigationEntries(expectValue:Value):Array<ModelCollabAgentMetadataEntry> {
		final out:Array<ModelCollabAgentMetadataEntry> = [];
		final values = optionalArrayField(expectValue, "navigationEntries");
		for (value in values) {
			final entry = objectValue(value);
			out.push(new ModelCollabAgentMetadataEntry({
				threadId: stringField(entry, "threadId", ""),
				agentNickname: stringField(entry, "agentNickname", ""),
				agentRole: stringField(entry, "agentRole", "")
			}));
		}
		return out;
	}

	static function collabReplayWaitItems(expectValue:Value):Array<ModelCollabReplayWaitItem> {
		final out:Array<ModelCollabReplayWaitItem> = [];
		final values = optionalArrayField(expectValue, "waitItems");
		for (value in values) {
			final item = objectValue(value);
			out.push(new ModelCollabReplayWaitItem({
				itemId: stringField(item, "itemId", ""),
				receiverThreadId: stringField(item, "receiverThreadId", ""),
				statusKind: collabReplayWaitStatusKind(stringField(item, "statusKind", "in_progress"))
			}));
		}
		return out;
	}

	static function threadSnapshotSessionRefreshTurns(expectValue:Value):Array<ModelThreadSnapshotSessionRefreshTurn> {
		final out:Array<ModelThreadSnapshotSessionRefreshTurn> = [];
		final values = optionalArrayField(expectValue, "resumedTurns");
		for (value in values) {
			final turn = objectValue(value);
			out.push(new ModelThreadSnapshotSessionRefreshTurn({
				turnId: stringField(turn, "turnId", ""),
				statusKind: threadSnapshotTurnStatusKind(stringField(turn, "statusKind", "completed")),
				userText: stringField(turn, "userText", "")
			}));
		}
		return out;
	}

	static function backtrackTranscriptCells(expectValue:Value):Array<ModelBacktrackTranscriptCell> {
		final out:Array<ModelBacktrackTranscriptCell> = [];
		final values = optionalArrayField(expectValue, "transcriptCells");
		for (value in values) {
			final cell = objectValue(value);
			out.push(new ModelBacktrackTranscriptCell({
				cellKind: backtrackTranscriptCellKind(stringField(cell, "cellKind", "agent")),
				message: stringField(cell, "message", ""),
				textElementCount: intField(cell, "textElementCount", 0),
				localImageCount: intField(cell, "localImageCount", 0),
				remoteImageCount: intField(cell, "remoteImageCount", 0),
				localImagePath: stringField(cell, "localImagePath", ""),
				remoteImageUrl: stringField(cell, "remoteImageUrl", "")
			}));
		}
		return out;
	}

	static function patchApplyStatus(value:String):ModelPatchApplyStatus {
		return switch value {
			case "completed": ModelPatchApplyStatus.Completed;
			case "failed": ModelPatchApplyStatus.Failed;
			case "declined": ModelPatchApplyStatus.Declined;
			case _: throw "invalid patch apply status: " + value;
		}
	}

	static function approvalRequirement(value:String):ModelPatchApprovalRequirement {
		return switch value {
			case "skip": ModelPatchApprovalRequirement.Skip;
			case "needs_approval": ModelPatchApprovalRequirement.NeedsApproval;
			case _: throw "invalid patch approval requirement: " + value;
		}
	}

	static function reviewDecision(value:String):ModelPatchReviewDecision {
		return switch value {
			case "approved": ModelPatchReviewDecision.Approved;
			case "approved_for_session": ModelPatchReviewDecision.ApprovedForSession;
			case "approved_with_amendment": ModelPatchReviewDecision.ApprovedWithAmendment;
			case "denied": ModelPatchReviewDecision.Denied;
			case "timed_out": ModelPatchReviewDecision.TimedOut;
			case "abort": ModelPatchReviewDecision.Abort;
			case _: throw "invalid patch review decision: " + value;
		}
	}

	static function sandboxAttempt(value:String):ModelPatchSandboxAttemptKind {
		return switch value {
			case "none": ModelPatchSandboxAttemptKind.None;
			case "sandboxed": ModelPatchSandboxAttemptKind.Sandboxed;
			case "escalated": ModelPatchSandboxAttemptKind.Escalated;
			case _: throw "invalid patch sandbox attempt: " + value;
		}
	}

	static function toolEventStage(value:String):ModelPatchToolEventStageKind {
		return switch value {
			case "success": ModelPatchToolEventStageKind.Success;
			case "failure_output": ModelPatchToolEventStageKind.FailureOutput;
			case "failure_message": ModelPatchToolEventStageKind.FailureMessage;
			case "rejected": ModelPatchToolEventStageKind.Rejected;
			case _: throw "invalid patch tool event stage: " + value;
		}
	}

	static function fixtureRoot(path:String):Value {
		return expectParse(CodexJson.parse(File.getContent(path)));
	}

	static function objectField(object:Value, name:String):Value {
		return objectValue(valueField(object, name));
	}

	static function optionalKeymapBinding(object:Value, name:String):Null<ModelKeymapBinding> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value: keymapBinding(objectValue(value));
		}
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function optionalArrayField(object:Value, name:String):Array<Value> {
		return switch optionalField(object, name) {
			case JArray(values): values;
			case JNull: [];
			case _: throw "expected array field: " + name;
		}
	}

	static function stringArrayField(object:Value, name:String):Array<String> {
		final out:Array<String> = [];
		return switch optionalField(object, name) {
			case JArray(values):
				for (value in values) {
					switch value {
						case JString(text): out.push(text);
						case _: throw "expected string array field: " + name;
					}
				}
				out;
			case JNull:
				out;
			case _:
				throw "expected string array field: " + name;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch optionalField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch optionalField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch optionalField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}

	static function valueField(object:Value, name:String):Value {
		return optionalField(object, name);
	}

	static function optionalField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) return values[i];
					i = i + 1;
				}
				JNull;
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function objectValue(value:Value):Value {
		return switch value {
			case JObject(_, _): value;
			case _: throw "expected object";
		}
	}

	static function expectParse(outcome:JsonParseOutcome):Value {
		if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function assertContains(value:String, needle:String):Void {
		if (needle.length == 0) return;
		if (value.indexOf(needle) < 0) throw "expected to find `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0) throw "expected not to find `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) throw "expected `" + expected + "` but got `" + actual + "`";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
