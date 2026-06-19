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
				chatWidgetStatusState: optionalStatusStatePlan(value, "chatWidgetStatusState"),
				chatWidgetCommandLifecycle: optionalCommandLifecyclePlan(value, "chatWidgetCommandLifecycle"),
				chatWidgetToolLifecycle: optionalToolLifecyclePlan(value, "chatWidgetToolLifecycle"),
				chatWidgetInterruptQuit: optionalChatWidgetInterruptQuitPlan(value, "chatWidgetInterruptQuit"),
				chatWidgetInterruptedRestore: optionalChatWidgetInterruptedRestorePlan(value, "chatWidgetInterruptedRestore"),
				sideConversation: optionalSideConversationPlan(value, "sideConversation"),
				clearArchive: optionalClearArchivePlan(value, "clearArchive"),
				resumeFork: optionalResumeForkPlan(value, "resumeFork"),
				terminalTitle: optionalTerminalTitlePlan(value, "terminalTitle"),
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
				targetLabel: optionalStringField(value, "targetLabel", ""),
				targetPath: optionalStringField(value, "targetPath", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				pageSize: optionalIntField(value, "pageSize", 0),
				loadedRows: optionalIntField(value, "loadedRows", 0),
				turnCount: optionalIntField(value, "turnCount", 0),
				altScreenEntered: optionalBoolField(value, "altScreenEntered", false),
				altScreenExited: optionalBoolField(value, "altScreenExited", false),
				pickerStarted: optionalBoolField(value, "pickerStarted", false),
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
				parentThreadId: optionalStringField(value, "parentThreadId", ""),
				childThreadId: optionalStringField(value, "childThreadId", ""),
				targetThreadId: optionalStringField(value, "targetThreadId", ""),
				status: optionalStringField(value, "status", ""),
				statusChange: optionalStringField(value, "statusChange", ""),
				label: optionalStringField(value, "label", ""),
				blockMessage: optionalStringField(value, "blockMessage", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				userMessageText: optionalStringField(value, "userMessageText", ""),
				errorMessage: optionalStringField(value, "errorMessage", ""),
				sideThreadsBefore: optionalIntField(value, "sideThreadsBefore", 0),
				sideThreadsAfter: optionalIntField(value, "sideThreadsAfter", 0),
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
				reason: optionalStringField(value, "reason", ""),
				noticeMode: optionalStringField(value, "noticeMode", ""),
				noticeText: optionalStringField(value, "noticeText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				promptText: optionalStringField(value, "promptText", ""),
				restoredText: optionalStringField(value, "restoredText", ""),
				composerText: optionalStringField(value, "composerText", ""),
				queueSource: optionalStringField(value, "queueSource", ""),
				popOrder: optionalStringField(value, "popOrder", ""),
				historyRecord: optionalStringField(value, "historyRecord", ""),
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
				pendingPreviewRefreshed: optionalBoolField(value, "pendingPreviewRefreshed", false),
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
				key: optionalStringField(value, "key", ""),
				route: optionalStringField(value, "route", ""),
				exitMode: optionalStringField(value, "exitMode", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				doublePressEnabled: optionalBoolField(value, "doublePressEnabled", false),
				realtimeLive: optionalBoolField(value, "realtimeLive", false),
				modalOrPopupActive: optionalBoolField(value, "modalOrPopupActive", false),
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
				pendingSteersBefore: optionalIntField(value, "pendingSteersBefore", 0),
				pendingSteersAfter: optionalIntField(value, "pendingSteersAfter", 0),
				submitPendingSteersAfterInterrupt: optionalBoolField(value, "submitPendingSteersAfterInterrupt", false),
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
				keyName: optionalStringField(value, "keyName", ""),
				inputText: optionalStringField(value, "inputText", ""),
				outputText: optionalStringField(value, "outputText", ""),
				failureCode: optionalStringField(value, "failureCode", ""),
				cursorBefore: optionalIntField(value, "cursorBefore", 0),
				cursorAfter: optionalIntField(value, "cursorAfter", 0),
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
				needsRedraw: optionalBoolField(value, "needsRedraw", false),
				keyConsumed: optionalBoolField(value, "keyConsumed", false),
				releaseIgnored: optionalBoolField(value, "releaseIgnored", false),
				queueSubmissions: optionalBoolField(value, "queueSubmissions", false),
				taskRunning: optionalBoolField(value, "taskRunning", false),
				shellCommand: optionalBoolField(value, "shellCommand", false),
				submissionQueued: optionalBoolField(value, "submissionQueued", false),
				submissionSubmitted: optionalBoolField(value, "submissionSubmitted", false),
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
				queueBefore: optionalIntField(value, "queueBefore", 0),
				queueAfter: optionalIntField(value, "queueAfter", 0),
				itemOrder: optionalStringField(value, "itemOrder", ""),
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
