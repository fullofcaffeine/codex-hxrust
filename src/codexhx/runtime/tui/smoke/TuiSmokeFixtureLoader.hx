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
				threadReplay: optionalThreadReplay(value, "threadReplay")
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
