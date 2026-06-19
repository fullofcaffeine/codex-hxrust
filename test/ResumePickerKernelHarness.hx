import codexhx.protocol.json.CodexJson;
import codexhx.runtime.tui.resume.ResumePickerCommand;
import codexhx.runtime.tui.resume.ResumePickerCommandKind;
import codexhx.runtime.tui.resume.ResumePickerDensity;
import codexhx.runtime.tui.resume.ResumePickerEffectKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerReducer;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerToolbarFocus;
import haxe.json.Value;
import sys.io.File;

class ResumePickerKernelHarness {
	static function main():Void {
		final commands:Array<ResumePickerCommand> = [];
		var planCount = 0;
		for (request in arrayField(fixtureRoot(), "loopCases")) {
			for (event in arrayField(request, "events")) {
				final plan = optionalObjectField(event, "resumeFork");
				if (plan == null)
					continue;
				planCount = planCount + 1;
				for (action in arrayField(plan, "actions")) {
					commands.push(command(action));
				}
			}
		}

		final report = ResumePickerReducer.run(commands, planCount);
		assertEquals("9", Std.string(report.planCount), "plan count");
		assertEquals("90", Std.string(report.commandCount), "command count");
		assertEquals("7", Std.string(report.finalState.pickerOpenCount), "picker open count");
		assertEquals("1", Std.string(report.finalState.staleIngests), "stale page ingests");
		assertEquals("7", Std.string(report.finalState.failureCount), "failure count");
		assertEquals("0", Std.string(report.finalState.unknownCount), "unknown command count");

		assertEquals("3", Std.string(report.pageRequests), "page request effects");
		assertEquals("2", Std.string(report.previewRequests), "preview request effects");
		assertEquals("4", Std.string(report.transcriptRequests), "transcript request effects");
		assertEquals("34", Std.string(report.frameRequests), "frame request effects");
		assertEquals("2", Std.string(report.persistDensityRequests), "density persistence effects");
		assertEquals("2", Std.string(report.overlayOpenRequests), "overlay open effects");
		assertEquals("2", Std.string(report.loadMoreRequests), "load-more effects");
		assertEquals("1", Std.string(report.startFreshRequests), "start-fresh effects");
		assertEquals("8", Std.string(report.errorSurfaces), "error surface effects");

		assertTrue(report.finalState.opened, "picker should be opened by fixture evidence");
		assertEquals(ResumePickerDensity.Dense, report.finalState.density, "density");
		assertEquals(ResumePickerToolbarFocus.Sort, report.finalState.toolbarFocus, "toolbar focus");
		assertEquals(ResumePickerSortKey.UpdatedAt, report.finalState.sortKey, "sort key");
		assertEquals(ResumePickerFilterMode.All, report.finalState.filterMode, "filter mode");
		assertEquals("No sessions yet", report.finalState.emptyStateMessage, "empty state");
		assertEquals("Loading transcript…", report.finalState.loadingOverlayMessage, "loading overlay");
		assertEquals("session_not_found", report.finalState.lastFailureCode, "final failure code");
		assertEquals("No saved chat found matching missing-thread.", report.finalState.lastError, "final error");
		assertTrue(report.finalState.countEffect(ResumePickerEffectKind.SurfaceError) == report.errorSurfaces, "effect recount should match report");

		Sys.println(report.summary());
	}

	static function command(value:Value):ResumePickerCommand {
		return new ResumePickerCommand({
			kind: ResumePickerCommandKind.fromString(stringField(value, "kind", "")),
			action: codexhx.runtime.tui.resume.ResumePickerActionKind.fromString(stringField(value, "action", "")),
			keyName: stringField(value, "keyName", ""),
			threadId: stringField(value, "threadId", ""),
			pendingThreadId: stringField(value, "pendingThreadId", ""),
			expandedThreadId: stringField(value, "expandedThreadId", ""),
			targetPath: stringField(value, "targetPath", ""),
			targetLabel: stringField(value, "targetLabel", ""),
			errorMessage: stringField(value, "errorMessage", ""),
			failureCode: stringField(value, "failureCode", ""),
			query: stringField(value, "query", ""),
			queryBefore: stringField(value, "queryBefore", ""),
			queryAfter: stringField(value, "queryAfter", ""),
			cursor: stringField(value, "cursor", ""),
			nextCursor: stringField(value, "nextCursor", ""),
			sortKey: ResumePickerSortKey.fromString(stringField(value, "sortKey", "")),
			sortKeyBefore: ResumePickerSortKey.fromString(stringField(value, "sortKeyBefore", "")),
			sortKeyAfter: ResumePickerSortKey.fromString(stringField(value, "sortKeyAfter", "")),
			filterModeBefore: ResumePickerFilterMode.fromString(stringField(value, "filterModeBefore", "")),
			filterModeAfter: ResumePickerFilterMode.fromString(stringField(value, "filterModeAfter", "")),
			densityBefore: ResumePickerDensity.fromString(stringField(value, "densityBefore", "")),
			densityAfter: ResumePickerDensity.fromString(stringField(value, "densityAfter", "")),
			toolbarFocusBefore: ResumePickerToolbarFocus.fromString(stringField(value, "toolbarFocusBefore", "")),
			toolbarFocusAfter: ResumePickerToolbarFocus.fromString(stringField(value, "toolbarFocusAfter", "")),
			toolbarRenderMode: stringField(value, "toolbarRenderMode", ""),
			previewState: stringField(value, "previewState", ""),
			previewCacheAfter: stringField(value, "previewCacheAfter", ""),
			transcriptState: stringField(value, "transcriptState", ""),
			transcriptCacheAfter: stringField(value, "transcriptCacheAfter", ""),
			footerProgressLabel: stringField(value, "footerProgressLabel", ""),
			footerHintMode: stringField(value, "footerHintMode", ""),
			emptyStateMessage: stringField(value, "emptyStateMessage", ""),
			loadingOverlayMessage: stringField(value, "loadingOverlayMessage", ""),
			cwdFilter: stringField(value, "cwdFilter", ""),
			requestToken: intField(value, "requestToken", 0),
			searchToken: intField(value, "searchToken", 0),
			scannedRows: intField(value, "scannedRows", 0),
			acceptedRows: intField(value, "acceptedRows", 0),
			invalidRows: intField(value, "invalidRows", 0),
			loadedRows: intField(value, "loadedRows", 0),
			filteredRows: intField(value, "filteredRows", 0),
			selectedIndex: intField(value, "selectedIndex", 0),
			selectedBefore: intField(value, "selectedBefore", 0),
			selectedAfter: intField(value, "selectedAfter", 0),
			scrollTopBefore: intField(value, "scrollTopBefore", 0),
			scrollTopAfter: intField(value, "scrollTopAfter", 0),
			viewRows: intField(value, "viewRows", 0),
			pageSize: intField(value, "pageSize", 0),
			footerPercent: intField(value, "footerPercent", 0),
			frozenFooterPercent: intField(value, "frozenFooterPercent", 0),
			footerWidth: intField(value, "footerWidth", 0),
			previewLineCount: intField(value, "previewLineCount", 0),
			userLineCount: intField(value, "userLineCount", 0),
			assistantLineCount: intField(value, "assistantLineCount", 0),
			transcriptCellCount: intField(value, "transcriptCellCount", 0),
			planCellCount: intField(value, "planCellCount", 0),
			reasoningCellCount: intField(value, "reasoningCellCount", 0),
			fallbackCellCount: intField(value, "fallbackCellCount", 0),
			showAll: boolField(value, "showAll", false),
			includeNonInteractive: boolField(value, "includeNonInteractive", false),
			remoteWorkspace: boolField(value, "remoteWorkspace", false),
			altScreenEntered: boolField(value, "altScreenEntered", false),
			altScreenExited: boolField(value, "altScreenExited", false),
			searchActive: boolField(value, "searchActive", false),
			staleIgnored: boolField(value, "staleIgnored", false),
			nextCursorPresent: boolField(value, "nextCursorPresent", false),
			reachedScanCap: boolField(value, "reachedScanCap", false),
			pendingPageDownCompleted: boolField(value, "pendingPageDownCompleted", false),
			lookupRequested: boolField(value, "lookupRequested", false),
			cacheInserted: boolField(value, "cacheInserted", false),
			expansionToggled: boolField(value, "expansionToggled", false),
			includeTurns: boolField(value, "includeTurns", false),
			threadReadRequested: boolField(value, "threadReadRequested", false),
			appServerStarted: boolField(value, "appServerStarted", false),
			noModelCall: boolField(value, "noModelCall", false),
			noFilesystemMutation: boolField(value, "noFilesystemMutation", false),
			previewRendered: boolField(value, "previewRendered", false),
			selected: boolField(value, "selected", false),
			loadingFrameShown: boolField(value, "loadingFrameShown", false),
			overlayOpened: boolField(value, "overlayOpened", false),
			loadMoreRequested: boolField(value, "loadMoreRequested", false),
			startFresh: boolField(value, "startFresh", false),
			keyConsumed: boolField(value, "keyConsumed", false),
			overlayClosed: boolField(value, "overlayClosed", false),
			persistenceConfigured: boolField(value, "persistenceConfigured", false),
			persistenceAttempted: boolField(value, "persistenceAttempted", false),
			persistenceSucceeded: boolField(value, "persistenceSucceeded", false),
			inlineErrorShown: boolField(value, "inlineErrorShown", false),
			queryPreserved: boolField(value, "queryPreserved", false),
			frameScheduled: boolField(value, "frameScheduled", false),
			loadingPending: boolField(value, "loadingPending", false),
			moreAbove: boolField(value, "moreAbove", false),
			moreBelow: boolField(value, "moreBelow", false),
			loadingOlderShown: boolField(value, "loadingOlderShown", false),
			compactFallback: boolField(value, "compactFallback", false),
			keyOnlyFallback: boolField(value, "keyOnlyFallback", false),
			noLiveTerminal: boolField(value, "noLiveTerminal", false),
			noRatatuiRender: boolField(value, "noRatatuiRender", false),
			unsupportedRejected: boolField(value, "unsupportedRejected", false)
		});
	}

	static function fixtureRoot():Value {
		final parsed = CodexJson.parse(File.getContent("fixtures/hxrust/tui-smoke.v1.json"));
		if (!parsed.ok)
			throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		return parsed.value;
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function optionalObjectField(object:Value, name:String):Null<Value> {
		final found = optionalField(object, name);
		if (!found.exists)
			return null;
		return switch found.value {
			case JNull: null;
			case JObject(_, _): found.value;
			case _: null;
		}
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		final found = optionalField(object, name);
		if (!found.exists)
			return fallback;
		return switch found.value {
			case JNull: fallback;
			case JString(text): text;
			case _: fallback;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		final found = optionalField(object, name);
		if (!found.exists)
			return fallback;
		return switch found.value {
			case JNull: fallback;
			case JNumber(number): Std.int(number);
			case _: fallback;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		final found = optionalField(object, name);
		if (!found.exists)
			return fallback;
		return switch found.value {
			case JNull: fallback;
			case JBool(flag): flag;
			case _: fallback;
		}
	}

	static function valueField(object:Value, name:String):Value {
		final found = optionalField(object, name);
		if (found.exists)
			return found.value;
		throw "missing field: " + name;
	}

	static function optionalField(object:Value, name:String):ResumePickerFieldLookup {
		switch object {
			case JObject(keys, values):
				var index = 0;
				while (index < keys.length && index < values.length) {
					if (keys[index] == name)
						return new ResumePickerFieldLookup(true, values[index]);
					index = index + 1;
				}
				return new ResumePickerFieldLookup(false, JNull);
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function assertEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + " expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}
}

class ResumePickerFieldLookup {
	public final exists:Bool;
	public final value:Value;

	public function new(exists:Bool, value:Value) {
		this.exists = exists;
		this.value = value;
	}
}
