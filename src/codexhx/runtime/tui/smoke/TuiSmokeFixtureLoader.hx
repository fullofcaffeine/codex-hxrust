package codexhx.runtime.tui.smoke;

import codexhx.protocol.json.CodexJson;
import haxe.json.Value;
import sys.io.File;

class TuiSmokeFixtureLoader {
	public static function load(path:String):Array<TuiSmokeFrameRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok)
			throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		final cases = arrayField(parsed.value, "cases");
		final out:Array<TuiSmokeFrameRequest> = [];
		for (caseValue in cases) {
			out.push(frameRequest(caseValue));
		}
		return out;
	}

	public static function loadLoops(path:String):Array<TuiSmokeLoopRequest> {
		final parsed = CodexJson.parse(File.getContent(path));
		if (!parsed.ok)
			throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
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
		return new TuiSmokeLoopRequest(stringField(value, "name", ""), frameRequest(valueField(value, "frame")), events(arrayField(value, "events")),
			TuiSmokeExitKind.fromString(stringField(value, "expectedExit", "")), stringField(value, "expectedTrace", ""),
			stringField(value, "expectedSnapshot", ""));
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
				slashCommandPopup: optionalSlashPopupPlan(value, "slashCommandPopup"),
				fileMentionPopup: optionalFileMentionPopupPlan(value, "fileMentionPopup"),
				historySearch: optionalHistorySearchPlan(value, "historySearch"),
				composerAttachment: optionalComposerAttachmentPlan(value, "composerAttachment"),
				composerSubmission: optionalComposerSubmissionPlan(value, "composerSubmission"),
				composerEditing: optionalComposerEditingPlan(value, "composerEditing"),
				composerPopupSync: optionalComposerPopupSyncPlan(value, "composerPopupSync"),
				composerPopupKey: optionalComposerPopupKeyPlan(value, "composerPopupKey"),
				composerPopupRender: optionalComposerPopupRenderPlan(value, "composerPopupRender"),
				composerFooterRender: optionalComposerFooterRenderPlan(value, "composerFooterRender"),
				composerTextareaRender: optionalComposerTextareaRenderPlan(value, "composerTextareaRender"),
				chatWidgetComposerRender: optionalChatWidgetComposerRenderPlan(value, "chatWidgetComposerRender"),
				chatWidgetActiveStream: optionalChatWidgetActiveStreamPlan(value, "chatWidgetActiveStream"),
				chatWidgetStreamStatus: optionalChatWidgetStreamStatusPlan(value, "chatWidgetStreamStatus"),
				chatWidgetStreamLifecycle: optionalChatWidgetStreamLifecyclePlan(value, "chatWidgetStreamLifecycle"),
				chatWidgetMcpStartup: optionalMcpStartupPlan(value, "chatWidgetMcpStartup"),
				chatWidgetStatusSurface: optionalStatusSurfacePlan(value, "chatWidgetStatusSurface"),
				chatWidgetStatusSurfaceRender: optionalStatusSurfaceRenderPlan(value, "chatWidgetStatusSurfaceRender"),
				chatWidgetStatusState: optionalStatusStatePlan(value, "chatWidgetStatusState"),
				chatWidgetCommandLifecycle: optionalCommandLifecyclePlan(value, "chatWidgetCommandLifecycle"),
				chatWidgetToolLifecycle: optionalToolLifecyclePlan(value, "chatWidgetToolLifecycle"),
				chatWidgetHookLifecycle: optionalHookLifecyclePlan(value, "chatWidgetHookLifecycle"),
				chatWidgetInputSubmission: optionalInputSubmissionPlan(value, "chatWidgetInputSubmission"),
				chatWidgetTurnRuntime: optionalTurnRuntimePlan(value, "chatWidgetTurnRuntime"),
				chatWidgetSessionFlow: optionalSessionFlowPlan(value, "chatWidgetSessionFlow"),
				chatWidgetReplayProtocol: optionalReplayProtocolPlan(value, "chatWidgetReplayProtocol"),
				chatWidgetRateLimit: optionalRateLimitPlan(value, "chatWidgetRateLimit"),
				chatWidgetWindowsSandbox: optionalWindowsSandboxPlan(value, "chatWidgetWindowsSandbox"),
				chatWidgetPermissionSelection: optionalPermissionSelectionPlan(value, "chatWidgetPermissionSelection"),
				chatWidgetModelSettings: optionalModelSettingsPlan(value, "chatWidgetModelSettings"),
				goalDisplay: optionalGoalDisplayPlan(value, "goalDisplay"),
				gitActionDirectives: optionalGitActionDirectivePlan(value, "gitActionDirectives"),
				threadTranscript: optionalThreadTranscriptPlan(value, "threadTranscript"),
				lineTruncation: optionalLineTruncationPlan(value, "lineTruncation"),
				markdownTextMerge: optionalMarkdownTextMergePlan(value, "markdownTextMerge"),
				textFormatting: optionalTextFormattingPlan(value, "textFormatting"),
				liveWrap: optionalLiveWrapPlan(value, "liveWrap"),
				wrapping: optionalWrappingPlan(value, "wrapping"),
				scrollState: optionalScrollStatePlan(value, "scrollState"),
				selectionTabs: optionalSelectionTabsPlan(value, "selectionTabs"),
				actionRequiredTitle: optionalActionRequiredTitlePlan(value, "actionRequiredTitle"),
				popupConsts: optionalPopupConstsPlan(value, "popupConsts"),
				statusLineStyle: optionalStatusLineStylePlan(value, "statusLineStyle"),
				statusSurfacePreview: optionalStatusSurfacePreviewPlan(value, "statusSurfacePreview"),
				pendingInputPreview: optionalPendingInputPreviewPlan(value, "pendingInputPreview"),
				pendingThreadApprovals: optionalPendingThreadApprovalsPlan(value, "pendingThreadApprovals"),
				promptArgs: optionalPromptArgsPlan(value, "promptArgs"),
				unifiedExecFooter: optionalUnifiedExecFooterPlan(value, "unifiedExecFooter"),
				fileSearchPopup: optionalFileSearchPopupPlan(value, "fileSearchPopup"),
				skillPopup: optionalSkillPopupPlan(value, "skillPopup"),
				selectionPopupCommon: optionalSelectionPopupCommonPlan(value, "selectionPopupCommon"),
				listSelectionView: optionalListSelectionPlan(value, "listSelectionView"),
				commandPopup: optionalCommandPopupPlan(value, "commandPopup"),
				multiSelectPicker: optionalMultiSelectPlan(value, "multiSelectPicker"),
				appLinkView: optionalAppLinkViewPlan(value, "appLinkView"),
				customPromptView: optionalCustomPromptPlan(value, "customPromptView"),
				pasteBurst: optionalPasteBurstPlan(value, "pasteBurst"),
				textArea: optionalTextAreaPlan(value, "textArea"),
				chatWidgetGoalMenu: optionalGoalMenuPlan(value, "chatWidgetGoalMenu"),
				chatWidgetReviewMode: optionalReviewModePlan(value, "chatWidgetReviewMode"),
				chatWidgetTranscriptHistory: optionalTranscriptHistoryPlan(value, "chatWidgetTranscriptHistory"),
				chatWidgetTranscriptOverlay: optionalTranscriptOverlayPlan(value, "chatWidgetTranscriptOverlay"),
				chatWidgetBacktrackOverlay: optionalBacktrackOverlayPlan(value, "chatWidgetBacktrackOverlay"),
				chatWidgetKeymapRawOutput: optionalKeymapRawOutputPlan(value, "chatWidgetKeymapRawOutput"),
				chatWidgetRawOutputRender: optionalRawOutputRenderPlan(value, "chatWidgetRawOutputRender"),
				chatWidgetSlashCommand: optionalSlashCommandPlan(value, "chatWidgetSlashCommand"),
				chatWidgetStatusCard: optionalStatusCardPlan(value, "chatWidgetStatusCard"),
				chatWidgetInterruptQuit: optionalChatWidgetInterruptQuitPlan(value, "chatWidgetInterruptQuit"),
				chatWidgetInterruptedRestore: optionalChatWidgetInterruptedRestorePlan(value, "chatWidgetInterruptedRestore"),
				sideConversation: optionalSideConversationPlan(value, "sideConversation"),
				clearArchive: optionalClearArchivePlan(value, "clearArchive"),
				sessionArchiveCommand: optionalSessionArchiveCommandPlan(value, "sessionArchiveCommand"),
				resumeFork: optionalResumeForkPlan(value, "resumeFork"),
				terminalTitle: optionalTerminalTitlePlan(value, "terminalTitle"),
				browserOpen: optionalBrowserOpenPlan(value, "browserOpen"),
				desktopThread: optionalDesktopThreadPlan(value, "desktopThread"),
				terminalVisualization: optionalTerminalVisualizationPlan(value, "terminalVisualization"),
				agentStatus: optionalAgentStatusPlan(value, "agentStatus"),
				agentNavigation: optionalAgentNavigationPlan(value, "agentNavigation"),
				loadedThreads: optionalLoadedThreadsPlan(value, "loadedThreads"),
				desktopNotification: optionalDesktopNotificationPlan(value, "desktopNotification"),
				terminalHyperlink: optionalTerminalHyperlinkPlan(value, "terminalHyperlink"),
				terminalPalette: optionalTerminalPalettePlan(value, "terminalPalette"),
				terminalStartupProbe: optionalTerminalStartupProbePlan(value, "terminalStartupProbe"),
				clipboardCopy: optionalClipboardCopyPlan(value, "clipboardCopy"),
				clipboardPaste: optionalClipboardPastePlan(value, "clipboardPaste")
			}));
		}
		return out;
	}

	static function optionalGoalDisplayPlan(object:Value, name:String):Null<TuiSmokeGoalDisplayPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeGoalDisplayPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: goalDisplayActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function goalDisplayActions(values:Array<Value>):Array<TuiSmokeGoalDisplayAction> {
		final out:Array<TuiSmokeGoalDisplayAction> = [];
		for (value in values) {
			out.push(new TuiSmokeGoalDisplayAction({
				kind: TuiSmokeGoalDisplayActionKind.fromString(stringField(value, "kind", "")),
				status: optionalStringField(value, "status", ""),
				objective: optionalStringField(value, "objective", ""),
				expectedLabel: optionalStringField(value, "expectedLabel", ""),
				expectedElapsed: optionalStringField(value, "expectedElapsed", ""),
				expectedSummary: optionalStringField(value, "expectedSummary", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				seconds: optionalIntField(value, "seconds", 0),
				tokenBudget: optionalIntField(value, "tokenBudget", 0),
				tokensUsed: optionalIntField(value, "tokensUsed", 0),
				timeUsedSeconds: optionalIntField(value, "timeUsedSeconds", 0),
				hasTokenBudget: optionalBoolField(value, "hasTokenBudget", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalGitActionDirectivePlan(object:Value, name:String):Null<TuiSmokeGitActionDirectivePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeGitActionDirectivePlan({
					allowGitMutation: optionalBoolField(value, "allowGitMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowGithubCall: optionalBoolField(value, "allowGithubCall", false),
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					actions: gitActionDirectiveActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function gitActionDirectiveActions(values:Array<Value>):Array<TuiSmokeGitActionDirectiveAction> {
		final out:Array<TuiSmokeGitActionDirectiveAction> = [];
		for (value in values) {
			out.push(new TuiSmokeGitActionDirectiveAction({
				kind: TuiSmokeGitActionDirectiveActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				cwd: optionalStringField(value, "cwd", ""),
				markdown: optionalStringField(value, "markdown", ""),
				expectedVisibleMarkdown: optionalStringField(value, "expectedVisibleMarkdown", ""),
				expectedLastCreatedBranchCwd: optionalStringField(value, "expectedLastCreatedBranchCwd", ""),
				expectedDirectives: gitActionDirectiveExpectations(optionalArrayField(value, "expectedDirectives")),
				failureCode: optionalStringField(value, "failureCode", ""),
				noGitMutation: optionalBoolField(value, "noGitMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noGithubCall: optionalBoolField(value, "noGithubCall", false),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function gitActionDirectiveExpectations(values:Array<Value>):Array<TuiSmokeGitActionDirectiveExpectation> {
		final out:Array<TuiSmokeGitActionDirectiveExpectation> = [];
		for (value in values) {
			out.push(new TuiSmokeGitActionDirectiveExpectation({
				kind: optionalStringField(value, "kind", ""),
				cwd: optionalStringField(value, "cwd", ""),
				branch: optionalStringField(value, "branch", ""),
				url: optionalStringField(value, "url", ""),
				isDraft: optionalBoolField(value, "isDraft", false)
			}));
		}
		return out;
	}

	static function optionalThreadTranscriptPlan(object:Value, name:String):Null<TuiSmokeThreadTranscriptPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeThreadTranscriptPlan({
					allowAppServerRead: optionalBoolField(value, "allowAppServerRead", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: threadTranscriptActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function threadTranscriptActions(values:Array<Value>):Array<TuiSmokeThreadTranscriptAction> {
		final out:Array<TuiSmokeThreadTranscriptAction> = [];
		for (value in values) {
			out.push(new TuiSmokeThreadTranscriptAction({
				kind: TuiSmokeThreadTranscriptActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				cwd: optionalStringField(value, "cwd", ""),
				rawReasoningVisibility: optionalStringField(value, "rawReasoningVisibility", "hidden"),
				items: threadTranscriptItems(optionalArrayField(value, "items")),
				expectedCells: threadTranscriptCells(optionalArrayField(value, "expectedCells")),
				failureCode: optionalStringField(value, "failureCode", ""),
				noAppServerRead: optionalBoolField(value, "noAppServerRead", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function threadTranscriptItems(values:Array<Value>):Array<TuiSmokeThreadTranscriptItem> {
		final out:Array<TuiSmokeThreadTranscriptItem> = [];
		for (value in values) {
			out.push(new TuiSmokeThreadTranscriptItem({
				kind: TuiSmokeThreadTranscriptItemKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				summary: optionalStringArrayField(value, "summary"),
				content: optionalStringArrayField(value, "content"),
				fragments: optionalStringArrayField(value, "fragments"),
				command: optionalStringField(value, "command", ""),
				status: optionalStringField(value, "status", ""),
				aggregatedOutput: optionalStringField(value, "aggregatedOutput", ""),
				exitCode: optionalStringField(value, "exitCode", ""),
				changesCount: optionalIntField(value, "changesCount", 0),
				server: optionalStringField(value, "server", ""),
				tool: optionalStringField(value, "tool", ""),
				namespace: optionalStringField(value, "namespace", ""),
				query: optionalStringField(value, "query", ""),
				path: optionalStringField(value, "path", ""),
				savedPath: optionalStringField(value, "savedPath", ""),
				review: optionalStringField(value, "review", "")
			}));
		}
		return out;
	}

	static function threadTranscriptCells(values:Array<Value>):Array<TuiSmokeThreadTranscriptCell> {
		final out:Array<TuiSmokeThreadTranscriptCell> = [];
		for (value in values) {
			out.push(new TuiSmokeThreadTranscriptCell({
				kind: TuiSmokeThreadTranscriptCellKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", "")
			}));
		}
		return out;
	}

	static function optionalLineTruncationPlan(object:Value, name:String):Null<TuiSmokeLineTruncationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeLineTruncationPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: lineTruncationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function lineTruncationActions(values:Array<Value>):Array<TuiSmokeLineTruncationAction> {
		final out:Array<TuiSmokeLineTruncationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeLineTruncationAction({
				kind: TuiSmokeLineTruncationActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				maxWidth: optionalIntField(value, "maxWidth", 0),
				spans: lineTruncationSpans(optionalArrayField(value, "spans")),
				expectedSpans: lineTruncationSpans(optionalArrayField(value, "expectedSpans")),
				expectedWidth: optionalIntField(value, "expectedWidth", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function lineTruncationSpans(values:Array<Value>):Array<TuiSmokeLineTruncationSpan> {
		final out:Array<TuiSmokeLineTruncationSpan> = [];
		for (value in values) {
			out.push(new TuiSmokeLineTruncationSpan({
				text: optionalStringField(value, "text", ""),
				style: optionalStringField(value, "style", "")
			}));
		}
		return out;
	}

	static function optionalMarkdownTextMergePlan(object:Value, name:String):Null<TuiSmokeMarkdownTextMergePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeMarkdownTextMergePlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: markdownTextMergeActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function markdownTextMergeActions(values:Array<Value>):Array<TuiSmokeMarkdownTextMergeAction> {
		final out:Array<TuiSmokeMarkdownTextMergeAction> = [];
		for (value in values) {
			out.push(new TuiSmokeMarkdownTextMergeAction({
				kind: TuiSmokeMarkdownTextMergeActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				events: markdownTextMergeEvents(optionalArrayField(value, "events")),
				expectedEvents: markdownTextMergeEvents(optionalArrayField(value, "expectedEvents")),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function markdownTextMergeEvents(values:Array<Value>):Array<TuiSmokeMarkdownTextEvent> {
		final out:Array<TuiSmokeMarkdownTextEvent> = [];
		for (value in values) {
			out.push(new TuiSmokeMarkdownTextEvent({
				kind: TuiSmokeMarkdownTextEventKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				start: optionalIntField(value, "start", 0),
				end: optionalIntField(value, "end", 0)
			}));
		}
		return out;
	}

	static function optionalTextFormattingPlan(object:Value, name:String):Null<TuiSmokeTextFormattingPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTextFormattingPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: textFormattingActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function textFormattingActions(values:Array<Value>):Array<TuiSmokeTextFormattingAction> {
		final out:Array<TuiSmokeTextFormattingAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTextFormattingAction({
				kind: TuiSmokeTextFormattingActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				input: optionalStringField(value, "input", ""),
				items: optionalStringArrayField(value, "items"),
				maxGraphemes: optionalIntField(value, "maxGraphemes", 0),
				maxLines: optionalIntField(value, "maxLines", 0),
				lineWidth: optionalIntField(value, "lineWidth", 0),
				maxWidth: optionalIntField(value, "maxWidth", 0),
				expected: optionalStringField(value, "expected", ""),
				expectedFormatted: optionalBoolField(value, "expectedFormatted", false),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalLiveWrapPlan(object:Value, name:String):Null<TuiSmokeLiveWrapPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeLiveWrapPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: liveWrapActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function liveWrapActions(values:Array<Value>):Array<TuiSmokeLiveWrapAction> {
		final out:Array<TuiSmokeLiveWrapAction> = [];
		for (value in values) {
			out.push(new TuiSmokeLiveWrapAction({
				kind: TuiSmokeLiveWrapActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				width: optionalIntField(value, "width", 0),
				maxKeep: optionalIntField(value, "maxKeep", 0),
				maxCols: optionalIntField(value, "maxCols", 0),
				fragment: optionalStringField(value, "fragment", ""),
				text: optionalStringField(value, "text", ""),
				expectedRows: liveWrapRows(optionalArrayField(value, "expectedRows")),
				expectedRemainingRows: liveWrapRows(optionalArrayField(value, "expectedRemainingRows")),
				expectedPrefix: optionalStringField(value, "expectedPrefix", ""),
				expectedSuffix: optionalStringField(value, "expectedSuffix", ""),
				expectedWidth: optionalIntField(value, "expectedWidth", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function liveWrapRows(values:Array<Value>):Array<TuiSmokeLiveWrapRow> {
		final out:Array<TuiSmokeLiveWrapRow> = [];
		for (value in values) {
			out.push(new TuiSmokeLiveWrapRow({
				text: optionalStringField(value, "text", ""),
				explicitBreak: optionalBoolField(value, "explicitBreak", false),
				width: optionalIntField(value, "width", 0)
			}));
		}
		return out;
	}

	static function optionalWrappingPlan(object:Value, name:String):Null<TuiSmokeWrappingPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeWrappingPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: wrappingActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function wrappingActions(values:Array<Value>):Array<TuiSmokeWrappingAction> {
		final out:Array<TuiSmokeWrappingAction> = [];
		for (value in values) {
			out.push(new TuiSmokeWrappingAction({
				kind: TuiSmokeWrappingActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				text: optionalStringField(value, "text", ""),
				spans: wrappingSpans(optionalArrayField(value, "spans")),
				width: optionalIntField(value, "width", 0),
				subsequentIndent: optionalStringField(value, "subsequentIndent", ""),
				expectedBool: optionalBoolField(value, "expectedBool", false),
				expectedLines: optionalStringArrayField(value, "expectedLines"),
				expectedRanges: wrappingRanges(optionalArrayField(value, "expectedRanges")),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function wrappingSpans(values:Array<Value>):Array<TuiSmokeWrappingSpan> {
		final out:Array<TuiSmokeWrappingSpan> = [];
		for (value in values) {
			out.push(new TuiSmokeWrappingSpan({
				text: optionalStringField(value, "text", "")
			}));
		}
		return out;
	}

	static function wrappingRanges(values:Array<Value>):Array<TuiSmokeWrappingRange> {
		final out:Array<TuiSmokeWrappingRange> = [];
		for (value in values) {
			out.push(new TuiSmokeWrappingRange({
				start: optionalIntField(value, "start", 0),
				end: optionalIntField(value, "end", 0)
			}));
		}
		return out;
	}

	static function optionalScrollStatePlan(object:Value, name:String):Null<TuiSmokeScrollStatePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeScrollStatePlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: scrollStateActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function scrollStateActions(values:Array<Value>):Array<TuiSmokeScrollStateAction> {
		final out:Array<TuiSmokeScrollStateAction> = [];
		for (value in values) {
			out.push(new TuiSmokeScrollStateAction({
				kind: TuiSmokeScrollStateActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				len: optionalIntField(value, "len", 0),
				visibleRows: optionalIntField(value, "visibleRows", 0),
				selected: optionalIntField(value, "selected", -1),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				expectedSelected: optionalIntField(value, "expectedSelected", -1),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSelectionTabsPlan(object:Value, name:String):Null<TuiSmokeSelectionTabsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSelectionTabsPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: selectionTabsActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function selectionTabsActions(values:Array<Value>):Array<TuiSmokeSelectionTabsAction> {
		final out:Array<TuiSmokeSelectionTabsAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSelectionTabsAction({
				kind: TuiSmokeSelectionTabsActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				tabs: selectionTabs(optionalArrayField(value, "tabs")),
				activeIdx: optionalIntField(value, "activeIdx", 0),
				width: optionalIntField(value, "width", 0),
				areaHeight: optionalIntField(value, "areaHeight", 0),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				expectedLines: optionalStringArrayField(value, "expectedLines"),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function selectionTabs(values:Array<Value>):Array<TuiSmokeSelectionTab> {
		final out:Array<TuiSmokeSelectionTab> = [];
		for (value in values) {
			out.push(new TuiSmokeSelectionTab({
				id: optionalStringField(value, "id", ""),
				label: optionalStringField(value, "label", "")
			}));
		}
		return out;
	}

	static function optionalActionRequiredTitlePlan(object:Value, name:String):Null<TuiSmokeActionRequiredTitlePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeActionRequiredTitlePlan({
					allowTerminalTitleMutation: optionalBoolField(value, "allowTerminalTitleMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: actionRequiredTitleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function actionRequiredTitleActions(values:Array<Value>):Array<TuiSmokeActionRequiredTitleAction> {
		final out:Array<TuiSmokeActionRequiredTitleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeActionRequiredTitleAction({
				kind: TuiSmokeActionRequiredTitleActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				prefix: optionalStringField(value, "prefix", ""),
				items: optionalStringArrayField(value, "items"),
				excludedItems: optionalStringArrayField(value, "excludedItems"),
				values: actionRequiredTitleValues(optionalArrayField(value, "values")),
				expected: optionalStringField(value, "expected", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalTitleMutation: optionalBoolField(value, "noTerminalTitleMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function actionRequiredTitleValues(values:Array<Value>):Array<TuiSmokeActionRequiredTitleValue> {
		final out:Array<TuiSmokeActionRequiredTitleValue> = [];
		for (value in values) {
			out.push(new TuiSmokeActionRequiredTitleValue({
				item: optionalStringField(value, "item", ""),
				value: optionalStringField(value, "value", ""),
				present: optionalBoolField(value, "present", true)
			}));
		}
		return out;
	}

	static function optionalPopupConstsPlan(object:Value, name:String):Null<TuiSmokePopupConstsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePopupConstsPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: popupConstsActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function popupConstsActions(values:Array<Value>):Array<TuiSmokePopupConstsAction> {
		final out:Array<TuiSmokePopupConstsAction> = [];
		for (value in values) {
			out.push(new TuiSmokePopupConstsAction({
				kind: TuiSmokePopupConstsActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				acceptBindings: optionalStringArrayField(value, "acceptBindings"),
				acceptLabel: optionalStringField(value, "acceptLabel", ""),
				cancelBindings: optionalStringArrayField(value, "cancelBindings"),
				cancelLabel: optionalStringField(value, "cancelLabel", ""),
				expected: optionalStringField(value, "expected", ""),
				expectedMaxRows: optionalIntField(value, "expectedMaxRows", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalStatusLineStylePlan(object:Value, name:String):Null<TuiSmokeStatusLineStylePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusLineStylePlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: statusLineStyleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusLineStyleActions(values:Array<Value>):Array<TuiSmokeStatusLineStyleAction> {
		final out:Array<TuiSmokeStatusLineStyleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusLineStyleAction({
				kind: TuiSmokeStatusLineStyleActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				useThemeColors: optionalBoolField(value, "useThemeColors", true),
				themeAccent: optionalStringField(value, "themeAccent", ""),
				themeColor: optionalStringField(value, "themeColor", ""),
				segments: statusLineStyleSegments(optionalArrayField(value, "segments")),
				expectedPresent: optionalBoolField(value, "expectedPresent", false),
				expectedText: optionalStringField(value, "expectedText", ""),
				expectedSpans: optionalStringArrayField(value, "expectedSpans"),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function statusLineStyleSegments(values:Array<Value>):Array<TuiSmokeStatusLineStyleSegment> {
		final out:Array<TuiSmokeStatusLineStyleSegment> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusLineStyleSegment({
				item: optionalStringField(value, "item", ""),
				text: optionalStringField(value, "text", "")
			}));
		}
		return out;
	}

	static function optionalStatusSurfacePreviewPlan(object:Value, name:String):Null<TuiSmokeStatusSurfacePreviewPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusSurfacePreviewPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: statusSurfacePreviewActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusSurfacePreviewActions(values:Array<Value>):Array<TuiSmokeStatusSurfacePreviewAction> {
		final out:Array<TuiSmokeStatusSurfacePreviewAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusSurfacePreviewAction({
				kind: TuiSmokeStatusSurfacePreviewActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				item: optionalStringField(value, "item", ""),
				value: optionalStringField(value, "value", ""),
				items: optionalStringArrayField(value, "items"),
				expected: optionalStringField(value, "expected", ""),
				expectedPresent: optionalBoolField(value, "expectedPresent", false),
				expectedCount: optionalIntField(value, "expectedCount", 0),
				fallbackName: optionalStringField(value, "fallbackName", ""),
				fallbackDescription: optionalStringField(value, "fallbackDescription", ""),
				expectedName: optionalStringField(value, "expectedName", ""),
				expectedDescription: optionalStringField(value, "expectedDescription", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalPendingInputPreviewPlan(object:Value, name:String):Null<TuiSmokePendingInputPreviewPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePendingInputPreviewPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: pendingInputPreviewActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function pendingInputPreviewActions(values:Array<Value>):Array<TuiSmokePendingInputPreviewAction> {
		final out:Array<TuiSmokePendingInputPreviewAction> = [];
		for (value in values) {
			out.push(new TuiSmokePendingInputPreviewAction({
				kind: TuiSmokePendingInputPreviewActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				width: optionalIntField(value, "width", 0),
				pendingSteers: optionalStringArrayField(value, "pendingSteers"),
				rejectedSteers: optionalStringArrayField(value, "rejectedSteers"),
				queuedMessages: optionalStringArrayField(value, "queuedMessages"),
				editBinding: optionalStringField(value, "editBinding", "alt + ↑"),
				interruptBinding: optionalStringField(value, "interruptBinding", "esc"),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedNoEllipsis: optionalBoolField(value, "expectedNoEllipsis", false),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalPendingThreadApprovalsPlan(object:Value, name:String):Null<TuiSmokePendingThreadApprovalsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePendingThreadApprovalsPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: pendingThreadApprovalsActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function pendingThreadApprovalsActions(values:Array<Value>):Array<TuiSmokePendingThreadApprovalsAction> {
		final out:Array<TuiSmokePendingThreadApprovalsAction> = [];
		for (value in values) {
			out.push(new TuiSmokePendingThreadApprovalsAction({
				kind: TuiSmokePendingThreadApprovalsActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				width: optionalIntField(value, "width", 0),
				threads: optionalStringArrayField(value, "threads"),
				expectedChanged: optionalBoolField(value, "expectedChanged", false),
				expectedEmpty: optionalBoolField(value, "expectedEmpty", false),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalPromptArgsPlan(object:Value, name:String):Null<TuiSmokePromptArgsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePromptArgsPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: promptArgsActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function promptArgsActions(values:Array<Value>):Array<TuiSmokePromptArgsAction> {
		final out:Array<TuiSmokePromptArgsAction> = [];
		for (value in values) {
			out.push(new TuiSmokePromptArgsAction({
				kind: TuiSmokePromptArgsActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				line: optionalStringField(value, "line", ""),
				expectedPresent: optionalBoolField(value, "expectedPresent", false),
				expectedName: optionalStringField(value, "expectedName", ""),
				expectedRest: optionalStringField(value, "expectedRest", ""),
				expectedRestOffset: optionalIntField(value, "expectedRestOffset", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalUnifiedExecFooterPlan(object:Value, name:String):Null<TuiSmokeUnifiedExecFooterPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeUnifiedExecFooterPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: unifiedExecFooterActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function unifiedExecFooterActions(values:Array<Value>):Array<TuiSmokeUnifiedExecFooterAction> {
		final out:Array<TuiSmokeUnifiedExecFooterAction> = [];
		for (value in values) {
			out.push(new TuiSmokeUnifiedExecFooterAction({
				kind: TuiSmokeUnifiedExecFooterActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				width: optionalIntField(value, "width", 0),
				processes: optionalStringArrayField(value, "processes"),
				expectedChanged: optionalBoolField(value, "expectedChanged", false),
				expectedEmpty: optionalBoolField(value, "expectedEmpty", false),
				expectedPresent: optionalBoolField(value, "expectedPresent", false),
				expectedSummary: optionalStringField(value, "expectedSummary", ""),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalFileSearchPopupPlan(object:Value, name:String):Null<TuiSmokeFileSearchPopupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeFileSearchPopupPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: fileSearchPopupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function fileSearchPopupActions(values:Array<Value>):Array<TuiSmokeFileSearchPopupAction> {
		final out:Array<TuiSmokeFileSearchPopupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeFileSearchPopupAction({
				kind: TuiSmokeFileSearchPopupActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				query: optionalStringField(value, "query", ""),
				paths: optionalStringArrayField(value, "paths"),
				expectedDisplayQuery: optionalStringField(value, "expectedDisplayQuery", ""),
				expectedPendingQuery: optionalStringField(value, "expectedPendingQuery", ""),
				expectedWaiting: optionalBoolField(value, "expectedWaiting", false),
				expectedMatches: optionalStringArrayField(value, "expectedMatches"),
				expectedHeight: optionalIntField(value, "expectedHeight", 1),
				expectedSelectedPath: optionalStringField(value, "expectedSelectedPath", ""),
				expectedEmptyMessage: optionalStringField(value, "expectedEmptyMessage", ""),
				expectedSelectedIndex: optionalIntField(value, "expectedSelectedIndex", -1),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSkillPopupPlan(object:Value, name:String):Null<TuiSmokeSkillPopupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSkillPopupPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: skillPopupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function skillPopupActions(values:Array<Value>):Array<TuiSmokeSkillPopupAction> {
		final out:Array<TuiSmokeSkillPopupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSkillPopupAction({
				kind: TuiSmokeSkillPopupActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				query: optionalStringField(value, "query", ""),
				mentions: skillPopupMentions(optionalArrayField(value, "mentions")),
				expectedOrder: optionalStringArrayField(value, "expectedOrder"),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedHeight: optionalIntField(value, "expectedHeight", 3),
				expectedSelectedName: optionalStringField(value, "expectedSelectedName", ""),
				expectedSelectedInsertText: optionalStringField(value, "expectedSelectedInsertText", ""),
				expectedSelectedPath: optionalStringField(value, "expectedSelectedPath", ""),
				expectedSelectedIndex: optionalIntField(value, "expectedSelectedIndex", -1),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function skillPopupMentions(values:Array<Value>):Array<TuiSmokeSkillPopupMention> {
		final out:Array<TuiSmokeSkillPopupMention> = [];
		for (value in values) {
			out.push(new TuiSmokeSkillPopupMention({
				displayName: optionalStringField(value, "displayName", ""),
				description: optionalStringField(value, "description", ""),
				insertText: optionalStringField(value, "insertText", ""),
				searchTerms: optionalStringArrayField(value, "searchTerms"),
				path: optionalStringField(value, "path", ""),
				categoryTag: optionalStringField(value, "categoryTag", ""),
				sortRank: optionalIntField(value, "sortRank", 1)
			}));
		}
		return out;
	}

	static function optionalSelectionPopupCommonPlan(object:Value, name:String):Null<TuiSmokeSelectionPopupCommonPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSelectionPopupCommonPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: selectionPopupCommonActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function selectionPopupCommonActions(values:Array<Value>):Array<TuiSmokeSelectionPopupCommonAction> {
		final out:Array<TuiSmokeSelectionPopupCommonAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSelectionPopupCommonAction({
				kind: TuiSmokeSelectionPopupCommonActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				rows: selectionPopupRows(optionalArrayField(value, "rows")),
				columnMode: TuiSmokeSelectionPopupColumnMode.fromString(optionalStringField(value, "columnMode", "auto_visible")),
				x: optionalIntField(value, "x", 0),
				y: optionalIntField(value, "y", 0),
				width: optionalIntField(value, "width", 0),
				height: optionalIntField(value, "height", 0),
				maxResults: optionalIntField(value, "maxResults", 0),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				selectedIndex: optionalIntField(value, "selectedIndex", -1),
				nameColumnWidth: optionalIntField(value, "nameColumnWidth", 0),
				hasNameColumnWidth: optionalBoolField(value, "hasNameColumnWidth", false),
				emptyMessage: optionalStringField(value, "emptyMessage", "no rows"),
				rowIndex: optionalIntField(value, "rowIndex", 0),
				expectedInset: optionalStringField(value, "expectedInset", ""),
				expectedPaddingHeight: optionalIntField(value, "expectedPaddingHeight", 0),
				expectedDescCol: optionalIntField(value, "expectedDescCol", 0),
				expectedStartIndex: optionalIntField(value, "expectedStartIndex", 0),
				expectedRenderedLines: optionalIntField(value, "expectedRenderedLines", 0),
				expectedMeasuredHeight: optionalIntField(value, "expectedMeasuredHeight", 0),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedVisibleSelected: optionalBoolField(value, "expectedVisibleSelected", false),
				expectedWrapIndent: optionalIntField(value, "expectedWrapIndent", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function selectionPopupRows(values:Array<Value>):Array<TuiSmokeSelectionPopupRow> {
		final out:Array<TuiSmokeSelectionPopupRow> = [];
		for (value in values) {
			out.push(new TuiSmokeSelectionPopupRow({
				name: optionalStringField(value, "name", ""),
				prefix: optionalStringField(value, "prefix", ""),
				shortcut: optionalStringField(value, "shortcut", ""),
				matchIndices: optionalIntArrayField(value, "matchIndices"),
				description: optionalStringField(value, "description", ""),
				categoryTag: optionalStringField(value, "categoryTag", ""),
				disabledReason: optionalStringField(value, "disabledReason", ""),
				isDisabled: optionalBoolField(value, "isDisabled", false),
				wrapIndent: optionalIntField(value, "wrapIndent", -1)
			}));
		}
		return out;
	}

	static function optionalListSelectionPlan(object:Value, name:String):Null<TuiSmokeListSelectionPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeListSelectionPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: listSelectionActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function listSelectionActions(values:Array<Value>):Array<TuiSmokeListSelectionAction> {
		final out:Array<TuiSmokeListSelectionAction> = [];
		for (value in values) {
			out.push(new TuiSmokeListSelectionAction({
				kind: TuiSmokeListSelectionActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				items: listSelectionItems(optionalArrayField(value, "items")),
				isSearchable: optionalBoolField(value, "isSearchable", true),
				query: optionalStringField(value, "query", ""),
				previousSelectedActual: optionalIntField(value, "previousSelectedActual", -1),
				initialSelectedActual: optionalIntField(value, "initialSelectedActual", -1),
				selectedVisibleIndex: optionalIntField(value, "selectedVisibleIndex", -1),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				maxVisibleRows: optionalIntField(value, "maxVisibleRows", 8),
				width: optionalIntField(value, "width", 0),
				sideWidthKind: TuiSmokeListSelectionSideWidthKind.fromString(optionalStringField(value, "sideWidthKind", "disabled")),
				sideWidth: optionalIntField(value, "sideWidth", 0),
				sideMinWidth: optionalIntField(value, "sideMinWidth", 0),
				rowDisplay: TuiSmokeListSelectionRowDisplay.fromString(optionalStringField(value, "rowDisplay", "single_line")),
				headerHeight: optionalIntField(value, "headerHeight", 0),
				tabCount: optionalIntField(value, "tabCount", 0),
				footerNoteLines: optionalIntField(value, "footerNoteLines", 0),
				footerHintPresent: optionalBoolField(value, "footerHintPresent", false),
				sideContentHeight: optionalIntField(value, "sideContentHeight", 0),
				expectedContentWidth: optionalIntField(value, "expectedContentWidth", 0),
				expectedSideLayout: optionalStringField(value, "expectedSideLayout", ""),
				expectedDesiredHeight: optionalIntField(value, "expectedDesiredHeight", 0),
				expectedFilteredIndices: optionalIntArrayField(value, "expectedFilteredIndices"),
				expectedSelectedVisibleIndex: optionalIntField(value, "expectedSelectedVisibleIndex", -1),
				expectedSelectedActualIndex: optionalIntField(value, "expectedSelectedActualIndex", -1),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedAccepted: optionalBoolField(value, "expectedAccepted", false),
				expectedCancelled: optionalBoolField(value, "expectedCancelled", false),
				expectedLastSelectedActual: optionalIntField(value, "expectedLastSelectedActual", -1),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function listSelectionItems(values:Array<Value>):Array<TuiSmokeListSelectionItem> {
		final out:Array<TuiSmokeListSelectionItem> = [];
		for (value in values) {
			out.push(new TuiSmokeListSelectionItem({
				name: optionalStringField(value, "name", ""),
				description: optionalStringField(value, "description", ""),
				selectedDescription: optionalStringField(value, "selectedDescription", ""),
				searchValue: optionalStringField(value, "searchValue", ""),
				isCurrent: optionalBoolField(value, "isCurrent", false),
				isDefault: optionalBoolField(value, "isDefault", false),
				isDisabled: optionalBoolField(value, "isDisabled", false),
				disabledReason: optionalStringField(value, "disabledReason", ""),
				dismissOnSelect: optionalBoolField(value, "dismissOnSelect", true)
			}));
		}
		return out;
	}

	static function optionalCommandPopupPlan(object:Value, name:String):Null<TuiSmokeCommandPopupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeCommandPopupPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					catalog: commandPopupItems(optionalArrayField(value, "catalog")),
					actions: commandPopupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function commandPopupActions(values:Array<Value>):Array<TuiSmokeCommandPopupAction> {
		final out:Array<TuiSmokeCommandPopupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeCommandPopupAction({
				kind: TuiSmokeCommandPopupActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				composerText: optionalStringField(value, "composerText", ""),
				previousFilter: optionalStringField(value, "previousFilter", ""),
				selectedIndex: optionalIntField(value, "selectedIndex", 0),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				maxVisibleRows: optionalIntField(value, "maxVisibleRows", 8),
				width: optionalIntField(value, "width", 72),
				moveCount: optionalIntField(value, "moveCount", 1),
				catalog: commandPopupItems(optionalArrayField(value, "catalog")),
				collaborationModesEnabled: optionalBoolField(value, "collaborationModesEnabled", false),
				connectorsEnabled: optionalBoolField(value, "connectorsEnabled", false),
				pluginsCommandEnabled: optionalBoolField(value, "pluginsCommandEnabled", false),
				serviceTierCommandsEnabled: optionalBoolField(value, "serviceTierCommandsEnabled", false),
				goalCommandEnabled: optionalBoolField(value, "goalCommandEnabled", false),
				personalityCommandEnabled: optionalBoolField(value, "personalityCommandEnabled", false),
				realtimeConversationEnabled: optionalBoolField(value, "realtimeConversationEnabled", false),
				audioDeviceSelectionEnabled: optionalBoolField(value, "audioDeviceSelectionEnabled", false),
				windowsDegradedSandboxActive: optionalBoolField(value, "windowsDegradedSandboxActive", false),
				sideConversationActive: optionalBoolField(value, "sideConversationActive", false),
				expectedFilter: optionalStringField(value, "expectedFilter", ""),
				expectedCommands: optionalStringArrayField(value, "expectedCommands"),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedSelectedIndex: optionalIntField(value, "expectedSelectedIndex", -1),
				expectedSelectedCommand: optionalStringField(value, "expectedSelectedCommand", ""),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				expectedAccepted: optionalBoolField(value, "expectedAccepted", false),
				expectedCancelled: optionalBoolField(value, "expectedCancelled", false),
				expectedAcceptedKind: optionalStringField(value, "expectedAcceptedKind", ""),
				expectedAcceptedId: optionalStringField(value, "expectedAcceptedId", ""),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function commandPopupItems(values:Array<Value>):Array<TuiSmokeCommandPopupItem> {
		final out:Array<TuiSmokeCommandPopupItem> = [];
		for (value in values) {
			out.push(new TuiSmokeCommandPopupItem({
				kind: TuiSmokeCommandPopupItemKind.fromString(optionalStringField(value, "kind", "builtin")),
				command: optionalStringField(value, "command", ""),
				description: optionalStringField(value, "description", ""),
				id: optionalStringField(value, "id", ""),
				isAlias: optionalBoolField(value, "isAlias", false),
				isDebug: optionalBoolField(value, "isDebug", false),
				isApps: optionalBoolField(value, "isApps", false),
				requiresFlag: optionalStringField(value, "requiresFlag", ""),
				availableInSideConversation: optionalBoolField(value, "availableInSideConversation", false)
			}));
		}
		return out;
	}

	static function optionalMultiSelectPlan(object:Value, name:String):Null<TuiSmokeMultiSelectPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeMultiSelectPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppEventDelivery: optionalBoolField(value, "allowAppEventDelivery", false),
					items: multiSelectItems(optionalArrayField(value, "items")),
					actions: multiSelectActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function multiSelectActions(values:Array<Value>):Array<TuiSmokeMultiSelectAction> {
		final out:Array<TuiSmokeMultiSelectAction> = [];
		for (value in values) {
			out.push(new TuiSmokeMultiSelectAction({
				kind: TuiSmokeMultiSelectActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				items: multiSelectItems(optionalArrayField(value, "items")),
				query: optionalStringField(value, "query", ""),
				selectedIndex: optionalIntField(value, "selectedIndex", 0),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				maxVisibleRows: optionalIntField(value, "maxVisibleRows", 8),
				width: optionalIntField(value, "width", 72),
				headerHeight: optionalIntField(value, "headerHeight", 1),
				hasPreview: optionalBoolField(value, "hasPreview", false),
				orderingEnabled: optionalBoolField(value, "orderingEnabled", false),
				moveCount: optionalIntField(value, "moveCount", 1),
				expectedQuery: optionalStringField(value, "expectedQuery", ""),
				expectedFilteredIndices: optionalIntArrayField(value, "expectedFilteredIndices"),
				expectedOrder: optionalStringArrayField(value, "expectedOrder"),
				expectedEnabledIds: optionalStringArrayField(value, "expectedEnabledIds"),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedSelectedIndex: optionalIntField(value, "expectedSelectedIndex", -1),
				expectedSelectedActual: optionalIntField(value, "expectedSelectedActual", -1),
				expectedScrollTop: optionalIntField(value, "expectedScrollTop", 0),
				expectedChangeCount: optionalIntField(value, "expectedChangeCount", 0),
				expectedConfirmedIds: optionalStringArrayField(value, "expectedConfirmedIds"),
				expectedCancelled: optionalBoolField(value, "expectedCancelled", false),
				expectedComplete: optionalBoolField(value, "expectedComplete", false),
				expectedPreview: optionalStringField(value, "expectedPreview", ""),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppEventDelivery: optionalBoolField(value, "noAppEventDelivery", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalAppLinkViewPlan(object:Value, name:String):Null<TuiSmokeAppLinkViewPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppLinkViewPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowBrowserLaunch: optionalBoolField(value, "allowBrowserLaunch", false),
					allowAppServerDelivery: optionalBoolField(value, "allowAppServerDelivery", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: appLinkViewActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function appLinkViewActions(values:Array<Value>):Array<TuiSmokeAppLinkViewAction> {
		final out:Array<TuiSmokeAppLinkViewAction> = [];
		for (value in values) {
			out.push(new TuiSmokeAppLinkViewAction({
				kind: TuiSmokeAppLinkViewActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				serverName: optionalStringField(value, "serverName", ""),
				requestId: optionalStringField(value, "requestId", ""),
				threadId: optionalStringField(value, "threadId", ""),
				url: optionalStringField(value, "url", ""),
				elicitationId: optionalStringField(value, "elicitationId", ""),
				message: optionalStringField(value, "message", ""),
				hasAuthMeta: optionalBoolField(value, "hasAuthMeta", false),
				authFailure: optionalBoolField(value, "authFailure", false),
				connectorId: optionalStringField(value, "connectorId", ""),
				connectorName: optionalStringField(value, "connectorName", ""),
				appId: optionalStringField(value, "appId", ""),
				title: optionalStringField(value, "title", ""),
				description: optionalStringField(value, "description", ""),
				instructions: optionalStringField(value, "instructions", ""),
				isInstalled: optionalBoolField(value, "isInstalled", false),
				isEnabled: optionalBoolField(value, "isEnabled", false),
				suggestionType: optionalStringField(value, "suggestionType", ""),
				hasTarget: optionalBoolField(value, "hasTarget", false),
				screen: optionalStringField(value, "screen", "link"),
				selectedIndex: optionalIntField(value, "selectedIndex", 0),
				direction: optionalStringField(value, "direction", "next"),
				moveCount: optionalIntField(value, "moveCount", 1),
				dismissServerName: optionalStringField(value, "dismissServerName", ""),
				dismissRequestId: optionalStringField(value, "dismissRequestId", ""),
				width: optionalIntField(value, "width", 72),
				expectedAdmitted: optionalBoolField(value, "expectedAdmitted", false),
				expectedSummary: optionalStringField(value, "expectedSummary", ""),
				expectedLabels: optionalStringArrayField(value, "expectedLabels"),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				expectedSelectedIndex: optionalIntField(value, "expectedSelectedIndex", 0),
				expectedScreen: optionalStringField(value, "expectedScreen", "link"),
				expectedEnabled: optionalBoolField(value, "expectedEnabled", false),
				expectedComplete: optionalBoolField(value, "expectedComplete", false),
				expectedEvents: optionalStringArrayField(value, "expectedEvents"),
				expectedDismissed: optionalBoolField(value, "expectedDismissed", false),
				expectedRequiresTitleAction: optionalBoolField(value, "expectedRequiresTitleAction", false),
				expectedHeight: optionalIntField(value, "expectedHeight", 0),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noBrowserLaunch: optionalBoolField(value, "noBrowserLaunch", false),
				noAppServerDelivery: optionalBoolField(value, "noAppServerDelivery", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalCustomPromptPlan(object:Value, name:String):Null<TuiSmokeCustomPromptPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeCustomPromptPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowPromptCallback: optionalBoolField(value, "allowPromptCallback", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: customPromptActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function customPromptActions(values:Array<Value>):Array<TuiSmokeCustomPromptAction> {
		final out:Array<TuiSmokeCustomPromptAction> = [];
		for (value in values) {
			out.push(new TuiSmokeCustomPromptAction({
				kind: TuiSmokeCustomPromptActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				title: optionalStringField(value, "title", ""),
				placeholder: optionalStringField(value, "placeholder", ""),
				contextLabel: optionalStringField(value, "contextLabel", ""),
				initialText: optionalStringField(value, "initialText", ""),
				width: optionalIntField(value, "width", 72),
				areaHeight: optionalIntField(value, "areaHeight", 12),
				pasteText: optionalStringField(value, "pasteText", ""),
				steps: customPromptSteps(optionalArrayField(value, "steps")),
				expectedText: optionalStringField(value, "expectedText", ""),
				expectedCursor: optionalIntField(value, "expectedCursor", 0),
				expectedSubmitted: optionalStringField(value, "expectedSubmitted", ""),
				expectedCompletion: optionalStringField(value, "expectedCompletion", ""),
				expectedPasteAccepted: optionalBoolField(value, "expectedPasteAccepted", false),
				expectedInputHeight: optionalIntField(value, "expectedInputHeight", 0),
				expectedDesiredHeight: optionalIntField(value, "expectedDesiredHeight", 0),
				expectedCursorAvailable: optionalBoolField(value, "expectedCursorAvailable", false),
				expectedRows: optionalStringArrayField(value, "expectedRows"),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noPromptCallback: optionalBoolField(value, "noPromptCallback", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function customPromptSteps(values:Array<Value>):Array<TuiSmokeCustomPromptStep> {
		final out:Array<TuiSmokeCustomPromptStep> = [];
		for (value in values) {
			out.push(new TuiSmokeCustomPromptStep({
				kind: TuiSmokeCustomPromptStepKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				modifiers: optionalStringField(value, "modifiers", "none"),
				elapsedMs: optionalIntField(value, "elapsedMs", 0)
			}));
		}
		return out;
	}

	static function optionalPasteBurstPlan(object:Value, name:String):Null<TuiSmokePasteBurstPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePasteBurstPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowTextareaMutation: optionalBoolField(value, "allowTextareaMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerDelivery: optionalBoolField(value, "allowAppServerDelivery", false),
					actions: pasteBurstActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function pasteBurstActions(values:Array<Value>):Array<TuiSmokePasteBurstAction> {
		final out:Array<TuiSmokePasteBurstAction> = [];
		for (value in values) {
			out.push(new TuiSmokePasteBurstAction({
				kind: TuiSmokePasteBurstActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				beforeText: optionalStringField(value, "beforeText", ""),
				retroChars: optionalIntField(value, "retroChars", 0),
				firstChar: optionalStringField(value, "firstChar", "a"),
				secondChar: optionalStringField(value, "secondChar", "b"),
				thirdChar: optionalStringField(value, "thirdChar", "c"),
				expectedTrace: optionalStringField(value, "expectedTrace", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noTextareaMutation: optionalBoolField(value, "noTextareaMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerDelivery: optionalBoolField(value, "noAppServerDelivery", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalTextAreaPlan(object:Value, name:String):Null<TuiSmokeTextAreaPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTextAreaPlan({
					allowTerminalMutation: optionalBoolField(value, "allowTerminalMutation", false),
					allowRatatuiBuffer: optionalBoolField(value, "allowRatatuiBuffer", false),
					allowClipboardMutation: optionalBoolField(value, "allowClipboardMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerDelivery: optionalBoolField(value, "allowAppServerDelivery", false),
					actions: textAreaActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function textAreaActions(values:Array<Value>):Array<TuiSmokeTextAreaAction> {
		final out:Array<TuiSmokeTextAreaAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTextAreaAction({
				kind: TuiSmokeTextAreaActionKind.fromString(stringField(value, "kind", "")),
				name: optionalStringField(value, "name", ""),
				text: optionalStringField(value, "text", ""),
				cursor: optionalIntField(value, "cursor", 0),
				newText: optionalStringField(value, "newText", ""),
				insertText: optionalStringField(value, "insertText", ""),
				replaceText: optionalStringField(value, "replaceText", ""),
				insertPos: optionalIntField(value, "insertPos", 0),
				rangeStart: optionalIntField(value, "rangeStart", 0),
				rangeEnd: optionalIntField(value, "rangeEnd", 0),
				count: optionalIntField(value, "count", 1),
				width: optionalIntField(value, "width", 80),
				areaX: optionalIntField(value, "areaX", 0),
				areaY: optionalIntField(value, "areaY", 0),
				areaHeight: optionalIntField(value, "areaHeight", 10),
				scroll: optionalIntField(value, "scroll", 0),
				vimEnabled: optionalBoolField(value, "vimEnabled", false),
				vimMode: optionalStringField(value, "vimMode", "insert"),
				killBuffer: optionalStringField(value, "killBuffer", ""),
				elements: textAreaElements(optionalArrayField(value, "elements")),
				expectedTrace: optionalStringField(value, "expectedTrace", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				noTerminalMutation: optionalBoolField(value, "noTerminalMutation", false),
				noRatatuiBuffer: optionalBoolField(value, "noRatatuiBuffer", false),
				noClipboardMutation: optionalBoolField(value, "noClipboardMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerDelivery: optionalBoolField(value, "noAppServerDelivery", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function textAreaElements(values:Array<Value>):Array<TuiSmokeTextAreaElement> {
		final out:Array<TuiSmokeTextAreaElement> = [];
		for (value in values) {
			out.push(new TuiSmokeTextAreaElement({
				start: optionalIntField(value, "start", 0),
				end: optionalIntField(value, "end", 0),
				name: optionalStringField(value, "name", "")
			}));
		}
		return out;
	}

	static function multiSelectItems(values:Array<Value>):Array<TuiSmokeMultiSelectItem> {
		final out:Array<TuiSmokeMultiSelectItem> = [];
		for (value in values) {
			out.push(new TuiSmokeMultiSelectItem({
				id: optionalStringField(value, "id", ""),
				name: optionalStringField(value, "name", ""),
				description: optionalStringField(value, "description", ""),
				enabled: optionalBoolField(value, "enabled", false),
				orderable: optionalBoolField(value, "orderable", true),
				sectionBreakAfter: optionalBoolField(value, "sectionBreakAfter", false)
			}));
		}
		return out;
	}

	static function optionalIntArrayField(object:Value, name:String):Array<Int> {
		final values = optionalArrayField(object, name);
		final out:Array<Int> = [];
		for (value in values) {
			switch value {
				case JNumber(number):
					out.push(Std.int(number));
				case _:
			}
		}
		return out;
	}

	static function optionalGoalMenuPlan(object:Value, name:String):Null<TuiSmokeGoalMenuPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeGoalMenuPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: goalMenuActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function goalMenuActions(values:Array<Value>):Array<TuiSmokeGoalMenuAction> {
		final out:Array<TuiSmokeGoalMenuAction> = [];
		for (value in values) {
			out.push(new TuiSmokeGoalMenuAction({
				kind: TuiSmokeGoalMenuActionKind.fromString(stringField(value, "kind", "")),
				status: optionalStringField(value, "status", ""),
				objective: optionalStringField(value, "objective", ""),
				commandHint: optionalStringField(value, "commandHint", ""),
				indicator: optionalStringField(value, "indicator", ""),
				usage: optionalStringField(value, "usage", ""),
				validationSource: optionalStringField(value, "validationSource", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				tokenBudget: optionalIntField(value, "tokenBudget", 0),
				tokensUsed: optionalIntField(value, "tokensUsed", 0),
				timeUsedSeconds: optionalIntField(value, "timeUsedSeconds", 0),
				actualChars: optionalIntField(value, "actualChars", 0),
				maxChars: optionalIntField(value, "maxChars", 0),
				activeTurnElapsedSeconds: optionalIntField(value, "activeTurnElapsedSeconds", 0),
				budgetPresent: optionalBoolField(value, "budgetPresent", false),
				summaryInserted: optionalBoolField(value, "summaryInserted", false),
				editPromptOpened: optionalBoolField(value, "editPromptOpened", false),
				editedStatus: optionalStringField(value, "editedStatus", ""),
				setObjectiveEvent: optionalBoolField(value, "setObjectiveEvent", false),
				resumePromptOpened: optionalBoolField(value, "resumePromptOpened", false),
				resumeDefaultSelected: optionalBoolField(value, "resumeDefaultSelected", false),
				setStatusEvent: optionalBoolField(value, "setStatusEvent", false),
				leavePausedSelected: optionalBoolField(value, "leavePausedSelected", false),
				allowed: optionalBoolField(value, "allowed", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				composerCleared: optionalBoolField(value, "composerCleared", false),
				pendingSubmissionDrained: optionalBoolField(value, "pendingSubmissionDrained", false),
				activeGoalPaused: optionalBoolField(value, "activeGoalPaused", false),
				currentGoalCleared: optionalBoolField(value, "currentGoalCleared", false),
				collaborationIndicatorUpdated: optionalBoolField(value, "collaborationIndicatorUpdated", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalReviewModePlan(object:Value, name:String):Null<TuiSmokeReviewModePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeReviewModePlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: reviewModeActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function reviewModeActions(values:Array<Value>):Array<TuiSmokeReviewModeAction> {
		final out:Array<TuiSmokeReviewModeAction> = [];
		for (value in values) {
			out.push(new TuiSmokeReviewModeAction({
				kind: TuiSmokeReviewModeActionKind.fromString(stringField(value, "kind", "")),
				target: optionalStringField(value, "target", ""),
				hint: optionalStringField(value, "hint", ""),
				pickerKind: optionalStringField(value, "pickerKind", ""),
				prompt: optionalStringField(value, "prompt", ""),
				guardianStatus: optionalStringField(value, "guardianStatus", ""),
				risk: optionalStringField(value, "risk", ""),
				actionSummary: optionalStringField(value, "actionSummary", ""),
				statusHeader: optionalStringField(value, "statusHeader", ""),
				statusDetails: optionalStringField(value, "statusDetails", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				itemCount: optionalIntField(value, "itemCount", 0),
				branchCount: optionalIntField(value, "branchCount", 0),
				commitCount: optionalIntField(value, "commitCount", 0),
				pendingSteerCount: optionalIntField(value, "pendingSteerCount", 0),
				queuedMessageCount: optionalIntField(value, "queuedMessageCount", 0),
				rejectedSteerCount: optionalIntField(value, "rejectedSteerCount", 0),
				submittedCount: optionalIntField(value, "submittedCount", 0),
				preReviewPercent: optionalIntField(value, "preReviewPercent", 0),
				reviewPercent: optionalIntField(value, "reviewPercent", 0),
				restoredPercent: optionalIntField(value, "restoredPercent", 0),
				parallelCount: optionalIntField(value, "parallelCount", 0),
				remainingCount: optionalIntField(value, "remainingCount", 0),
				popupOpened: optionalBoolField(value, "popupOpened", false),
				branchPickerEvent: optionalBoolField(value, "branchPickerEvent", false),
				commitPickerEvent: optionalBoolField(value, "commitPickerEvent", false),
				uncommittedReviewEvent: optionalBoolField(value, "uncommittedReviewEvent", false),
				customPromptEvent: optionalBoolField(value, "customPromptEvent", false),
				dismissParentOnChildAccept: optionalBoolField(value, "dismissParentOnChildAccept", false),
				searchable: optionalBoolField(value, "searchable", false),
				emptyIgnored: optionalBoolField(value, "emptyIgnored", false),
				reviewModeEntered: optionalBoolField(value, "reviewModeEntered", false),
				reviewModeExited: optionalBoolField(value, "reviewModeExited", false),
				bannerInserted: optionalBoolField(value, "bannerInserted", false),
				reviewPromptSuppressed: optionalBoolField(value, "reviewPromptSuppressed", false),
				assistantRendered: optionalBoolField(value, "assistantRendered", false),
				pendingSteerSubmitted: optionalBoolField(value, "pendingSteerSubmitted", false),
				nonSteerableRejected: optionalBoolField(value, "nonSteerableRejected", false),
				rejectedSteersPrepended: optionalBoolField(value, "rejectedSteersPrepended", false),
				mergedAfterReviewExit: optionalBoolField(value, "mergedAfterReviewExit", false),
				existingQueuePreserved: optionalBoolField(value, "existingQueuePreserved", false),
				escWarningInserted: optionalBoolField(value, "escWarningInserted", false),
				interruptSuppressed: optionalBoolField(value, "interruptSuppressed", false),
				tokenSnapshotSaved: optionalBoolField(value, "tokenSnapshotSaved", false),
				tokenRestored: optionalBoolField(value, "tokenRestored", false),
				statusSet: optionalBoolField(value, "statusSet", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				warningInserted: optionalBoolField(value, "warningInserted", false),
				denialStored: optionalBoolField(value, "denialStored", false),
				approvalSubmitted: optionalBoolField(value, "approvalSubmitted", false),
				remainingStatusVisible: optionalBoolField(value, "remainingStatusVisible", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalTranscriptHistoryPlan(object:Value, name:String):Null<TuiSmokeTranscriptHistoryPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTranscriptHistoryPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: transcriptHistoryActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function transcriptHistoryActions(values:Array<Value>):Array<TuiSmokeTranscriptHistoryAction> {
		final out:Array<TuiSmokeTranscriptHistoryAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTranscriptHistoryAction({
				kind: TuiSmokeTranscriptHistoryActionKind.fromString(stringField(value, "kind", "")),
				cellKind: optionalStringField(value, "cellKind", ""),
				renderMode: optionalStringField(value, "renderMode", ""),
				source: optionalStringField(value, "source", ""),
				message: optionalStringField(value, "message", ""),
				rawText: optionalStringField(value, "rawText", ""),
				transcriptText: optionalStringField(value, "transcriptText", ""),
				toolName: optionalStringField(value, "toolName", ""),
				status: optionalStringField(value, "status", ""),
				command: optionalStringField(value, "command", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				displayLines: optionalIntField(value, "displayLines", 0),
				rawLines: optionalIntField(value, "rawLines", 0),
				transcriptLines: optionalIntField(value, "transcriptLines", 0),
				height: optionalIntField(value, "height", 0),
				visibleUserTurns: optionalIntField(value, "visibleUserTurns", 0),
				copyEntries: optionalIntField(value, "copyEntries", 0),
				revision: optionalIntField(value, "revision", 0),
				exitCode: optionalIntField(value, "exitCode", 0),
				inserted: optionalBoolField(value, "inserted", false),
				visible: optionalBoolField(value, "visible", false),
				rawMode: optionalBoolField(value, "rawMode", false),
				richMode: optionalBoolField(value, "richMode", false),
				hyperlinkAnnotated: optionalBoolField(value, "hyperlinkAnnotated", false),
				transcriptOnly: optionalBoolField(value, "transcriptOnly", false),
				activeCell: optionalBoolField(value, "activeCell", false),
				activeRevisionBumped: optionalBoolField(value, "activeRevisionBumped", false),
				streamStarted: optionalBoolField(value, "streamStarted", false),
				streamConsolidated: optionalBoolField(value, "streamConsolidated", false),
				separatorInserted: optionalBoolField(value, "separatorInserted", false),
				copyRecorded: optionalBoolField(value, "copyRecorded", false),
				trailingBlankTrimmed: optionalBoolField(value, "trailingBlankTrimmed", false),
				remoteImagesSummarized: optionalBoolField(value, "remoteImagesSummarized", false),
				textElementsStyled: optionalBoolField(value, "textElementsStyled", false),
				noticeHintShown: optionalBoolField(value, "noticeHintShown", false),
				warningDeduped: optionalBoolField(value, "warningDeduped", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				commandGrouped: optionalBoolField(value, "commandGrouped", false),
				orphanHistoryInserted: optionalBoolField(value, "orphanHistoryInserted", false),
				toolExtraImageCell: optionalBoolField(value, "toolExtraImageCell", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalTranscriptOverlayPlan(object:Value, name:String):Null<TuiSmokeTranscriptOverlayPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTranscriptOverlayPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: transcriptOverlayActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function transcriptOverlayActions(values:Array<Value>):Array<TuiSmokeTranscriptOverlayAction> {
		final out:Array<TuiSmokeTranscriptOverlayAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTranscriptOverlayAction({
				kind: TuiSmokeTranscriptOverlayActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				title: optionalStringField(value, "title", ""),
				renderMode: optionalStringField(value, "renderMode", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				height: optionalIntField(value, "height", 0),
				committedCellCount: optionalIntField(value, "committedCellCount", 0),
				liveTailLines: optionalIntField(value, "liveTailLines", 0),
				renderableCount: optionalIntField(value, "renderableCount", 0),
				revision: optionalIntField(value, "revision", 0),
				animationTick: optionalIntField(value, "animationTick", -1),
				pageHeight: optionalIntField(value, "pageHeight", 0),
				scrollOffset: optionalIntField(value, "scrollOffset", 0),
				selectedCell: optionalIntField(value, "selectedCell", -1),
				replacedCount: optionalIntField(value, "replacedCount", 0),
				consolidatedStart: optionalIntField(value, "consolidatedStart", 0),
				consolidatedEnd: optionalIntField(value, "consolidatedEnd", 0),
				inserted: optionalBoolField(value, "inserted", false),
				opened: optionalBoolField(value, "opened", false),
				closed: optionalBoolField(value, "closed", false),
				altScreenEntered: optionalBoolField(value, "altScreenEntered", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				keyPresent: optionalBoolField(value, "keyPresent", false),
				recomputed: optionalBoolField(value, "recomputed", false),
				cacheHit: optionalBoolField(value, "cacheHit", false),
				dropped: optionalBoolField(value, "dropped", false),
				followBottom: optionalBoolField(value, "followBottom", false),
				streamContinuation: optionalBoolField(value, "streamContinuation", false),
				topInset: optionalBoolField(value, "topInset", false),
				hyperlinkAnnotated: optionalBoolField(value, "hyperlinkAnnotated", false),
				rawMode: optionalBoolField(value, "rawMode", false),
				richMode: optionalBoolField(value, "richMode", false),
				activeRevisionBumped: optionalBoolField(value, "activeRevisionBumped", false),
				animationScheduled: optionalBoolField(value, "animationScheduled", false),
				scrolledToBottom: optionalBoolField(value, "scrolledToBottom", false),
				highlightApplied: optionalBoolField(value, "highlightApplied", false),
				highlightCleared: optionalBoolField(value, "highlightCleared", false),
				continuousPaging: optionalBoolField(value, "continuousPaging", false),
				roundTripped: optionalBoolField(value, "roundTripped", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalBacktrackOverlayPlan(object:Value, name:String):Null<TuiSmokeBacktrackOverlayPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeBacktrackOverlayPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: backtrackOverlayActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function backtrackOverlayActions(values:Array<Value>):Array<TuiSmokeBacktrackOverlayAction> {
		final out:Array<TuiSmokeBacktrackOverlayAction> = [];
		for (value in values) {
			out.push(new TuiSmokeBacktrackOverlayAction({
				kind: TuiSmokeBacktrackOverlayActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				threadId: optionalStringField(value, "threadId", ""),
				baseThreadId: optionalStringField(value, "baseThreadId", ""),
				message: optionalStringField(value, "message", ""),
				prefill: optionalStringField(value, "prefill", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				direction: optionalStringField(value, "direction", ""),
				userCount: optionalIntField(value, "userCount", 0),
				nthUserMessage: optionalIntField(value, "nthUserMessage", -1),
				cellIndex: optionalIntField(value, "cellIndex", -1),
				previousNthUserMessage: optionalIntField(value, "previousNthUserMessage", -1),
				nextNthUserMessage: optionalIntField(value, "nextNthUserMessage", -1),
				numTurns: optionalIntField(value, "numTurns", 0),
				originalCellCount: optionalIntField(value, "originalCellCount", 0),
				trimmedCellCount: optionalIntField(value, "trimmedCellCount", 0),
				copyHistoryUserCount: optionalIntField(value, "copyHistoryUserCount", 0),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				localImageCount: optionalIntField(value, "localImageCount", 0),
				textElementCount: optionalIntField(value, "textElementCount", 0),
				composerEmpty: optionalBoolField(value, "composerEmpty", false),
				primed: optionalBoolField(value, "primed", false),
				baseThreadCaptured: optionalBoolField(value, "baseThreadCaptured", false),
				hintShown: optionalBoolField(value, "hintShown", false),
				targetAvailable: optionalBoolField(value, "targetAvailable", false),
				overlayOpened: optionalBoolField(value, "overlayOpened", false),
				overlayPreviewActive: optionalBoolField(value, "overlayPreviewActive", false),
				altScreenEntered: optionalBoolField(value, "altScreenEntered", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				hintCleared: optionalBoolField(value, "hintCleared", false),
				highlightApplied: optionalBoolField(value, "highlightApplied", false),
				highlightCleared: optionalBoolField(value, "highlightCleared", false),
				steppedOlder: optionalBoolField(value, "steppedOlder", false),
				steppedNewer: optionalBoolField(value, "steppedNewer", false),
				clamped: optionalBoolField(value, "clamped", false),
				confirmed: optionalBoolField(value, "confirmed", false),
				closed: optionalBoolField(value, "closed", false),
				selectionMatchedThread: optionalBoolField(value, "selectionMatchedThread", false),
				pendingRollbackSet: optionalBoolField(value, "pendingRollbackSet", false),
				pendingRollbackCleared: optionalBoolField(value, "pendingRollbackCleared", false),
				pendingRollbackBlocked: optionalBoolField(value, "pendingRollbackBlocked", false),
				rollbackSubmitted: optionalBoolField(value, "rollbackSubmitted", false),
				composerPrefilled: optionalBoolField(value, "composerPrefilled", false),
				remoteImagesRestored: optionalBoolField(value, "remoteImagesRestored", false),
				copyHistoryTruncated: optionalBoolField(value, "copyHistoryTruncated", false),
				overlayReplaced: optionalBoolField(value, "overlayReplaced", false),
				deferredHistoryCleared: optionalBoolField(value, "deferredHistoryCleared", false),
				renderPending: optionalBoolField(value, "renderPending", false),
				ignoredThreadMismatch: optionalBoolField(value, "ignoredThreadMismatch", false),
				stateReset: optionalBoolField(value, "stateReset", false),
				infoInserted: optionalBoolField(value, "infoInserted", false),
				sideConversationRejected: optionalBoolField(value, "sideConversationRejected", false),
				vimInsertAllowed: optionalBoolField(value, "vimInsertAllowed", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalKeymapRawOutputPlan(object:Value, name:String):Null<TuiSmokeKeymapRawOutputPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeKeymapRawOutputPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: keymapRawOutputActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function keymapRawOutputActions(values:Array<Value>):Array<TuiSmokeKeymapRawOutputAction> {
		final out:Array<TuiSmokeKeymapRawOutputAction> = [];
		for (value in values) {
			out.push(new TuiSmokeKeymapRawOutputAction({
				kind: TuiSmokeKeymapRawOutputActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				surface: optionalStringField(value, "surface", ""),
				actionName: optionalStringField(value, "actionName", ""),
				binding: optionalStringField(value, "binding", ""),
				previousBinding: optionalStringField(value, "previousBinding", ""),
				conflictAction: optionalStringField(value, "conflictAction", ""),
				conflictWith: optionalStringField(value, "conflictWith", ""),
				errorPath: optionalStringField(value, "errorPath", ""),
				fallback: optionalStringField(value, "fallback", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				beforeCount: optionalIntField(value, "beforeCount", 0),
				afterCount: optionalIntField(value, "afterCount", 0),
				aliasCount: optionalIntField(value, "aliasCount", 0),
				modifiedDeleteCount: optionalIntField(value, "modifiedDeleteCount", 0),
				rawOutputBefore: optionalBoolField(value, "rawOutputBefore", false),
				rawOutputAfter: optionalBoolField(value, "rawOutputAfter", false),
				matched: optionalBoolField(value, "matched", false),
				remapped: optionalBoolField(value, "remapped", false),
				defaultPruned: optionalBoolField(value, "defaultPruned", false),
				unbound: optionalBoolField(value, "unbound", false),
				fallbackSuppressed: optionalBoolField(value, "fallbackSuppressed", false),
				preserved: optionalBoolField(value, "preserved", false),
				assigned: optionalBoolField(value, "assigned", false),
				conflict: optionalBoolField(value, "conflict", false),
				rejected: optionalBoolField(value, "rejected", false),
				legacyPruned: optionalBoolField(value, "legacyPruned", false),
				stringOrArrayAccepted: optionalBoolField(value, "stringOrArrayAccepted", false),
				deduped: optionalBoolField(value, "deduped", false),
				rawOutputToggled: optionalBoolField(value, "rawOutputToggled", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalRawOutputRenderPlan(object:Value, name:String):Null<TuiSmokeRawOutputRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeRawOutputRenderPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: rawOutputRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function rawOutputRenderActions(values:Array<Value>):Array<TuiSmokeRawOutputRenderAction> {
		final out:Array<TuiSmokeRawOutputRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeRawOutputRenderAction({
				kind: TuiSmokeRawOutputRenderActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				cellKind: optionalStringField(value, "cellKind", ""),
				renderMode: optionalStringField(value, "renderMode", ""),
				status: optionalStringField(value, "status", ""),
				command: optionalStringField(value, "command", ""),
				toolName: optionalStringField(value, "toolName", ""),
				notice: optionalStringField(value, "notice", ""),
				slashCommand: optionalStringField(value, "slashCommand", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				previousWidth: optionalIntField(value, "previousWidth", 0),
				displayLines: optionalIntField(value, "displayLines", 0),
				rawLines: optionalIntField(value, "rawLines", 0),
				transcriptLines: optionalIntField(value, "transcriptLines", 0),
				copyLines: optionalIntField(value, "copyLines", 0),
				visibleLines: optionalIntField(value, "visibleLines", 0),
				hiddenLines: optionalIntField(value, "hiddenLines", 0),
				revisionBefore: optionalIntField(value, "revisionBefore", 0),
				revisionAfter: optionalIntField(value, "revisionAfter", 0),
				rawOutputBefore: optionalBoolField(value, "rawOutputBefore", false),
				rawOutputAfter: optionalBoolField(value, "rawOutputAfter", false),
				configUpdated: optionalBoolField(value, "configUpdated", false),
				noticeInserted: optionalBoolField(value, "noticeInserted", false),
				statusVisible: optionalBoolField(value, "statusVisible", false),
				richMode: optionalBoolField(value, "richMode", false),
				rawMode: optionalBoolField(value, "rawMode", false),
				hyperlinkAnnotated: optionalBoolField(value, "hyperlinkAnnotated", false),
				plainSelection: optionalBoolField(value, "plainSelection", false),
				transcriptPreserved: optionalBoolField(value, "transcriptPreserved", false),
				copyPreserved: optionalBoolField(value, "copyPreserved", false),
				commandGrouped: optionalBoolField(value, "commandGrouped", false),
				stdoutVisible: optionalBoolField(value, "stdoutVisible", false),
				stderrVisible: optionalBoolField(value, "stderrVisible", false),
				toolExtraImageCell: optionalBoolField(value, "toolExtraImageCell", false),
				activeRevisionBumped: optionalBoolField(value, "activeRevisionBumped", false),
				activeTailSynced: optionalBoolField(value, "activeTailSynced", false),
				renderModePropagated: optionalBoolField(value, "renderModePropagated", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				rawEventEmitted: optionalBoolField(value, "rawEventEmitted", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalModelSettingsPlan(object:Value, name:String):Null<TuiSmokeModelSettingsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeModelSettingsPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowConfigMutation: optionalBoolField(value, "allowConfigMutation", false),
					actions: modelSettingsActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function modelSettingsActions(values:Array<Value>):Array<TuiSmokeModelSettingsAction> {
		final out:Array<TuiSmokeModelSettingsAction> = [];
		for (value in values) {
			out.push(new TuiSmokeModelSettingsAction({
				kind: TuiSmokeModelSettingsActionKind.fromString(stringField(value, "kind", "")),
				model: optionalStringField(value, "model", ""),
				effort: optionalStringField(value, "effort", ""),
				serviceTier: optionalStringField(value, "serviceTier", ""),
				personality: optionalStringField(value, "personality", ""),
				audioKind: optionalStringField(value, "audioKind", ""),
				selectedDevice: optionalStringField(value, "selectedDevice", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				itemCount: optionalIntField(value, "itemCount", 0),
				autoPresetCount: optionalIntField(value, "autoPresetCount", 0),
				otherPresetCount: optionalIntField(value, "otherPresetCount", 0),
				reasoningChoiceCount: optionalIntField(value, "reasoningChoiceCount", 0),
				featureCount: optionalIntField(value, "featureCount", 0),
				deviceCount: optionalIntField(value, "deviceCount", 0),
				configuredTier: optionalStringField(value, "configuredTier", ""),
				effectiveTier: optionalStringField(value, "effectiveTier", ""),
				sessionConfigured: optionalBoolField(value, "sessionConfigured", false),
				catalogReady: optionalBoolField(value, "catalogReady", false),
				customBaseUrlWarning: optionalBoolField(value, "customBaseUrlWarning", false),
				currentSelected: optionalBoolField(value, "currentSelected", false),
				defaultSelected: optionalBoolField(value, "defaultSelected", false),
				allModelsRow: optionalBoolField(value, "allModelsRow", false),
				openAllModelsEvent: optionalBoolField(value, "openAllModelsEvent", false),
				openReasoningEvent: optionalBoolField(value, "openReasoningEvent", false),
				singleEffortAutoApplied: optionalBoolField(value, "singleEffortAutoApplied", false),
				warningShown: optionalBoolField(value, "warningShown", false),
				planMode: optionalBoolField(value, "planMode", false),
				planOnlySelected: optionalBoolField(value, "planOnlySelected", false),
				allModesSelected: optionalBoolField(value, "allModesSelected", false),
				updateModel: optionalBoolField(value, "updateModel", false),
				updateReasoning: optionalBoolField(value, "updateReasoning", false),
				updatePlanReasoning: optionalBoolField(value, "updatePlanReasoning", false),
				persistModel: optionalBoolField(value, "persistModel", false),
				persistPlanReasoning: optionalBoolField(value, "persistPlanReasoning", false),
				notifyPlanPrompt: optionalBoolField(value, "notifyPlanPrompt", false),
				fastFeatureEnabled: optionalBoolField(value, "fastFeatureEnabled", false),
				fastToggleAllowed: optionalBoolField(value, "fastToggleAllowed", false),
				overrideTurnContext: optionalBoolField(value, "overrideTurnContext", false),
				persistServiceTier: optionalBoolField(value, "persistServiceTier", false),
				refreshSurfaces: optionalBoolField(value, "refreshSurfaces", false),
				supportsPersonality: optionalBoolField(value, "supportsPersonality", false),
				persistPersonality: optionalBoolField(value, "persistPersonality", false),
				popupOpened: optionalBoolField(value, "popupOpened", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				defaultDeviceRow: optionalBoolField(value, "defaultDeviceRow", false),
				unavailableDeviceRow: optionalBoolField(value, "unavailableDeviceRow", false),
				persistAudioDevice: optionalBoolField(value, "persistAudioDevice", false),
				restartPrompt: optionalBoolField(value, "restartPrompt", false),
				restartEvent: optionalBoolField(value, "restartEvent", false),
				stableFeatureOmitted: optionalBoolField(value, "stableFeatureOmitted", false),
				configSaveOnExit: optionalBoolField(value, "configSaveOnExit", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noConfigMutation: optionalBoolField(value, "noConfigMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalPermissionSelectionPlan(object:Value, name:String):Null<TuiSmokePermissionSelectionPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokePermissionSelectionPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: permissionSelectionActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function permissionSelectionActions(values:Array<Value>):Array<TuiSmokePermissionSelectionAction> {
		final out:Array<TuiSmokePermissionSelectionAction> = [];
		for (value in values) {
			out.push(new TuiSmokePermissionSelectionAction({
				kind: TuiSmokePermissionSelectionActionKind.fromString(stringField(value, "kind", "")),
				presetId: optionalStringField(value, "presetId", ""),
				profileId: optionalStringField(value, "profileId", ""),
				displayLabel: optionalStringField(value, "displayLabel", ""),
				approvalPolicy: optionalStringField(value, "approvalPolicy", ""),
				reviewer: optionalStringField(value, "reviewer", ""),
				selectedId: optionalStringField(value, "selectedId", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				itemCount: optionalIntField(value, "itemCount", 0),
				builtinCount: optionalIntField(value, "builtinCount", 0),
				customProfileCount: optionalIntField(value, "customProfileCount", 0),
				disabledCount: optionalIntField(value, "disabledCount", 0),
				denialCount: optionalIntField(value, "denialCount", 0),
				includeReadOnly: optionalBoolField(value, "includeReadOnly", false),
				guardianEnabled: optionalBoolField(value, "guardianEnabled", false),
				autoReviewIncluded: optionalBoolField(value, "autoReviewIncluded", false),
				windowsDegradedSandbox: optionalBoolField(value, "windowsDegradedSandbox", false),
				elevateSandboxHint: optionalBoolField(value, "elevateSandboxHint", false),
				isCurrent: optionalBoolField(value, "isCurrent", false),
				overrideTurnContext: optionalBoolField(value, "overrideTurnContext", false),
				updateApprovalPolicy: optionalBoolField(value, "updateApprovalPolicy", false),
				updateReviewer: optionalBoolField(value, "updateReviewer", false),
				selectProfileEvent: optionalBoolField(value, "selectProfileEvent", false),
				historyCellEmitted: optionalBoolField(value, "historyCellEmitted", false),
				warningHidden: optionalBoolField(value, "warningHidden", false),
				requiresConfirmation: optionalBoolField(value, "requiresConfirmation", false),
				confirmationOpened: optionalBoolField(value, "confirmationOpened", false),
				returnToPermissions: optionalBoolField(value, "returnToPermissions", false),
				rememberDismissal: optionalBoolField(value, "rememberDismissal", false),
				popupOpened: optionalBoolField(value, "popupOpened", false),
				emptyInfoInserted: optionalBoolField(value, "emptyInfoInserted", false),
				missingThreadError: optionalBoolField(value, "missingThreadError", false),
				submitThreadOp: optionalBoolField(value, "submitThreadOp", false),
				infoInserted: optionalBoolField(value, "infoInserted", false),
				approvalDisabled: optionalBoolField(value, "approvalDisabled", false),
				guardianDisabled: optionalBoolField(value, "guardianDisabled", false),
				skippedByNavigation: optionalBoolField(value, "skippedByNavigation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalWindowsSandboxPlan(object:Value, name:String):Null<TuiSmokeWindowsSandboxPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeWindowsSandboxPlan({
					allowOsSandboxMutation: optionalBoolField(value, "allowOsSandboxMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: windowsSandboxActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function windowsSandboxActions(values:Array<Value>):Array<TuiSmokeWindowsSandboxAction> {
		final out:Array<TuiSmokeWindowsSandboxAction> = [];
		for (value in values) {
			out.push(new TuiSmokeWindowsSandboxAction({
				kind: TuiSmokeWindowsSandboxActionKind.fromString(stringField(value, "kind", "")),
				mode: optionalStringField(value, "mode", ""),
				promptKind: optionalStringField(value, "promptKind", ""),
				presetId: optionalStringField(value, "presetId", ""),
				initialMessage: optionalStringField(value, "initialMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				samplePaths: optionalStringField(value, "samplePaths", ""),
				extraCount: optionalIntField(value, "extraCount", 0),
				itemCount: optionalIntField(value, "itemCount", 0),
				allowed: optionalBoolField(value, "allowed", false),
				elevatedLevel: optionalBoolField(value, "elevatedLevel", false),
				configSourcePresent: optionalBoolField(value, "configSourcePresent", false),
				setupComplete: optionalBoolField(value, "setupComplete", false),
				setupRequired: optionalBoolField(value, "setupRequired", false),
				showNow: optionalBoolField(value, "showNow", false),
				popupOpened: optionalBoolField(value, "popupOpened", false),
				legacyNuxEnabled: optionalBoolField(value, "legacyNuxEnabled", false),
				allowUnelevated: optionalBoolField(value, "allowUnelevated", false),
				unelevatedFallbackShown: optionalBoolField(value, "unelevatedFallbackShown", false),
				adminActionShown: optionalBoolField(value, "adminActionShown", false),
				retryActionShown: optionalBoolField(value, "retryActionShown", false),
				quitActionShown: optionalBoolField(value, "quitActionShown", false),
				cancelReopens: optionalBoolField(value, "cancelReopens", false),
				telemetryRecorded: optionalBoolField(value, "telemetryRecorded", false),
				elevatedSetupEvent: optionalBoolField(value, "elevatedSetupEvent", false),
				legacySetupEvent: optionalBoolField(value, "legacySetupEvent", false),
				fallbackPromptEvent: optionalBoolField(value, "fallbackPromptEvent", false),
				enablePromptEvent: optionalBoolField(value, "enablePromptEvent", false),
				exitEvent: optionalBoolField(value, "exitEvent", false),
				initialMessageHeld: optionalBoolField(value, "initialMessageHeld", false),
				initialMessageSubmitted: optionalBoolField(value, "initialMessageSubmitted", false),
				failedScan: optionalBoolField(value, "failedScan", false),
				warningShown: optionalBoolField(value, "warningShown", false),
				rememberedWarning: optionalBoolField(value, "rememberedWarning", false),
				noOsSandboxMutation: optionalBoolField(value, "noOsSandboxMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalRateLimitPlan(object:Value, name:String):Null<TuiSmokeRateLimitPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeRateLimitPlan({
					allowLiveAccountRefresh: optionalBoolField(value, "allowLiveAccountRefresh", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: rateLimitActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function rateLimitActions(values:Array<Value>):Array<TuiSmokeRateLimitAction> {
		final out:Array<TuiSmokeRateLimitAction> = [];
		for (value in values) {
			out.push(new TuiSmokeRateLimitAction({
				kind: TuiSmokeRateLimitActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				limitId: optionalStringField(value, "limitId", ""),
				label: optionalStringField(value, "label", ""),
				fallbackLabel: optionalStringField(value, "fallbackLabel", ""),
				promptStateBefore: optionalStringField(value, "promptStateBefore", ""),
				promptStateAfter: optionalStringField(value, "promptStateAfter", ""),
				model: optionalStringField(value, "model", ""),
				nudgeModel: optionalStringField(value, "nudgeModel", ""),
				planTypeBefore: optionalStringField(value, "planTypeBefore", ""),
				planTypeAfter: optionalStringField(value, "planTypeAfter", ""),
				reachedType: optionalStringField(value, "reachedType", ""),
				errorKind: optionalStringField(value, "errorKind", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				windowMinutes: optionalIntField(value, "windowMinutes", 0),
				usedPercent: optionalIntField(value, "usedPercent", 0),
				thresholdPercent: optionalIntField(value, "thresholdPercent", 0),
				remainingPercent: optionalIntField(value, "remainingPercent", 0),
				warningCount: optionalIntField(value, "warningCount", 0),
				primaryIndexBefore: optionalIntField(value, "primaryIndexBefore", 0),
				primaryIndexAfter: optionalIntField(value, "primaryIndexAfter", 0),
				secondaryIndexBefore: optionalIntField(value, "secondaryIndexBefore", 0),
				secondaryIndexAfter: optionalIntField(value, "secondaryIndexAfter", 0),
				entriesBefore: optionalIntField(value, "entriesBefore", 0),
				entriesAfter: optionalIntField(value, "entriesAfter", 0),
				capReached: optionalBoolField(value, "capReached", false),
				warningEmitted: optionalBoolField(value, "warningEmitted", false),
				creditsPreserved: optionalBoolField(value, "creditsPreserved", false),
				individualLimitPreserved: optionalBoolField(value, "individualLimitPreserved", false),
				planTypePreserved: optionalBoolField(value, "planTypePreserved", false),
				codexReachedTypeStored: optionalBoolField(value, "codexReachedTypeStored", false),
				promptPending: optionalBoolField(value, "promptPending", false),
				promptShown: optionalBoolField(value, "promptShown", false),
				hiddenNotice: optionalBoolField(value, "hiddenNotice", false),
				lowerCostModel: optionalBoolField(value, "lowerCostModel", false),
				nonCodexLimit: optionalBoolField(value, "nonCodexLimit", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				deferred: optionalBoolField(value, "deferred", false),
				shownOnce: optionalBoolField(value, "shownOnce", false),
				popupOpened: optionalBoolField(value, "popupOpened", false),
				rateLimitRefreshRequested: optionalBoolField(value, "rateLimitRefreshRequested", false),
				staleCreditsRemapped: optionalBoolField(value, "staleCreditsRemapped", false),
				ownerNudgeSuppressed: optionalBoolField(value, "ownerNudgeSuppressed", false),
				missingStateSuppressed: optionalBoolField(value, "missingStateSuppressed", false),
				classified: optionalBoolField(value, "classified", false),
				cyberPolicy: optionalBoolField(value, "cyberPolicy", false),
				noLiveAccountRefresh: optionalBoolField(value, "noLiveAccountRefresh", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalReplayProtocolPlan(object:Value, name:String):Null<TuiSmokeReplayProtocolPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeReplayProtocolPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: replayProtocolActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function replayProtocolActions(values:Array<Value>):Array<TuiSmokeReplayProtocolAction> {
		final out:Array<TuiSmokeReplayProtocolAction> = [];
		for (value in values) {
			out.push(new TuiSmokeReplayProtocolAction({
				kind: TuiSmokeReplayProtocolActionKind.fromString(stringField(value, "kind", "")),
				replayKind: optionalStringField(value, "replayKind", ""),
				turnStatus: optionalStringField(value, "turnStatus", ""),
				itemType: optionalStringField(value, "itemType", ""),
				notificationType: optionalStringField(value, "notificationType", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				turnId: optionalStringField(value, "turnId", ""),
				itemCount: optionalIntField(value, "itemCount", 0),
				reasoningDeltaCount: optionalIntField(value, "reasoningDeltaCount", 0),
				durationMs: optionalIntField(value, "durationMs", 0),
				fromReplay: optionalBoolField(value, "fromReplay", false),
				resumeInitialReplay: optionalBoolField(value, "resumeInitialReplay", false),
				threadSnapshotReplay: optionalBoolField(value, "threadSnapshotReplay", false),
				taskStarted: optionalBoolField(value, "taskStarted", false),
				completionSynthesized: optionalBoolField(value, "completionSynthesized", false),
				taskCompleted: optionalBoolField(value, "taskCompleted", false),
				interrupted: optionalBoolField(value, "interrupted", false),
				failed: optionalBoolField(value, "failed", false),
				finalizedTurn: optionalBoolField(value, "finalizedTurn", false),
				budgetLimited: optionalBoolField(value, "budgetLimited", false),
				lastTurnIdSet: optionalBoolField(value, "lastTurnIdSet", false),
				lastRenderedUserCleared: optionalBoolField(value, "lastRenderedUserCleared", false),
				lastNonRetryErrorCleared: optionalBoolField(value, "lastNonRetryErrorCleared", false),
				lastNonRetryErrorSet: optionalBoolField(value, "lastNonRetryErrorSet", false),
				retryHeaderRestored: optionalBoolField(value, "retryHeaderRestored", false),
				retryable: optionalBoolField(value, "retryable", false),
				streamErrorShown: optionalBoolField(value, "streamErrorShown", false),
				nonRetryHandled: optionalBoolField(value, "nonRetryHandled", false),
				liveEffectsSuppressed: optionalBoolField(value, "liveEffectsSuppressed", false),
				misroutedRejected: optionalBoolField(value, "misroutedRejected", false),
				userCommitted: optionalBoolField(value, "userCommitted", false),
				composerHistorySeeded: optionalBoolField(value, "composerHistorySeeded", false),
				agentCommitted: optionalBoolField(value, "agentCommitted", false),
				planCompleted: optionalBoolField(value, "planCompleted", false),
				reasoningFinalized: optionalBoolField(value, "reasoningFinalized", false),
				rawReasoningShown: optionalBoolField(value, "rawReasoningShown", false),
				commandStarted: optionalBoolField(value, "commandStarted", false),
				commandCompleted: optionalBoolField(value, "commandCompleted", false),
				fileChangeIgnored: optionalBoolField(value, "fileChangeIgnored", false),
				fileChangeCompleted: optionalBoolField(value, "fileChangeCompleted", false),
				mcpStarted: optionalBoolField(value, "mcpStarted", false),
				mcpCompleted: optionalBoolField(value, "mcpCompleted", false),
				webSearchCompleted: optionalBoolField(value, "webSearchCompleted", false),
				imageViewOpened: optionalBoolField(value, "imageViewOpened", false),
				imageGenerationCompleted: optionalBoolField(value, "imageGenerationCompleted", false),
				reviewEntered: optionalBoolField(value, "reviewEntered", false),
				reviewExited: optionalBoolField(value, "reviewExited", false),
				contextCompacted: optionalBoolField(value, "contextCompacted", false),
				collabToolRouted: optionalBoolField(value, "collabToolRouted", false),
				subAgentActivityRouted: optionalBoolField(value, "subAgentActivityRouted", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalClipboardPastePlan(object:Value, name:String):Null<TuiSmokeClipboardPastePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeClipboardPastePlan({
					allowLiveClipboard: optionalBoolField(value, "allowLiveClipboard", false),
					allowProcessSpawn: optionalBoolField(value, "allowProcessSpawn", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: clipboardPasteActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function clipboardPasteActions(values:Array<Value>):Array<TuiSmokeClipboardPasteAction> {
		final out:Array<TuiSmokeClipboardPasteAction> = [];
		for (value in values) {
			out.push(new TuiSmokeClipboardPasteAction({
				kind: TuiSmokeClipboardPasteActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				errorKind: optionalStringField(value, "errorKind", ""),
				wslSession: optionalBoolField(value, "wslSession", false),
				nativeClipboardAvailable: optionalBoolField(value, "nativeClipboardAvailable", false),
				nativeImageAvailable: optionalBoolField(value, "nativeImageAvailable", false),
				nativeFileAvailable: optionalBoolField(value, "nativeFileAvailable", false),
				wslFallbackAttempted: optionalBoolField(value, "wslFallbackAttempted", false),
				wslFallbackSucceeded: optionalBoolField(value, "wslFallbackSucceeded", false),
				windowsPath: optionalStringField(value, "windowsPath", ""),
				wslPath: optionalStringField(value, "wslPath", ""),
				tempPath: optionalStringField(value, "tempPath", ""),
				width: optionalIntField(value, "width", 0),
				height: optionalIntField(value, "height", 0),
				format: optionalStringField(value, "format", "png"),
				imageBytes: optionalIntField(value, "imageBytes", 0),
				maxImageBytes: optionalIntField(value, "maxImageBytes", 10000000),
				placeholder: optionalStringField(value, "placeholder", ""),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				localImageCountBefore: optionalIntField(value, "localImageCountBefore", 0),
				localImageCountAfter: optionalIntField(value, "localImageCountAfter", 0),
				insertedPlaceholder: optionalBoolField(value, "insertedPlaceholder", false),
				expectedDecision: optionalStringField(value, "expectedDecision", ""),
				liveClipboardAllowed: optionalBoolField(value, "liveClipboardAllowed", false),
				processSpawnAllowed: optionalBoolField(value, "processSpawnAllowed", false),
				filesystemMutationAllowed: optionalBoolField(value, "filesystemMutationAllowed", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalClipboardCopyPlan(object:Value, name:String):Null<TuiSmokeClipboardCopyPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeClipboardCopyPlan({
					allowLiveClipboard: optionalBoolField(value, "allowLiveClipboard", false),
					allowLiveTerminalWrite: optionalBoolField(value, "allowLiveTerminalWrite", false),
					allowProcessSpawn: optionalBoolField(value, "allowProcessSpawn", false),
					actions: clipboardCopyActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function clipboardCopyActions(values:Array<Value>):Array<TuiSmokeClipboardCopyAction> {
		final out:Array<TuiSmokeClipboardCopyAction> = [];
		for (value in values) {
			out.push(new TuiSmokeClipboardCopyAction({
				kind: TuiSmokeClipboardCopyActionKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				sshSession: optionalBoolField(value, "sshSession", false),
				wslSession: optionalBoolField(value, "wslSession", false),
				tmuxSession: optionalBoolField(value, "tmuxSession", false),
				nativeOk: optionalBoolField(value, "nativeOk", false),
				nativeLease: optionalBoolField(value, "nativeLease", false),
				wslOk: optionalBoolField(value, "wslOk", false),
				tmuxOk: optionalBoolField(value, "tmuxOk", false),
				osc52Ok: optionalBoolField(value, "osc52Ok", false),
				expectedBackend: optionalStringField(value, "expectedBackend", ""),
				expectedSequence: optionalStringField(value, "expectedSequence", ""),
				tmuxSetClipboard: optionalStringField(value, "tmuxSetClipboard", ""),
				tmuxInfo: optionalStringField(value, "tmuxInfo", ""),
				expectedReady: optionalBoolField(value, "expectedReady", false),
				rawBytes: optionalIntField(value, "rawBytes", 0),
				maxRawBytes: optionalIntField(value, "maxRawBytes", 100000),
				failureCode: optionalStringField(value, "failureCode", ""),
				liveClipboardAllowed: optionalBoolField(value, "liveClipboardAllowed", false),
				liveTerminalWriteAllowed: optionalBoolField(value, "liveTerminalWriteAllowed", false),
				processSpawnAllowed: optionalBoolField(value, "processSpawnAllowed", false)
			}));
		}
		return out;
	}

	static function optionalTerminalStartupProbePlan(object:Value, name:String):Null<TuiSmokeTerminalStartupProbePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalStartupProbePlan({
					allowLiveProbe: optionalBoolField(value, "allowLiveProbe", false),
					actions: terminalStartupProbeActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalStartupProbeActions(values:Array<Value>):Array<TuiSmokeTerminalStartupProbeAction> {
		final out:Array<TuiSmokeTerminalStartupProbeAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalStartupProbeAction({
				kind: TuiSmokeTerminalStartupProbeActionKind.fromString(stringField(value, "kind", "")),
				buffer: optionalStringField(value, "buffer", ""),
				cursorX: optionalIntField(value, "cursorX", -1),
				cursorY: optionalIntField(value, "cursorY", -1),
				foreground: optionalStringField(value, "foreground", ""),
				background: optionalStringField(value, "background", ""),
				queryKeyboard: optionalBoolField(value, "queryKeyboard", false),
				keyboardSupported: optionalBoolField(value, "keyboardSupported", false),
				fallbackSeen: optionalBoolField(value, "fallbackSeen", false),
				complete: optionalBoolField(value, "complete", false),
				handleSource: optionalStringField(value, "handleSource", ""),
				duplicatedStdio: optionalBoolField(value, "duplicatedStdio", false),
				controllingTerminalFallback: optionalBoolField(value, "controllingTerminalFallback", false),
				originalFlagsRestored: optionalBoolField(value, "originalFlagsRestored", false),
				timeoutMs: optionalIntField(value, "timeoutMs", 0),
				liveProbeAllowed: optionalBoolField(value, "liveProbeAllowed", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalTerminalPalettePlan(object:Value, name:String):Null<TuiSmokeTerminalPalettePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalPalettePlan({
					allowLiveQuery: optionalBoolField(value, "allowLiveQuery", false),
					actions: terminalPaletteActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalPaletteActions(values:Array<Value>):Array<TuiSmokeTerminalPaletteAction> {
		final out:Array<TuiSmokeTerminalPaletteAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalPaletteAction({
				kind: TuiSmokeTerminalPaletteActionKind.fromString(stringField(value, "kind", "")),
				slot: optionalIntField(value, "slot", 0),
				payload: optionalStringField(value, "payload", ""),
				buffer: optionalStringField(value, "buffer", ""),
				color: optionalStringField(value, "color", ""),
				foreground: optionalStringField(value, "foreground", ""),
				background: optionalStringField(value, "background", ""),
				valid: optionalBoolField(value, "valid", false),
				startupAttempted: optionalBoolField(value, "startupAttempted", false),
				startupValue: optionalStringField(value, "startupValue", ""),
				requeryRequested: optionalBoolField(value, "requeryRequested", false),
				requeryValue: optionalStringField(value, "requeryValue", ""),
				skippedBecauseUnavailable: optionalBoolField(value, "skippedBecauseUnavailable", false),
				liveQueryAllowed: optionalBoolField(value, "liveQueryAllowed", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalTerminalHyperlinkPlan(object:Value, name:String):Null<TuiSmokeTerminalHyperlinkPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalHyperlinkPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					actions: terminalHyperlinkActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalHyperlinkActions(values:Array<Value>):Array<TuiSmokeTerminalHyperlinkAction> {
		final out:Array<TuiSmokeTerminalHyperlinkAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalHyperlinkAction({
				kind: TuiSmokeTerminalHyperlinkActionKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				destination: optionalStringField(value, "destination", ""),
				safeDestination: optionalStringField(value, "safeDestination", ""),
				decoratedText: optionalStringField(value, "decoratedText", ""),
				strippedText: optionalStringField(value, "strippedText", ""),
				startColumn: optionalIntField(value, "startColumn", -1),
				endColumn: optionalIntField(value, "endColumn", -1),
				prefixWidth: optionalIntField(value, "prefixWidth", 0),
				shiftedStartColumn: optionalIntField(value, "shiftedStartColumn", -1),
				shiftedEndColumn: optionalIntField(value, "shiftedEndColumn", -1),
				validWebDestination: optionalBoolField(value, "validWebDestination", false),
				osc8PairCount: optionalIntField(value, "osc8PairCount", 0),
				liveWriteAllowed: optionalBoolField(value, "liveWriteAllowed", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalDesktopNotificationPlan(object:Value, name:String):Null<TuiSmokeDesktopNotificationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeDesktopNotificationPlan({
					allowLiveNotification: optionalBoolField(value, "allowLiveNotification", false),
					actions: desktopNotificationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function optionalDesktopThreadPlan(object:Value, name:String):Null<TuiSmokeDesktopThreadPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeDesktopThreadPlan({
					allowLiveDesktopLaunch: optionalBoolField(value, "allowLiveDesktopLaunch", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: desktopThreadActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function desktopThreadActions(values:Array<Value>):Array<TuiSmokeDesktopThreadAction> {
		final out:Array<TuiSmokeDesktopThreadAction> = [];
		for (value in values) {
			out.push(new TuiSmokeDesktopThreadAction({
				kind: TuiSmokeDesktopThreadActionKind.fromString(stringField(value, "kind", "")),
				threadId: optionalStringField(value, "threadId", ""),
				url: optionalStringField(value, "url", ""),
				message: optionalStringField(value, "message", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				opened: optionalBoolField(value, "opened", false),
				infoInserted: optionalBoolField(value, "infoInserted", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				noLiveDesktopLaunch: optionalBoolField(value, "noLiveDesktopLaunch", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalBrowserOpenPlan(object:Value, name:String):Null<TuiSmokeBrowserOpenPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeBrowserOpenPlan({
					allowLiveBrowserLaunch: optionalBoolField(value, "allowLiveBrowserLaunch", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: browserOpenActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function browserOpenActions(values:Array<Value>):Array<TuiSmokeBrowserOpenAction> {
		final out:Array<TuiSmokeBrowserOpenAction> = [];
		for (value in values) {
			out.push(new TuiSmokeBrowserOpenAction({
				kind: TuiSmokeBrowserOpenActionKind.fromString(stringField(value, "kind", "")),
				url: optionalStringField(value, "url", ""),
				message: optionalStringField(value, "message", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				opened: optionalBoolField(value, "opened", false),
				infoInserted: optionalBoolField(value, "infoInserted", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				noLiveBrowserLaunch: optionalBoolField(value, "noLiveBrowserLaunch", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalTerminalVisualizationPlan(object:Value, name:String):Null<TuiSmokeTerminalVisualizationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalVisualizationPlan({
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: terminalVisualizationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalVisualizationActions(values:Array<Value>):Array<TuiSmokeTerminalVisualizationAction> {
		final out:Array<TuiSmokeTerminalVisualizationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalVisualizationAction({
				kind: TuiSmokeTerminalVisualizationActionKind.fromString(stringField(value, "kind", "")),
				featureEnabled: optionalBoolField(value, "featureEnabled", false),
				controlInstructions: optionalStringField(value, "controlInstructions", ""),
				developerInstructions: optionalStringField(value, "developerInstructions", ""),
				expectedInstructions: optionalStringField(value, "expectedInstructions", ""),
				usedControl: optionalBoolField(value, "usedControl", false),
				usedDeveloperFallback: optionalBoolField(value, "usedDeveloperFallback", false),
				appendedTerminalInstructions: optionalBoolField(value, "appendedTerminalInstructions", false),
				generatedFromEmpty: optionalBoolField(value, "generatedFromEmpty", false),
				failureCode: optionalStringField(value, "failureCode", ""),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalAgentStatusPlan(object:Value, name:String):Null<TuiSmokeAgentStatusPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAgentStatusPlan({
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: agentStatusActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function agentStatusActions(values:Array<Value>):Array<TuiSmokeAgentStatusAction> {
		final out:Array<TuiSmokeAgentStatusAction> = [];
		for (value in values) {
			out.push(new TuiSmokeAgentStatusAction({
				kind: TuiSmokeAgentStatusActionKind.fromString(stringField(value, "kind", "")),
				itemKind: TuiSmokeAgentStatusItemKind.fromString(optionalStringField(value, "itemKind", "")),
				agentPath: optionalStringField(value, "agentPath", ""),
				itemId: optionalStringField(value, "itemId", ""),
				rawText: optionalStringField(value, "rawText", ""),
				summary: optionalStringField(value, "summary", ""),
				displayText: optionalStringField(value, "displayText", ""),
				server: optionalStringField(value, "server", ""),
				namespace: optionalStringField(value, "namespace", ""),
				tool: optionalStringField(value, "tool", ""),
				collabTool: optionalStringField(value, "collabTool", ""),
				subAgentActivity: optionalStringField(value, "subAgentActivity", ""),
				fileChangeCount: optionalIntField(value, "fileChangeCount", 0),
				accepted: optionalBoolField(value, "accepted", false),
				duplicate: optionalBoolField(value, "duplicate", false),
				rawReasoningHidden: optionalBoolField(value, "rawReasoningHidden", false),
				aggregatedOutputHidden: optionalBoolField(value, "aggregatedOutputHidden", false),
				whitespaceCollapsed: optionalBoolField(value, "whitespaceCollapsed", false),
				emptyState: optionalBoolField(value, "emptyState", false),
				previewLineCount: optionalIntField(value, "previewLineCount", 0),
				previewItemCount: optionalIntField(value, "previewItemCount", 0),
				maxPreviewLines: optionalIntField(value, "maxPreviewLines", 3),
				maxPreviewItems: optionalIntField(value, "maxPreviewItems", 6),
				maxGraphemes: optionalIntField(value, "maxGraphemes", 240),
				failureCode: optionalStringField(value, "failureCode", ""),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalAgentNavigationPlan(object:Value, name:String):Null<TuiSmokeAgentNavigationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAgentNavigationPlan({
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: agentNavigationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function agentNavigationActions(values:Array<Value>):Array<TuiSmokeAgentNavigationAction> {
		final out:Array<TuiSmokeAgentNavigationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeAgentNavigationAction({
				kind: TuiSmokeAgentNavigationActionKind.fromString(stringField(value, "kind", "")),
				threadId: optionalStringField(value, "threadId", ""),
				agentNickname: optionalStringField(value, "agentNickname", ""),
				agentRole: optionalStringField(value, "agentRole", ""),
				agentPath: optionalStringField(value, "agentPath", ""),
				isRunning: optionalBoolField(value, "isRunning", false),
				isClosed: optionalBoolField(value, "isClosed", false),
				currentThreadId: optionalStringField(value, "currentThreadId", ""),
				primaryThreadId: optionalStringField(value, "primaryThreadId", ""),
				direction: TuiSmokeAgentNavigationDirectionKind.fromString(optionalStringField(value, "direction", "")),
				expectedThreadId: optionalStringField(value, "expectedThreadId", ""),
				expectedLabel: optionalStringField(value, "expectedLabel", ""),
				expectedSubtitle: optionalStringField(value, "expectedSubtitle", ""),
				expectedOrder: optionalStringArrayField(value, "expectedOrder"),
				expectedHasNonPrimary: optionalBoolField(value, "expectedHasNonPrimary", false),
				failureCode: optionalStringField(value, "failureCode", ""),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalLoadedThreadsPlan(object:Value, name:String):Null<TuiSmokeLoadedThreadsPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeLoadedThreadsPlan({
					primaryThreadId: optionalStringField(value, "primaryThreadId", ""),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerRequest: optionalBoolField(value, "allowAppServerRequest", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					threads: loadedThreads(optionalArrayField(value, "threads")),
					expected: loadedSubagentThreads(optionalArrayField(value, "expected")),
					expectedInvalidSkipped: optionalIntField(value, "expectedInvalidSkipped", 0),
					expectedUnrelatedSkipped: optionalIntField(value, "expectedUnrelatedSkipped", 0),
					expectedNonSpawnSkipped: optionalIntField(value, "expectedNonSpawnSkipped", 0),
					failureCode: optionalStringField(value, "failureCode", ""),
					noModelCall: optionalBoolField(value, "noModelCall", false),
					noAppServerRequest: optionalBoolField(value, "noAppServerRequest", false),
					noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
					unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
				});
		}
	}

	static function loadedThreads(values:Array<Value>):Array<TuiSmokeLoadedThread> {
		final out:Array<TuiSmokeLoadedThread> = [];
		for (value in values) {
			out.push(new TuiSmokeLoadedThread({
				threadId: optionalStringField(value, "threadId", ""),
				validThreadId: optionalBoolField(value, "validThreadId", true),
				source: TuiSmokeLoadedThreadSourceKind.fromString(optionalStringField(value, "source", "")),
				parentThreadId: optionalStringField(value, "parentThreadId", ""),
				agentNickname: optionalStringField(value, "agentNickname", ""),
				agentRole: optionalStringField(value, "agentRole", ""),
				agentPath: optionalStringField(value, "agentPath", "")
			}));
		}
		return out;
	}

	static function loadedSubagentThreads(values:Array<Value>):Array<TuiSmokeLoadedSubagentThread> {
		final out:Array<TuiSmokeLoadedSubagentThread> = [];
		for (value in values) {
			out.push(new TuiSmokeLoadedSubagentThread({
				threadId: optionalStringField(value, "threadId", ""),
				agentNickname: optionalStringField(value, "agentNickname", ""),
				agentRole: optionalStringField(value, "agentRole", ""),
				agentPath: optionalStringField(value, "agentPath", "")
			}));
		}
		return out;
	}

	static function desktopNotificationActions(values:Array<Value>):Array<TuiSmokeDesktopNotificationAction> {
		final out:Array<TuiSmokeDesktopNotificationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeDesktopNotificationAction({
				kind: TuiSmokeDesktopNotificationActionKind.fromString(stringField(value, "kind", "")),
				method: TuiSmokeDesktopNotificationMethodKind.fromString(optionalStringField(value, "method", "")),
				terminalName: optionalStringField(value, "terminalName", ""),
				multiplexer: optionalStringField(value, "multiplexer", ""),
				backend: TuiSmokeDesktopNotificationBackendKind.fromString(optionalStringField(value, "backend", "")),
				condition: TuiSmokeDesktopNotificationConditionKind.fromString(optionalStringField(value, "condition", "")),
				terminalFocused: optionalBoolField(value, "terminalFocused", false),
				shouldEmit: optionalBoolField(value, "shouldEmit", false),
				message: optionalStringField(value, "message", ""),
				escapedMessage: optionalStringField(value, "escapedMessage", ""),
				dcsPassthrough: optionalBoolField(value, "dcsPassthrough", false),
				liveWriteAllowed: optionalBoolField(value, "liveWriteAllowed", false),
				emitted: optionalBoolField(value, "emitted", false),
				disabledAfterFailure: optionalBoolField(value, "disabledAfterFailure", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalTerminalTitlePlan(object:Value, name:String):Null<TuiSmokeTerminalTitlePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTerminalTitlePlan({
					allowLiveTitleWrite: optionalBoolField(value, "allowLiveTitleWrite", false),
					actions: terminalTitleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function terminalTitleActions(values:Array<Value>):Array<TuiSmokeTerminalTitleAction> {
		final out:Array<TuiSmokeTerminalTitleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTerminalTitleAction({
				kind: TuiSmokeTerminalTitleActionKind.fromString(stringField(value, "kind", "")),
				rawTitle: optionalStringField(value, "rawTitle", ""),
				sanitizedTitle: optionalStringField(value, "sanitizedTitle", ""),
				lastTitleBefore: optionalStringField(value, "lastTitleBefore", ""),
				lastTitleAfter: optionalStringField(value, "lastTitleAfter", ""),
				stdoutTerminal: optionalBoolField(value, "stdoutTerminal", false),
				liveWriteAllowed: optionalBoolField(value, "liveWriteAllowed", false),
				applied: optionalBoolField(value, "applied", false),
				noVisibleContent: optionalBoolField(value, "noVisibleContent", false),
				duplicateSkipped: optionalBoolField(value, "duplicateSkipped", false),
				cleared: optionalBoolField(value, "cleared", false),
				maxChars: optionalIntField(value, "maxChars", 0),
				invalidItemCount: optionalIntField(value, "invalidItemCount", 0),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				failureCode: optionalStringField(value, "failureCode", "")
			}));
		}
		return out;
	}

	static function optionalResumeForkPlan(object:Value, name:String):Null<TuiSmokeResumeForkPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeResumeForkPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: resumeForkActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function resumeForkActions(values:Array<Value>):Array<TuiSmokeResumeForkAction> {
		final out:Array<TuiSmokeResumeForkAction> = [];
		for (value in values) {
			out.push(new TuiSmokeResumeForkAction({
				kind: TuiSmokeResumeForkActionKind.fromString(stringField(value, "kind", "")),
				action: optionalStringField(value, "action", ""),
				source: optionalStringField(value, "source", ""),
				context: optionalStringField(value, "context", ""),
				selection: optionalStringField(value, "selection", ""),
				idOrName: optionalStringField(value, "idOrName", ""),
				threadId: optionalStringField(value, "threadId", ""),
				parentThreadId: optionalStringField(value, "parentThreadId", ""),
				childThreadId: optionalStringField(value, "childThreadId", ""),
				expandedThreadId: optionalStringField(value, "expandedThreadId", ""),
				targetLabel: optionalStringField(value, "targetLabel", ""),
				targetPath: optionalStringField(value, "targetPath", ""),
				keyName: optionalStringField(value, "keyName", ""),
				previewState: optionalStringField(value, "previewState", ""),
				previewCacheBefore: optionalStringField(value, "previewCacheBefore", ""),
				previewCacheAfter: optionalStringField(value, "previewCacheAfter", ""),
				transcriptState: optionalStringField(value, "transcriptState", ""),
				transcriptCacheBefore: optionalStringField(value, "transcriptCacheBefore", ""),
				transcriptCacheAfter: optionalStringField(value, "transcriptCacheAfter", ""),
				pendingThreadId: optionalStringField(value, "pendingThreadId", ""),
				query: optionalStringField(value, "query", ""),
				queryBefore: optionalStringField(value, "queryBefore", ""),
				queryAfter: optionalStringField(value, "queryAfter", ""),
				cursor: optionalStringField(value, "cursor", ""),
				nextCursor: optionalStringField(value, "nextCursor", ""),
				sortKey: optionalStringField(value, "sortKey", ""),
				sortKeyBefore: optionalStringField(value, "sortKeyBefore", ""),
				sortKeyAfter: optionalStringField(value, "sortKeyAfter", ""),
				filterModeBefore: optionalStringField(value, "filterModeBefore", ""),
				filterModeAfter: optionalStringField(value, "filterModeAfter", ""),
				cwdFilter: optionalStringField(value, "cwdFilter", ""),
				densityBefore: optionalStringField(value, "densityBefore", ""),
				densityAfter: optionalStringField(value, "densityAfter", ""),
				toolbarFocusBefore: optionalStringField(value, "toolbarFocusBefore", ""),
				toolbarFocusAfter: optionalStringField(value, "toolbarFocusAfter", ""),
				toolbarRenderMode: optionalStringField(value, "toolbarRenderMode", ""),
				footerProgressLabel: optionalStringField(value, "footerProgressLabel", ""),
				footerHintMode: optionalStringField(value, "footerHintMode", ""),
				emptyStateMessage: optionalStringField(value, "emptyStateMessage", ""),
				loadingOverlayMessage: optionalStringField(value, "loadingOverlayMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				pageSize: optionalIntField(value, "pageSize", 0),
				loadedRows: optionalIntField(value, "loadedRows", 0),
				selectedIndex: optionalIntField(value, "selectedIndex", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				scrollTopBefore: optionalIntField(value, "scrollTopBefore", 0),
				scrollTopAfter: optionalIntField(value, "scrollTopAfter", 0),
				viewRows: optionalIntField(value, "viewRows", 0),
				footerPercent: optionalIntField(value, "footerPercent", 0),
				frozenFooterPercent: optionalIntField(value, "frozenFooterPercent", 0),
				footerWidth: optionalIntField(value, "footerWidth", 0),
				requestToken: optionalIntField(value, "requestToken", 0),
				searchToken: optionalIntField(value, "searchToken", 0),
				scannedRows: optionalIntField(value, "scannedRows", 0),
				acceptedRows: optionalIntField(value, "acceptedRows", 0),
				invalidRows: optionalIntField(value, "invalidRows", 0),
				filteredRows: optionalIntField(value, "filteredRows", 0),
				turnCount: optionalIntField(value, "turnCount", 0),
				previewLineCount: optionalIntField(value, "previewLineCount", 0),
				userLineCount: optionalIntField(value, "userLineCount", 0),
				assistantLineCount: optionalIntField(value, "assistantLineCount", 0),
				transcriptCellCount: optionalIntField(value, "transcriptCellCount", 0),
				planCellCount: optionalIntField(value, "planCellCount", 0),
				reasoningCellCount: optionalIntField(value, "reasoningCellCount", 0),
				fallbackCellCount: optionalIntField(value, "fallbackCellCount", 0),
				altScreenEntered: optionalBoolField(value, "altScreenEntered", false),
				altScreenExited: optionalBoolField(value, "altScreenExited", false),
				pickerStarted: optionalBoolField(value, "pickerStarted", false),
				searchActive: optionalBoolField(value, "searchActive", false),
				staleIgnored: optionalBoolField(value, "staleIgnored", false),
				nextCursorPresent: optionalBoolField(value, "nextCursorPresent", false),
				reachedScanCap: optionalBoolField(value, "reachedScanCap", false),
				pendingPageDownCompleted: optionalBoolField(value, "pendingPageDownCompleted", false),
				expansionToggled: optionalBoolField(value, "expansionToggled", false),
				cacheInserted: optionalBoolField(value, "cacheInserted", false),
				includeTurns: optionalBoolField(value, "includeTurns", false),
				previewRendered: optionalBoolField(value, "previewRendered", false),
				loadingFrameShown: optionalBoolField(value, "loadingFrameShown", false),
				overlayOpened: optionalBoolField(value, "overlayOpened", false),
				loadMoreRequested: optionalBoolField(value, "loadMoreRequested", false),
				startFresh: optionalBoolField(value, "startFresh", false),
				keyConsumed: optionalBoolField(value, "keyConsumed", false),
				overlayClosed: optionalBoolField(value, "overlayClosed", false),
				persistenceConfigured: optionalBoolField(value, "persistenceConfigured", false),
				persistenceAttempted: optionalBoolField(value, "persistenceAttempted", false),
				persistenceSucceeded: optionalBoolField(value, "persistenceSucceeded", false),
				inlineErrorShown: optionalBoolField(value, "inlineErrorShown", false),
				queryPreserved: optionalBoolField(value, "queryPreserved", false),
				loadingPending: optionalBoolField(value, "loadingPending", false),
				moreAbove: optionalBoolField(value, "moreAbove", false),
				moreBelow: optionalBoolField(value, "moreBelow", false),
				loadingOlderShown: optionalBoolField(value, "loadingOlderShown", false),
				compactFallback: optionalBoolField(value, "compactFallback", false),
				keyOnlyFallback: optionalBoolField(value, "keyOnlyFallback", false),
				showAll: optionalBoolField(value, "showAll", false),
				includeNonInteractive: optionalBoolField(value, "includeNonInteractive", false),
				selected: optionalBoolField(value, "selected", false),
				lookupRequested: optionalBoolField(value, "lookupRequested", false),
				lookupSucceeded: optionalBoolField(value, "lookupSucceeded", false),
				threadReadRequested: optionalBoolField(value, "threadReadRequested", false),
				waitForInitialSession: optionalBoolField(value, "waitForInitialSession", false),
				activeEventsAllowed: optionalBoolField(value, "activeEventsAllowed", false),
				pausedGoalPromptEligible: optionalBoolField(value, "pausedGoalPromptEligible", false),
				sameThreadActive: optionalBoolField(value, "sameThreadActive", false),
				ignored: optionalBoolField(value, "ignored", false),
				infoInserted: optionalBoolField(value, "infoInserted", false),
				configReloaded: optionalBoolField(value, "configReloaded", false),
				cwdResolved: optionalBoolField(value, "cwdResolved", false),
				configRebuilt: optionalBoolField(value, "configRebuilt", false),
				remoteWorkspace: optionalBoolField(value, "remoteWorkspace", false),
				runtimePolicyApplied: optionalBoolField(value, "runtimePolicyApplied", false),
				resumeRequested: optionalBoolField(value, "resumeRequested", false),
				resumeSucceeded: optionalBoolField(value, "resumeSucceeded", false),
				forkRequested: optionalBoolField(value, "forkRequested", false),
				forkSucceeded: optionalBoolField(value, "forkSucceeded", false),
				currentThreadShutdown: optionalBoolField(value, "currentThreadShutdown", false),
				chatWidgetReplaced: optionalBoolField(value, "chatWidgetReplaced", false),
				primaryThreadEnqueued: optionalBoolField(value, "primaryThreadEnqueued", false),
				subagentsBackfilled: optionalBoolField(value, "subagentsBackfilled", false),
				notificationSettingsUpdated: optionalBoolField(value, "notificationSettingsUpdated", false),
				fileSearchDirUpdated: optionalBoolField(value, "fileSearchDirUpdated", false),
				summaryInserted: optionalBoolField(value, "summaryInserted", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				appServerStarted: optionalBoolField(value, "appServerStarted", false),
				appServerMutationRequested: optionalBoolField(value, "appServerMutationRequested", false),
				initialUserMessageSubmitted: optionalBoolField(value, "initialUserMessageSubmitted", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalClearArchivePlan(object:Value, name:String):Null<TuiSmokeClearArchivePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeClearArchivePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: clearArchiveActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function clearArchiveActions(values:Array<Value>):Array<TuiSmokeClearArchiveAction> {
		final out:Array<TuiSmokeClearArchiveAction> = [];
		for (value in values) {
			out.push(new TuiSmokeClearArchiveAction({
				kind: TuiSmokeClearArchiveActionKind.fromString(stringField(value, "kind", "")),
				mode: optionalStringField(value, "mode", ""),
				threadId: optionalStringField(value, "threadId", ""),
				sessionStartSource: optionalStringField(value, "sessionStartSource", ""),
				userMessageText: optionalStringField(value, "userMessageText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				clearBackend: optionalStringField(value, "clearBackend", ""),
				exitMode: optionalStringField(value, "exitMode", ""),
				exitReason: optionalStringField(value, "exitReason", ""),
				archivedSessionPath: optionalStringField(value, "archivedSessionPath", ""),
				unarchiveCommand: optionalStringField(value, "unarchiveCommand", ""),
				transcriptCellsBefore: optionalIntField(value, "transcriptCellsBefore", 0),
				transcriptCellsAfter: optionalIntField(value, "transcriptCellsAfter", 0),
				deferredHistoryBefore: optionalIntField(value, "deferredHistoryBefore", 0),
				deferredHistoryAfter: optionalIntField(value, "deferredHistoryAfter", 0),
				pendingHistoryBefore: optionalIntField(value, "pendingHistoryBefore", 0),
				pendingHistoryAfter: optionalIntField(value, "pendingHistoryAfter", 0),
				skillWarningsBefore: optionalIntField(value, "skillWarningsBefore", 0),
				skillWarningsAfter: optionalIntField(value, "skillWarningsAfter", 0),
				activeSkillWarningsBefore: optionalIntField(value, "activeSkillWarningsBefore", 0),
				activeSkillWarningsAfter: optionalIntField(value, "activeSkillWarningsAfter", 0),
				activeThreadBefore: optionalBoolField(value, "activeThreadBefore", false),
				activeThreadAfter: optionalBoolField(value, "activeThreadAfter", false),
				sessionPreserved: optionalBoolField(value, "sessionPreserved", false),
				composerPreserved: optionalBoolField(value, "composerPreserved", false),
				overlayCleared: optionalBoolField(value, "overlayCleared", false),
				backtrackCleared: optionalBoolField(value, "backtrackCleared", false),
				reflowCleared: optionalBoolField(value, "reflowCleared", false),
				replayBufferCleared: optionalBoolField(value, "replayBufferCleared", false),
				headerQueued: optionalBoolField(value, "headerQueued", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				freshSessionStarted: optionalBoolField(value, "freshSessionStarted", false),
				initialUserMessageSubmitted: optionalBoolField(value, "initialUserMessageSubmitted", false),
				archiveRequested: optionalBoolField(value, "archiveRequested", false),
				archiveSucceeded: optionalBoolField(value, "archiveSucceeded", false),
				unarchiveRequested: optionalBoolField(value, "unarchiveRequested", false),
				unarchiveSucceeded: optionalBoolField(value, "unarchiveSucceeded", false),
				sideConversationActive: optionalBoolField(value, "sideConversationActive", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				pendingShutdownThreadBefore: optionalBoolField(value, "pendingShutdownThreadBefore", false),
				pendingShutdownThreadAfter: optionalBoolField(value, "pendingShutdownThreadAfter", false),
				shutdownFeedbackShown: optionalBoolField(value, "shutdownFeedbackShown", false),
				inputDisabled: optionalBoolField(value, "inputDisabled", false),
				appServerShutdownRequested: optionalBoolField(value, "appServerShutdownRequested", false),
				exitRequested: optionalBoolField(value, "exitRequested", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSessionArchiveCommandPlan(object:Value, name:String):Null<TuiSmokeSessionArchiveCommandPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSessionArchiveCommandPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					actions: sessionArchiveCommandActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function sessionArchiveCommandActions(values:Array<Value>):Array<TuiSmokeSessionArchiveCommandAction> {
		final out:Array<TuiSmokeSessionArchiveCommandAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSessionArchiveCommandAction({
				kind: TuiSmokeSessionArchiveCommandActionKind.fromString(stringField(value, "kind", "")),
				action: optionalStringField(value, "action", ""),
				requestId: optionalStringField(value, "requestId", ""),
				method: optionalStringField(value, "method", ""),
				target: optionalStringField(value, "target", ""),
				searchScope: optionalStringField(value, "searchScope", ""),
				threadId: optionalStringField(value, "threadId", ""),
				threadName: optionalStringField(value, "threadName", ""),
				responseThreadId: optionalStringField(value, "responseThreadId", ""),
				responseThreadName: optionalStringField(value, "responseThreadName", ""),
				sourceKind: optionalStringField(value, "sourceKind", ""),
				cwd: optionalStringField(value, "cwd", ""),
				preview: optionalStringField(value, "preview", ""),
				displayPreview: optionalStringField(value, "displayPreview", ""),
				path: optionalStringField(value, "path", ""),
				gitBranch: optionalStringField(value, "gitBranch", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				successMessage: optionalStringField(value, "successMessage", ""),
				cursor: optionalStringField(value, "cursor", ""),
				nextCursor: optionalStringField(value, "nextCursor", ""),
				backwardsCursor: optionalStringField(value, "backwardsCursor", ""),
				sortKey: optionalStringField(value, "sortKey", ""),
				sortDirection: optionalStringField(value, "sortDirection", ""),
				pageSize: optionalIntField(value, "pageSize", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				rowIndex: optionalIntField(value, "rowIndex", 0),
				createdAt: optionalIntField(value, "createdAt", 0),
				updatedAt: optionalIntField(value, "updatedAt", 0),
				validThreadId: optionalBoolField(value, "validThreadId", false),
				uuidParsed: optionalBoolField(value, "uuidParsed", false),
				lookupRequested: optionalBoolField(value, "lookupRequested", false),
				archivedScope: optionalBoolField(value, "archivedScope", false),
				includeNonInteractive: optionalBoolField(value, "includeNonInteractive", false),
				useStateDbOnly: optionalBoolField(value, "useStateDbOnly", false),
				archivedMatchesFilter: optionalBoolField(value, "archivedMatchesFilter", false),
				rowAccepted: optionalBoolField(value, "rowAccepted", false),
				exactNameMatched: optionalBoolField(value, "exactNameMatched", false),
				resolved: optionalBoolField(value, "resolved", false),
				archiveRequested: optionalBoolField(value, "archiveRequested", false),
				unarchiveRequested: optionalBoolField(value, "unarchiveRequested", false),
				mutationSucceeded: optionalBoolField(value, "mutationSucceeded", false),
				responseEmpty: optionalBoolField(value, "responseEmpty", false),
				responseHasThread: optionalBoolField(value, "responseHasThread", false),
				errorWrapped: optionalBoolField(value, "errorWrapped", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSideConversationPlan(object:Value, name:String):Null<TuiSmokeSideConversationPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSideConversationPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: sideConversationActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function sideConversationActions(values:Array<Value>):Array<TuiSmokeSideConversationAction> {
		final out:Array<TuiSmokeSideConversationAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSideConversationAction({
				kind: TuiSmokeSideConversationActionKind.fromString(stringField(value, "kind", "")),
				handoffMode: TuiSmokeAppThreadInputHandoffMode.fromString(optionalStringField(value, "handoffMode", "unknown")),
				parentThreadId: optionalStringField(value, "parentThreadId", ""),
				childThreadId: optionalStringField(value, "childThreadId", ""),
				targetThreadId: optionalStringField(value, "targetThreadId", ""),
				activeThreadId: optionalStringField(value, "activeThreadId", ""),
				sourceThreadId: optionalStringField(value, "sourceThreadId", ""),
				status: optionalStringField(value, "status", ""),
				statusChange: optionalStringField(value, "statusChange", ""),
				label: optionalStringField(value, "label", ""),
				blockMessage: optionalStringField(value, "blockMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				userMessageText: optionalStringField(value, "userMessageText", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				sideThreadsBefore: optionalIntField(value, "sideThreadsBefore", 0),
				sideThreadsAfter: optionalIntField(value, "sideThreadsAfter", 0),
				pendingInputCount: optionalIntField(value, "pendingInputCount", 0),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				localImageCount: optionalIntField(value, "localImageCount", 0),
				mentionBindingCount: optionalIntField(value, "mentionBindingCount", 0),
				parentIsMain: optionalBoolField(value, "parentIsMain", false),
				sideConversationActiveBefore: optionalBoolField(value, "sideConversationActiveBefore", false),
				sideConversationActiveAfter: optionalBoolField(value, "sideConversationActiveAfter", false),
				noticeSuppressedBefore: optionalBoolField(value, "noticeSuppressedBefore", false),
				noticeSuppressedAfter: optionalBoolField(value, "noticeSuppressedAfter", false),
				renameBlockedBefore: optionalBoolField(value, "renameBlockedBefore", false),
				renameBlockedAfter: optionalBoolField(value, "renameBlockedAfter", false),
				overlayActive: optionalBoolField(value, "overlayActive", false),
				modalOrPopupActive: optionalBoolField(value, "modalOrPopupActive", false),
				composerEmpty: optionalBoolField(value, "composerEmpty", false),
				parentStatusActionable: optionalBoolField(value, "parentStatusActionable", false),
				forkConfigEphemeral: optionalBoolField(value, "forkConfigEphemeral", false),
				developerInstructionsAdded: optionalBoolField(value, "developerInstructionsAdded", false),
				modelInherited: optionalBoolField(value, "modelInherited", false),
				serviceTierInherited: optionalBoolField(value, "serviceTierInherited", false),
				boundaryInjected: optionalBoolField(value, "boundaryInjected", false),
				hiddenBoundaryPrompt: optionalBoolField(value, "hiddenBoundaryPrompt", false),
				switchedToChild: optionalBoolField(value, "switchedToChild", false),
				switchedToParent: optionalBoolField(value, "switchedToParent", false),
				submittedInitialUserMessage: optionalBoolField(value, "submittedInitialUserMessage", false),
				restoredComposer: optionalBoolField(value, "restoredComposer", false),
				returnRequested: optionalBoolField(value, "returnRequested", false),
				returnedToParent: optionalBoolField(value, "returnedToParent", false),
				interruptSubmitted: optionalBoolField(value, "interruptSubmitted", false),
				startupInterruptUsed: optionalBoolField(value, "startupInterruptUsed", false),
				turnInterruptUsed: optionalBoolField(value, "turnInterruptUsed", false),
				threadUnsubscribed: optionalBoolField(value, "threadUnsubscribed", false),
				localStateDiscarded: optionalBoolField(value, "localStateDiscarded", false),
				listenerAborted: optionalBoolField(value, "listenerAborted", false),
				channelRemoved: optionalBoolField(value, "channelRemoved", false),
				navigationRemoved: optionalBoolField(value, "navigationRemoved", false),
				activeThreadCleared: optionalBoolField(value, "activeThreadCleared", false),
				approvalsRefreshed: optionalBoolField(value, "approvalsRefreshed", false),
				statusSynced: optionalBoolField(value, "statusSynced", false),
				activeThreadPresent: optionalBoolField(value, "activeThreadPresent", false),
				activeThreadStored: optionalBoolField(value, "activeThreadStored", false),
				receiverStored: optionalBoolField(value, "receiverStored", false),
				inputStateCaptured: optionalBoolField(value, "inputStateCaptured", false),
				snapshotStored: optionalBoolField(value, "snapshotStored", false),
				snapshotInputStatePresent: optionalBoolField(value, "snapshotInputStatePresent", false),
				targetActivated: optionalBoolField(value, "targetActivated", false),
				restoredIntoTarget: optionalBoolField(value, "restoredIntoTarget", false),
				missingSnapshotFallback: optionalBoolField(value, "missingSnapshotFallback", false),
				sideThreadTarget: optionalBoolField(value, "sideThreadTarget", false),
				currentThreadTarget: optionalBoolField(value, "currentThreadTarget", false),
				pendingInputPreserved: optionalBoolField(value, "pendingInputPreserved", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetInterruptedRestorePlan(object:Value, name:String):Null<TuiSmokeChatWidgetInterruptedRestorePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetInterruptedRestorePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: chatWidgetInterruptedRestoreActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function chatWidgetInterruptedRestoreActions(values:Array<Value>):Array<TuiSmokeChatWidgetInterruptedRestoreAction> {
		final out:Array<TuiSmokeChatWidgetInterruptedRestoreAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetInterruptedRestoreAction({
				kind: TuiSmokeChatWidgetInterruptedRestoreActionKind.fromString(stringField(value, "kind", "")),
				threadInputStateMode: TuiSmokeChatWidgetThreadInputStateMode.fromString(optionalStringField(value, "threadInputStateMode", "unknown")),
				reason: optionalStringField(value, "reason", ""),
				noticeMode: optionalStringField(value, "noticeMode", ""),
				noticeText: optionalStringField(value, "noticeText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				initialMessage: optionalStringField(value, "initialMessage", ""),
				promptText: optionalStringField(value, "promptText", ""),
				restoredText: optionalStringField(value, "restoredText", ""),
				composerText: optionalStringField(value, "composerText", ""),
				queueSource: optionalStringField(value, "queueSource", ""),
				popOrder: optionalStringField(value, "popOrder", ""),
				mergeOrder: TuiSmokeChatWidgetRestoreMergeOrder.fromString(optionalStringField(value, "mergeOrder", "unknown")),
				historyRecord: optionalStringField(value, "historyRecord", ""),
				currentStatusHeader: optionalStringField(value, "currentStatusHeader", ""),
				retryStatusHeaderBefore: optionalStringField(value, "retryStatusHeaderBefore", ""),
				retryStatusHeaderAfter: optionalStringField(value, "retryStatusHeaderAfter", ""),
				restoredStatusHeader: optionalStringField(value, "restoredStatusHeader", ""),
				retryDetails: optionalStringField(value, "retryDetails", ""),
				currentCollaborationMode: optionalStringField(value, "currentCollaborationMode", ""),
				activeCollaborationMode: optionalStringField(value, "activeCollaborationMode", ""),
				localImageLabelsBefore: optionalStringField(value, "localImageLabelsBefore", ""),
				localImageLabelsAfter: optionalStringField(value, "localImageLabelsAfter", ""),
				textElementRanges: optionalStringField(value, "textElementRanges", ""),
				queuedMessagesBefore: optionalIntField(value, "queuedMessagesBefore", 0),
				queuedMessagesAfter: optionalIntField(value, "queuedMessagesAfter", 0),
				pendingSteersBefore: optionalIntField(value, "pendingSteersBefore", 0),
				pendingSteersAfter: optionalIntField(value, "pendingSteersAfter", 0),
				pendingSteerHistoryRecords: optionalIntField(value, "pendingSteerHistoryRecords", 0),
				pendingSteerCompareKeys: optionalIntField(value, "pendingSteerCompareKeys", 0),
				rejectedSteersBefore: optionalIntField(value, "rejectedSteersBefore", 0),
				rejectedSteersAfter: optionalIntField(value, "rejectedSteersAfter", 0),
				rejectedSteerHistoryRecords: optionalIntField(value, "rejectedSteerHistoryRecords", 0),
				queuedUserMessageHistoryRecords: optionalIntField(value, "queuedUserMessageHistoryRecords", 0),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				localImageCount: optionalIntField(value, "localImageCount", 0),
				mentionBindingCount: optionalIntField(value, "mentionBindingCount", 0),
				textElementCount: optionalIntField(value, "textElementCount", 0),
				pendingPasteCount: optionalIntField(value, "pendingPasteCount", 0),
				cancelEditEligibleBefore: optionalBoolField(value, "cancelEditEligibleBefore", false),
				cancelEditEligibleAfter: optionalBoolField(value, "cancelEditEligibleAfter", false),
				cancelEditArmedBefore: optionalBoolField(value, "cancelEditArmedBefore", false),
				cancelEditArmedAfter: optionalBoolField(value, "cancelEditArmedAfter", false),
				cancelEditPromptBefore: optionalBoolField(value, "cancelEditPromptBefore", false),
				cancelEditPromptAfter: optionalBoolField(value, "cancelEditPromptAfter", false),
				composerEmpty: optionalBoolField(value, "composerEmpty", false),
				sideConversationActive: optionalBoolField(value, "sideConversationActive", false),
				sendPendingSteersImmediately: optionalBoolField(value, "sendPendingSteersImmediately", false),
				submitPendingSteersAfterInterruptBefore: optionalBoolField(value, "submitPendingSteersAfterInterruptBefore", false),
				submitPendingSteersAfterInterruptAfter: optionalBoolField(value, "submitPendingSteersAfterInterruptAfter", false),
				agentTurnRunningBefore: optionalBoolField(value, "agentTurnRunningBefore", false),
				agentTurnRunningAfter: optionalBoolField(value, "agentTurnRunningAfter", false),
				taskRunningBefore: optionalBoolField(value, "taskRunningBefore", false),
				taskRunningAfter: optionalBoolField(value, "taskRunningAfter", false),
				sleepInhibitorRunningBefore: optionalBoolField(value, "sleepInhibitorRunningBefore", false),
				sleepInhibitorRunningAfter: optionalBoolField(value, "sleepInhibitorRunningAfter", false),
				userTurnPendingBefore: optionalBoolField(value, "userTurnPendingBefore", false),
				userTurnPendingAfter: optionalBoolField(value, "userTurnPendingAfter", false),
				finalizedTurn: optionalBoolField(value, "finalizedTurn", false),
				noticeInserted: optionalBoolField(value, "noticeInserted", false),
				noticeSuppressed: optionalBoolField(value, "noticeSuppressed", false),
				pendingMerged: optionalBoolField(value, "pendingMerged", false),
				queuedMerged: optionalBoolField(value, "queuedMerged", false),
				composerMerged: optionalBoolField(value, "composerMerged", false),
				composerRestored: optionalBoolField(value, "composerRestored", false),
				historyFallback: optionalBoolField(value, "historyFallback", false),
				historyOverrideApplied: optionalBoolField(value, "historyOverrideApplied", false),
				historyRecordsResized: optionalBoolField(value, "historyRecordsResized", false),
				compareKeyFallbackUsed: optionalBoolField(value, "compareKeyFallbackUsed", false),
				pendingSteersPreserved: optionalBoolField(value, "pendingSteersPreserved", false),
				queuedDraftsPreserved: optionalBoolField(value, "queuedDraftsPreserved", false),
				inputStatePresent: optionalBoolField(value, "inputStatePresent", false),
				inputStateCleared: optionalBoolField(value, "inputStateCleared", false),
				collaborationModeRestored: optionalBoolField(value, "collaborationModeRestored", false),
				modelSurfacesRefreshed: optionalBoolField(value, "modelSurfacesRefreshed", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				remoteImagesCleared: optionalBoolField(value, "remoteImagesCleared", false),
				pendingPastesCleared: optionalBoolField(value, "pendingPastesCleared", false),
				localPlaceholdersRemapped: optionalBoolField(value, "localPlaceholdersRemapped", false),
				textElementsRebased: optionalBoolField(value, "textElementsRebased", false),
				cursorAtEnd: optionalBoolField(value, "cursorAtEnd", false),
				cancelledTurnRestoreEventSent: optionalBoolField(value, "cancelledTurnRestoreEventSent", false),
				cancelEditPromptTaken: optionalBoolField(value, "cancelEditPromptTaken", false),
				initialMessageSubmitted: optionalBoolField(value, "initialMessageSubmitted", false),
				initialMessageSuppressed: optionalBoolField(value, "initialMessageSuppressed", false),
				elevatedSandboxBlocked: optionalBoolField(value, "elevatedSandboxBlocked", false),
				enqueueRejectedSteerSucceeded: optionalBoolField(value, "enqueueRejectedSteerSucceeded", false),
				queueAutosendSuppressed: optionalBoolField(value, "queueAutosendSuppressed", false),
				pendingPreviewRefreshed: optionalBoolField(value, "pendingPreviewRefreshed", false),
				willRetry: optionalBoolField(value, "willRetry", false),
				fromReplay: optionalBoolField(value, "fromReplay", false),
				retryStatusRemembered: optionalBoolField(value, "retryStatusRemembered", false),
				retryStatusTaken: optionalBoolField(value, "retryStatusTaken", false),
				statusIndicatorVisible: optionalBoolField(value, "statusIndicatorVisible", false),
				retryStatusShown: optionalBoolField(value, "retryStatusShown", false),
				retryStatusRestored: optionalBoolField(value, "retryStatusRestored", false),
				threadRollbackSent: optionalBoolField(value, "threadRollbackSent", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalStatusSurfaceRenderPlan(object:Value, name:String):Null<TuiSmokeStatusSurfaceRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusSurfaceRenderPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: statusSurfaceRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusSurfaceRenderActions(values:Array<Value>):Array<TuiSmokeStatusSurfaceRenderAction> {
		final out:Array<TuiSmokeStatusSurfaceRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusSurfaceRenderAction({
				kind: TuiSmokeStatusSurfaceRenderActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				surface: optionalStringField(value, "surface", ""),
				itemIds: optionalStringField(value, "itemIds", ""),
				indicator: optionalStringField(value, "indicator", ""),
				model: optionalStringField(value, "model", ""),
				branch: optionalStringField(value, "branch", ""),
				gitSummary: optionalStringField(value, "gitSummary", ""),
				rawOutputLabel: optionalStringField(value, "rawOutputLabel", ""),
				runState: optionalStringField(value, "runState", ""),
				statusHeader: optionalStringField(value, "statusHeader", ""),
				statusDetails: optionalStringField(value, "statusDetails", ""),
				warningCode: optionalStringField(value, "warningCode", ""),
				warningMessage: optionalStringField(value, "warningMessage", ""),
				previewItems: optionalStringField(value, "previewItems", ""),
				renderedText: optionalStringField(value, "renderedText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				itemCount: optionalIntField(value, "itemCount", 0),
				visibleCount: optionalIntField(value, "visibleCount", 0),
				segmentCount: optionalIntField(value, "segmentCount", 0),
				warningCount: optionalIntField(value, "warningCount", 0),
				dedupeCount: optionalIntField(value, "dedupeCount", 0),
				revisionBefore: optionalIntField(value, "revisionBefore", 0),
				revisionAfter: optionalIntField(value, "revisionAfter", 0),
				statusLineEnabled: optionalBoolField(value, "statusLineEnabled", false),
				terminalTitleEnabled: optionalBoolField(value, "terminalTitleEnabled", false),
				modelVisible: optionalBoolField(value, "modelVisible", false),
				branchVisible: optionalBoolField(value, "branchVisible", false),
				gitSummaryVisible: optionalBoolField(value, "gitSummaryVisible", false),
				rawOutputVisible: optionalBoolField(value, "rawOutputVisible", false),
				activityVisible: optionalBoolField(value, "activityVisible", false),
				warningsVisible: optionalBoolField(value, "warningsVisible", false),
				warningDeduped: optionalBoolField(value, "warningDeduped", false),
				previewStarted: optionalBoolField(value, "previewStarted", false),
				previewCommitted: optionalBoolField(value, "previewCommitted", false),
				previewReverted: optionalBoolField(value, "previewReverted", false),
				branchRequested: optionalBoolField(value, "branchRequested", false),
				gitSummaryRequested: optionalBoolField(value, "gitSummaryRequested", false),
				hyperlinkAnnotated: optionalBoolField(value, "hyperlinkAnnotated", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSlashCommandPlan(object:Value, name:String):Null<TuiSmokeSlashCommandPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSlashCommandPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: slashCommandActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function slashCommandActions(values:Array<Value>):Array<TuiSmokeSlashCommandAction> {
		final out:Array<TuiSmokeSlashCommandAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSlashCommandAction({
				kind: TuiSmokeSlashCommandActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				command: optionalStringField(value, "command", ""),
				args: optionalStringField(value, "args", ""),
				appEvent: optionalStringField(value, "appEvent", ""),
				notice: optionalStringField(value, "notice", ""),
				statusCard: optionalStringField(value, "statusCard", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				requestId: optionalIntField(value, "requestId", 0),
				historyStaged: optionalBoolField(value, "historyStaged", false),
				historyRecorded: optionalBoolField(value, "historyRecorded", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				sideConversation: optionalBoolField(value, "sideConversation", false),
				sideAllowed: optionalBoolField(value, "sideAllowed", false),
				commandAllowed: optionalBoolField(value, "commandAllowed", false),
				supportsInlineArgs: optionalBoolField(value, "supportsInlineArgs", false),
				argsTrimmed: optionalBoolField(value, "argsTrimmed", false),
				fallbackToBare: optionalBoolField(value, "fallbackToBare", false),
				rawOutputBefore: optionalBoolField(value, "rawOutputBefore", false),
				rawOutputAfter: optionalBoolField(value, "rawOutputAfter", false),
				configUpdated: optionalBoolField(value, "configUpdated", false),
				noticeInserted: optionalBoolField(value, "noticeInserted", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				appEventSent: optionalBoolField(value, "appEventSent", false),
				statusOutputInserted: optionalBoolField(value, "statusOutputInserted", false),
				rateLimitPrefetch: optionalBoolField(value, "rateLimitPrefetch", false),
				statusRefreshing: optionalBoolField(value, "statusRefreshing", false),
				submissionDrained: optionalBoolField(value, "submissionDrained", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalStatusCardPlan(object:Value, name:String):Null<TuiSmokeStatusCardPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusCardPlan({
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					allowAppServerMutation: optionalBoolField(value, "allowAppServerMutation", false),
					actions: statusCardActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusCardActions(values:Array<Value>):Array<TuiSmokeStatusCardAction> {
		final out:Array<TuiSmokeStatusCardAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusCardAction({
				kind: TuiSmokeStatusCardActionKind.fromString(stringField(value, "kind", "")),
				commandRow: optionalStringField(value, "commandRow", ""),
				rowName: optionalStringField(value, "rowName", ""),
				model: optionalStringField(value, "model", ""),
				modelDetails: optionalStringField(value, "modelDetails", ""),
				provider: optionalStringField(value, "provider", ""),
				runtimeProvider: optionalStringField(value, "runtimeProvider", ""),
				account: optionalStringField(value, "account", ""),
				directory: optionalStringField(value, "directory", ""),
				permissions: optionalStringField(value, "permissions", ""),
				agentsSummary: optionalStringField(value, "agentsSummary", ""),
				threadName: optionalStringField(value, "threadName", ""),
				sessionId: optionalStringField(value, "sessionId", ""),
				forkedFrom: optionalStringField(value, "forkedFrom", ""),
				collaborationMode: optionalStringField(value, "collaborationMode", ""),
				rateLimitState: optionalStringField(value, "rateLimitState", ""),
				rateLimitLabel: optionalStringField(value, "rateLimitLabel", ""),
				rateLimitSummary: optionalStringField(value, "rateLimitSummary", ""),
				rateLimitReset: optionalStringField(value, "rateLimitReset", ""),
				rateLimitDetails: optionalStringField(value, "rateLimitDetails", ""),
				rateLimitWarning: optionalStringField(value, "rateLimitWarning", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				remoteAddress: optionalStringField(value, "remoteAddress", ""),
				totalTokens: optionalIntField(value, "totalTokens", 0),
				inputTokens: optionalIntField(value, "inputTokens", 0),
				outputTokens: optionalIntField(value, "outputTokens", 0),
				contextUsed: optionalIntField(value, "contextUsed", 0),
				contextWindow: optionalIntField(value, "contextWindow", 0),
				contextPercentRemaining: optionalIntField(value, "contextPercentRemaining", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				rateLimitRowCount: optionalIntField(value, "rateLimitRowCount", 0),
				width: optionalIntField(value, "width", 0),
				innerWidth: optionalIntField(value, "innerWidth", 0),
				valueWidth: optionalIntField(value, "valueWidth", 0),
				wrappedLineCount: optionalIntField(value, "wrappedLineCount", 0),
				continuationLineCount: optionalIntField(value, "continuationLineCount", 0),
				truncatedLineCount: optionalIntField(value, "truncatedLineCount", 0),
				hiddenRowCount: optionalIntField(value, "hiddenRowCount", 0),
				requestId: optionalIntField(value, "requestId", -1),
				nextRequestId: optionalIntField(value, "nextRequestId", 0),
				pendingRefreshCount: optionalIntField(value, "pendingRefreshCount", 0),
				remainingRefreshCount: optionalIntField(value, "remainingRefreshCount", 0),
				snapshotPercentRemaining: optionalIntField(value, "snapshotPercentRemaining", 0),
				refreshingRateLimits: optionalBoolField(value, "refreshingRateLimits", false),
				showChatGptUsageLink: optionalBoolField(value, "showChatGptUsageLink", false),
				remoteConnectionVisible: optionalBoolField(value, "remoteConnectionVisible", false),
				rowVisible: optionalBoolField(value, "rowVisible", false),
				tokenUsageVisible: optionalBoolField(value, "tokenUsageVisible", false),
				contextWindowVisible: optionalBoolField(value, "contextWindowVisible", false),
				statusOutputInserted: optionalBoolField(value, "statusOutputInserted", false),
				refreshCompleted: optionalBoolField(value, "refreshCompleted", false),
				appEventEmitted: optionalBoolField(value, "appEventEmitted", false),
				statusHistoryUpdated: optionalBoolField(value, "statusHistoryUpdated", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				cachedForFutureStatus: optionalBoolField(value, "cachedForFutureStatus", false),
				staleCompletionIgnored: optionalBoolField(value, "staleCompletionIgnored", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				noAppServerMutation: optionalBoolField(value, "noAppServerMutation", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetInterruptQuitPlan(object:Value, name:String):Null<TuiSmokeChatWidgetInterruptQuitPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetInterruptQuitPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: chatWidgetInterruptQuitActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function chatWidgetInterruptQuitActions(values:Array<Value>):Array<TuiSmokeChatWidgetInterruptQuitAction> {
		final out:Array<TuiSmokeChatWidgetInterruptQuitAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetInterruptQuitAction({
				kind: TuiSmokeChatWidgetInterruptQuitActionKind.fromString(stringField(value, "kind", "")),
				ctrlCPrecedence: TuiSmokeChatWidgetCtrlCPrecedenceKind.fromString(optionalStringField(value, "ctrlCPrecedence", "unknown")),
				interruptKeyRoute: TuiSmokeChatWidgetInterruptKeyRouteKind.fromString(optionalStringField(value, "interruptKeyRoute",
					optionalStringField(value, "route", "unknown"))),
				shortcutTransition: TuiSmokeChatWidgetQuitShortcutTransitionKind.fromString(optionalStringField(value, "shortcutTransition", "unknown")),
				key: optionalStringField(value, "key", ""),
				activeShortcutKeyBefore: optionalStringField(value, "activeShortcutKeyBefore", ""),
				activeShortcutKeyAfter: optionalStringField(value, "activeShortcutKeyAfter", ""),
				route: optionalStringField(value, "route", ""),
				exitMode: optionalStringField(value, "exitMode", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				doublePressEnabled: optionalBoolField(value, "doublePressEnabled", false),
				realtimeLive: optionalBoolField(value, "realtimeLive", false),
				realtimeStopped: optionalBoolField(value, "realtimeStopped", false),
				modalOrPopupActive: optionalBoolField(value, "modalOrPopupActive", false),
				bottomPaneAttempted: optionalBoolField(value, "bottomPaneAttempted", false),
				bottomPaneHandled: optionalBoolField(value, "bottomPaneHandled", false),
				cancellableWorkActive: optionalBoolField(value, "cancellableWorkActive", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				reviewMode: optionalBoolField(value, "reviewMode", false),
				composerEmpty: optionalBoolField(value, "composerEmpty", false),
				quitShortcutActiveBefore: optionalBoolField(value, "quitShortcutActiveBefore", false),
				quitShortcutActiveAfter: optionalBoolField(value, "quitShortcutActiveAfter", false),
				quitShortcutKeyMatched: optionalBoolField(value, "quitShortcutKeyMatched", false),
				quitShortcutHintShown: optionalBoolField(value, "quitShortcutHintShown", false),
				quitShortcutHintCleared: optionalBoolField(value, "quitShortcutHintCleared", false),
				quitShortcutExpired: optionalBoolField(value, "quitShortcutExpired", false),
				interruptSubmitted: optionalBoolField(value, "interruptSubmitted", false),
				interruptRestoresPrompt: optionalBoolField(value, "interruptRestoresPrompt", false),
				interruptBindingMatched: optionalBoolField(value, "interruptBindingMatched", false),
				pendingSteersBefore: optionalIntField(value, "pendingSteersBefore", 0),
				pendingSteersAfter: optionalIntField(value, "pendingSteersAfter", 0),
				submitPendingSteersAfterInterrupt: optionalBoolField(value, "submitPendingSteersAfterInterrupt", false),
				queuedSteerSubmittedAfterInterrupt: optionalBoolField(value, "queuedSteerSubmittedAfterInterrupt", false),
				reviewWarningInserted: optionalBoolField(value, "reviewWarningInserted", false),
				activeGoalPaused: optionalBoolField(value, "activeGoalPaused", false),
				streamQueueCleared: optionalBoolField(value, "streamQueueCleared", false),
				planStreamQueueCleared: optionalBoolField(value, "planStreamQueueCleared", false),
				activeTailCleared: optionalBoolField(value, "activeTailCleared", false),
				cancelEditArmedBefore: optionalBoolField(value, "cancelEditArmedBefore", false),
				cancelEditArmedAfter: optionalBoolField(value, "cancelEditArmedAfter", false),
				cancelEditCleared: optionalBoolField(value, "cancelEditCleared", false),
				appExitSent: optionalBoolField(value, "appExitSent", false),
				shutdownFeedbackShown: optionalBoolField(value, "shutdownFeedbackShown", false),
				appServerShutdownRequested: optionalBoolField(value, "appServerShutdownRequested", false),
				pendingShutdownThreadBefore: optionalBoolField(value, "pendingShutdownThreadBefore", false),
				pendingShutdownThreadAfter: optionalBoolField(value, "pendingShutdownThreadAfter", false),
				inputDisabled: optionalBoolField(value, "inputDisabled", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetStreamLifecyclePlan(object:Value, name:String):Null<TuiSmokeChatWidgetStreamLifecyclePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetStreamLifecyclePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: chatWidgetStreamLifecycleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function optionalMcpStartupPlan(object:Value, name:String):Null<TuiSmokeMcpStartupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeMcpStartupPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: mcpStartupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function optionalStatusSurfacePlan(object:Value, name:String):Null<TuiSmokeStatusSurfacePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusSurfacePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: statusSurfaceActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusSurfaceActions(values:Array<Value>):Array<TuiSmokeStatusSurfaceAction> {
		final out:Array<TuiSmokeStatusSurfaceAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusSurfaceAction({
				kind: TuiSmokeStatusSurfaceActionKind.fromString(stringField(value, "kind", "")),
				statusLineItems: optionalStringField(value, "statusLineItems", ""),
				terminalTitleItems: optionalStringField(value, "terminalTitleItems", ""),
				invalidStatusLineItems: optionalStringField(value, "invalidStatusLineItems", ""),
				invalidTerminalTitleItems: optionalStringField(value, "invalidTerminalTitleItems", ""),
				statusLineText: optionalStringField(value, "statusLineText", ""),
				statusLineHyperlink: optionalStringField(value, "statusLineHyperlink", ""),
				terminalTitle: optionalStringField(value, "terminalTitle", ""),
				lastTerminalTitleBefore: optionalStringField(value, "lastTerminalTitleBefore", ""),
				lastTerminalTitleAfter: optionalStringField(value, "lastTerminalTitleAfter", ""),
				statusHeader: optionalStringField(value, "statusHeader", ""),
				statusDetails: optionalStringField(value, "statusDetails", ""),
				configuredItems: optionalStringField(value, "configuredItems", ""),
				originalItems: optionalStringField(value, "originalItems", ""),
				cwd: optionalStringField(value, "cwd", ""),
				branch: optionalStringField(value, "branch", ""),
				gitSummary: optionalStringField(value, "gitSummary", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				statusLineItemCount: optionalIntField(value, "statusLineItemCount", 0),
				terminalTitleItemCount: optionalIntField(value, "terminalTitleItemCount", 0),
				statusLineSegmentCount: optionalIntField(value, "statusLineSegmentCount", 0),
				invalidWarningCount: optionalIntField(value, "invalidWarningCount", 0),
				frameDelayMs: optionalIntField(value, "frameDelayMs", 0),
				threadPresent: optionalBoolField(value, "threadPresent", false),
				statusLineEnabled: optionalBoolField(value, "statusLineEnabled", false),
				terminalTitleEmptySelection: optionalBoolField(value, "terminalTitleEmptySelection", false),
				usesGitBranch: optionalBoolField(value, "usesGitBranch", false),
				usesGitSummary: optionalBoolField(value, "usesGitSummary", false),
				branchReset: optionalBoolField(value, "branchReset", false),
				branchRequested: optionalBoolField(value, "branchRequested", false),
				branchStaleIgnored: optionalBoolField(value, "branchStaleIgnored", false),
				gitSummaryReset: optionalBoolField(value, "gitSummaryReset", false),
				gitSummaryRequested: optionalBoolField(value, "gitSummaryRequested", false),
				gitSummaryStaleIgnored: optionalBoolField(value, "gitSummaryStaleIgnored", false),
				statusInvalidWarningInserted: optionalBoolField(value, "statusInvalidWarningInserted", false),
				statusInvalidWarningSuppressed: optionalBoolField(value, "statusInvalidWarningSuppressed", false),
				titleInvalidWarningInserted: optionalBoolField(value, "titleInvalidWarningInserted", false),
				titleInvalidWarningSuppressed: optionalBoolField(value, "titleInvalidWarningSuppressed", false),
				statusLineCleared: optionalBoolField(value, "statusLineCleared", false),
				hyperlinkCleared: optionalBoolField(value, "hyperlinkCleared", false),
				terminalTitleCleared: optionalBoolField(value, "terminalTitleCleared", false),
				terminalTitleSkippedDuplicate: optionalBoolField(value, "terminalTitleSkippedDuplicate", false),
				terminalTitleNoVisibleContent: optionalBoolField(value, "terminalTitleNoVisibleContent", false),
				terminalTitleSet: optionalBoolField(value, "terminalTitleSet", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				titleUsesStatus: optionalBoolField(value, "titleUsesStatus", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				statusLineSetupCommitted: optionalBoolField(value, "statusLineSetupCommitted", false),
				statusLineSetupCancelled: optionalBoolField(value, "statusLineSetupCancelled", false),
				terminalTitlePreviewStarted: optionalBoolField(value, "terminalTitlePreviewStarted", false),
				terminalTitlePreviewReverted: optionalBoolField(value, "terminalTitlePreviewReverted", false),
				terminalTitleSetupCommitted: optionalBoolField(value, "terminalTitleSetupCommitted", false),
				originalSnapshotCleared: optionalBoolField(value, "originalSnapshotCleared", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalStatusStatePlan(object:Value, name:String):Null<TuiSmokeStatusStatePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeStatusStatePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: statusStateActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function statusStateActions(values:Array<Value>):Array<TuiSmokeStatusStateAction> {
		final out:Array<TuiSmokeStatusStateAction> = [];
		for (value in values) {
			out.push(new TuiSmokeStatusStateAction({
				kind: TuiSmokeStatusStateActionKind.fromString(stringField(value, "kind", "")),
				id: optionalStringField(value, "id", ""),
				header: optionalStringField(value, "header", ""),
				details: optionalStringField(value, "details", ""),
				detail: optionalStringField(value, "detail", ""),
				entries: optionalStringField(value, "entries", ""),
				terminalTitleStatusKind: optionalStringField(value, "terminalTitleStatusKind", ""),
				retryHeaderBefore: optionalStringField(value, "retryHeaderBefore", ""),
				retryHeaderAfter: optionalStringField(value, "retryHeaderAfter", ""),
				takenHeader: optionalStringField(value, "takenHeader", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				entryCount: optionalIntField(value, "entryCount", 0),
				detailsMaxLines: optionalIntField(value, "detailsMaxLines", 0),
				overflowCount: optionalIntField(value, "overflowCount", 0),
				changed: optionalBoolField(value, "changed", false),
				guardianEmpty: optionalBoolField(value, "guardianEmpty", false),
				statusPresent: optionalBoolField(value, "statusPresent", false),
				guardianReviewHeader: optionalBoolField(value, "guardianReviewHeader", false),
				retryHeaderRemembered: optionalBoolField(value, "retryHeaderRemembered", false),
				retryHeaderTaken: optionalBoolField(value, "retryHeaderTaken", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalCommandLifecyclePlan(object:Value, name:String):Null<TuiSmokeCommandLifecyclePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeCommandLifecyclePlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowProcessSpawn: optionalBoolField(value, "allowProcessSpawn", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: commandLifecycleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function commandLifecycleActions(values:Array<Value>):Array<TuiSmokeCommandLifecycleAction> {
		final out:Array<TuiSmokeCommandLifecycleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeCommandLifecycleAction({
				kind: TuiSmokeCommandLifecycleActionKind.fromString(stringField(value, "kind", "")),
				callId: optionalStringField(value, "callId", ""),
				processId: optionalStringField(value, "processId", ""),
				source: optionalStringField(value, "source", ""),
				command: optionalStringField(value, "command", ""),
				commandDisplay: optionalStringField(value, "commandDisplay", ""),
				parsedKind: optionalStringField(value, "parsedKind", ""),
				activeCell: optionalStringField(value, "activeCell", ""),
				endTarget: optionalStringField(value, "endTarget", ""),
				stdout: optionalStringField(value, "stdout", ""),
				stderr: optionalStringField(value, "stderr", ""),
				aggregatedOutput: optionalStringField(value, "aggregatedOutput", ""),
				recentChunks: optionalStringField(value, "recentChunks", ""),
				footerProcesses: optionalStringField(value, "footerProcesses", ""),
				statusHeader: optionalStringField(value, "statusHeader", ""),
				statusDetails: optionalStringField(value, "statusDetails", ""),
				stdin: optionalStringField(value, "stdin", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				recentChunkCountBefore: optionalIntField(value, "recentChunkCountBefore", 0),
				recentChunkCountAfter: optionalIntField(value, "recentChunkCountAfter", 0),
				processCountBefore: optionalIntField(value, "processCountBefore", 0),
				processCountAfter: optionalIntField(value, "processCountAfter", 0),
				runningCommandCountBefore: optionalIntField(value, "runningCommandCountBefore", 0),
				runningCommandCountAfter: optionalIntField(value, "runningCommandCountAfter", 0),
				exitCode: optionalIntField(value, "exitCode", 0),
				durationMs: optionalIntField(value, "durationMs", 0),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				unifiedSource: optionalBoolField(value, "unifiedSource", false),
				startupSource: optionalBoolField(value, "startupSource", false),
				standardToolCall: optionalBoolField(value, "standardToolCall", false),
				statusEnsured: optionalBoolField(value, "statusEnsured", false),
				answerStreamFlushed: optionalBoolField(value, "answerStreamFlushed", false),
				footerSynced: optionalBoolField(value, "footerSynced", false),
				outputTracked: optionalBoolField(value, "outputTracked", false),
				recentChunksTrimmed: optionalBoolField(value, "recentChunksTrimmed", false),
				waitStreakCreated: optionalBoolField(value, "waitStreakCreated", false),
				waitStreakUpdated: optionalBoolField(value, "waitStreakUpdated", false),
				waitStreakFlushed: optionalBoolField(value, "waitStreakFlushed", false),
				waitDuplicateSuppressed: optionalBoolField(value, "waitDuplicateSuppressed", false),
				commandGrouped: optionalBoolField(value, "commandGrouped", false),
				activeCellFlushed: optionalBoolField(value, "activeCellFlushed", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				activeCellRedrawn: optionalBoolField(value, "activeCellRedrawn", false),
				suppressedAfterTaskComplete: optionalBoolField(value, "suppressedAfterTaskComplete", false),
				suppressedExecCall: optionalBoolField(value, "suppressedExecCall", false),
				queuedInputDrainRequested: optionalBoolField(value, "queuedInputDrainRequested", false),
				hadWorkActivity: optionalBoolField(value, "hadWorkActivity", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noProcessSpawn: optionalBoolField(value, "noProcessSpawn", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalToolLifecyclePlan(object:Value, name:String):Null<TuiSmokeToolLifecyclePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeToolLifecyclePlan({
					allowLiveToolExecution: optionalBoolField(value, "allowLiveToolExecution", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: toolLifecycleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function toolLifecycleActions(values:Array<Value>):Array<TuiSmokeToolLifecycleAction> {
		final out:Array<TuiSmokeToolLifecycleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeToolLifecycleAction({
				kind: TuiSmokeToolLifecycleActionKind.fromString(stringField(value, "kind", "")),
				callId: optionalStringField(value, "callId", ""),
				itemKind: optionalStringField(value, "itemKind", ""),
				status: optionalStringField(value, "status", ""),
				server: optionalStringField(value, "server", ""),
				tool: optionalStringField(value, "tool", ""),
				path: optionalStringField(value, "path", ""),
				query: optionalStringField(value, "query", ""),
				action: optionalStringField(value, "action", ""),
				resultKind: optionalStringField(value, "resultKind", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				revisedPrompt: optionalStringField(value, "revisedPrompt", ""),
				savedPath: optionalStringField(value, "savedPath", ""),
				collabTool: optionalStringField(value, "collabTool", ""),
				collabStatus: optionalStringField(value, "collabStatus", ""),
				threadId: optionalStringField(value, "threadId", ""),
				summary: optionalStringField(value, "summary", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				changeCount: optionalIntField(value, "changeCount", 0),
				durationMs: optionalIntField(value, "durationMs", 0),
				queuedStartedCount: optionalIntField(value, "queuedStartedCount", 0),
				queuedCompletedCount: optionalIntField(value, "queuedCompletedCount", 0),
				pendingSpawnCountBefore: optionalIntField(value, "pendingSpawnCountBefore", 0),
				pendingSpawnCountAfter: optionalIntField(value, "pendingSpawnCountAfter", 0),
				activeCellBefore: optionalStringField(value, "activeCellBefore", ""),
				activeCellAfter: optionalStringField(value, "activeCellAfter", ""),
				activeCellMatched: optionalBoolField(value, "activeCellMatched", false),
				activeCellFlushed: optionalBoolField(value, "activeCellFlushed", false),
				answerStreamFlushed: optionalBoolField(value, "answerStreamFlushed", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				extraHistoryInserted: optionalBoolField(value, "extraHistoryInserted", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				hadWorkActivity: optionalBoolField(value, "hadWorkActivity", false),
				visibleTurnActivityRecorded: optionalBoolField(value, "visibleTurnActivityRecorded", false),
				spawnRequestCached: optionalBoolField(value, "spawnRequestCached", false),
				spawnRequestRemoved: optionalBoolField(value, "spawnRequestRemoved", false),
				queuedToStarted: optionalBoolField(value, "queuedToStarted", false),
				queuedToCompleted: optionalBoolField(value, "queuedToCompleted", false),
				noLiveToolExecution: optionalBoolField(value, "noLiveToolExecution", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalHookLifecyclePlan(object:Value, name:String):Null<TuiSmokeHookLifecyclePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeHookLifecyclePlan({
					allowLiveHookExecution: optionalBoolField(value, "allowLiveHookExecution", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: hookLifecycleActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function hookLifecycleActions(values:Array<Value>):Array<TuiSmokeHookLifecycleAction> {
		final out:Array<TuiSmokeHookLifecycleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeHookLifecycleAction({
				kind: TuiSmokeHookLifecycleActionKind.fromString(stringField(value, "kind", "")),
				runId: optionalStringField(value, "runId", ""),
				hookName: optionalStringField(value, "hookName", ""),
				eventKind: optionalStringField(value, "eventKind", ""),
				status: optionalStringField(value, "status", ""),
				output: optionalStringField(value, "output", ""),
				cwd: optionalStringField(value, "cwd", ""),
				loadedCwd: optionalStringField(value, "loadedCwd", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				browserEntry: optionalStringField(value, "browserEntry", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				activeCellBefore: optionalStringField(value, "activeCellBefore", ""),
				activeCellAfter: optionalStringField(value, "activeCellAfter", ""),
				activeRunCountBefore: optionalIntField(value, "activeRunCountBefore", 0),
				activeRunCountAfter: optionalIntField(value, "activeRunCountAfter", 0),
				completedRunCountBefore: optionalIntField(value, "completedRunCountBefore", 0),
				completedRunCountAfter: optionalIntField(value, "completedRunCountAfter", 0),
				historyCellCount: optionalIntField(value, "historyCellCount", 0),
				revisionBefore: optionalIntField(value, "revisionBefore", 0),
				revisionAfter: optionalIntField(value, "revisionAfter", 0),
				timerDelayMs: optionalIntField(value, "timerDelayMs", 0),
				fetchCount: optionalIntField(value, "fetchCount", 0),
				activeCellPresentBefore: optionalBoolField(value, "activeCellPresentBefore", false),
				activeCellPresentAfter: optionalBoolField(value, "activeCellPresentAfter", false),
				existingActiveCell: optionalBoolField(value, "existingActiveCell", false),
				completedExistingRun: optionalBoolField(value, "completedExistingRun", false),
				addedCompletedRun: optionalBoolField(value, "addedCompletedRun", false),
				createdCompletedCell: optionalBoolField(value, "createdCompletedCell", false),
				completedCellEmpty: optionalBoolField(value, "completedCellEmpty", false),
				completedOutputFlushed: optionalBoolField(value, "completedOutputFlushed", false),
				persistentOutputTaken: optionalBoolField(value, "persistentOutputTaken", false),
				activeCellEmpty: optionalBoolField(value, "activeCellEmpty", false),
				activeCellCleared: optionalBoolField(value, "activeCellCleared", false),
				shouldFlush: optionalBoolField(value, "shouldFlush", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				needsFinalSeparator: optionalBoolField(value, "needsFinalSeparator", false),
				answerStreamFlushed: optionalBoolField(value, "answerStreamFlushed", false),
				visibleTurnActivityRecorded: optionalBoolField(value, "visibleTurnActivityRecorded", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				advancedVisibility: optionalBoolField(value, "advancedVisibility", false),
				finishIdle: optionalBoolField(value, "finishIdle", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				visibleRunningRun: optionalBoolField(value, "visibleRunningRun", false),
				deadlineScheduled: optionalBoolField(value, "deadlineScheduled", false),
				staleCwdIgnored: optionalBoolField(value, "staleCwdIgnored", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				browserOpened: optionalBoolField(value, "browserOpened", false),
				fetchRequested: optionalBoolField(value, "fetchRequested", false),
				noLiveHookExecution: optionalBoolField(value, "noLiveHookExecution", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalInputSubmissionPlan(object:Value, name:String):Null<TuiSmokeInputSubmissionPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeInputSubmissionPlan({
					allowLiveProcess: optionalBoolField(value, "allowLiveProcess", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: inputSubmissionActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function inputSubmissionActions(values:Array<Value>):Array<TuiSmokeInputSubmissionAction> {
		final out:Array<TuiSmokeInputSubmissionAction> = [];
		for (value in values) {
			out.push(new TuiSmokeInputSubmissionAction({
				kind: TuiSmokeInputSubmissionActionKind.fromString(stringField(value, "kind", "")),
				text: optionalStringField(value, "text", ""),
				action: optionalStringField(value, "action", ""),
				source: optionalStringField(value, "source", ""),
				historyRecord: optionalStringField(value, "historyRecord", ""),
				shellCommand: optionalStringField(value, "shellCommand", ""),
				model: optionalStringField(value, "model", ""),
				collaborationMode: optionalStringField(value, "collaborationMode", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				previewText: optionalStringField(value, "previewText", ""),
				itemsSummary: optionalStringField(value, "itemsSummary", ""),
				mentionsSummary: optionalStringField(value, "mentionsSummary", ""),
				localImages: optionalIntField(value, "localImages", 0),
				remoteImages: optionalIntField(value, "remoteImages", 0),
				textElements: optionalIntField(value, "textElements", 0),
				mentionBindings: optionalIntField(value, "mentionBindings", 0),
				queuedBefore: optionalIntField(value, "queuedBefore", 0),
				queuedAfter: optionalIntField(value, "queuedAfter", 0),
				pendingSteersBefore: optionalIntField(value, "pendingSteersBefore", 0),
				pendingSteersAfter: optionalIntField(value, "pendingSteersAfter", 0),
				rejectedBefore: optionalIntField(value, "rejectedBefore", 0),
				rejectedAfter: optionalIntField(value, "rejectedAfter", 0),
				historyBefore: optionalIntField(value, "historyBefore", 0),
				historyAfter: optionalIntField(value, "historyAfter", 0),
				itemsCount: optionalIntField(value, "itemsCount", 0),
				skillsCount: optionalIntField(value, "skillsCount", 0),
				pluginsCount: optionalIntField(value, "pluginsCount", 0),
				appsCount: optionalIntField(value, "appsCount", 0),
				duplicatesSkipped: optionalIntField(value, "duplicatesSkipped", 0),
				budgetCountBefore: optionalIntField(value, "budgetCountBefore", 0),
				budgetCountAfter: optionalIntField(value, "budgetCountAfter", 0),
				sessionConfigured: optionalBoolField(value, "sessionConfigured", false),
				planStreaming: optionalBoolField(value, "planStreaming", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				agentTurnRunningBefore: optionalBoolField(value, "agentTurnRunningBefore", false),
				agentTurnRunningAfter: optionalBoolField(value, "agentTurnRunningAfter", false),
				sleepTurnRunningBefore: optionalBoolField(value, "sleepTurnRunningBefore", false),
				sleepTurnRunningAfter: optionalBoolField(value, "sleepTurnRunningAfter", false),
				preventIdleSleep: optionalBoolField(value, "preventIdleSleep", false),
				queued: optionalBoolField(value, "queued", false),
				submitted: optionalBoolField(value, "submitted", false),
				accepted: optionalBoolField(value, "accepted", false),
				appCommandCreated: optionalBoolField(value, "appCommandCreated", false),
				pendingPreviewRefreshed: optionalBoolField(value, "pendingPreviewRefreshed", false),
				reasoningCleared: optionalBoolField(value, "reasoningCleared", false),
				statusSet: optionalBoolField(value, "statusSet", false),
				emptyRejected: optionalBoolField(value, "emptyRejected", false),
				modelSupportsImages: optionalBoolField(value, "modelSupportsImages", false),
				restoredComposer: optionalBoolField(value, "restoredComposer", false),
				warningInserted: optionalBoolField(value, "warningInserted", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				shellEscapeAllowed: optionalBoolField(value, "shellEscapeAllowed", false),
				shellHelpInserted: optionalBoolField(value, "shellHelpInserted", false),
				shellRunCommand: optionalBoolField(value, "shellRunCommand", false),
				shellHistoryInserted: optionalBoolField(value, "shellHistoryInserted", false),
				renderInHistory: optionalBoolField(value, "renderInHistory", false),
				userTurnPendingStart: optionalBoolField(value, "userTurnPendingStart", false),
				cancelEditRecorded: optionalBoolField(value, "cancelEditRecorded", false),
				displayInserted: optionalBoolField(value, "displayInserted", false),
				finalSeparatorCleared: optionalBoolField(value, "finalSeparatorCleared", false),
				pendingSteerCreated: optionalBoolField(value, "pendingSteerCreated", false),
				historyAppended: optionalBoolField(value, "historyAppended", false),
				mentionsEncoded: optionalBoolField(value, "mentionsEncoded", false),
				ideContextApplied: optionalBoolField(value, "ideContextApplied", false),
				modelAvailable: optionalBoolField(value, "modelAvailable", false),
				blocked: optionalBoolField(value, "blocked", false),
				noLiveProcess: optionalBoolField(value, "noLiveProcess", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalTurnRuntimePlan(object:Value, name:String):Null<TuiSmokeTurnRuntimePlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeTurnRuntimePlan({
					allowLiveProcess: optionalBoolField(value, "allowLiveProcess", false),
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: turnRuntimeActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function turnRuntimeActions(values:Array<Value>):Array<TuiSmokeTurnRuntimeAction> {
		final out:Array<TuiSmokeTurnRuntimeAction> = [];
		for (value in values) {
			out.push(new TuiSmokeTurnRuntimeAction({
				kind: TuiSmokeTurnRuntimeActionKind.fromString(stringField(value, "kind", "")),
				source: optionalStringField(value, "source", ""),
				status: optionalStringField(value, "status", ""),
				message: optionalStringField(value, "message", ""),
				notificationKind: optionalStringField(value, "notificationKind", ""),
				display: optionalStringField(value, "display", ""),
				promptTitle: optionalStringField(value, "promptTitle", ""),
				mode: optionalStringField(value, "mode", ""),
				contextLabel: optionalStringField(value, "contextLabel", ""),
				errorKind: optionalStringField(value, "errorKind", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				activeGoal: optionalStringField(value, "activeGoal", ""),
				agentTurnRunning: optionalBoolField(value, "agentTurnRunning", false),
				mcpStartupRunning: optionalBoolField(value, "mcpStartupRunning", false),
				taskRunningBefore: optionalBoolField(value, "taskRunningBefore", false),
				taskRunningAfter: optionalBoolField(value, "taskRunningAfter", false),
				pendingStartBefore: optionalBoolField(value, "pendingStartBefore", false),
				pendingStartAfter: optionalBoolField(value, "pendingStartAfter", false),
				activeHookCellBefore: optionalBoolField(value, "activeHookCellBefore", false),
				activeHookCellAfter: optionalBoolField(value, "activeHookCellAfter", false),
				pendingStatusRestoreBefore: optionalBoolField(value, "pendingStatusRestoreBefore", false),
				pendingStatusRestoreAfter: optionalBoolField(value, "pendingStatusRestoreAfter", false),
				interruptHintVisible: optionalBoolField(value, "interruptHintVisible", false),
				terminalTitleWorking: optionalBoolField(value, "terminalTitleWorking", false),
				statusHeaderSet: optionalBoolField(value, "statusHeaderSet", false),
				transcriptReset: optionalBoolField(value, "transcriptReset", false),
				adaptiveChunkingReset: optionalBoolField(value, "adaptiveChunkingReset", false),
				planStreamCleared: optionalBoolField(value, "planStreamCleared", false),
				runtimeMetricsReset: optionalBoolField(value, "runtimeMetricsReset", false),
				telemetryReset: optionalBoolField(value, "telemetryReset", false),
				quitHintCleared: optionalBoolField(value, "quitHintCleared", false),
				reasoningCleared: optionalBoolField(value, "reasoningCleared", false),
				petKind: optionalStringField(value, "petKind", ""),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				runtimeDelta: optionalStringField(value, "runtimeDelta", ""),
				metricsMerged: optionalBoolField(value, "metricsMerged", false),
				websocketTimingLogged: optionalBoolField(value, "websocketTimingLogged", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				finalSeparatorInserted: optionalBoolField(value, "finalSeparatorInserted", false),
				elapsedSeconds: optionalIntField(value, "elapsedSeconds", 0),
				fromReplay: optionalBoolField(value, "fromReplay", false),
				lastAgentMessage: optionalStringField(value, "lastAgentMessage", ""),
				copySource: optionalStringField(value, "copySource", ""),
				notificationResponse: optionalStringField(value, "notificationResponse", ""),
				answerStreamFlushed: optionalBoolField(value, "answerStreamFlushed", false),
				planFinalized: optionalBoolField(value, "planFinalized", false),
				planConsolidated: optionalBoolField(value, "planConsolidated", false),
				waitStreakFlushed: optionalBoolField(value, "waitStreakFlushed", false),
				runtimeMetricsAttached: optionalBoolField(value, "runtimeMetricsAttached", false),
				statusLineRefreshRequested: optionalBoolField(value, "statusLineRefreshRequested", false),
				gitSummaryRefreshRequested: optionalBoolField(value, "gitSummaryRefreshRequested", false),
				runningCommandsBefore: optionalIntField(value, "runningCommandsBefore", 0),
				runningCommandsAfter: optionalIntField(value, "runningCommandsAfter", 0),
				suppressedExecBefore: optionalIntField(value, "suppressedExecBefore", 0),
				suppressedExecAfter: optionalIntField(value, "suppressedExecAfter", 0),
				pendingSteersBefore: optionalIntField(value, "pendingSteersBefore", 0),
				pendingSteersAfter: optionalIntField(value, "pendingSteersAfter", 0),
				queuedFollowUps: optionalBoolField(value, "queuedFollowUps", false),
				followUpStarted: optionalBoolField(value, "followUpStarted", false),
				notificationQueued: optionalBoolField(value, "notificationQueued", false),
				pendingPreviewRefreshed: optionalBoolField(value, "pendingPreviewRefreshed", false),
				planPromptEligible: optionalBoolField(value, "planPromptEligible", false),
				planSeen: optionalBoolField(value, "planSeen", false),
				modalActive: optionalBoolField(value, "modalActive", false),
				rateLimitPending: optionalBoolField(value, "rateLimitPending", false),
				promptOpened: optionalBoolField(value, "promptOpened", false),
				rateLimitPromptShown: optionalBoolField(value, "rateLimitPromptShown", false),
				warningDisplayed: optionalBoolField(value, "warningDisplayed", false),
				warningDeduped: optionalBoolField(value, "warningDeduped", false),
				activeCellFinalized: optionalBoolField(value, "activeCellFinalized", false),
				activeHookCleared: optionalBoolField(value, "activeHookCleared", false),
				streamsCleared: optionalBoolField(value, "streamsCleared", false),
				cancelEditCleared: optionalBoolField(value, "cancelEditCleared", false),
				queueDrainAttempted: optionalBoolField(value, "queueDrainAttempted", false),
				errorInserted: optionalBoolField(value, "errorInserted", false),
				cyberPolicy: optionalBoolField(value, "cyberPolicy", false),
				ownerNudgeOpened: optionalBoolField(value, "ownerNudgeOpened", false),
				planItemsTotal: optionalIntField(value, "planItemsTotal", 0),
				planItemsCompleted: optionalIntField(value, "planItemsCompleted", 0),
				planProgressRecorded: optionalBoolField(value, "planProgressRecorded", false),
				allowed: optionalBoolField(value, "allowed", false),
				priority: optionalIntField(value, "priority", 0),
				existingPriority: optionalIntField(value, "existingPriority", -1),
				stored: optionalBoolField(value, "stored", false),
				posted: optionalBoolField(value, "posted", false),
				noLiveProcess: optionalBoolField(value, "noLiveProcess", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalSessionFlowPlan(object:Value, name:String):Null<TuiSmokeSessionFlowPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeSessionFlowPlan({
					allowFilesystemMutation: optionalBoolField(value, "allowFilesystemMutation", false),
					allowNetwork: optionalBoolField(value, "allowNetwork", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: sessionFlowActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function sessionFlowActions(values:Array<Value>):Array<TuiSmokeSessionFlowAction> {
		final out:Array<TuiSmokeSessionFlowAction> = [];
		for (value in values) {
			out.push(new TuiSmokeSessionFlowAction({
				kind: TuiSmokeSessionFlowActionKind.fromString(stringField(value, "kind", "")),
				display: optionalStringField(value, "display", ""),
				threadId: optionalStringField(value, "threadId", ""),
				previousThreadId: optionalStringField(value, "previousThreadId", ""),
				threadName: optionalStringField(value, "threadName", ""),
				forkedFromId: optionalStringField(value, "forkedFromId", ""),
				forkParentTitle: optionalStringField(value, "forkParentTitle", ""),
				logId: optionalStringField(value, "logId", ""),
				cwd: optionalStringField(value, "cwd", ""),
				workspaceRoots: optionalStringField(value, "workspaceRoots", ""),
				model: optionalStringField(value, "model", ""),
				reasoningEffort: optionalStringField(value, "reasoningEffort", ""),
				collaborationMode: optionalStringField(value, "collaborationMode", ""),
				serviceTier: optionalStringField(value, "serviceTier", ""),
				personality: optionalStringField(value, "personality", ""),
				approvalPolicy: optionalStringField(value, "approvalPolicy", ""),
				activePermissionProfile: optionalStringField(value, "activePermissionProfile", ""),
				instructionSourceCount: optionalIntField(value, "instructionSourceCount", 0),
				historyEntryCount: optionalIntField(value, "historyEntryCount", 0),
				queuedBefore: optionalIntField(value, "queuedBefore", 0),
				queuedAfter: optionalIntField(value, "queuedAfter", 0),
				skillsCount: optionalIntField(value, "skillsCount", 0),
				connectorCount: optionalIntField(value, "connectorCount", 0),
				initialMessage: optionalStringField(value, "initialMessage", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				copyHistoryReset: optionalBoolField(value, "copyHistoryReset", false),
				historyMetadataSet: optionalBoolField(value, "historyMetadataSet", false),
				skillsCleared: optionalBoolField(value, "skillsCleared", false),
				networkProxySet: optionalBoolField(value, "networkProxySet", false),
				queueSubmissionsCleared: optionalBoolField(value, "queueSubmissionsCleared", false),
				reviewDenialsReset: optionalBoolField(value, "reviewDenialsReset", false),
				planNudgeRefreshed: optionalBoolField(value, "planNudgeRefreshed", false),
				turnLifecycleReset: optionalBoolField(value, "turnLifecycleReset", false),
				goalStatusCleared: optionalBoolField(value, "goalStatusCleared", false),
				collaborationIndicatorUpdated: optionalBoolField(value, "collaborationIndicatorUpdated", false),
				rolloutPathSet: optionalBoolField(value, "rolloutPathSet", false),
				cwdSynced: optionalBoolField(value, "cwdSynced", false),
				workspaceRootsSynced: optionalBoolField(value, "workspaceRootsSynced", false),
				approvalPolicySynced: optionalBoolField(value, "approvalPolicySynced", false),
				permissionProfileSynced: optionalBoolField(value, "permissionProfileSynced", false),
				permissionFallbackApplied: optionalBoolField(value, "permissionFallbackApplied", false),
				personalitySynced: optionalBoolField(value, "personalitySynced", false),
				projectRootCacheCleared: optionalBoolField(value, "projectRootCacheCleared", false),
				collaborationMaskInitialized: optionalBoolField(value, "collaborationMaskInitialized", false),
				effectiveCollaborationSet: optionalBoolField(value, "effectiveCollaborationSet", false),
				modelDisplayRefreshed: optionalBoolField(value, "modelDisplayRefreshed", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				serviceTierCommandsSynced: optionalBoolField(value, "serviceTierCommandsSynced", false),
				personalityCommandSynced: optionalBoolField(value, "personalityCommandSynced", false),
				pluginsCommandSynced: optionalBoolField(value, "pluginsCommandSynced", false),
				goalCommandSynced: optionalBoolField(value, "goalCommandSynced", false),
				pluginMentionsRefreshed: optionalBoolField(value, "pluginMentionsRefreshed", false),
				sessionInfoInserted: optionalBoolField(value, "sessionInfoInserted", false),
				activeSessionHeaderCleared: optionalBoolField(value, "activeSessionHeaderCleared", false),
				activeCellRevisionBumped: optionalBoolField(value, "activeCellRevisionBumped", false),
				copySourceReset: optionalBoolField(value, "copySourceReset", false),
				skillsReloadRequested: optionalBoolField(value, "skillsReloadRequested", false),
				connectorsPrefetched: optionalBoolField(value, "connectorsPrefetched", false),
				initialMessageSubmitted: optionalBoolField(value, "initialMessageSubmitted", false),
				initialMessageSuppressed: optionalBoolField(value, "initialMessageSuppressed", false),
				elevatedSandboxBlocked: optionalBoolField(value, "elevatedSandboxBlocked", false),
				forkNoticeInserted: optionalBoolField(value, "forkNoticeInserted", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				suppressRedraw: optionalBoolField(value, "suppressRedraw", false),
				threadMatched: optionalBoolField(value, "threadMatched", false),
				renameConfirmationInserted: optionalBoolField(value, "renameConfirmationInserted", false),
				queuedInputDrainAttempted: optionalBoolField(value, "queuedInputDrainAttempted", false),
				noFilesystemMutation: optionalBoolField(value, "noFilesystemMutation", false),
				noNetwork: optionalBoolField(value, "noNetwork", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function mcpStartupActions(values:Array<Value>):Array<TuiSmokeMcpStartupAction> {
		final out:Array<TuiSmokeMcpStartupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeMcpStartupAction({
				kind: TuiSmokeMcpStartupActionKind.fromString(stringField(value, "kind", "")),
				server: optionalStringField(value, "server", ""),
				status: optionalStringField(value, "status", ""),
				expectedServers: optionalStringField(value, "expectedServers", ""),
				activeServers: optionalStringField(value, "activeServers", ""),
				pendingServers: optionalStringField(value, "pendingServers", ""),
				startingServers: optionalStringField(value, "startingServers", ""),
				failedServers: optionalStringField(value, "failedServers", ""),
				cancelledServers: optionalStringField(value, "cancelledServers", ""),
				header: optionalStringField(value, "header", ""),
				warningText: optionalStringField(value, "warningText", ""),
				summaryText: optionalStringField(value, "summaryText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				expectedCount: optionalIntField(value, "expectedCount", 0),
				activeCountBefore: optionalIntField(value, "activeCountBefore", 0),
				activeCountAfter: optionalIntField(value, "activeCountAfter", 0),
				pendingCountBefore: optionalIntField(value, "pendingCountBefore", 0),
				pendingCountAfter: optionalIntField(value, "pendingCountAfter", 0),
				completedCount: optionalIntField(value, "completedCount", 0),
				totalCount: optionalIntField(value, "totalCount", 0),
				completeWhenSettled: optionalBoolField(value, "completeWhenSettled", false),
				ignoreUntilNextStartBefore: optionalBoolField(value, "ignoreUntilNextStartBefore", false),
				ignoreUntilNextStartAfter: optionalBoolField(value, "ignoreUntilNextStartAfter", false),
				allowTerminalOnlyBefore: optionalBoolField(value, "allowTerminalOnlyBefore", false),
				allowTerminalOnlyAfter: optionalBoolField(value, "allowTerminalOnlyAfter", false),
				sawStartingBefore: optionalBoolField(value, "sawStartingBefore", false),
				sawStartingAfter: optionalBoolField(value, "sawStartingAfter", false),
				pendingRoundActivated: optionalBoolField(value, "pendingRoundActivated", false),
				duplicateWarningSuppressed: optionalBoolField(value, "duplicateWarningSuppressed", false),
				warningInserted: optionalBoolField(value, "warningInserted", false),
				summaryInserted: optionalBoolField(value, "summaryInserted", false),
				statusHeaderOwned: optionalBoolField(value, "statusHeaderOwned", false),
				statusRestored: optionalBoolField(value, "statusRestored", false),
				queuedInputDrainRequested: optionalBoolField(value, "queuedInputDrainRequested", false),
				queuedInputSubmitted: optionalBoolField(value, "queuedInputSubmitted", false),
				taskRunningBefore: optionalBoolField(value, "taskRunningBefore", false),
				taskRunningAfter: optionalBoolField(value, "taskRunningAfter", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function chatWidgetStreamLifecycleActions(values:Array<Value>):Array<TuiSmokeChatWidgetStreamLifecycleAction> {
		final out:Array<TuiSmokeChatWidgetStreamLifecycleAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetStreamLifecycleAction({
				kind: TuiSmokeChatWidgetStreamLifecycleActionKind.fromString(stringField(value, "kind", "")),
				interruptKind: optionalStringField(value, "interruptKind", ""),
				finishReason: optionalStringField(value, "finishReason", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				delta: optionalStringField(value, "delta", ""),
				queuedInterruptsBefore: optionalIntField(value, "queuedInterruptsBefore", 0),
				queuedInterruptsAfter: optionalIntField(value, "queuedInterruptsAfter", 0),
				queuedLinesBefore: optionalIntField(value, "queuedLinesBefore", 0),
				queuedLinesAfter: optionalIntField(value, "queuedLinesAfter", 0),
				committedCells: optionalIntField(value, "committedCells", 0),
				activeStreamControllerBefore: optionalBoolField(value, "activeStreamControllerBefore", false),
				activeStreamControllerAfter: optionalBoolField(value, "activeStreamControllerAfter", false),
				planStreamControllerBefore: optionalBoolField(value, "planStreamControllerBefore", false),
				planStreamControllerAfter: optionalBoolField(value, "planStreamControllerAfter", false),
				activeTailBefore: optionalBoolField(value, "activeTailBefore", false),
				activeTailAfter: optionalBoolField(value, "activeTailAfter", false),
				taskCompletePendingBefore: optionalBoolField(value, "taskCompletePendingBefore", false),
				taskCompletePendingAfter: optionalBoolField(value, "taskCompletePendingAfter", false),
				taskRunningBefore: optionalBoolField(value, "taskRunningBefore", false),
				taskRunningAfter: optionalBoolField(value, "taskRunningAfter", false),
				statusHidden: optionalBoolField(value, "statusHidden", false),
				statusPreserved: optionalBoolField(value, "statusPreserved", false),
				pendingStatusRestoreBefore: optionalBoolField(value, "pendingStatusRestoreBefore", false),
				pendingStatusRestoreAfter: optionalBoolField(value, "pendingStatusRestoreAfter", false),
				interruptQueued: optionalBoolField(value, "interruptQueued", false),
				interruptHandled: optionalBoolField(value, "interruptHandled", false),
				fifoPreserved: optionalBoolField(value, "fifoPreserved", false),
				flushedInterrupts: optionalIntField(value, "flushedInterrupts", 0),
				startCommitAnimation: optionalBoolField(value, "startCommitAnimation", false),
				stopCommitAnimation: optionalBoolField(value, "stopCommitAnimation", false),
				catchUpTick: optionalBoolField(value, "catchUpTick", false),
				adaptiveChunkingReset: optionalBoolField(value, "adaptiveChunkingReset", false),
				runningCommandsCleared: optionalBoolField(value, "runningCommandsCleared", false),
				suppressedExecCleared: optionalBoolField(value, "suppressedExecCleared", false),
				unifiedWaitCleared: optionalBoolField(value, "unifiedWaitCleared", false),
				cancelEditCleared: optionalBoolField(value, "cancelEditCleared", false),
				rateLimitPromptChecked: optionalBoolField(value, "rateLimitPromptChecked", false),
				taskStateUpdated: optionalBoolField(value, "taskStateUpdated", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetStreamStatusPlan(object:Value, name:String):Null<TuiSmokeChatWidgetStreamStatusPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetStreamStatusPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: chatWidgetStreamStatusActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function chatWidgetStreamStatusActions(values:Array<Value>):Array<TuiSmokeChatWidgetStreamStatusAction> {
		final out:Array<TuiSmokeChatWidgetStreamStatusAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetStreamStatusAction({
				kind: TuiSmokeChatWidgetStreamStatusActionKind.fromString(stringField(value, "kind", "")),
				phase: optionalStringField(value, "phase", ""),
				titleKind: optionalStringField(value, "titleKind", ""),
				runState: optionalStringField(value, "runState", ""),
				header: optionalStringField(value, "header", ""),
				details: optionalStringField(value, "details", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				reasoningDelta: optionalStringField(value, "reasoningDelta", ""),
				extractedHeader: optionalStringField(value, "extractedHeader", ""),
				reasoningBufferLength: optionalIntField(value, "reasoningBufferLength", 0),
				fullReasoningBufferLength: optionalIntField(value, "fullReasoningBufferLength", 0),
				detailsMaxLines: optionalIntField(value, "detailsMaxLines", 0),
				queuedLines: optionalIntField(value, "queuedLines", 0),
				pendingSteers: optionalIntField(value, "pendingSteers", 0),
				pendingRestoreBefore: optionalBoolField(value, "pendingRestoreBefore", false),
				pendingRestoreAfter: optionalBoolField(value, "pendingRestoreAfter", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				streamIdle: optionalBoolField(value, "streamIdle", false),
				statusEnsured: optionalBoolField(value, "statusEnsured", false),
				statusUpdated: optionalBoolField(value, "statusUpdated", false),
				statusHidden: optionalBoolField(value, "statusHidden", false),
				statusRestored: optionalBoolField(value, "statusRestored", false),
				titleUsesStatus: optionalBoolField(value, "titleUsesStatus", false),
				statusSurfacesRefreshed: optionalBoolField(value, "statusSurfacesRefreshed", false),
				retryHeaderRemembered: optionalBoolField(value, "retryHeaderRemembered", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				reasoningCleared: optionalBoolField(value, "reasoningCleared", false),
				unifiedExecWaitActive: optionalBoolField(value, "unifiedExecWaitActive", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetActiveStreamPlan(object:Value, name:String):Null<TuiSmokeChatWidgetActiveStreamPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetActiveStreamPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowModelCall: optionalBoolField(value, "allowModelCall", false),
					actions: chatWidgetActiveStreamActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function chatWidgetActiveStreamActions(values:Array<Value>):Array<TuiSmokeChatWidgetActiveStreamAction> {
		final out:Array<TuiSmokeChatWidgetActiveStreamAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetActiveStreamAction({
				kind: TuiSmokeChatWidgetActiveStreamActionKind.fromString(stringField(value, "kind", "")),
				renderMode: optionalStringField(value, "renderMode", ""),
				scrollbackReflow: optionalStringField(value, "scrollbackReflow", ""),
				text: optionalStringField(value, "text", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				previousWidth: optionalIntField(value, "previousWidth", 0),
				streamReservedCols: optionalIntField(value, "streamReservedCols", 0),
				planReservedCols: optionalIntField(value, "planReservedCols", 0),
				streamWidth: optionalIntField(value, "streamWidth", 0),
				planStreamWidth: optionalIntField(value, "planStreamWidth", 0),
				queuedLinesBefore: optionalIntField(value, "queuedLinesBefore", 0),
				queuedLinesAfter: optionalIntField(value, "queuedLinesAfter", 0),
				committedCells: optionalIntField(value, "committedCells", 0),
				revisionBefore: optionalIntField(value, "revisionBefore", 0),
				revisionAfter: optionalIntField(value, "revisionAfter", 0),
				animationTick: optionalIntField(value, "animationTick", -1),
				transcriptLineCount: optionalIntField(value, "transcriptLineCount", 0),
				hyperlinkLineCount: optionalIntField(value, "hyperlinkLineCount", 0),
				planBufferLength: optionalIntField(value, "planBufferLength", 0),
				activeCellPresent: optionalBoolField(value, "activeCellPresent", false),
				activeHookPresent: optionalBoolField(value, "activeHookPresent", false),
				streamControllerPresent: optionalBoolField(value, "streamControllerPresent", false),
				planStreamControllerPresent: optionalBoolField(value, "planStreamControllerPresent", false),
				pushed: optionalBoolField(value, "pushed", false),
				startedCommitAnimation: optionalBoolField(value, "startedCommitAnimation", false),
				ranCatchUpTick: optionalBoolField(value, "ranCatchUpTick", false),
				statusHidden: optionalBoolField(value, "statusHidden", false),
				statusRestorePending: optionalBoolField(value, "statusRestorePending", false),
				statusRestored: optionalBoolField(value, "statusRestored", false),
				activeTailPresent: optionalBoolField(value, "activeTailPresent", false),
				liveTailPresent: optionalBoolField(value, "liveTailPresent", false),
				activeTailCleared: optionalBoolField(value, "activeTailCleared", false),
				sourceConsolidated: optionalBoolField(value, "sourceConsolidated", false),
				historyInserted: optionalBoolField(value, "historyInserted", false),
				deferredHistoryCell: optionalBoolField(value, "deferredHistoryCell", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noModelCall: optionalBoolField(value, "noModelCall", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalChatWidgetComposerRenderPlan(object:Value, name:String):Null<TuiSmokeChatWidgetComposerRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeChatWidgetComposerRenderPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					allowLiveDispatch: optionalBoolField(value, "allowLiveDispatch", false),
					actions: chatWidgetComposerRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function chatWidgetComposerRenderActions(values:Array<Value>):Array<TuiSmokeChatWidgetComposerRenderAction> {
		final out:Array<TuiSmokeChatWidgetComposerRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeChatWidgetComposerRenderAction({
				kind: TuiSmokeChatWidgetComposerRenderActionKind.fromString(stringField(value, "kind", "")),
				inputResult: TuiSmokeComposerSubmissionResultKind.fromString(optionalStringField(value, "inputResult", "unknown")),
				queuedAction: TuiSmokeComposerQueuedActionKind.fromString(optionalStringField(value, "queuedAction", "unknown")),
				cursorStyle: optionalStringField(value, "cursorStyle", ""),
				text: optionalStringField(value, "text", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				height: optionalIntField(value, "height", 0),
				rightReserve: optionalIntField(value, "rightReserve", 0),
				bottomPaneInsetTop: optionalIntField(value, "bottomPaneInsetTop", 0),
				bottomPaneDesiredHeight: optionalIntField(value, "bottomPaneDesiredHeight", 0),
				activeCellDesiredHeight: optionalIntField(value, "activeCellDesiredHeight", 0),
				activeHookDesiredHeight: optionalIntField(value, "activeHookDesiredHeight", 0),
				transcriptAreaWidth: optionalIntField(value, "transcriptAreaWidth", 0),
				transcriptAreaHeight: optionalIntField(value, "transcriptAreaHeight", 0),
				transcriptScrollOffset: optionalIntField(value, "transcriptScrollOffset", 0),
				cursorX: optionalIntField(value, "cursorX", 0),
				cursorY: optionalIntField(value, "cursorY", 0),
				queuedBefore: optionalIntField(value, "queuedBefore", 0),
				queuedAfter: optionalIntField(value, "queuedAfter", 0),
				pendingSteers: optionalIntField(value, "pendingSteers", 0),
				rejectedSteers: optionalIntField(value, "rejectedSteers", 0),
				queuedHistoryRecords: optionalIntField(value, "queuedHistoryRecords", 0),
				rejectedHistoryRecords: optionalIntField(value, "rejectedHistoryRecords", 0),
				pendingSteerHistoryRecords: optionalIntField(value, "pendingSteerHistoryRecords", 0),
				pendingSteerCompareKeys: optionalIntField(value, "pendingSteerCompareKeys", 0),
				userTurnPendingBefore: optionalBoolField(value, "userTurnPendingBefore", false),
				userTurnPendingAfter: optionalBoolField(value, "userTurnPendingAfter", false),
				submitPendingSteersAfterInterruptBefore: optionalBoolField(value, "submitPendingSteersAfterInterruptBefore", false),
				submitPendingSteersAfterInterruptAfter: optionalBoolField(value, "submitPendingSteersAfterInterruptAfter", false),
				suppressAutosendBefore: optionalBoolField(value, "suppressAutosendBefore", false),
				suppressAutosendAfter: optionalBoolField(value, "suppressAutosendAfter", false),
				queuedFollowUps: optionalBoolField(value, "queuedFollowUps", false),
				missingHistoryFallback: optionalBoolField(value, "missingHistoryFallback", false),
				previewQueuedText: optionalStringField(value, "previewQueuedText", ""),
				previewPendingText: optionalStringField(value, "previewPendingText", ""),
				previewRejectedText: optionalStringField(value, "previewRejectedText", ""),
				activeCellPresent: optionalBoolField(value, "activeCellPresent", false),
				activeHookPresent: optionalBoolField(value, "activeHookPresent", false),
				activeHookShouldRender: optionalBoolField(value, "activeHookShouldRender", false),
				cursorVisible: optionalBoolField(value, "cursorVisible", false),
				inputEnabled: optionalBoolField(value, "inputEnabled", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				sessionConfigured: optionalBoolField(value, "sessionConfigured", false),
				planStreaming: optionalBoolField(value, "planStreaming", false),
				userTurnPending: optionalBoolField(value, "userTurnPending", false),
				onlyUserShellCommandsRunning: optionalBoolField(value, "onlyUserShellCommandsRunning", false),
				hadModalOrPopup: optionalBoolField(value, "hadModalOrPopup", false),
				modalCleared: optionalBoolField(value, "modalCleared", false),
				shouldSubmitNow: optionalBoolField(value, "shouldSubmitNow", false),
				previewUpdated: optionalBoolField(value, "previewUpdated", false),
				autosendSuppressed: optionalBoolField(value, "autosendSuppressed", false),
				followupSubmitted: optionalBoolField(value, "followupSubmitted", false),
				statusWorking: optionalBoolField(value, "statusWorking", false),
				reasoningCleared: optionalBoolField(value, "reasoningCleared", false),
				commandDispatched: optionalBoolField(value, "commandDispatched", false),
				serviceTierDispatched: optionalBoolField(value, "serviceTierDispatched", false),
				slashArgsDispatched: optionalBoolField(value, "slashArgsDispatched", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				preDrawTick: optionalBoolField(value, "preDrawTick", false),
				bottomPaneTick: optionalBoolField(value, "bottomPaneTick", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				noLiveDispatch: optionalBoolField(value, "noLiveDispatch", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerTextareaRenderPlan(object:Value, name:String):Null<TuiSmokeComposerTextareaRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerTextareaRenderPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					actions: composerTextareaRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerTextareaRenderActions(values:Array<Value>):Array<TuiSmokeComposerTextareaRenderAction> {
		final out:Array<TuiSmokeComposerTextareaRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerTextareaRenderAction({
				kind: TuiSmokeComposerTextareaRenderActionKind.fromString(stringField(value, "kind", "")),
				mode: TuiSmokeComposerTextareaRenderModeKind.fromString(optionalStringField(value, "mode", "unknown")),
				promptKind: TuiSmokeComposerTextareaPromptKind.fromString(optionalStringField(value, "promptKind", "unknown")),
				promptText: optionalStringField(value, "promptText", ""),
				placeholderText: optionalStringField(value, "placeholderText", ""),
				maskChar: optionalStringField(value, "maskChar", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				width: optionalIntField(value, "width", 0),
				height: optionalIntField(value, "height", 0),
				textareaRightReserve: optionalIntField(value, "textareaRightReserve", 0),
				innerWidth: optionalIntField(value, "innerWidth", 0),
				composerHeight: optionalIntField(value, "composerHeight", 0),
				popupHeight: optionalIntField(value, "popupHeight", 0),
				footerTotalHeight: optionalIntField(value, "footerTotalHeight", 0),
				textareaWidth: optionalIntField(value, "textareaWidth", 0),
				textareaHeight: optionalIntField(value, "textareaHeight", 0),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				remoteImageHeight: optionalIntField(value, "remoteImageHeight", 0),
				remoteImageSeparator: optionalIntField(value, "remoteImageSeparator", 0),
				selectedRemoteIndex: optionalIntField(value, "selectedRemoteIndex", -1),
				desiredHeight: optionalIntField(value, "desiredHeight", 0),
				wrappedLineCount: optionalIntField(value, "wrappedLineCount", 0),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				visibleStartLine: optionalIntField(value, "visibleStartLine", 0),
				visibleEndLine: optionalIntField(value, "visibleEndLine", 0),
				textLength: optionalIntField(value, "textLength", 0),
				elementCount: optionalIntField(value, "elementCount", 0),
				highlightCount: optionalIntField(value, "highlightCount", 0),
				pluginHighlightCount: optionalIntField(value, "pluginHighlightCount", 0),
				historyHighlightCount: optionalIntField(value, "historyHighlightCount", 0),
				cursorX: optionalIntField(value, "cursorX", 0),
				cursorY: optionalIntField(value, "cursorY", 0),
				inputEnabled: optionalBoolField(value, "inputEnabled", false),
				bashMode: optionalBoolField(value, "bashMode", false),
				textareaEmpty: optionalBoolField(value, "textareaEmpty", false),
				placeholderVisible: optionalBoolField(value, "placeholderVisible", false),
				cursorVisible: optionalBoolField(value, "cursorVisible", false),
				remoteImagesDoNotMutateTextarea: optionalBoolField(value, "remoteImagesDoNotMutateTextarea", false),
				renderOnlyHighlights: optionalBoolField(value, "renderOnlyHighlights", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerFooterRenderPlan(object:Value, name:String):Null<TuiSmokeComposerFooterRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerFooterRenderPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					actions: composerFooterRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerFooterRenderActions(values:Array<Value>):Array<TuiSmokeComposerFooterRenderAction> {
		final out:Array<TuiSmokeComposerFooterRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerFooterRenderAction({
				kind: TuiSmokeComposerFooterRenderActionKind.fromString(stringField(value, "kind", "")),
				modeBefore: TuiSmokeComposerFooterModeKind.fromString(optionalStringField(value, "modeBefore", "unknown")),
				modeAfter: TuiSmokeComposerFooterModeKind.fromString(optionalStringField(value, "modeAfter", "unknown")),
				baseMode: TuiSmokeComposerFooterModeKind.fromString(optionalStringField(value, "baseMode", "unknown")),
				keyName: optionalStringField(value, "keyName", ""),
				statusText: optionalStringField(value, "statusText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				footerHeight: optionalIntField(value, "footerHeight", 0),
				spacing: optionalIntField(value, "spacing", 0),
				totalHeight: optionalIntField(value, "totalHeight", 0),
				lineCount: optionalIntField(value, "lineCount", 0),
				hintCount: optionalIntField(value, "hintCount", 0),
				width: optionalIntField(value, "width", 0),
				hasInputFocus: optionalBoolField(value, "hasInputFocus", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				inputEmpty: optionalBoolField(value, "inputEmpty", false),
				historySearchActive: optionalBoolField(value, "historySearchActive", false),
				quitHintVisible: optionalBoolField(value, "quitHintVisible", false),
				quitHintExpired: optionalBoolField(value, "quitHintExpired", false),
				shortcutOverlayActive: optionalBoolField(value, "shortcutOverlayActive", false),
				collaborationModesEnabled: optionalBoolField(value, "collaborationModesEnabled", false),
				collaborationIndicatorVisible: optionalBoolField(value, "collaborationIndicatorVisible", false),
				showCycleHint: optionalBoolField(value, "showCycleHint", false),
				showShortcutsHint: optionalBoolField(value, "showShortcutsHint", false),
				showQueueHint: optionalBoolField(value, "showQueueHint", false),
				pasteBurstActive: optionalBoolField(value, "pasteBurstActive", false),
				statusLineEnabled: optionalBoolField(value, "statusLineEnabled", false),
				passiveStatusActive: optionalBoolField(value, "passiveStatusActive", false),
				statusHyperlinkActive: optionalBoolField(value, "statusHyperlinkActive", false),
				escBacktrackHint: optionalBoolField(value, "escBacktrackHint", false),
				ctrlCQuitHint: optionalBoolField(value, "ctrlCQuitHint", false),
				ctrlDQuitHint: optionalBoolField(value, "ctrlDQuitHint", false),
				quitShortcutKeyMatched: optionalBoolField(value, "quitShortcutKeyMatched", false),
				quitShortcutHintCleared: optionalBoolField(value, "quitShortcutHintCleared", false),
				expiryRedrawScheduled: optionalBoolField(value, "expiryRedrawScheduled", false),
				activityClearsHint: optionalBoolField(value, "activityClearsHint", false),
				requestRedraw: optionalBoolField(value, "requestRedraw", false),
				reminderText: optionalStringField(value, "reminderText", ""),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerPopupRenderPlan(object:Value, name:String):Null<TuiSmokeComposerPopupRenderPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerPopupRenderPlan({
					allowLiveTerminal: optionalBoolField(value, "allowLiveTerminal", false),
					allowRatatuiRender: optionalBoolField(value, "allowRatatuiRender", false),
					actions: composerPopupRenderActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerPopupRenderActions(values:Array<Value>):Array<TuiSmokeComposerPopupRenderAction> {
		final out:Array<TuiSmokeComposerPopupRenderAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerPopupRenderAction({
				kind: TuiSmokeComposerPopupRenderActionKind.fromString(stringField(value, "kind", "")),
				popup: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popup", "unknown")),
				searchMode: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchMode", "unknown")),
				width: optionalIntField(value, "width", 0),
				composerHeight: optionalIntField(value, "composerHeight", 0),
				popupHeight: optionalIntField(value, "popupHeight", 0),
				requiredHeight: optionalIntField(value, "requiredHeight", 0),
				footerHeight: optionalIntField(value, "footerHeight", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				visibleRows: optionalIntField(value, "visibleRows", 0),
				maxRows: optionalIntField(value, "maxRows", 0),
				selectedIndex: optionalIntField(value, "selectedIndex", -1),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				windowStart: optionalIntField(value, "windowStart", 0),
				windowEnd: optionalIntField(value, "windowEnd", 0),
				horizontalInset: optionalIntField(value, "horizontalInset", 0),
				verticalInset: optionalIntField(value, "verticalInset", 0),
				emptyMessage: optionalStringField(value, "emptyMessage", ""),
				columnMode: optionalStringField(value, "columnMode", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				renderDelegated: optionalBoolField(value, "renderDelegated", false),
				wrapsDescriptions: optionalBoolField(value, "wrapsDescriptions", false),
				footerHintRendered: optionalBoolField(value, "footerHintRendered", false),
				selectedVisible: optionalBoolField(value, "selectedVisible", false),
				waiting: optionalBoolField(value, "waiting", false),
				noLiveTerminal: optionalBoolField(value, "noLiveTerminal", false),
				noRatatuiRender: optionalBoolField(value, "noRatatuiRender", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerPopupKeyPlan(object:Value, name:String):Null<TuiSmokeComposerPopupKeyPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerPopupKeyPlan({
					allowLiveInput: optionalBoolField(value, "allowLiveInput", false),
					allowLiveFileProbe: optionalBoolField(value, "allowLiveFileProbe", false),
					actions: composerPopupKeyActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerPopupKeyActions(values:Array<Value>):Array<TuiSmokeComposerPopupKeyAction> {
		final out:Array<TuiSmokeComposerPopupKeyAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerPopupKeyAction({
				kind: TuiSmokeComposerPopupKeyActionKind.fromString(stringField(value, "kind", "")),
				popupBefore: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupBefore", "unknown")),
				popupAfter: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupAfter", "unknown")),
				candidateKind: TuiSmokeMentionCandidateKind.fromString(optionalStringField(value, "candidateKind", "unknown")),
				searchModeBefore: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchModeBefore", "unknown")),
				searchModeAfter: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchModeAfter", "unknown")),
				keyName: optionalStringField(value, "keyName", ""),
				commandName: optionalStringField(value, "commandName", ""),
				token: optionalStringField(value, "token", ""),
				selectedPath: optionalStringField(value, "selectedPath", ""),
				insertText: optionalStringField(value, "insertText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				matchCount: optionalIntField(value, "matchCount", 0),
				selectedAvailable: optionalBoolField(value, "selectedAvailable", false),
				dismissedTokenStored: optionalBoolField(value, "dismissedTokenStored", false),
				draftUpdated: optionalBoolField(value, "draftUpdated", false),
				textCleared: optionalBoolField(value, "textCleared", false),
				commandCompleted: optionalBoolField(value, "commandCompleted", false),
				commandDispatched: optionalBoolField(value, "commandDispatched", false),
				serviceTierDispatched: optionalBoolField(value, "serviceTierDispatched", false),
				historyStaged: optionalBoolField(value, "historyStaged", false),
				inlineArgsPreserved: optionalBoolField(value, "inlineArgsPreserved", false),
				imagePath: optionalBoolField(value, "imagePath", false),
				imageDimensionsAvailable: optionalBoolField(value, "imageDimensionsAvailable", false),
				imageAttached: optionalBoolField(value, "imageAttached", false),
				pathInserted: optionalBoolField(value, "pathInserted", false),
				mentionBindingStored: optionalBoolField(value, "mentionBindingStored", false),
				modeSwitchAllowed: optionalBoolField(value, "modeSwitchAllowed", false),
				fallbackWithoutPopup: optionalBoolField(value, "fallbackWithoutPopup", false),
				submitWithoutPopup: optionalBoolField(value, "submitWithoutPopup", false),
				inputForwarded: optionalBoolField(value, "inputForwarded", false),
				shortcutOverlayHandled: optionalBoolField(value, "shortcutOverlayHandled", false),
				footerModeChanged: optionalBoolField(value, "footerModeChanged", false),
				keyConsumed: optionalBoolField(value, "keyConsumed", false),
				syncAfterKey: optionalBoolField(value, "syncAfterKey", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				liveProbeRejected: optionalBoolField(value, "liveProbeRejected", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerPopupSyncPlan(object:Value, name:String):Null<TuiSmokeComposerPopupSyncPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerPopupSyncPlan({
					allowLiveFileSearch: optionalBoolField(value, "allowLiveFileSearch", false),
					actions: composerPopupSyncActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerPopupSyncActions(values:Array<Value>):Array<TuiSmokeComposerPopupSyncAction> {
		final out:Array<TuiSmokeComposerPopupSyncAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerPopupSyncAction({
				kind: TuiSmokeComposerPopupSyncActionKind.fromString(stringField(value, "kind", "")),
				popupBefore: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupBefore", "unknown")),
				popupAfter: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupAfter", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				token: optionalStringField(value, "token", ""),
				query: optionalStringField(value, "query", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				candidateCount: optionalIntField(value, "candidateCount", 0),
				fileCandidateCount: optionalIntField(value, "fileCandidateCount", 0),
				skillCandidateCount: optionalIntField(value, "skillCandidateCount", 0),
				pluginCandidateCount: optionalIntField(value, "pluginCandidateCount", 0),
				appCandidateCount: optionalIntField(value, "appCandidateCount", 0),
				visibleRowCount: optionalIntField(value, "visibleRowCount", 0),
				selectedIndex: optionalIntField(value, "selectedIndex", 0),
				scrollTop: optionalIntField(value, "scrollTop", 0),
				score: optionalIntField(value, "score", 0),
				matchIndexCount: optionalIntField(value, "matchIndexCount", 0),
				searchTermCount: optionalIntField(value, "searchTermCount", 0),
				directMatchCount: optionalIntField(value, "directMatchCount", 0),
				searchTermMatchCount: optionalIntField(value, "searchTermMatchCount", 0),
				requiredHeight: optionalIntField(value, "requiredHeight", 0),
				maxPopupRows: optionalIntField(value, "maxPopupRows", 0),
				areaHeight: optionalIntField(value, "areaHeight", 0),
				listHeight: optionalIntField(value, "listHeight", 0),
				hintHeight: optionalIntField(value, "hintHeight", 0),
				leftInset: optionalIntField(value, "leftInset", 0),
				footerLeftInset: optionalIntField(value, "footerLeftInset", 0),
				primaryColumnWidth: optionalIntField(value, "primaryColumnWidth", 0),
				visibleStartIndex: optionalIntField(value, "visibleStartIndex", 0),
				visibleEndIndex: optionalIntField(value, "visibleEndIndex", 0),
				renderedLineCount: optionalIntField(value, "renderedLineCount", 0),
				footerLeftWidth: optionalIntField(value, "footerLeftWidth", 0),
				footerRightWidth: optionalIntField(value, "footerRightWidth", 0),
				searchMode: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchMode", "unknown")),
				candidateKind: TuiSmokeMentionCandidateKind.fromString(optionalStringField(value, "candidateKind", "unknown")),
				catalogSummary: optionalStringField(value, "catalogSummary", ""),
				rowSummary: optionalStringField(value, "rowSummary", ""),
				selectionSummary: optionalStringField(value, "selectionSummary", ""),
				footerHintSummary: optionalStringField(value, "footerHintSummary", ""),
				footerModeSummary: optionalStringField(value, "footerModeSummary", ""),
				activeModeLabel: optionalStringField(value, "activeModeLabel", ""),
				emptyMessage: optionalStringField(value, "emptyMessage", ""),
				popupsEnabled: optionalBoolField(value, "popupsEnabled", false),
				slashCommandsEnabled: optionalBoolField(value, "slashCommandsEnabled", false),
				bashMode: optionalBoolField(value, "bashMode", false),
				mentionsV2Enabled: optionalBoolField(value, "mentionsV2Enabled", false),
				historySearchActive: optionalBoolField(value, "historySearchActive", false),
				browsingHistory: optionalBoolField(value, "browsingHistory", false),
				commandAllowed: optionalBoolField(value, "commandAllowed", false),
				commandPopupUpdated: optionalBoolField(value, "commandPopupUpdated", false),
				commandPopupCreated: optionalBoolField(value, "commandPopupCreated", false),
				commandPopupDismissed: optionalBoolField(value, "commandPopupDismissed", false),
				fileTokenPresent: optionalBoolField(value, "fileTokenPresent", false),
				mentionTokenPresent: optionalBoolField(value, "mentionTokenPresent", false),
				mentionsV2TokenPresent: optionalBoolField(value, "mentionsV2TokenPresent", false),
				fileSearchStarted: optionalBoolField(value, "fileSearchStarted", false),
				fileSearchCleared: optionalBoolField(value, "fileSearchCleared", false),
				currentFileQueryBefore: optionalBoolField(value, "currentFileQueryBefore", false),
				currentFileQueryAfter: optionalBoolField(value, "currentFileQueryAfter", false),
				dismissedFileTokenMatched: optionalBoolField(value, "dismissedFileTokenMatched", false),
				dismissedMentionTokenMatched: optionalBoolField(value, "dismissedMentionTokenMatched", false),
				dismissedFileTokenCleared: optionalBoolField(value, "dismissedFileTokenCleared", false),
				dismissedMentionTokenCleared: optionalBoolField(value, "dismissedMentionTokenCleared", false),
				popupCleared: optionalBoolField(value, "popupCleared", false),
				noLiveFileSearch: optionalBoolField(value, "noLiveFileSearch", false),
				fileMatchesShown: optionalBoolField(value, "fileMatchesShown", false),
				fileMatchesTruncated: optionalBoolField(value, "fileMatchesTruncated", false),
				staleFileMatchesRejected: optionalBoolField(value, "staleFileMatchesRejected", false),
				waitingForFileSearch: optionalBoolField(value, "waitingForFileSearch", false),
				displayNameMatched: optionalBoolField(value, "displayNameMatched", false),
				searchTermMatched: optionalBoolField(value, "searchTermMatched", false),
				modeFiltered: optionalBoolField(value, "modeFiltered", false),
				selectionClamped: optionalBoolField(value, "selectionClamped", false),
				queryTrimmed: optionalBoolField(value, "queryTrimmed", false),
				selectedVisible: optionalBoolField(value, "selectedVisible", false),
				selectedBold: optionalBoolField(value, "selectedBold", false),
				secondaryDimmed: optionalBoolField(value, "secondaryDimmed", false),
				fileNameProjected: optionalBoolField(value, "fileNameProjected", false),
				pathProjected: optionalBoolField(value, "pathProjected", false),
				tagProjected: optionalBoolField(value, "tagProjected", false),
				truncationApplied: optionalBoolField(value, "truncationApplied", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerEditingPlan(object:Value, name:String):Null<TuiSmokeComposerEditingPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerEditingPlan({
					allowLiveInput: optionalBoolField(value, "allowLiveInput", false),
					actions: composerEditingActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerEditingActions(values:Array<Value>):Array<TuiSmokeComposerEditingAction> {
		final out:Array<TuiSmokeComposerEditingAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerEditingAction({
				kind: TuiSmokeComposerEditingActionKind.fromString(stringField(value, "kind", "")),
				result: TuiSmokeComposerEditingResultKind.fromString(optionalStringField(value, "result", "unknown")),
				modeBefore: TuiSmokeComposerEditingModeKind.fromString(optionalStringField(value, "modeBefore", "unknown")),
				modeAfter: TuiSmokeComposerEditingModeKind.fromString(optionalStringField(value, "modeAfter", "unknown")),
				popupBefore: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupBefore", "unknown")),
				popupAfter: TuiSmokeComposerPopupKind.fromString(optionalStringField(value, "popupAfter", "unknown")),
				direction: TuiSmokeHistorySearchDirectionKind.fromString(optionalStringField(value, "direction", "unknown")),
				keyName: optionalStringField(value, "keyName", ""),
				inputText: optionalStringField(value, "inputText", ""),
				outputText: optionalStringField(value, "outputText", ""),
				recalledText: optionalStringField(value, "recalledText", ""),
				canonicalText: optionalStringField(value, "canonicalText", ""),
				textareaText: optionalStringField(value, "textareaText", ""),
				submissionText: optionalStringField(value, "submissionText", ""),
				selectedPath: optionalStringField(value, "selectedPath", ""),
				insertText: optionalStringField(value, "insertText", ""),
				bindingPath: optionalStringField(value, "bindingPath", ""),
				tokenBefore: optionalStringField(value, "tokenBefore", ""),
				tokenAfter: optionalStringField(value, "tokenAfter", ""),
				placeholderBefore: optionalStringField(value, "placeholderBefore", ""),
				placeholderAfter: optionalStringField(value, "placeholderAfter", ""),
				elementPayloads: optionalStringField(value, "elementPayloads", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
				historyCursor: optionalIntField(value, "historyCursor", 0),
				persistentOffset: optionalIntField(value, "persistentOffset", 0),
				logId: optionalIntField(value, "logId", 0),
				pendingPasteBefore: optionalIntField(value, "pendingPasteBefore", 0),
				pendingPasteAfter: optionalIntField(value, "pendingPasteAfter", 0),
				elementBefore: optionalIntField(value, "elementBefore", 0),
				elementAfter: optionalIntField(value, "elementAfter", 0),
				localImageBefore: optionalIntField(value, "localImageBefore", 0),
				localImageAfter: optionalIntField(value, "localImageAfter", 0),
				remoteImageBefore: optionalIntField(value, "remoteImageBefore", 0),
				remoteImageAfter: optionalIntField(value, "remoteImageAfter", 0),
				selectedRemoteBefore: optionalIntField(value, "selectedRemoteBefore", -1),
				selectedRemoteAfter: optionalIntField(value, "selectedRemoteAfter", -1),
				mentionBindingBefore: optionalIntField(value, "mentionBindingBefore", 0),
				mentionBindingAfter: optionalIntField(value, "mentionBindingAfter", 0),
				needsRedraw: optionalBoolField(value, "needsRedraw", false),
				keyConsumed: optionalBoolField(value, "keyConsumed", false),
				releaseIgnored: optionalBoolField(value, "releaseIgnored", false),
				queueSubmissions: optionalBoolField(value, "queueSubmissions", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				shellCommand: optionalBoolField(value, "shellCommand", false),
				submissionQueued: optionalBoolField(value, "submissionQueued", false),
				submissionSubmitted: optionalBoolField(value, "submissionSubmitted", false),
				composerCleared: optionalBoolField(value, "composerCleared", false),
				emptyNoop: optionalBoolField(value, "emptyNoop", false),
				historyRecorded: optionalBoolField(value, "historyRecorded", false),
				appHistoryAppended: optionalBoolField(value, "appHistoryAppended", false),
				quitHintShown: optionalBoolField(value, "quitHintShown", false),
				bottomPaneConsumed: optionalBoolField(value, "bottomPaneConsumed", false),
				chatWidgetConsumed: optionalBoolField(value, "chatWidgetConsumed", false),
				interruptSuppressed: optionalBoolField(value, "interruptSuppressed", false),
				quitSuppressed: optionalBoolField(value, "quitSuppressed", false),
				historySearchCancelled: optionalBoolField(value, "historySearchCancelled", false),
				composerEmpty: optionalBoolField(value, "composerEmpty", false),
				modalOrPopupActive: optionalBoolField(value, "modalOrPopupActive", false),
				historySearchActive: optionalBoolField(value, "historySearchActive", false),
				doublePressEnabled: optionalBoolField(value, "doublePressEnabled", false),
				quitShortcutActive: optionalBoolField(value, "quitShortcutActive", false),
				quitShortcutArmed: optionalBoolField(value, "quitShortcutArmed", false),
				quitShortcutCleared: optionalBoolField(value, "quitShortcutCleared", false),
				quitRequested: optionalBoolField(value, "quitRequested", false),
				bottomPaneNotHandled: optionalBoolField(value, "bottomPaneNotHandled", false),
				fallsThrough: optionalBoolField(value, "fallsThrough", false),
				pasteBurstActiveBefore: optionalBoolField(value, "pasteBurstActiveBefore", false),
				pasteBurstActiveAfter: optionalBoolField(value, "pasteBurstActiveAfter", false),
				pasteBurstFlushed: optionalBoolField(value, "pasteBurstFlushed", false),
				burstWindowCleared: optionalBoolField(value, "burstWindowCleared", false),
				newlineCaptured: optionalBoolField(value, "newlineCaptured", false),
				remoteSelectionHandled: optionalBoolField(value, "remoteSelectionHandled", false),
				remoteSelectionCleared: optionalBoolField(value, "remoteSelectionCleared", false),
				shortcutOverlayHandled: optionalBoolField(value, "shortcutOverlayHandled", false),
				bashModeEnabled: optionalBoolField(value, "bashModeEnabled", false),
				bashModeDisabled: optionalBoolField(value, "bashModeDisabled", false),
				vimInsertEscapeHandled: optionalBoolField(value, "vimInsertEscapeHandled", false),
				historyHandled: optionalBoolField(value, "historyHandled", false),
				historyApplied: optionalBoolField(value, "historyApplied", false),
				pendingPastePruned: optionalBoolField(value, "pendingPastePruned", false),
				localImagesPruned: optionalBoolField(value, "localImagesPruned", false),
				inputEnabled: optionalBoolField(value, "inputEnabled", true),
				textareaDelegated: optionalBoolField(value, "textareaDelegated", false),
				pasteBurstDelegated: optionalBoolField(value, "pasteBurstDelegated", false),
				popupSynced: optionalBoolField(value, "popupSynced", false),
				vimReset: optionalBoolField(value, "vimReset", false),
				submissionReadyPreserved: optionalBoolField(value, "submissionReadyPreserved", false),
				navigationEligible: optionalBoolField(value, "navigationEligible", false),
				cursorBoundary: optionalBoolField(value, "cursorBoundary", false),
				textMatchesLastHistory: optionalBoolField(value, "textMatchesLastHistory", false),
				lookupRequested: optionalBoolField(value, "lookupRequested", false),
				lookupResponded: optionalBoolField(value, "lookupResponded", false),
				staleIgnored: optionalBoolField(value, "staleIgnored", false),
				cacheHit: optionalBoolField(value, "cacheHit", false),
				cacheInserted: optionalBoolField(value, "cacheInserted", false),
				duplicateSkipped: optionalBoolField(value, "duplicateSkipped", false),
				navigationReset: optionalBoolField(value, "navigationReset", false),
				vimNormalMode: optionalBoolField(value, "vimNormalMode", false),
				operatorPending: optionalBoolField(value, "operatorPending", false),
				remapped: optionalBoolField(value, "remapped", false),
				fallbackSuppressed: optionalBoolField(value, "fallbackSuppressed", false),
				elementsShifted: optionalBoolField(value, "elementsShifted", false),
				cursorClamped: optionalBoolField(value, "cursorClamped", false),
				pendingExpanded: optionalBoolField(value, "pendingExpanded", false),
				textTrimmed: optionalBoolField(value, "textTrimmed", false),
				attachmentsRetained: optionalBoolField(value, "attachmentsRetained", false),
				attachmentsDropped: optionalBoolField(value, "attachmentsDropped", false),
				placeholdersRenumbered: optionalBoolField(value, "placeholdersRenumbered", false),
				duplicateLimited: optionalBoolField(value, "duplicateLimited", false),
				elementsRebuilt: optionalBoolField(value, "elementsRebuilt", false),
				cursorAtEnd: optionalBoolField(value, "cursorAtEnd", false),
				noLiveInput: optionalBoolField(value, "noLiveInput", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerSubmissionPlan(object:Value, name:String):Null<TuiSmokeComposerSubmissionPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerSubmissionPlan({
					allowLiveDispatch: optionalBoolField(value, "allowLiveDispatch", false),
					actions: composerSubmissionActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerSubmissionActions(values:Array<Value>):Array<TuiSmokeComposerSubmissionAction> {
		final out:Array<TuiSmokeComposerSubmissionAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerSubmissionAction({
				kind: TuiSmokeComposerSubmissionActionKind.fromString(stringField(value, "kind", "")),
				result: TuiSmokeComposerSubmissionResultKind.fromString(optionalStringField(value, "result", "unknown")),
				queuedAction: TuiSmokeComposerQueuedActionKind.fromString(optionalStringField(value, "queuedAction", "unknown")),
				slashValidation: TuiSmokeComposerSlashValidationKind.fromString(optionalStringField(value, "slashValidation", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				preparedText: optionalStringField(value, "preparedText", ""),
				argsText: optionalStringField(value, "argsText", ""),
				commandName: optionalStringField(value, "commandName", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				charCount: optionalIntField(value, "charCount", 0),
				maxChars: optionalIntField(value, "maxChars", 0),
				pendingBefore: optionalIntField(value, "pendingBefore", 0),
				pendingAfter: optionalIntField(value, "pendingAfter", 0),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
				textElementBefore: optionalIntField(value, "textElementBefore", 0),
				textElementAfter: optionalIntField(value, "textElementAfter", 0),
				localImageBefore: optionalIntField(value, "localImageBefore", 0),
				localImageAfter: optionalIntField(value, "localImageAfter", 0),
				remoteImageBefore: optionalIntField(value, "remoteImageBefore", 0),
				remoteImageAfter: optionalIntField(value, "remoteImageAfter", 0),
				textItemCount: optionalIntField(value, "textItemCount", 0),
				remoteImageItemCount: optionalIntField(value, "remoteImageItemCount", 0),
				localImageItemCount: optionalIntField(value, "localImageItemCount", 0),
				skillItemCount: optionalIntField(value, "skillItemCount", 0),
				mentionItemCount: optionalIntField(value, "mentionItemCount", 0),
				itemCount: optionalIntField(value, "itemCount", 0),
				mentionBindingCount: optionalIntField(value, "mentionBindingCount", 0),
				mentionBindingBefore: optionalIntField(value, "mentionBindingBefore", 0),
				mentionBindingAfter: optionalIntField(value, "mentionBindingAfter", 0),
				recentMentionBindingBefore: optionalIntField(value, "recentMentionBindingBefore", 0),
				recentMentionBindingAfter: optionalIntField(value, "recentMentionBindingAfter", 0),
				queueBefore: optionalIntField(value, "queueBefore", 0),
				queueAfter: optionalIntField(value, "queueAfter", 0),
				itemOrder: optionalStringField(value, "itemOrder", ""),
				mentionBindingSummary: optionalStringField(value, "mentionBindingSummary", ""),
				modelName: optionalStringField(value, "modelName", ""),
				shouldQueue: optionalBoolField(value, "shouldQueue", false),
				recordHistory: optionalBoolField(value, "recordHistory", false),
				pasteBurstFlushed: optionalBoolField(value, "pasteBurstFlushed", false),
				pendingExpanded: optionalBoolField(value, "pendingExpanded", false),
				pendingRestored: optionalBoolField(value, "pendingRestored", false),
				pendingCleared: optionalBoolField(value, "pendingCleared", false),
				textTrimmed: optionalBoolField(value, "textTrimmed", false),
				slashValidationDeferred: optionalBoolField(value, "slashValidationDeferred", false),
				slashValidationFailed: optionalBoolField(value, "slashValidationFailed", false),
				tooLargeRejected: optionalBoolField(value, "tooLargeRejected", false),
				emptySuppressed: optionalBoolField(value, "emptySuppressed", false),
				imagesPruned: optionalBoolField(value, "imagesPruned", false),
				localImagesDrained: optionalBoolField(value, "localImagesDrained", false),
				remoteImagesDrained: optionalBoolField(value, "remoteImagesDrained", false),
				messageBuilt: optionalBoolField(value, "messageBuilt", false),
				submittedNow: optionalBoolField(value, "submittedNow", false),
				queued: optionalBoolField(value, "queued", false),
				statusWorking: optionalBoolField(value, "statusWorking", false),
				reasoningCleared: optionalBoolField(value, "reasoningCleared", false),
				historyStaged: optionalBoolField(value, "historyStaged", false),
				historyRecorded: optionalBoolField(value, "historyRecorded", false),
				vimNormalEntered: optionalBoolField(value, "vimNormalEntered", false),
				modelSupportsImages: optionalBoolField(value, "modelSupportsImages", false),
				sessionConfigured: optionalBoolField(value, "sessionConfigured", false),
				modelAvailable: optionalBoolField(value, "modelAvailable", false),
				blockedRestored: optionalBoolField(value, "blockedRestored", false),
				userTurnSubmitted: optionalBoolField(value, "userTurnSubmitted", false),
				shellEscapeAllowed: optionalBoolField(value, "shellEscapeAllowed", false),
				shellCommandSubmitted: optionalBoolField(value, "shellCommandSubmitted", false),
				renderInHistory: optionalBoolField(value, "renderInHistory", false),
				pendingSteerQueued: optionalBoolField(value, "pendingSteerQueued", false),
				displayRecorded: optionalBoolField(value, "displayRecorded", false),
				cancelEditRecorded: optionalBoolField(value, "cancelEditRecorded", false),
				ideContextApplied: optionalBoolField(value, "ideContextApplied", false),
				collaborationModeAttached: optionalBoolField(value, "collaborationModeAttached", false),
				emptySuppressedBeforeDispatch: optionalBoolField(value, "emptySuppressedBeforeDispatch", false),
				appEventSent: optionalBoolField(value, "appEventSent", false),
				draftCleared: optionalBoolField(value, "draftCleared", false),
				mentionBindingsRestored: optionalBoolField(value, "mentionBindingsRestored", false),
				recentMentionBindingsDrained: optionalBoolField(value, "recentMentionBindingsDrained", false),
				invalidBindingsDropped: optionalBoolField(value, "invalidBindingsDropped", false),
				pathlessBindingsIgnored: optionalBoolField(value, "pathlessBindingsIgnored", false),
				mentionBindingsSubmitted: optionalBoolField(value, "mentionBindingsSubmitted", false),
				pluginAccentApplied: optionalBoolField(value, "pluginAccentApplied", false),
				popupSuppressed: optionalBoolField(value, "popupSuppressed", false),
				arrowNavigationPassed: optionalBoolField(value, "arrowNavigationPassed", false),
				sigilMatched: optionalBoolField(value, "sigilMatched", false),
				boundaryMatched: optionalBoolField(value, "boundaryMatched", false),
				emailSubstringSkipped: optionalBoolField(value, "emailSubstringSkipped", false),
				punctuationBoundaryAccepted: optionalBoolField(value, "punctuationBoundaryAccepted", false),
				noLiveDispatch: optionalBoolField(value, "noLiveDispatch", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalComposerAttachmentPlan(object:Value, name:String):Null<TuiSmokeComposerAttachmentPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeComposerAttachmentPlan({
					allowLiveFilesystem: optionalBoolField(value, "allowLiveFilesystem", false),
					allowLiveClipboard: optionalBoolField(value, "allowLiveClipboard", false),
					allowProcessSpawn: optionalBoolField(value, "allowProcessSpawn", false),
					actions: composerAttachmentActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function composerAttachmentActions(values:Array<Value>):Array<TuiSmokeComposerAttachmentAction> {
		final out:Array<TuiSmokeComposerAttachmentAction> = [];
		for (value in values) {
			out.push(new TuiSmokeComposerAttachmentAction({
				kind: TuiSmokeComposerAttachmentActionKind.fromString(stringField(value, "kind", "")),
				pasteKind: TuiSmokeComposerPasteKind.fromString(optionalStringField(value, "pasteKind", "unknown")),
				attachmentKind: TuiSmokeComposerAttachmentKind.fromString(optionalStringField(value, "attachmentKind", "unknown")),
				burstBefore: TuiSmokeComposerPasteBurstStateKind.fromString(optionalStringField(value, "burstBefore", "unknown")),
				burstAfter: TuiSmokeComposerPasteBurstStateKind.fromString(optionalStringField(value, "burstAfter", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				normalizedText: optionalStringField(value, "normalizedText", ""),
				placeholder: optionalStringField(value, "placeholder", ""),
				path: optionalStringField(value, "path", ""),
				remoteUrl: optionalStringField(value, "remoteUrl", ""),
				keyName: optionalStringField(value, "keyName", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				charCount: optionalIntField(value, "charCount", 0),
				threshold: optionalIntField(value, "threshold", 0),
				pendingBefore: optionalIntField(value, "pendingBefore", 0),
				pendingAfter: optionalIntField(value, "pendingAfter", 0),
				textElementBefore: optionalIntField(value, "textElementBefore", 0),
				textElementAfter: optionalIntField(value, "textElementAfter", 0),
				localImageBefore: optionalIntField(value, "localImageBefore", 0),
				localImageAfter: optionalIntField(value, "localImageAfter", 0),
				remoteImageBefore: optionalIntField(value, "remoteImageBefore", 0),
				remoteImageAfter: optionalIntField(value, "remoteImageAfter", 0),
				selectedRemoteBefore: optionalIntField(value, "selectedRemoteBefore", -1),
				selectedRemoteAfter: optionalIntField(value, "selectedRemoteAfter", -1),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
				charIntervalMs: optionalIntField(value, "charIntervalMs", 0),
				activeIdleTimeoutMs: optionalIntField(value, "activeIdleTimeoutMs", 0),
				followupDelayMs: optionalIntField(value, "followupDelayMs", 0),
				needsRedraw: optionalBoolField(value, "needsRedraw", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				pasteBurstDisabled: optionalBoolField(value, "pasteBurstDisabled", false),
				buffered: optionalBoolField(value, "buffered", false),
				flushed: optionalBoolField(value, "flushed", false),
				newlineCaptured: optionalBoolField(value, "newlineCaptured", false),
				placeholderInserted: optionalBoolField(value, "placeholderInserted", false),
				pendingStored: optionalBoolField(value, "pendingStored", false),
				pendingExpanded: optionalBoolField(value, "pendingExpanded", false),
				pendingCleared: optionalBoolField(value, "pendingCleared", false),
				imagePasteEnabled: optionalBoolField(value, "imagePasteEnabled", false),
				imageDimensionsChecked: optionalBoolField(value, "imageDimensionsChecked", false),
				imageAttached: optionalBoolField(value, "imageAttached", false),
				pathInsertedFallback: optionalBoolField(value, "pathInsertedFallback", false),
				textInserted: optionalBoolField(value, "textInserted", false),
				selectionCleared: optionalBoolField(value, "selectionCleared", false),
				remoteRelabeledLocals: optionalBoolField(value, "remoteRelabeledLocals", false),
				draftSnapshotStored: optionalBoolField(value, "draftSnapshotStored", false),
				draftRestored: optionalBoolField(value, "draftRestored", false),
				historyEntryApplied: optionalBoolField(value, "historyEntryApplied", false),
				submissionSuppressed: optionalBoolField(value, "submissionSuppressed", false),
				submissionPrepared: optionalBoolField(value, "submissionPrepared", false),
				localImagesPruned: optionalBoolField(value, "localImagesPruned", false),
				remoteImagesTaken: optionalBoolField(value, "remoteImagesTaken", false),
				explicitPasteClearsBurst: optionalBoolField(value, "explicitPasteClearsBurst", false),
				shortcutOverlaySuppressed: optionalBoolField(value, "shortcutOverlaySuppressed", false),
				noLiveClipboard: optionalBoolField(value, "noLiveClipboard", false),
				noProcessSpawn: optionalBoolField(value, "noProcessSpawn", false),
				noLiveFilesystem: optionalBoolField(value, "noLiveFilesystem", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalHistorySearchPlan(object:Value, name:String):Null<TuiSmokeHistorySearchPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeHistorySearchPlan({
					allowLiveHistoryLookup: optionalBoolField(value, "allowLiveHistoryLookup", false),
					actions: historySearchActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function historySearchActions(values:Array<Value>):Array<TuiSmokeHistorySearchAction> {
		final out:Array<TuiSmokeHistorySearchAction> = [];
		for (value in values) {
			out.push(new TuiSmokeHistorySearchAction({
				kind: TuiSmokeHistorySearchActionKind.fromString(stringField(value, "kind", "")),
				direction: TuiSmokeHistorySearchDirectionKind.fromString(optionalStringField(value, "direction", "unknown")),
				result: TuiSmokeHistorySearchResultKind.fromString(optionalStringField(value, "result", "unknown")),
				statusBefore: TuiSmokeHistorySearchStatusKind.fromString(optionalStringField(value, "statusBefore", "unknown")),
				statusAfter: TuiSmokeHistorySearchStatusKind.fromString(optionalStringField(value, "statusAfter", "unknown")),
				keyName: optionalStringField(value, "keyName", ""),
				inputText: optionalStringField(value, "inputText", ""),
				queryBefore: optionalStringField(value, "queryBefore", ""),
				queryAfter: optionalStringField(value, "queryAfter", ""),
				originalDraft: optionalStringField(value, "originalDraft", ""),
				previewText: optionalStringField(value, "previewText", ""),
				acceptedText: optionalStringField(value, "acceptedText", ""),
				restoredText: optionalStringField(value, "restoredText", ""),
				footerLine: optionalStringField(value, "footerLine", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				matchCount: optionalIntField(value, "matchCount", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				persistentOffset: optionalIntField(value, "persistentOffset", 0),
				logId: optionalIntField(value, "logId", 0),
				highlightCount: optionalIntField(value, "highlightCount", 0),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
				activeBefore: optionalBoolField(value, "activeBefore", false),
				activeAfter: optionalBoolField(value, "activeAfter", false),
				pasteFlushed: optionalBoolField(value, "pasteFlushed", false),
				fileQueryCleared: optionalBoolField(value, "fileQueryCleared", false),
				popupsCleared: optionalBoolField(value, "popupsCleared", false),
				remoteImageSelectionCleared: optionalBoolField(value, "remoteImageSelectionCleared", false),
				searchReset: optionalBoolField(value, "searchReset", false),
				navigationReset: optionalBoolField(value, "navigationReset", false),
				lookupRequested: optionalBoolField(value, "lookupRequested", false),
				pendingStored: optionalBoolField(value, "pendingStored", false),
				draftRestored: optionalBoolField(value, "draftRestored", false),
				draftPreviewed: optionalBoolField(value, "draftPreviewed", false),
				draftAccepted: optionalBoolField(value, "draftAccepted", false),
				footerMode: optionalBoolField(value, "footerMode", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				keyConsumed: optionalBoolField(value, "keyConsumed", false),
				releaseIgnored: optionalBoolField(value, "releaseIgnored", false),
				ctrlCConsumed: optionalBoolField(value, "ctrlCConsumed", false),
				remapped: optionalBoolField(value, "remapped", false),
				fallbackSuppressed: optionalBoolField(value, "fallbackSuppressed", false),
				noLiveLookup: optionalBoolField(value, "noLiveLookup", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
			}));
		}
		return out;
	}

	static function optionalFileMentionPopupPlan(object:Value, name:String):Null<TuiSmokeFileMentionPopupPlan> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeFileMentionPopupPlan({
					allowLiveFileSearch: optionalBoolField(value, "allowLiveFileSearch", false),
					actions: fileMentionPopupActions(optionalArrayField(value, "actions"))
				});
		}
	}

	static function fileMentionPopupActions(values:Array<Value>):Array<TuiSmokeFileMentionPopupAction> {
		final out:Array<TuiSmokeFileMentionPopupAction> = [];
		for (value in values) {
			out.push(new TuiSmokeFileMentionPopupAction({
				kind: TuiSmokeFileMentionPopupActionKind.fromString(stringField(value, "kind", "")),
				popupBefore: TuiSmokeFileMentionPopupKind.fromString(optionalStringField(value, "popupBefore", "unknown")),
				popupAfter: TuiSmokeFileMentionPopupKind.fromString(optionalStringField(value, "popupAfter", "unknown")),
				candidateKind: TuiSmokeMentionCandidateKind.fromString(optionalStringField(value, "candidateKind", "unknown")),
				searchModeBefore: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchModeBefore", "unknown")),
				searchModeAfter: TuiSmokeMentionSearchModeKind.fromString(optionalStringField(value, "searchModeAfter", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				token: optionalStringField(value, "token", ""),
				query: optionalStringField(value, "query", ""),
				selectedPath: optionalStringField(value, "selectedPath", ""),
				insertText: optionalStringField(value, "insertText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				matchCount: optionalIntField(value, "matchCount", 0),
				visibleCount: optionalIntField(value, "visibleCount", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				selectedBefore: optionalIntField(value, "selectedBefore", 0),
				selectedAfter: optionalIntField(value, "selectedAfter", 0),
				scrollBefore: optionalIntField(value, "scrollBefore", 0),
				scrollAfter: optionalIntField(value, "scrollAfter", 0),
				maxRows: optionalIntField(value, "maxRows", 0),
				fileCandidateCount: optionalIntField(value, "fileCandidateCount", 0),
				directoryCandidateCount: optionalIntField(value, "directoryCandidateCount", 0),
				skillCandidateCount: optionalIntField(value, "skillCandidateCount", 0),
				pluginCandidateCount: optionalIntField(value, "pluginCandidateCount", 0),
				toolCandidateCount: optionalIntField(value, "toolCandidateCount", 0),
				mentionsV2Enabled: optionalBoolField(value, "mentionsV2Enabled", false),
				slashPopupSuppressed: optionalBoolField(value, "slashPopupSuppressed", false),
				queryStartSent: optionalBoolField(value, "queryStartSent", false),
				queryClearSent: optionalBoolField(value, "queryClearSent", false),
				sameQuerySkipped: optionalBoolField(value, "sameQuerySkipped", false),
				resultAccepted: optionalBoolField(value, "resultAccepted", false),
				resultStale: optionalBoolField(value, "resultStale", false),
				popupCreated: optionalBoolField(value, "popupCreated", false),
				popupDismissed: optionalBoolField(value, "popupDismissed", false),
				dismissedTokenStored: optionalBoolField(value, "dismissedTokenStored", false),
				bindingStored: optionalBoolField(value, "bindingStored", false),
				draftUpdated: optionalBoolField(value, "draftUpdated", false),
				frameScheduled: optionalBoolField(value, "frameScheduled", false),
				redrawRequested: optionalBoolField(value, "redrawRequested", false),
				liveSearchRejected: optionalBoolField(value, "liveSearchRejected", false),
				unsupportedRejected: optionalBoolField(value, "unsupportedRejected", false)
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
				queuedAction: TuiSmokeComposerQueuedActionKind.fromString(optionalStringField(value, "queuedAction", "unknown")),
				inputText: optionalStringField(value, "inputText", ""),
				filterText: optionalStringField(value, "filterText", ""),
				commandName: optionalStringField(value, "commandName", ""),
				canonicalCommandText: optionalStringField(value, "canonicalCommandText", ""),
				recalledText: optionalStringField(value, "recalledText", ""),
				inlineArgs: optionalStringField(value, "inlineArgs", ""),
				totalCommands: optionalIntField(value, "totalCommands", 0),
				visibleCount: optionalIntField(value, "visibleCount", 0),
				matchedCount: optionalIntField(value, "matchedCount", 0),
				rowCount: optionalIntField(value, "rowCount", 0),
				textElementCount: optionalIntField(value, "textElementCount", 0),
				localImageCount: optionalIntField(value, "localImageCount", 0),
				remoteImageCount: optionalIntField(value, "remoteImageCount", 0),
				pendingPasteCount: optionalIntField(value, "pendingPasteCount", 0),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
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
				queued: optionalBoolField(value, "queued", false),
				slashValidationDeferred: optionalBoolField(value, "slashValidationDeferred", false),
				leadingSpaceInput: optionalBoolField(value, "leadingSpaceInput", false),
				inlineArgsTrimmed: optionalBoolField(value, "inlineArgsTrimmed", false),
				commandElementStored: optionalBoolField(value, "commandElementStored", false),
				commandElementRemoved: optionalBoolField(value, "commandElementRemoved", false),
				cursorAtEnd: optionalBoolField(value, "cursorAtEnd", false),
				appEventEmitted: optionalBoolField(value, "appEventEmitted", false),
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
				new TuiSmokeAppEvent(TuiSmokeAppEventKind.fromString(stringField(value, "kind", "")), optionalStringField(value, "status", ""),
					TuiSmokeExitMode.fromString(optionalStringField(value, "exitMode", "unknown")));
		}
	}

	static function optionalAppServerEvent(object:Value, name:String):Null<TuiSmokeAppServerEvent> {
		return switch optionalField(object, name) {
			case JNull: null;
			case value:
				new TuiSmokeAppServerEvent(TuiSmokeAppServerEventKind.fromString(stringField(value, "kind", "")), optionalStringField(value, "threadId", ""),
					optionalStringField(value, "status", ""), optionalStringField(value, "delta", ""), optionalStringField(value, "message", ""));
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
					if (keys[i] == name)
						return values[i];
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
					if (keys[i] == name)
						return values[i];
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

	static function optionalStringArrayField(object:Value, name:String):Array<String> {
		final out:Array<String> = [];
		for (value in optionalArrayField(object, name)) {
			switch value {
				case JString(text):
					out.push(text);
				case _:
					throw "expected string array field: " + name;
			}
		}
		return out;
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
