package codexhx.runtime.tui.smoke;

import codexhx.protocol.json.CodexJson;
import haxe.json.Value;
import sys.io.File;

class TuiSmokeFixtureLoader {
	public static function load(path:String):Array<TuiSmokeFrameRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		final cases = arrayField(parsed.value, "cases");
		final out:Array<TuiSmokeFrameRequest> = [];
		for (caseValue in cases) {
			out.push(frameRequest(caseValue));
		}
		return out;
	}

	public static function loadLoops(path:String):Array<TuiSmokeLoopRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		final cases = arrayField(parsed.value, "loopCases");
		final out:Array<TuiSmokeLoopRequest> = [];
		for (caseValue in cases) {
			out.push(loopRequest(caseValue));
		}
		return out;
	}

	static function frameRequest(value:Value):TuiSmokeFrameRequest {
		return new TuiSmokeFrameRequest({
			name: stringField(value, "name", ""),
			title: stringField(value, "title", ""),
			status: stringField(value, "status", ""),
			model: stringField(value, "model", ""),
			width: intField(value, "width", 80),
			transcript: transcriptRows(arrayField(value, "transcript")),
			input: stringField(value, "input", ""),
			terminalMode: TuiSmokeTerminalMode.fromString(stringField(value, "terminalMode", "")),
			key: TuiSmokeKeyKind.fromString(stringField(value, "key", "")),
			expectedExit: TuiSmokeExitKind.fromString(stringField(value, "expectedExit", "")),
			allowLiveTerminal: boolField(value, "allowLiveTerminal", false),
			allowNetwork: boolField(value, "allowNetwork", false),
			allowModelCall: boolField(value, "allowModelCall", false),
			expectedSnapshot: stringField(value, "expectedSnapshot", "")
		});
	}

	static function loopRequest(value:Value):TuiSmokeLoopRequest {
		return new TuiSmokeLoopRequest(
			stringField(value, "name", ""),
			frameRequest(valueField(value, "frame")),
			events(arrayField(value, "events")),
			TuiSmokeExitKind.fromString(stringField(value, "expectedExit", "")),
			stringField(value, "expectedTrace", ""),
			stringField(value, "expectedSnapshot", "")
		);
	}

	static function events(values:Array<Value>):Array<TuiSmokeEvent> {
		final out:Array<TuiSmokeEvent> = [];
		for (value in values) {
			out.push(new TuiSmokeEvent({
				kind: TuiSmokeEventKind.fromString(stringField(value, "kind", "")),
				key: TuiSmokeKeyKind.fromString(optionalStringField(value, "key", "none")),
				status: optionalStringField(value, "status", ""),
				input: optionalStringField(value, "input", ""),
				exitMode: TuiSmokeExitMode.fromString(optionalStringField(value, "exitMode", "unknown")),
				resizeDraw: optionalResizeDrawAction(value, "resizeDraw"),
				appEvent: optionalAppEvent(value, "appEvent"),
				appServerEvent: optionalAppServerEvent(value, "appServerEvent"),
				appServerRequest: optionalAppServerRequest(value, "appServerRequest"),
				appServerResolution: optionalAppServerResolution(value, "appServerResolution"),
				threadNotification: optionalThreadNotification(value, "threadNotification"),
				threadDelivery: optionalThreadDelivery(value, "threadDelivery"),
				threadReplay: optionalThreadReplay(value, "threadReplay"),
				eventStream: optionalEventStreamPlan(value, "eventStream"),
				terminalModePlan: optionalTerminalModePlan(value, "terminalModePlan"),
				altScreen: optionalAltScreenPlan(value, "altScreen"),
				drawComposition: optionalDrawCompositionPlan(value, "drawComposition"),
				frameScheduler: optionalFrameSchedulerPlan(value, "frameScheduler"),
				drawDispatch: optionalDrawDispatchPlan(value, "drawDispatch"),
				overlayRouting: optionalOverlayRoutingPlan(value, "overlayRouting"),
				approvalOverlay: optionalApprovalPlan(value, "approvalOverlay"),
				userInputOverlay: optionalUserInputPlan(value, "userInputOverlay"),
				mcpElicitationOverlay: optionalMcpElicitationPlan(value, "mcpElicitationOverlay"),
				appLinkOverlay: optionalAppLinkPlan(value, "appLinkOverlay"),
				hooksBrowser: optionalHooksBrowserPlan(value, "hooksBrowser"),
				slashCommandPopup: optionalSlashPopupPlan(value, "slashCommandPopup")
			}));
		}
		return out;
	}

	static function optionalSlashPopupPlan(object:Value, name:String):Null<TuiSmokeSlashPopupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSlashPopupPlan({
					allowLiveInput: optionalBoolField(value, "allowLiveInput", false),
					actions: slashPopupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function slashPopupActions(values:Array<Value>):Array<TuiSmokeSlashPopupAction> {
		final out:Array<TuiSmokeSlashPopupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSlashPopupAction({
				kind: TuiSmokeSlashPopupActionKind.fromString(stringField(value, "kind", "")),
				commandKind: TuiSmokeSlashPopupCommandKind.fromString(optionalStringField(value, "commandKind", "unknown")),
				matchKind: TuiSmokeSlashPopupMatchKind.fromString(optionalStringField(value, "matchKind", "unknown")),
				completionKind: TuiSmokeSlashPopupCompletionKind.fromString(optionalStringField(value, "completionKind", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				filterText: optionalStringField(value, "filterText", ""),
				commandName: optionalStringField(value, "commandName", ""),
				totalCommands: optionalIntField(value, "totalCommands", 0),
				visibleCount: optionalIntField(value, "visibleCount", 0),
				matchedCount: optionalIntField(value, "matchedCount", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				hiddenAliasCount: optionalIntField(value, "hiddenAliasCount", 0),
				serviceTierCount: optionalIntField(value, "serviceTierCount", 0),
				disabledCount: optionalIntField(value, "disabledCount", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				activeBefore: optionalBoolField(value, "activeBefore", false),
				activeAfter: optionalBoolField(value, "activeAfter", false),
				popupCreated: optionalBoolField(value, "popupCreated", false),
				popupDismissed: optionalBoolField(value, "popupDismissed", false),
				textCleared: optionalBoolField(value, "textCleared", false),
				draftPreserved: optionalBoolField(value, "draftPreserved", false),
				historyStaged: optionalBoolField(value, "historyStaged", false),
				historyRecorded: optionalBoolField(value, "historyRecorded", false),
				commandDispatched: optionalBoolField(value, "commandDispatched", false),
				serviceTierDispatched: optionalBoolField(value, "serviceTierDispatched", false),
				currentFileQueryCleared: optionalBoolField(value, "currentFileQueryCleared", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				interruptSuppressed: optionalBoolField(value, "interruptSuppressed", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalHooksBrowserPlan(object:Value, name:String):Null<TuiSmokeHooksBrowserPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeHooksBrowserPlan({
					allowLiveHooks: optionalBoolField(value, "allowLiveHooks", false),
					actions: hooksBrowserActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function hooksBrowserActions(values:Array<Value>):Array<TuiSmokeHooksBrowserAction> {
		final out:Array<TuiSmokeHooksBrowserAction> = [];
		for (value in values) {
			out.push(new TuiSmokeHooksBrowserAction({
				kind: TuiSmokeHooksBrowserActionKind.fromString(stringField(value, "kind", "")),
				pageBefore: TuiSmokeHooksBrowserPageKind.fromString(optionalStringField(value, "pageBefore", "unknown")),
				pageAfter: TuiSmokeHooksBrowserPageKind.fromString(optionalStringField(value, "pageAfter", "unknown")),
				eventName: optionalStringField(value, "eventName", ""),
				hookKey: optionalStringField(value, "hookKey", ""),
				hookSource: TuiSmokeHookSourceKind.fromString(optionalStringField(value, "hookSource", "unknown")),
				trustBefore: TuiSmokeHookTrustKind.fromString(optionalStringField(value, "trustBefore", "unknown")),
				trustAfter: TuiSmokeHookTrustKind.fromString(optionalStringField(value, "trustAfter", "unknown")),
				eventCount: optionalIntField(value, "eventCount", 0),
				hookCount: optionalIntField(value, "hookCount", 0),
				activeCount: optionalIntField(value, "activeCount", 0),
				installedCount: optionalIntField(value, "installedCount", 0),
				needsReviewCount: optionalIntField(value, "needsReviewCount", 0),
				warningCount: optionalIntField(value, "warningCount", 0),
				errorCount: optionalIntField(value, "errorCount", 0),
				visibleRows: optionalIntField(value, "visibleRows", 0),
				detailLines: optionalIntField(value, "detailLines", 0),
				commandDetailLines: optionalIntField(value, "commandDetailLines", 0),
				updatesCount: optionalIntField(value, "updatesCount", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				enabledBefore: optionalBoolField(value, "enabledBefore", false),
				enabledAfter: optionalBoolField(value, "enabledAfter", false),
				managed: optionalBoolField(value, "managed", false),
				needsReview: optionalBoolField(value, "needsReview", false),
				setHookEnabledSent: optionalBoolField(value, "setHookEnabledSent", false),
				trustHookSent: optionalBoolField(value, "trustHookSent", false),
				trustHooksSent: optionalBoolField(value, "trustHooksSent", false),
				completeBefore: optionalBoolField(value, "completeBefore", false),
				completeAfter: optionalBoolField(value, "completeAfter", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				rendered: optionalBoolField(value, "rendered", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalAppLinkPlan(object:Value, name:String):Null<TuiSmokeAppLinkPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppLinkPlan({
					allowLiveBrowser: optionalBoolField(value, "allowLiveBrowser", false),
					actions: appLinkActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function appLinkActions(values:Array<Value>):Array<TuiSmokeAppLinkAction> {
		final out:Array<TuiSmokeAppLinkAction> = [];
		for (value in values) {
			out.push(new TuiSmokeAppLinkAction({
				kind: TuiSmokeAppLinkActionKind.fromString(stringField(value, "kind", "")),
				suggestion: TuiSmokeAppLinkSuggestionKind.fromString(optionalStringField(value, "suggestion", "unknown")),
				screenBefore: TuiSmokeAppLinkScreenKind.fromString(optionalStringField(value, "screenBefore", "unknown")),
				screenAfter: TuiSmokeAppLinkScreenKind.fromString(optionalStringField(value, "screenAfter", "unknown")),
				decision: TuiSmokeAppLinkDecisionKind.fromString(optionalStringField(value, "decision", "unknown")),
				serverName: optionalStringField(value, "serverName", ""),
				requestId: optionalStringField(value, "requestId", ""),
				threadId: optionalStringField(value, "threadId", ""),
				appId: optionalStringField(value, "appId", ""),
				title: optionalStringField(value, "title", ""),
				urlHost: optionalStringField(value, "urlHost", ""),
				urlScheme: optionalStringField(value, "urlScheme", ""),
				messageChars: optionalIntField(value, "messageChars", 0),
				actionCount: optionalIntField(value, "actionCount", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				viewStackBefore: optionalIntField(value, "viewStackBefore", 0),
				viewStackAfter: optionalIntField(value, "viewStackAfter", 0),
				statusTimerPaused: optionalBoolField(value, "statusTimerPaused", false),
				statusTimerResumed: optionalBoolField(value, "statusTimerResumed", false),
				composerDisabled: optionalBoolField(value, "composerDisabled", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				trustedUrl: optionalBoolField(value, "trustedUrl", false),
				requiresChatgptHost: optionalBoolField(value, "requiresChatgptHost", false),
				browserOpenSent: optionalBoolField(value, "browserOpenSent", false),
				refreshConnectorsSent: optionalBoolField(value, "refreshConnectorsSent", false),
				setEnabledSent: optionalBoolField(value, "setEnabledSent", false),
				enabledBefore: optionalBoolField(value, "enabledBefore", false),
				enabledAfter: optionalBoolField(value, "enabledAfter", false),
				appCommandSent: optionalBoolField(value, "appCommandSent", false),
				resolutionSent: optionalBoolField(value, "resolutionSent", false),
				resolvedDismissed: optionalBoolField(value, "resolvedDismissed", false),
				staleResolution: optionalBoolField(value, "staleResolution", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				completeBefore: optionalBoolField(value, "completeBefore", false),
				completeAfter: optionalBoolField(value, "completeAfter", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalMcpElicitationPlan(object:Value, name:String):Null<TuiSmokeMcpElicitationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeMcpElicitationPlan({
					allowLiveElicitation: optionalBoolField(value, "allowLiveElicitation", false),
					actions: mcpElicitationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function mcpElicitationActions(values:Array<Value>):Array<TuiSmokeMcpElicitationAction> {
		final out:Array<TuiSmokeMcpElicitationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeMcpElicitationAction({
				kind: TuiSmokeMcpElicitationActionKind.fromString(stringField(value, "kind", "")),
				mode: TuiSmokeMcpElicitationModeKind.fromString(optionalStringField(value, "mode", "unknown")),
				fieldInput: TuiSmokeMcpElicitationFieldInputKind.fromString(optionalStringField(value, "fieldInput", "unknown")),
				decision: TuiSmokeMcpElicitationDecisionKind.fromString(optionalStringField(value, "decision", "unknown")),
				requestId: optionalStringField(value, "requestId", ""),
				serverName: optionalStringField(value, "serverName", ""),
				threadId: optionalStringField(value, "threadId", ""),
				fieldId: optionalStringField(value, "fieldId", ""),
				toolId: optionalStringField(value, "toolId", ""),
				toolName: optionalStringField(value, "toolName", ""),
				messageChars: optionalIntField(value, "messageChars", 0),
				fieldCount: optionalIntField(value, "fieldCount", 0),
				requiredFieldCount: optionalIntField(value, "requiredFieldCount", 0),
				optionalFieldCount: optionalIntField(value, "optionalFieldCount", 0),
				secretFieldCount: optionalIntField(value, "secretFieldCount", 0),
				approvalDisplayParamCount: optionalIntField(value, "approvalDisplayParamCount", 0),
				currentIndexBefore: optionalIntField(value, "currentIndexBefore", 0),
				currentIndexAfter: optionalIntField(value, "currentIndexAfter", 0),
				optionCount: optionalIntField(value, "optionCount", 0),
				selectedOptionBefore: optionalIntField(value, "selectedOptionBefore", -1),
				selectedOptionAfter: optionalIntField(value, "selectedOptionAfter", -1),
				draftCharsBefore: optionalIntField(value, "draftCharsBefore", 0),
				draftCharsAfter: optionalIntField(value, "draftCharsAfter", 0),
				pendingPasteCount: optionalIntField(value, "pendingPasteCount", 0),
				answeredBefore: optionalIntField(value, "answeredBefore", 0),
				answeredAfter: optionalIntField(value, "answeredAfter", 0),
				requiredUnansweredBefore: optionalIntField(value, "requiredUnansweredBefore", 0),
				requiredUnansweredAfter: optionalIntField(value, "requiredUnansweredAfter", 0),
				queueBefore: optionalIntField(value, "queueBefore", 0),
				queueAfter: optionalIntField(value, "queueAfter", 0),
				viewStackBefore: optionalIntField(value, "viewStackBefore", 0),
				viewStackAfter: optionalIntField(value, "viewStackAfter", 0),
				hasInputFocus: optionalBoolField(value, "hasInputFocus", false),
				composerDisabled: optionalBoolField(value, "composerDisabled", false),
				statusTimerPaused: optionalBoolField(value, "statusTimerPaused", false),
				statusTimerResumed: optionalBoolField(value, "statusTimerResumed", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				appCommandSent: optionalBoolField(value, "appCommandSent", false),
				resolutionSent: optionalBoolField(value, "resolutionSent", false),
				resolvedDismissed: optionalBoolField(value, "resolvedDismissed", false),
				staleResolution: optionalBoolField(value, "staleResolution", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				completeBefore: optionalBoolField(value, "completeBefore", false),
				completeAfter: optionalBoolField(value, "completeAfter", false),
				contentFieldCount: optionalIntField(value, "contentFieldCount", 0),
				metaPersisted: optionalBoolField(value, "metaPersisted", false),
				toolSuggestionHasInstallUrl: optionalBoolField(value, "toolSuggestionHasInstallUrl", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalUserInputPlan(object:Value, name:String):Null<TuiSmokeUserInputPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeUserInputPlan({
					allowLiveUserInput: optionalBoolField(value, "allowLiveUserInput", false),
					actions: userInputActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function userInputActions(values:Array<Value>):Array<TuiSmokeUserInputAction> {
		final out:Array<TuiSmokeUserInputAction> = [];
		for (value in values) {
			out.push(new TuiSmokeUserInputAction({
				kind: TuiSmokeUserInputActionKind.fromString(stringField(value, "kind", "")),
				requestKind: TuiSmokeUserInputRequestKind.fromString(optionalStringField(value, "requestKind", "unknown")),
				focus: TuiSmokeUserInputFocusKind.fromString(optionalStringField(value, "focus", "unknown")),
				requestId: optionalStringField(value, "requestId", ""),
				turnId: optionalStringField(value, "turnId", ""),
				itemId: optionalStringField(value, "itemId", ""),
				questionId: optionalStringField(value, "questionId", ""),
				callId: optionalStringField(value, "callId", ""),
				questionCount: optionalIntField(value, "questionCount", 0),
				currentIndexBefore: optionalIntField(value, "currentIndexBefore", 0),
				currentIndexAfter: optionalIntField(value, "currentIndexAfter", 0),
				optionCount: optionalIntField(value, "optionCount", 0),
				selectedOptionBefore: optionalIntField(value, "selectedOptionBefore", -1),
				selectedOptionAfter: optionalIntField(value, "selectedOptionAfter", -1),
				draftCharsBefore: optionalIntField(value, "draftCharsBefore", 0),
				draftCharsAfter: optionalIntField(value, "draftCharsAfter", 0),
				pendingPasteCount: optionalIntField(value, "pendingPasteCount", 0),
				notesVisible: optionalBoolField(value, "notesVisible", false),
				answeredBefore: optionalIntField(value, "answeredBefore", 0),
				answeredAfter: optionalIntField(value, "answeredAfter", 0),
				unansweredBefore: optionalIntField(value, "unansweredBefore", 0),
				unansweredAfter: optionalIntField(value, "unansweredAfter", 0),
				queueBefore: optionalIntField(value, "queueBefore", 0),
				queueAfter: optionalIntField(value, "queueAfter", 0),
				viewStackBefore: optionalIntField(value, "viewStackBefore", 0),
				viewStackAfter: optionalIntField(value, "viewStackAfter", 0),
				hasInputFocus: optionalBoolField(value, "hasInputFocus", false),
				composerDisabled: optionalBoolField(value, "composerDisabled", false),
				statusTimerPaused: optionalBoolField(value, "statusTimerPaused", false),
				statusTimerResumed: optionalBoolField(value, "statusTimerResumed", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				appCommandSent: optionalBoolField(value, "appCommandSent", false),
				historyCellInserted: optionalBoolField(value, "historyCellInserted", false),
				resolutionSent: optionalBoolField(value, "resolutionSent", false),
				resolvedDismissed: optionalBoolField(value, "resolvedDismissed", false),
				staleResolution: optionalBoolField(value, "staleResolution", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				completeBefore: optionalBoolField(value, "completeBefore", false),
				completeAfter: optionalBoolField(value, "completeAfter", false),
				answerCount: optionalIntField(value, "answerCount", 0),
				secretQuestionCount: optionalIntField(value, "secretQuestionCount", 0),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalApprovalPlan(object:Value, name:String):Null<TuiSmokeApprovalPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeApprovalPlan({
					allowLiveApproval: optionalBoolField(value, "allowLiveApproval", false),
					actions: approvalActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function approvalActions(values:Array<Value>):Array<TuiSmokeApprovalAction> {
		final out:Array<TuiSmokeApprovalAction> = [];
		for (value in values) {
			out.push(new TuiSmokeApprovalAction({
				kind: TuiSmokeApprovalActionKind.fromString(stringField(value, "kind", "")),
				requestKind: TuiSmokeApprovalRequestKind.fromString(optionalStringField(value, "requestKind", "unknown")),
				decision: TuiSmokeApprovalDecisionKind.fromString(optionalStringField(value, "decision", "unknown")),
				requestId: optionalStringField(value, "requestId", ""),
				approvalId: optionalStringField(value, "approvalId", ""),
				threadLabel: optionalStringField(value, "threadLabel", ""),
				promptTitle: optionalStringField(value, "promptTitle", ""),
				options: optionalIntField(value, "options", 0),
				selectedIndex: optionalIntField(value, "selectedIndex", -1),
				queueBefore: optionalIntField(value, "queueBefore", 0),
				queueAfter: optionalIntField(value, "queueAfter", 0),
				delayedBefore: optionalIntField(value, "delayedBefore", 0),
				delayedAfter: optionalIntField(value, "delayedAfter", 0),
				viewStackBefore: optionalIntField(value, "viewStackBefore", 0),
				viewStackAfter: optionalIntField(value, "viewStackAfter", 0),
				consumedByActiveView: optionalBoolField(value, "consumedByActiveView", false),
				promptDelayed: optionalBoolField(value, "promptDelayed", false),
				delayMs: optionalIntField(value, "delayMs", 0),
				statusTimerPaused: optionalBoolField(value, "statusTimerPaused", false),
				statusTimerResumed: optionalBoolField(value, "statusTimerResumed", false),
				historyCellInserted: optionalBoolField(value, "historyCellInserted", false),
				appCommandSent: optionalBoolField(value, "appCommandSent", false),
				resolutionSent: optionalBoolField(value, "resolutionSent", false),
				resolvedDismissed: optionalBoolField(value, "resolvedDismissed", false),
				staleResolution: optionalBoolField(value, "staleResolution", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false),
				completeBefore: optionalBoolField(value, "completeBefore", false),
				completeAfter: optionalBoolField(value, "completeAfter", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				keyAction: optionalStringField(value, "keyAction", ""),
				conflictPrevious: optionalStringField(value, "conflictPrevious", ""),
				conflictAction: optionalStringField(value, "conflictAction", ""),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalOverlayRoutingPlan(object:Value, name:String):Null<TuiSmokeOverlayRoutingPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeOverlayRoutingPlan({
					allowLiveOverlay: optionalBoolField(value, "allowLiveOverlay", false),
					actions: overlayRoutingActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function overlayRoutingActions(values:Array<Value>):Array<TuiSmokeOverlayRoutingAction> {
		final out:Array<TuiSmokeOverlayRoutingAction> = [];
		for (value in values) {
			out.push(new TuiSmokeOverlayRoutingAction({
				kind: TuiSmokeOverlayRoutingActionKind.fromString(stringField(value, "kind", "")),
				overlay: TuiSmokeOverlayKind.fromString(optionalStringField(value, "overlay", "unknown")),
				title: optionalStringField(value, "title", ""),
				keyAction: TuiSmokeOverlayKeyActionKind.fromString(optionalStringField(value, "keyAction", "unknown")),
				committedCellsBefore: optionalIntField(value, "committedCellsBefore", 0),
				committedCellsAfter: optionalIntField(value, "committedCellsAfter", 0),
				insertedCells: optionalIntField(value, "insertedCells", 0),
				lineCount: optionalIntField(value, "lineCount", 0),
				consolidateStart: optionalIntField(value, "consolidateStart", 0),
				consolidateEnd: optionalIntField(value, "consolidateEnd", 0),
				liveTailWidth: optionalIntField(value, "liveTailWidth", 0),
				liveTailRevision: optionalIntField(value, "liveTailRevision", 0),
				liveTailContinuation: optionalBoolField(value, "liveTailContinuation", false),
				liveTailAnimationTick: optionalIntField(value, "liveTailAnimationTick", -1),
				liveTailKeyChanged: optionalBoolField(value, "liveTailKeyChanged", false),
				liveTailComputed: optionalBoolField(value, "liveTailComputed", false),
				liveTailLines: optionalIntField(value, "liveTailLines", 0),
				pinnedBefore: optionalBoolField(value, "pinnedBefore", false),
				pinnedAfter: optionalBoolField(value, "pinnedAfter", false),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				drawHeight: optionalIntField(value, "drawHeight", 0),
				renderedWidth: optionalIntField(value, "renderedWidth", 0),
				renderedHeight: optionalIntField(value, "renderedHeight", 0),
				ownsTerminal: optionalBoolField(value, "ownsTerminal", false),
				doneBefore: optionalBoolField(value, "doneBefore", false),
				doneAfter: optionalBoolField(value, "doneAfter", false),
				enterAltScreen: optionalBoolField(value, "enterAltScreen", false),
				leaveAltScreen: optionalBoolField(value, "leaveAltScreen", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				deferredHistoryLines: optionalIntField(value, "deferredHistoryLines", 0),
				backtrackPreviewActiveBefore: optionalBoolField(value, "backtrackPreviewActiveBefore", false),
				backtrackPreviewActiveAfter: optionalBoolField(value, "backtrackPreviewActiveAfter", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalDrawDispatchPlan(object:Value, name:String):Null<TuiSmokeDrawDispatchPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeDrawDispatchPlan({
					allowLiveDispatch: optionalBoolField(value, "allowLiveDispatch", false),
					event: TuiSmokeDrawDispatchEventKind.fromString(optionalStringField(value, "event", "unknown")),
					renderMode: TuiSmokeDrawDispatchRenderMode.fromString(optionalStringField(value, "renderMode", "unknown")),
					resizeReflowEnabled: optionalBoolField(value, "resizeReflowEnabled", false),
					preRender: optionalBoolField(value, "preRender", false),
					sizeChanged: optionalBoolField(value, "sizeChanged", false),
					statusRefresh: optionalBoolField(value, "statusRefresh", false),
					clearPendingHistory: optionalBoolField(value, "clearPendingHistory", false),
					reflowDue: optionalBoolField(value, "reflowDue", false),
					reflowRan: optionalBoolField(value, "reflowRan", false),
					rearmDelayMs: optionalIntField(value, "rearmDelayMs", 0),
					overlayActive: optionalBoolField(value, "overlayActive", false),
					overlayHandled: optionalBoolField(value, "overlayHandled", false),
					backtrackRenderPending: optionalBoolField(value, "backtrackRenderPending", false),
					backtrackRebuilt: optionalBoolField(value, "backtrackRebuilt", false),
					pendingNotification: optionalBoolField(value, "pendingNotification", false),
					pasteBurstFlushed: optionalBoolField(value, "pasteBurstFlushed", false),
					pasteBurstCapturing: optionalBoolField(value, "pasteBurstCapturing", false),
					pasteBurstSkippedFrame: optionalBoolField(value, "pasteBurstSkippedFrame", false),
					pasteBurstFollowupMs: optionalIntField(value, "pasteBurstFollowupMs", 0),
					preDrawTick: optionalBoolField(value, "preDrawTick", false),
					desiredHeight: optionalIntField(value, "desiredHeight", 0),
					renderedWidth: optionalIntField(value, "renderedWidth", 0),
					renderedHeight: optionalIntField(value, "renderedHeight", 0),
					cursorSet: optionalBoolField(value, "cursorSet", false),
					ambientPetDraw: optionalBoolField(value, "ambientPetDraw", false),
					petPreviewDraw: optionalBoolField(value, "petPreviewDraw", false),
					petPreviewClear: optionalBoolField(value, "petPreviewClear", false),
					externalEditorLaunch: optionalBoolField(value, "externalEditorLaunch", false),
					followUpFrame: optionalBoolField(value, "followUpFrame", false),
					failureCode: optionalStringField(value, "failureCode", "")
				});
		}
	}

	static function optionalFrameSchedulerPlan(object:Value, name:String):Null<TuiSmokeFrameSchedulerPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeFrameSchedulerPlan({
					allowLiveScheduler: optionalBoolField(value, "allowLiveScheduler", false),
					actions: frameSchedulerActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function frameSchedulerActions(values:Array<Value>):Array<TuiSmokeFrameSchedulerAction> {
		final out:Array<TuiSmokeFrameSchedulerAction> = [];
		for (value in values) {
			out.push(new TuiSmokeFrameSchedulerAction({
				kind: TuiSmokeFrameSchedulerActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", "unknown"),
				requestMs: optionalIntField(value, "requestMs", 0),
				delayMs: optionalIntField(value, "delayMs", 0),
				previousDeadlineMs: optionalIntField(value, "previousDeadlineMs", -1),
				nextDeadlineMs: optionalIntField(value, "nextDeadlineMs", -1),
				clampedDeadlineMs: optionalIntField(value, "clampedDeadlineMs", 0),
				lastEmittedMs: optionalIntField(value, "lastEmittedMs", -1),
				minIntervalMs: optionalIntField(value, "minIntervalMs", 8),
				requestCount: optionalIntField(value, "requestCount", 0),
				coalescedCount: optionalIntField(value, "coalescedCount", 0),
				emittedCount: optionalIntField(value, "emittedCount", 0),
				broadcastCapacity: optionalIntField(value, "broadcastCapacity", 1),
				spawnedTask: optionalBoolField(value, "spawnedTask", false),
				drawSent: optionalBoolField(value, "drawSent", false),
				lagged: optionalBoolField(value, "lagged", false),
				closed: optionalBoolField(value, "closed", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalDrawCompositionPlan(object:Value, name:String):Null<TuiSmokeDrawCompositionPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeDrawCompositionPlan({
					allowLiveDraw: optionalBoolField(value, "allowLiveDraw", false),
					mode: TuiSmokeDrawCompositionMode.fromString(optionalStringField(value, "mode", "unknown")),
					height: optionalIntField(value, "height", 0),
					terminalWidth: optionalIntField(value, "terminalWidth", 0),
					terminalHeight: optionalIntField(value, "terminalHeight", 0),
					lastWidth: optionalIntField(value, "lastWidth", 0),
					lastHeight: optionalIntField(value, "lastHeight", 0),
					ensureVirtualTerminalProcessing: optionalBoolField(value, "ensureVirtualTerminalProcessing", true),
					syncUpdate: optionalBoolField(value, "syncUpdate", true),
					preparedResume: optionalBoolField(value, "preparedResume", false),
					pendingViewportComputed: optionalBoolField(value, "pendingViewportComputed", false),
					cursorMoved: optionalBoolField(value, "cursorMoved", false),
					lastCursorY: optionalIntField(value, "lastCursorY", 0),
					cursorY: optionalIntField(value, "cursorY", 0),
					previousViewportX: optionalIntField(value, "previousViewportX", 0),
					previousViewportY: optionalIntField(value, "previousViewportY", 0),
					previousViewportWidth: optionalIntField(value, "previousViewportWidth", 0),
					previousViewportHeight: optionalIntField(value, "previousViewportHeight", 0),
					pendingViewportX: optionalIntField(value, "pendingViewportX", 0),
					pendingViewportY: optionalIntField(value, "pendingViewportY", 0),
					pendingViewportWidth: optionalIntField(value, "pendingViewportWidth", 0),
					pendingViewportHeight: optionalIntField(value, "pendingViewportHeight", 0),
					appliedViewportX: optionalIntField(value, "appliedViewportX", 0),
					appliedViewportY: optionalIntField(value, "appliedViewportY", 0),
					appliedViewportWidth: optionalIntField(value, "appliedViewportWidth", 0),
					appliedViewportHeight: optionalIntField(value, "appliedViewportHeight", 0),
					clearForViewportChange: optionalBoolField(value, "clearForViewportChange", false),
					terminalClear: optionalBoolField(value, "terminalClear", false),
					scrollRegionUp: optionalBoolField(value, "scrollRegionUp", false),
					scrollRegionStart: optionalIntField(value, "scrollRegionStart", 0),
					scrollRegionEnd: optionalIntField(value, "scrollRegionEnd", 0),
					scrollBy: optionalIntField(value, "scrollBy", 0),
					pendingHistoryBatches: optionalIntField(value, "pendingHistoryBatches", 0),
					pendingHistoryRows: optionalIntField(value, "pendingHistoryRows", 0),
					zellijRaw: optionalBoolField(value, "zellijRaw", false),
					wrapPolicy: TuiSmokeHistoryWrapPolicy.fromString(optionalStringField(value, "wrapPolicy", "terminal")),
					suspendCursorY: optionalIntField(value, "suspendCursorY", 0),
					altScreenActive: optionalBoolField(value, "altScreenActive", false),
					needsFullRepaint: optionalBoolField(value, "needsFullRepaint", false),
					invalidateViewport: optionalBoolField(value, "invalidateViewport", false),
					renderCallback: optionalBoolField(value, "renderCallback", true),
					autoresize: optionalBoolField(value, "autoresize", true),
					diffPutCount: optionalIntField(value, "diffPutCount", 0),
					diffClearToEndCount: optionalIntField(value, "diffClearToEndCount", 0),
					cursorSet: optionalBoolField(value, "cursorSet", false),
					cursorX: optionalIntField(value, "cursorX", 0),
					cursorPositionY: optionalIntField(value, "cursorPositionY", 0),
					cursorStyle: optionalStringField(value, "cursorStyle", "default"),
					swapBuffers: optionalBoolField(value, "swapBuffers", true),
					backendFlush: optionalBoolField(value, "backendFlush", true),
					failureCode: optionalStringField(value, "failureCode", "")
				});
		}
	}

	static function optionalAltScreenPlan(object:Value, name:String):Null<TuiSmokeAltScreenPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAltScreenPlan({
					allowLiveAltScreen: optionalBoolField(value, "allowLiveAltScreen", false),
					actions: altScreenActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function altScreenActions(values:Array<Value>):Array<TuiSmokeAltScreenAction> {
		final out:Array<TuiSmokeAltScreenAction> = [];
		for (value in values) {
			out.push(new TuiSmokeAltScreenAction({
				kind: TuiSmokeAltScreenActionKind.fromString(stringField(value, "kind", "")),
				enabled: optionalBoolField(value, "enabled", true),
				activeBefore: optionalBoolField(value, "activeBefore", false),
				activeAfter: optionalBoolField(value, "activeAfter", false),
				savedViewportPresentBefore: optionalBoolField(value, "savedViewportPresentBefore", false),
				savedViewportPresentAfter: optionalBoolField(value, "savedViewportPresentAfter", false),
				previousViewportX: optionalIntField(value, "previousViewportX", 0),
				previousViewportY: optionalIntField(value, "previousViewportY", 0),
				previousViewportWidth: optionalIntField(value, "previousViewportWidth", 0),
				previousViewportHeight: optionalIntField(value, "previousViewportHeight", 0),
				savedViewportX: optionalIntField(value, "savedViewportX", 0),
				savedViewportY: optionalIntField(value, "savedViewportY", 0),
				savedViewportWidth: optionalIntField(value, "savedViewportWidth", 0),
				savedViewportHeight: optionalIntField(value, "savedViewportHeight", 0),
				terminalWidth: optionalIntField(value, "terminalWidth", 0),
				terminalHeight: optionalIntField(value, "terminalHeight", 0),
				appliedViewportX: optionalIntField(value, "appliedViewportX", 0),
				appliedViewportY: optionalIntField(value, "appliedViewportY", 0),
				appliedViewportWidth: optionalIntField(value, "appliedViewportWidth", 0),
				appliedViewportHeight: optionalIntField(value, "appliedViewportHeight", 0),
				enterAlternateScreen: optionalBoolField(value, "enterAlternateScreen", false),
				leaveAlternateScreen: optionalBoolField(value, "leaveAlternateScreen", false),
				enableAlternateScroll: optionalBoolField(value, "enableAlternateScroll", false),
				disableAlternateScroll: optionalBoolField(value, "disableAlternateScroll", false),
				clearTerminal: optionalBoolField(value, "clearTerminal", false),
				clearAfterX: optionalIntField(value, "clearAfterX", 0),
				clearAfterY: optionalIntField(value, "clearAfterY", 0),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalTerminalModePlan(object:Value, name:String):Null<TuiSmokeTerminalModePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalModePlan({
					allowLiveTerminalMode: optionalBoolField(value, "allowLiveTerminalMode", false),
					actions: terminalModeActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalModeActions(values:Array<Value>):Array<TuiSmokeTerminalModeAction> {
		final out:Array<TuiSmokeTerminalModeAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalModeAction({
				kind: TuiSmokeTerminalModeActionKind.fromString(stringField(value, "kind", "")),
				rawModeRestore: TuiSmokeRawModeRestoreKind.fromString(optionalStringField(value, "rawModeRestore", "none")),
				keyboardRestore: TuiSmokeKeyboardRestoreKind.fromString(optionalStringField(value, "keyboardRestore", "none")),
				virtualTerminalProcessing: optionalBoolField(value, "virtualTerminalProcessing", false),
				bracketedPaste: optionalBoolField(value, "bracketedPaste", false),
				rawMode: optionalBoolField(value, "rawMode", false),
				focusChange: optionalBoolField(value, "focusChange", false),
				mouseCapture: optionalBoolField(value, "mouseCapture", false),
				cursorDefault: optionalBoolField(value, "cursorDefault", false),
				cursorShow: optionalBoolField(value, "cursorShow", false),
				keyboardEnhancementDisabled: optionalBoolField(value, "keyboardEnhancementDisabled", false),
				envOverride: optionalStringField(value, "envOverride", "none"),
				wsl: optionalBoolField(value, "wsl", false),
				vscodeTerminal: optionalBoolField(value, "vscodeTerminal", false),
				tmuxSession: optionalBoolField(value, "tmuxSession", false),
				tmuxCsiU: optionalBoolField(value, "tmuxCsiU", false),
				pushKeyboardEnhancement: optionalBoolField(value, "pushKeyboardEnhancement", false),
				popKeyboardEnhancement: optionalBoolField(value, "popKeyboardEnhancement", false),
				resetKeyboardEnhancement: optionalBoolField(value, "resetKeyboardEnhancement", false),
				modifyOtherKeys: optionalBoolField(value, "modifyOtherKeys", false),
				stdinTerminal: optionalBoolField(value, "stdinTerminal", true),
				stdoutTerminal: optionalBoolField(value, "stdoutTerminal", true),
				flushInput: optionalBoolField(value, "flushInput", false),
				panicHook: optionalBoolField(value, "panicHook", false),
				terminalStderrFinish: optionalBoolField(value, "terminalStderrFinish", false),
				supported: optionalBoolField(value, "supported", true),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalEventStreamPlan(object:Value, name:String):Null<TuiSmokeEventStreamPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeEventStreamPlan({
					initialState: TuiSmokeEventStreamBrokerState.fromString(optionalStringField(value, "initialState", "unknown")),
					actions: eventStreamActions(optionalArrayField(value, "actions")),
					allowLiveEventSource: optionalBoolField(value, "allowLiveEventSource", false)
				});
		}
	}

	static function eventStreamActions(values:Array<Value>):Array<TuiSmokeEventStreamAction> {
		final out:Array<TuiSmokeEventStreamAction> = [];
		for (value in values) {
			out.push(new TuiSmokeEventStreamAction({
				kind: TuiSmokeEventStreamActionKind.fromString(stringField(value, "kind", "")),
				stateBefore: TuiSmokeEventStreamBrokerState.fromString(optionalStringField(value, "stateBefore", "unknown")),
				stateAfter: TuiSmokeEventStreamBrokerState.fromString(optionalStringField(value, "stateAfter", "unknown")),
				sourceEvent: TuiSmokeEventStreamEventKind.fromString(optionalStringField(value, "sourceEvent", "none")),
				mappedEvent: TuiSmokeMappedTuiEventKind.fromString(optionalStringField(value, "mappedEvent", "none")),
				pollOrder: TuiSmokeEventStreamPollOrder.fromString(optionalStringField(value, "pollOrder", "unknown")),
				key: TuiSmokeKeyKind.fromString(optionalStringField(value, "key", "none")),
				paste: optionalStringField(value, "paste", ""),
				dropSource: optionalBoolField(value, "dropSource", false),
				wakeResume: optionalBoolField(value, "wakeResume", false),
				recreateSource: optionalBoolField(value, "recreateSource", false),
				drawSubscription: optionalBoolField(value, "drawSubscription", false),
				sharedBroker: optionalBoolField(value, "sharedBroker", false),
				terminalFocused: optionalBoolField(value, "terminalFocused", true),
				paletteRequery: optionalBoolField(value, "paletteRequery", false),
				altScreenActive: optionalBoolField(value, "altScreenActive", false),
				keepRaw: optionalBoolField(value, "keepRaw", false)
			}));
		}
		return out;
	}

	static function optionalResizeDrawAction(object:Value, name:String):Null<TuiSmokeResizeDrawAction> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeResizeDrawAction({
					terminalWidth: optionalIntField(value, "terminalWidth", 0),
					terminalHeight: optionalIntField(value, "terminalHeight", 0),
					lastWidth: optionalIntField(value, "lastWidth", 0),
					lastHeight: optionalIntField(value, "lastHeight", 0),
					resizeReflowEnabled: optionalBoolField(value, "resizeReflowEnabled", false),
					scheduleAccepted: optionalBoolField(value, "scheduleAccepted", true),
					pendingReflow: optionalBoolField(value, "pendingReflow", false),
					pendingDue: optionalBoolField(value, "pendingDue", false),
					overlayActive: optionalBoolField(value, "overlayActive", false),
					transcriptCells: optionalBoolField(value, "transcriptCells", false),
					remainingMs: optionalIntField(value, "remainingMs", 0),
					runReflow: optionalBoolField(value, "runReflow", false),
					streamTime: optionalBoolField(value, "streamTime", false),
					followUpDraw: optionalBoolField(value, "followUpDraw", false),
					repaint: optionalResizeRepaintPlan(value, "repaint"),
					viewport: optionalViewportResizePlan(value, "viewport"),
					suspendResume: optionalSuspendResumePlan(value, "suspendResume")
				});
		}
	}

	static function optionalSuspendResumePlan(object:Value, name:String):Null<TuiSmokeSuspendResumePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSuspendResumePlan({
					action: TuiSmokeResumeActionKind.fromString(optionalStringField(value, "action", "none")),
					altScreenActive: optionalBoolField(value, "altScreenActive", false),
					cachedCursorY: optionalIntField(value, "cachedCursorY", 0),
					cursorYAfterResume: optionalIntField(value, "cursorYAfterResume", 0),
					savedViewportX: optionalIntField(value, "savedViewportX", 0),
					savedViewportY: optionalIntField(value, "savedViewportY", 0),
					savedViewportWidth: optionalIntField(value, "savedViewportWidth", 0),
					savedViewportHeight: optionalIntField(value, "savedViewportHeight", 0),
					appliedViewportX: optionalIntField(value, "appliedViewportX", 0),
					appliedViewportY: optionalIntField(value, "appliedViewportY", 0),
					appliedViewportWidth: optionalIntField(value, "appliedViewportWidth", 0),
					appliedViewportHeight: optionalIntField(value, "appliedViewportHeight", 0),
					enterAltScreen: optionalBoolField(value, "enterAltScreen", false),
					leaveAltScreen: optionalBoolField(value, "leaveAltScreen", false),
					altScroll: optionalBoolField(value, "altScroll", false),
					clearAfterRestore: optionalBoolField(value, "clearAfterRestore", false)
				});
		}
	}

	static function optionalViewportResizePlan(object:Value, name:String):Null<TuiSmokeViewportResizePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeViewportResizePlan({
					requestedHeight: optionalIntField(value, "requestedHeight", 0),
					previousX: optionalIntField(value, "previousX", 0),
					previousY: optionalIntField(value, "previousY", 0),
					previousWidth: optionalIntField(value, "previousWidth", 0),
					previousHeight: optionalIntField(value, "previousHeight", 0),
					nextX: optionalIntField(value, "nextX", 0),
					nextY: optionalIntField(value, "nextY", 0),
					nextWidth: optionalIntField(value, "nextWidth", 0),
					nextHeight: optionalIntField(value, "nextHeight", 0),
					terminalHeightShrank: optionalBoolField(value, "terminalHeightShrank", false),
					terminalHeightGrew: optionalBoolField(value, "terminalHeightGrew", false),
					bottomAligned: optionalBoolField(value, "bottomAligned", false),
					scrollBy: optionalIntField(value, "scrollBy", 0),
					pendingHistoryBatches: optionalIntField(value, "pendingHistoryBatches", 0),
					pendingHistoryRows: optionalIntField(value, "pendingHistoryRows", 0),
					zellijRaw: optionalBoolField(value, "zellijRaw", false),
					wrapPolicy: TuiSmokeHistoryWrapPolicy.fromString(optionalStringField(value, "wrapPolicy", "terminal")),
					clearAfterY: optionalIntField(value, "clearAfterY", 0),
					needsFullRepaint: optionalBoolField(value, "needsFullRepaint", false)
				});
		}
	}

	static function optionalResizeRepaintPlan(object:Value, name:String):Null<TuiSmokeResizeRepaintPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeResizeRepaintPlan({
					transcriptCellCount: optionalIntField(value, "transcriptCellCount", 0),
					reflowedRows: optionalIntField(value, "reflowedRows", 0),
					rowCap: optionalIntField(value, "rowCap", -1),
					pendingHistoryBatches: optionalIntField(value, "pendingHistoryBatches", 0),
					deferredHistoryRows: optionalIntField(value, "deferredHistoryRows", 0),
					clearKind: TuiSmokeResizeClearKind.fromString(optionalStringField(value, "clearKind", "none")),
					wrapPolicy: TuiSmokeHistoryWrapPolicy.fromString(optionalStringField(value, "wrapPolicy", "terminal")),
					viewportReset: optionalBoolField(value, "viewportReset", false),
					needsFullRepaint: optionalBoolField(value, "needsFullRepaint", false),
					emptyTranscript: optionalBoolField(value, "emptyTranscript", false),
					insertRows: optionalBoolField(value, "insertRows", false)
				});
		}
	}

	static function optionalAppEvent(object:Value, name:String):Null<TuiSmokeAppEvent> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppEvent(
					TuiSmokeAppEventKind.fromString(stringField(value, "kind", "")),
					optionalStringField(value, "status", ""),
					TuiSmokeExitMode.fromString(optionalStringField(value, "exitMode", "unknown"))
				);
		}
	}

	static function optionalAppServerEvent(object:Value, name:String):Null<TuiSmokeAppServerEvent> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerEvent(
					TuiSmokeAppServerEventKind.fromString(stringField(value, "kind", "")),
					optionalStringField(value, "threadId", ""),
					optionalStringField(value, "status", ""),
					optionalStringField(value, "delta", ""),
					optionalStringField(value, "message", "")
				);
		}
	}

	static function optionalAppServerRequest(object:Value, name:String):Null<TuiSmokeAppServerRequest> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value: appServerRequest(value);
		}
	}

	static function optionalAppServerResolution(object:Value, name:String):Null<TuiSmokeAppServerResolution> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerResolution({
					kind: TuiSmokeAppServerResolutionKind.fromString(stringField(value, "kind", "")),
					id: optionalStringField(value, "id", ""),
					requestId: optionalStringField(value, "requestId", ""),
					decision: optionalStringField(value, "decision", ""),
					response: optionalStringField(value, "response", "")
				});
		}
	}

	static function optionalThreadDelivery(object:Value, name:String):Null<TuiSmokeThreadDeliveryAction> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadDeliveryAction({
					kind: TuiSmokeThreadDeliveryActionKind.fromString(stringField(value, "kind", "")),
					threadId: optionalStringField(value, "threadId", ""),
					requestId: optionalStringField(value, "requestId", "")
				});
		}
	}

	static function optionalThreadNotification(object:Value, name:String):Null<TuiSmokeThreadNotification> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadNotification({
					kind: TuiSmokeThreadNotificationKind.fromString(stringField(value, "kind", "")),
					notificationId: optionalStringField(value, "notificationId", ""),
					threadId: optionalStringField(value, "threadId", ""),
					status: optionalStringField(value, "status", ""),
					delta: optionalStringField(value, "delta", ""),
					message: optionalStringField(value, "message", "")
				});
		}
	}

	static function optionalThreadReplay(object:Value, name:String):Null<TuiSmokeThreadReplayAction> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadReplayAction({
					kind: TuiSmokeThreadReplayActionKind.fromString(stringField(value, "kind", "")),
					threadId: optionalStringField(value, "threadId", ""),
					session: optionalThreadSession(value, "session"),
					inputState: optionalThreadInputState(value, "inputState"),
					turns: optionalThreadTurns(value, "turns"),
					snapshotRequests: appServerRequests(optionalArrayField(value, "snapshotRequests")),
					snapshotEvents: threadReplayEvents(optionalArrayField(value, "snapshotEvents")),
					replayBuffer: optionalReplayBufferPlan(value, "replayBuffer"),
					traceRequestSurfaces: optionalBoolField(value, "traceRequestSurfaces", false),
					resizeReflowEnabled: optionalBoolField(value, "resizeReflowEnabled", false),
					resumeRestoredQueue: optionalBoolField(value, "resumeRestoredQueue", false)
				});
		}
	}

	static function optionalReplayBufferPlan(object:Value, name:String):Null<TuiSmokeReplayBufferPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeReplayBufferPlan({
					kind: TuiSmokeReplayBufferKind.fromString(stringField(value, "kind", "")),
					terminalWidth: optionalIntField(value, "terminalWidth", 0),
					terminalHeight: optionalIntField(value, "terminalHeight", 0),
					previousWidth: optionalIntField(value, "previousWidth", 0),
					previousHeight: optionalIntField(value, "previousHeight", 0),
					maxRows: optionalIntField(value, "maxRows", -1),
					retainedRows: optionalIntField(value, "retainedRows", 0),
					renderFromTranscriptTail: optionalBoolField(value, "renderFromTranscriptTail", false),
					flushAfterReplay: optionalBoolField(value, "flushAfterReplay", false),
					reflowAfterFlush: optionalBoolField(value, "reflowAfterFlush", false)
				});
		}
	}

	static function optionalThreadSession(object:Value, name:String):Null<TuiSmokeThreadSession> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadSession({
					threadId: optionalStringField(value, "threadId", ""),
					model: optionalStringField(value, "model", ""),
					title: optionalStringField(value, "title", ""),
					isSideThread: optionalBoolField(value, "isSideThread", false)
				});
		}
	}

	static function optionalThreadInputState(object:Value, name:String):Null<TuiSmokeThreadInputState> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadInputState({
					composerText: optionalStringField(value, "composerText", ""),
					taskRunning: optionalBoolField(value, "taskRunning", false),
					queuedUserMessageCount: optionalIntField(value, "queuedUserMessageCount", 0),
					pendingInitialSubmit: optionalBoolField(value, "pendingInitialSubmit", false)
				});
		}
	}

	static function optionalThreadTurns(object:Value, name:String):Array<TuiSmokeThreadTurn> {
		return switch optionalField(object, name) {
			case JNull: [];
			case JArray(values):
				final out:Array<TuiSmokeThreadTurn> = [];
				for (value in values) {
					out.push(new TuiSmokeThreadTurn({
						turnId: stringField(value, "turnId", ""),
						status: TuiSmokeThreadTurnStatus.fromString(optionalStringField(value, "status", "unknown")),
						items: threadItems(optionalArrayField(value, "items"))
					}));
				}
				out;
			case _: throw "expected array field: " + name;
		}
	}

	static function threadItems(values:Array<Value>):Array<TuiSmokeThreadItem> {
		final out:Array<TuiSmokeThreadItem> = [];
		for (value in values) {
			out.push(new TuiSmokeThreadItem({
				kind: TuiSmokeThreadItemKind.fromString(stringField(value, "kind", "")),
				itemId: optionalStringField(value, "itemId", ""),
				text: optionalStringField(value, "text", "")
			}));
		}
		return out;
	}

	static function threadReplayEvents(values:Array<Value>):Array<TuiSmokeThreadReplayEvent> {
		final out:Array<TuiSmokeThreadReplayEvent> = [];
		for (value in values) {
			out.push(new TuiSmokeThreadReplayEvent({
				kind: TuiSmokeThreadReplayEventKind.fromString(stringField(value, "kind", "")),
				eventId: optionalStringField(value, "eventId", ""),
				threadId: optionalStringField(value, "threadId", ""),
				notification: optionalThreadNotification(value, "notification"),
				text: optionalStringField(value, "text", ""),
				category: optionalStringField(value, "category", ""),
				result: optionalStringField(value, "result", ""),
				success: optionalBoolField(value, "success", false),
				includeLogs: optionalBoolField(value, "includeLogs", false)
			}));
		}
		return out;
	}

	static function appServerRequests(values:Array<Value>):Array<TuiSmokeAppServerRequest> {
		final out:Array<TuiSmokeAppServerRequest> = [];
		for (value in values) {
			out.push(appServerRequest(value));
		}
		return out;
	}

	static function appServerRequest(value:Value):TuiSmokeAppServerRequest {
		return new TuiSmokeAppServerRequest({
			kind: TuiSmokeAppServerRequestKind.fromString(stringField(value, "kind", "")),
			requestId: optionalStringField(value, "requestId", ""),
			threadId: optionalStringField(value, "threadId", ""),
			turnId: optionalStringField(value, "turnId", ""),
			itemId: optionalStringField(value, "itemId", ""),
			approvalId: optionalStringField(value, "approvalId", ""),
			serverName: optionalStringField(value, "serverName", "")
		});
	}

	static function transcriptRows(values:Array<Value>):Array<TuiSmokeTranscriptRow> {
		final out:Array<TuiSmokeTranscriptRow> = [];
		for (value in values) {
			out.push(new TuiSmokeTranscriptRow({
				source: TuiSmokeTranscriptSource.fromString(stringField(value, "source", "")),
				text: stringField(value, "text", "")
			}));
		}
		return out;
	}

	static function valueField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) return values[i];
					i = i + 1;
				}
				throw "missing field: " + name;
			case _:
				throw "expected object for field: " + name;
		}
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
				throw "expected object for field: " + name;
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
			case JNull: [];
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch valueField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function optionalStringField(object:Value, name:String, fallback:String):String {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name) {
						return switch values[i] {
							case JString(value): value;
							case JNull: fallback;
							case _: throw "expected string field: " + name;
						}
					}
					i = i + 1;
				}
				fallback;
			case _:
				throw "expected object for field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch valueField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function optionalIntField(object:Value, name:String, fallback:Int):Int {
		return switch optionalField(object, name) {
			case JNull: fallback;
			case JNumber(value): Std.int(value);
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch valueField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}

	static function optionalBoolField(object:Value, name:String, fallback:Bool):Bool {
		return switch optionalField(object, name) {
			case JNull: fallback;
			case JBool(value): value;
			case _: throw "expected bool field: " + name;
		}
	}
}
