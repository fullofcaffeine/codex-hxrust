package codexhx.runtime.tui.turn;

class TurnRuntimeState {
    public final status:TurnRuntimeStatus;
    public final running:Bool;
    public final assistantDraft:String;
    public final assistantFinalMarkdown:String;
    public final assistantFinalSource:TurnMessageSource;
    public final lastAgentMarkdown:String;
    public final sawCopySourceThisTurn:Bool;
    public final notificationResponse:String;
    public final planDraftLines:Array<String>;
    public final finalPlanItems:Array<TurnPlanItem>;
    public final consolidatedPlanItems:Array<TurnPlanItem>;
    public final sawPlanItemThisTurn:Bool;
    public final pendingFollowUps:Array<String>;
    public final pendingSteers:Array<String>;
    public final startedFollowUp:String;
    public final submitPendingSteersAfterInterrupt:Bool;
    public final hadWorkActivity:Bool;
    public final finalSeparatorNeeded:Bool;
    public final completionNotified:Bool;
    public final terminalReason:TurnTerminalReason;
    public final failureMessage:String;

    function new(
        status:TurnRuntimeStatus,
        running:Bool,
        assistantDraft:String,
        assistantFinalMarkdown:String,
        assistantFinalSource:TurnMessageSource,
        lastAgentMarkdown:String,
        sawCopySourceThisTurn:Bool,
        notificationResponse:String,
        planDraftLines:Array<String>,
        finalPlanItems:Array<TurnPlanItem>,
        consolidatedPlanItems:Array<TurnPlanItem>,
        sawPlanItemThisTurn:Bool,
        pendingFollowUps:Array<String>,
        pendingSteers:Array<String>,
        startedFollowUp:String,
        submitPendingSteersAfterInterrupt:Bool,
        hadWorkActivity:Bool,
        finalSeparatorNeeded:Bool,
        completionNotified:Bool,
        terminalReason:TurnTerminalReason,
        failureMessage:String
    ) {
        this.status = status;
        this.running = running;
        this.assistantDraft = assistantDraft;
        this.assistantFinalMarkdown = assistantFinalMarkdown;
        this.assistantFinalSource = assistantFinalSource;
        this.lastAgentMarkdown = lastAgentMarkdown;
        this.sawCopySourceThisTurn = sawCopySourceThisTurn;
        this.notificationResponse = notificationResponse;
        this.planDraftLines = planDraftLines;
        this.finalPlanItems = finalPlanItems;
        this.consolidatedPlanItems = consolidatedPlanItems;
        this.sawPlanItemThisTurn = sawPlanItemThisTurn;
        this.pendingFollowUps = pendingFollowUps;
        this.pendingSteers = pendingSteers;
        this.startedFollowUp = startedFollowUp;
        this.submitPendingSteersAfterInterrupt = submitPendingSteersAfterInterrupt;
        this.hadWorkActivity = hadWorkActivity;
        this.finalSeparatorNeeded = finalSeparatorNeeded;
        this.completionNotified = completionNotified;
        this.terminalReason = terminalReason;
        this.failureMessage = failureMessage;
    }

    public static function initial():TurnRuntimeState {
        return new TurnRuntimeState(
            TurnRuntimeStatus.Idle,
            false,
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
            [],
            [],
            "",
            false,
            false,
            false,
            false,
            TurnTerminalReason.None,
            ""
        );
    }

    public function withValues(
        status:TurnRuntimeStatus,
        running:Bool,
        assistantDraft:String,
        assistantFinalMarkdown:String,
        assistantFinalSource:TurnMessageSource,
        lastAgentMarkdown:String,
        sawCopySourceThisTurn:Bool,
        notificationResponse:String,
        planDraftLines:Array<String>,
        finalPlanItems:Array<TurnPlanItem>,
        consolidatedPlanItems:Array<TurnPlanItem>,
        sawPlanItemThisTurn:Bool,
        pendingFollowUps:Array<String>,
        pendingSteers:Array<String>,
        startedFollowUp:String,
        submitPendingSteersAfterInterrupt:Bool,
        hadWorkActivity:Bool,
        finalSeparatorNeeded:Bool,
        completionNotified:Bool,
        terminalReason:TurnTerminalReason,
        failureMessage:String
    ):TurnRuntimeState {
        return new TurnRuntimeState(
            status,
            running,
            assistantDraft,
            assistantFinalMarkdown,
            assistantFinalSource,
            lastAgentMarkdown,
            sawCopySourceThisTurn,
            notificationResponse,
            planDraftLines,
            finalPlanItems,
            consolidatedPlanItems,
            sawPlanItemThisTurn,
            pendingFollowUps,
            pendingSteers,
            startedFollowUp,
            submitPendingSteersAfterInterrupt,
            hadWorkActivity,
            finalSeparatorNeeded,
            completionNotified,
            terminalReason,
            failureMessage
        );
    }

    public function planFingerprint():String {
        final parts:Array<String> = [];
        for (item in finalPlanItems) {
            parts.push(item.fingerprint());
        }
        return parts.join("|");
    }

    public function consolidatedPlanFingerprint():String {
        final parts:Array<String> = [];
        for (item in consolidatedPlanItems) {
            parts.push(item.fingerprint());
        }
        return parts.join("|");
    }
}
