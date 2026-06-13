package codexhx.runtime.tui.turn;

class TurnRuntimeReducer {
    public static function apply(state:TurnRuntimeState, action:TurnRuntimeAction):TurnRuntimeState {
        return switch action.kind {
            case TurnRuntimeActionKind.TaskStarted:
                onTaskStarted(state);
            case TurnRuntimeActionKind.AssistantDelta:
                onAssistantDelta(state, action.text);
            case TurnRuntimeActionKind.AssistantFinal:
                onAssistantFinal(state, action.text, action.copySource);
            case TurnRuntimeActionKind.PlanDelta:
                onPlanDelta(state, action.text);
            case TurnRuntimeActionKind.PlanFinal:
                onPlanFinal(state, action.planItems);
            case TurnRuntimeActionKind.QueueFollowUp:
                onQueueFollowUp(state, action.text);
            case TurnRuntimeActionKind.QueueSteer:
                onQueueSteer(state, action.text);
            case TurnRuntimeActionKind.TaskCompleted:
                onTaskCompleted(state, action.text, action.fromReplay, action.activeGoalContinuation);
            case TurnRuntimeActionKind.TaskFailed:
                terminal(state, TurnRuntimeStatus.Failed, TurnTerminalReason.Failed, action.text);
            case TurnRuntimeActionKind.TaskCancelled:
                terminal(state, TurnRuntimeStatus.Cancelled, TurnTerminalReason.Cancelled, action.text);
        }
    }

    static function onTaskStarted(state:TurnRuntimeState):TurnRuntimeState {
        return state.withValues(
            TurnRuntimeStatus.Running,
            true,
            "",
            "",
            TurnMessageSource.None,
            "",
            false,
            "",
            [],
            [],
            [],
            false,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            "",
            false,
            false,
            false,
            false,
            TurnTerminalReason.None,
            ""
        );
    }

    static function onAssistantDelta(state:TurnRuntimeState, text:String):TurnRuntimeState {
        return state.withValues(
            state.status,
            state.running,
            state.assistantDraft + text,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            copyStrings(state.planDraftLines),
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            state.sawPlanItemThisTurn,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            state.submitPendingSteersAfterInterrupt,
            true,
            state.finalSeparatorNeeded,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onAssistantFinal(state:TurnRuntimeState, markdown:String, copySource:Bool):TurnRuntimeState {
        final source = if (copySource) TurnMessageSource.Item else state.assistantFinalSource;
        final sawCopy = state.sawCopySourceThisTurn || copySource;
        return state.withValues(
            state.status,
            state.running,
            "",
            markdown,
            source,
            markdown,
            sawCopy,
            state.notificationResponse,
            copyStrings(state.planDraftLines),
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            state.sawPlanItemThisTurn,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            state.submitPendingSteersAfterInterrupt,
            true,
            state.finalSeparatorNeeded,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onPlanDelta(state:TurnRuntimeState, text:String):TurnRuntimeState {
        final draft = copyStrings(state.planDraftLines);
        draft.push(text);
        return state.withValues(
            state.status,
            state.running,
            state.assistantDraft,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            draft,
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            true,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            state.submitPendingSteersAfterInterrupt,
            true,
            state.finalSeparatorNeeded,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onPlanFinal(state:TurnRuntimeState, items:Array<TurnPlanItem>):TurnRuntimeState {
        final finalItems = copyPlanItems(items);
        return state.withValues(
            state.status,
            state.running,
            state.assistantDraft,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            [],
            finalItems,
            copyPlanItems(finalItems),
            true,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            state.submitPendingSteersAfterInterrupt,
            true,
            true,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onQueueFollowUp(state:TurnRuntimeState, prompt:String):TurnRuntimeState {
        final followUps = copyStrings(state.pendingFollowUps);
        followUps.push(prompt);
        return state.withValues(
            state.status,
            state.running,
            state.assistantDraft,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            copyStrings(state.planDraftLines),
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            state.sawPlanItemThisTurn,
            followUps,
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            state.submitPendingSteersAfterInterrupt,
            state.hadWorkActivity,
            state.finalSeparatorNeeded,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onQueueSteer(state:TurnRuntimeState, prompt:String):TurnRuntimeState {
        final steers = copyStrings(state.pendingSteers);
        steers.push(prompt);
        return state.withValues(
            state.status,
            state.running,
            state.assistantDraft,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            copyStrings(state.planDraftLines),
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            state.sawPlanItemThisTurn,
            copyStrings(state.pendingFollowUps),
            steers,
            state.startedFollowUp,
            true,
            state.hadWorkActivity,
            state.finalSeparatorNeeded,
            state.completionNotified,
            state.terminalReason,
            state.failureMessage
        );
    }

    static function onTaskCompleted(state:TurnRuntimeState, lastAgentMessage:String, fromReplay:Bool, activeGoalContinuation:Bool):TurnRuntimeState {
        final hasCompletionMessage = lastAgentMessage.length > 0;
        final finalMarkdown = if (hasCompletionMessage && !state.sawCopySourceThisTurn) cloneText(lastAgentMessage) else state.assistantFinalMarkdown;
        final finalSource = if (hasCompletionMessage && !state.sawCopySourceThisTurn) TurnMessageSource.Completion else state.assistantFinalSource;
        final lastMarkdown = if (hasCompletionMessage && !state.sawCopySourceThisTurn) cloneText(lastAgentMessage) else state.lastAgentMarkdown;
        final notification = if (hasCompletionMessage) cloneText(lastAgentMessage) else if (state.sawCopySourceThisTurn) state.lastAgentMarkdown else "";
        final followUps = copyStrings(state.pendingFollowUps);
        var startedFollowUp = "";
        final remainingFollowUps:Array<String> = [];
        if (followUps.length > 0) {
            startedFollowUp = followUps[0];
            var i = 1;
            while (i < followUps.length) {
                remainingFollowUps.push(followUps[i]);
                i = i + 1;
            }
        }
        final notified = startedFollowUp.length == 0 && !activeGoalContinuation;
        final sawPlan = if (fromReplay) state.sawPlanItemThisTurn else false;
        return state.withValues(
            TurnRuntimeStatus.Completed,
            false,
            "",
            finalMarkdown,
            finalSource,
            lastMarkdown,
            state.sawCopySourceThisTurn,
            notification,
            [],
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            sawPlan,
            remainingFollowUps,
            copyStrings(state.pendingSteers),
            startedFollowUp,
            false,
            state.hadWorkActivity,
            state.finalSeparatorNeeded,
            notified,
            TurnTerminalReason.Completed,
            ""
        );
    }

    static function terminal(
        state:TurnRuntimeState,
        status:TurnRuntimeStatus,
        reason:TurnTerminalReason,
        message:String
    ):TurnRuntimeState {
        return state.withValues(
            status,
            false,
            state.assistantDraft,
            state.assistantFinalMarkdown,
            state.assistantFinalSource,
            state.lastAgentMarkdown,
            state.sawCopySourceThisTurn,
            state.notificationResponse,
            copyStrings(state.planDraftLines),
            copyPlanItems(state.finalPlanItems),
            copyPlanItems(state.consolidatedPlanItems),
            state.sawPlanItemThisTurn,
            copyStrings(state.pendingFollowUps),
            copyStrings(state.pendingSteers),
            state.startedFollowUp,
            false,
            state.hadWorkActivity,
            state.finalSeparatorNeeded,
            false,
            reason,
            message
        );
    }

    static function copyStrings(values:Array<String>):Array<String> {
        final out:Array<String> = [];
        for (value in values) {
            out.push(value);
        }
        return out;
    }

    static function cloneText(value:String):String {
        return value.substr(0, value.length);
    }

    static function copyPlanItems(values:Array<TurnPlanItem>):Array<TurnPlanItem> {
        final out:Array<TurnPlanItem> = [];
        for (value in values) {
            out.push(new TurnPlanItem(value.label, value.status));
        }
        return out;
    }
}
