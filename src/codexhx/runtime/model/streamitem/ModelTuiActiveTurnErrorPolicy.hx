package codexhx.runtime.model.streamitem;

typedef ModelTuiActiveTurnErrorOutcomeDraft = {
	var request:ModelTuiActiveTurnErrorRequest;
	var decisionKind:ModelTuiActiveTurnErrorDecisionKind;
	var eventOrderingPreserved:Bool;
	var actualTurnId:String;
	var userVisibleMessage:String;
	var sanitizedSessionMessage:String;
	var structuredTurnErrorExtracted:Bool;
	var steerRaceDetected:Bool;
	var interruptRaceDetected:Bool;
	var archivedGuidanceDetected:Bool;
	var shouldClearCachedActiveTurn:Bool;
	var shouldStartNewTurn:Bool;
	var shouldRetryWithActualTurn:Bool;
	var shouldQueueRejectedSteer:Bool;
	var shouldDisplayErrorMessage:Bool;
}

class ModelTuiActiveTurnErrorPolicy {
	static final SteerMismatchPrefix = "expected active turn id `";
	static final SteerMismatchSeparator = "` but found `";
	static final InterruptMismatchPrefix = "expected active turn id ";
	static final InterruptMismatchSeparator = " but found ";
	static final ArchivedGuidanceNeedle = " is archived. Run `codex unarchive ";

	public static function classify(request:ModelTuiActiveTurnErrorRequest):ModelTuiActiveTurnErrorOutcome {
		if (request == null) return failure("", "missing active-turn error request");
		final ordered = request.eventOrderIndex == request.previousEventCount + 1;

		return switch request.requestKind {
			case ActiveTurnNotSteerable:
				classifyNotSteerable(request, ordered);
			case SteerRace:
				classifySteerRace(request, ordered);
			case InterruptRace:
				classifyInterruptRace(request, ordered);
			case SessionStart:
				classifySessionStart(request, ordered);
		}
	}

	static function classifyNotSteerable(
		request:ModelTuiActiveTurnErrorRequest,
		ordered:Bool
	):ModelTuiActiveTurnErrorOutcome {
		final matched = request.method == "turn/steer" && request.hasStructuredTurnError && request.structuredNotSteerable;
		final draft = blankDraft(
			request,
			matched ? ModelTuiActiveTurnErrorDecisionKind.StructuredNotSteerable : ModelTuiActiveTurnErrorDecisionKind.NoMatch,
			ordered
		);
		draft.userVisibleMessage = matched ? request.message : "";
		draft.structuredTurnErrorExtracted = matched;
		draft.shouldQueueRejectedSteer = matched;
		draft.shouldDisplayErrorMessage = matched;
		return success(draft);
	}

	static function classifySteerRace(
		request:ModelTuiActiveTurnErrorRequest,
		ordered:Bool
	):ModelTuiActiveTurnErrorOutcome {
		if (request.method != "turn/steer") return noMatch(request, ordered);
		if (request.message == "no active turn to steer") {
			final draft = blankDraft(request, ModelTuiActiveTurnErrorDecisionKind.SteerMissingActiveTurn, ordered);
			draft.steerRaceDetected = true;
			draft.shouldClearCachedActiveTurn = true;
			draft.shouldStartNewTurn = true;
			return success(draft);
		}
		final actualTurnId = extractBetween(request.message, SteerMismatchPrefix, SteerMismatchSeparator, "`");
		if (actualTurnId.length == 0) return noMatch(request, ordered);
		final draft = blankDraft(request, ModelTuiActiveTurnErrorDecisionKind.SteerExpectedTurnMismatch, ordered);
		draft.actualTurnId = actualTurnId;
		draft.steerRaceDetected = true;
		draft.shouldRetryWithActualTurn = true;
		return success(draft);
	}

	static function classifyInterruptRace(
		request:ModelTuiActiveTurnErrorRequest,
		ordered:Bool
	):ModelTuiActiveTurnErrorOutcome {
		if (request.method != "turn/interrupt") return noMatch(request, ordered);
		final actualTurnId = extractAfter(request.message, InterruptMismatchPrefix, InterruptMismatchSeparator);
		if (actualTurnId.length == 0) return noMatch(request, ordered);
		final draft = blankDraft(request, ModelTuiActiveTurnErrorDecisionKind.InterruptExpectedTurnMismatch, ordered);
		draft.actualTurnId = actualTurnId;
		draft.interruptRaceDetected = true;
		draft.shouldRetryWithActualTurn = true;
		return success(draft);
	}

	static function classifySessionStart(
		request:ModelTuiActiveTurnErrorRequest,
		ordered:Bool
	):ModelTuiActiveTurnErrorOutcome {
		final guidance = archivedSessionGuidance(request.message);
		final matched = guidance.length > 0;
		final draft = blankDraft(
			request,
			matched ? ModelTuiActiveTurnErrorDecisionKind.ArchivedSessionGuidance : ModelTuiActiveTurnErrorDecisionKind.NoMatch,
			ordered
		);
		draft.sanitizedSessionMessage = guidance;
		draft.archivedGuidanceDetected = matched;
		draft.shouldDisplayErrorMessage = matched;
		return success(draft);
	}

	static function noMatch(request:ModelTuiActiveTurnErrorRequest, ordered:Bool):ModelTuiActiveTurnErrorOutcome {
		return success(blankDraft(request, ModelTuiActiveTurnErrorDecisionKind.NoMatch, ordered));
	}

	static function blankDraft(
		request:ModelTuiActiveTurnErrorRequest,
		decisionKind:ModelTuiActiveTurnErrorDecisionKind,
		eventOrderingPreserved:Bool
	):ModelTuiActiveTurnErrorOutcomeDraft {
		return {
			request: request,
			decisionKind: decisionKind,
			eventOrderingPreserved: eventOrderingPreserved,
			actualTurnId: "",
			userVisibleMessage: "",
			sanitizedSessionMessage: "",
			structuredTurnErrorExtracted: false,
			steerRaceDetected: false,
			interruptRaceDetected: false,
			archivedGuidanceDetected: false,
			shouldClearCachedActiveTurn: false,
			shouldStartNewTurn: false,
			shouldRetryWithActualTurn: false,
			shouldQueueRejectedSteer: false,
			shouldDisplayErrorMessage: false
		};
	}

	static function success(draft:ModelTuiActiveTurnErrorOutcomeDraft):ModelTuiActiveTurnErrorOutcome {
		final request = draft.request;
		return new ModelTuiActiveTurnErrorOutcome({
			ok: true,
			code: "tui_active_turn_error_classified",
			requestId: request.requestId,
			requestKind: request.requestKind,
			decisionKind: draft.decisionKind,
			method: request.method,
			turnKind: draft.structuredTurnErrorExtracted ? request.turnKind : ModelTuiActiveTurnErrorTurnKind.None,
			userVisibleMessage: draft.userVisibleMessage,
			sanitizedSessionMessage: draft.sanitizedSessionMessage,
			actualTurnId: draft.actualTurnId,
			structuredTurnErrorExtracted: draft.structuredTurnErrorExtracted,
			steerRaceDetected: draft.steerRaceDetected,
			interruptRaceDetected: draft.interruptRaceDetected,
			archivedGuidanceDetected: draft.archivedGuidanceDetected,
			shouldClearCachedActiveTurn: draft.shouldClearCachedActiveTurn,
			shouldStartNewTurn: draft.shouldStartNewTurn,
			shouldRetryWithActualTurn: draft.shouldRetryWithActualTurn,
			shouldQueueRejectedSteer: draft.shouldQueueRejectedSteer,
			shouldDisplayErrorMessage: draft.shouldDisplayErrorMessage,
			rolloutPathLeaked: containsNonEmpty(draft.sanitizedSessionMessage, request.targetRolloutPath),
			eventOrderingPreserved: draft.eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ""
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelTuiActiveTurnErrorOutcome {
		return new ModelTuiActiveTurnErrorOutcome({
			ok: false,
			code: "tui_active_turn_error_failed",
			requestId: requestId,
			requestKind: ModelTuiActiveTurnErrorRequestKind.SteerRace,
			decisionKind: ModelTuiActiveTurnErrorDecisionKind.NoMatch,
			method: "",
			turnKind: ModelTuiActiveTurnErrorTurnKind.None,
			userVisibleMessage: "",
			sanitizedSessionMessage: "",
			actualTurnId: "",
			structuredTurnErrorExtracted: false,
			steerRaceDetected: false,
			interruptRaceDetected: false,
			archivedGuidanceDetected: false,
			shouldClearCachedActiveTurn: false,
			shouldStartNewTurn: false,
			shouldRetryWithActualTurn: false,
			shouldQueueRejectedSteer: false,
			shouldDisplayErrorMessage: false,
			rolloutPathLeaked: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}

	static function archivedSessionGuidance(message:String):String {
		final start = message.indexOf("session ");
		if (start < 0) return "";
		final candidate = message.substr(start);
		if (candidate.indexOf(ArchivedGuidanceNeedle) < 0) return "";
		final codeIndex = candidate.indexOf(" (code ");
		return codeIndex < 0 ? candidate : candidate.substr(0, codeIndex);
	}

	static function extractBetween(message:String, prefix:String, separator:String, suffix:String):String {
		if (!startsWith(message, prefix)) return "";
		final rest = message.substr(prefix.length);
		final separatorIndex = rest.indexOf(separator);
		if (separatorIndex < 0) return "";
		final value = rest.substr(separatorIndex + separator.length);
		if (suffix.length > 0 && !endsWith(value, suffix)) return "";
		return suffix.length > 0 ? value.substr(0, value.length - suffix.length) : value;
	}

	static function extractAfter(message:String, prefix:String, separator:String):String {
		if (!startsWith(message, prefix)) return "";
		final rest = message.substr(prefix.length);
		final separatorIndex = rest.indexOf(separator);
		if (separatorIndex < 0) return "";
		return rest.substr(separatorIndex + separator.length);
	}

	static function startsWith(value:String, prefix:String):Bool {
		return value.length >= prefix.length && value.substr(0, prefix.length) == prefix;
	}

	static function endsWith(value:String, suffix:String):Bool {
		return value.length >= suffix.length && value.substr(value.length - suffix.length) == suffix;
	}

	static function containsNonEmpty(value:String, needle:String):Bool {
		return needle != null && needle.length > 0 && value.indexOf(needle) >= 0;
	}
}
