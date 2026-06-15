package codexhx.runtime.model.streamitem;

class ModelInterruptQuestionNavigationKeymapPolicy {
	static final InterruptActionName = "chat.interrupt_turn";
	static final QuestionNavigationActionName = "list.move_right";
	static final FixedBacktrackActionName = "fixed.backtrack";
	static final EscBinding = "esc";
	static final F12Binding = "f12";

	public static function apply(request:ModelInterruptQuestionNavigationKeymapRequest):ModelInterruptQuestionNavigationKeymapOutcome {
		if (request == null) return failure("", "missing interrupt/question-navigation keymap request");

		final interruptActionNamePreserved = request.interruptActionName == InterruptActionName;
		final questionNavigationActionNamePreserved = request.questionNavigationActionName == QuestionNavigationActionName;
		final interruptRemapAcceptedBeforeValidation = request.interruptBinding == F12Binding;
		final questionNavigationBindingPreserved = request.questionNavigationBinding == F12Binding;
		final conflictingBindingDetected = request.interruptBinding == request.questionNavigationBinding && request.interruptBinding != "";
		final fixedBacktrackOverlapStillAllowed = request.fixedBacktrackActionName == FixedBacktrackActionName
			&& request.fixedBacktrackBinding == EscBinding
			&& request.allowedOverlapBinding == EscBinding;
		final conflictRejected = interruptActionNamePreserved
			&& questionNavigationActionNamePreserved
			&& conflictingBindingDetected;
		final noFalseBacktrackConflict = fixedBacktrackOverlapStillAllowed
			&& request.interruptBinding != request.fixedBacktrackBinding;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = interruptActionNamePreserved
			&& questionNavigationActionNamePreserved
			&& interruptRemapAcceptedBeforeValidation
			&& questionNavigationBindingPreserved
			&& conflictingBindingDetected
			&& fixedBacktrackOverlapStillAllowed
			&& conflictRejected
			&& noFalseBacktrackConflict
			&& eventOrderingPreserved;
		final decisionKind = ok
			? ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictRejected
			: ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictMissed;

		return new ModelInterruptQuestionNavigationKeymapOutcome({
			ok: ok,
			code: ok ? "interrupt_question_navigation_keymap_conflict_modeled" : "interrupt_question_navigation_keymap_conflict_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			interruptActionNamePreserved: interruptActionNamePreserved,
			questionNavigationActionNamePreserved: questionNavigationActionNamePreserved,
			interruptRemapAcceptedBeforeValidation: interruptRemapAcceptedBeforeValidation,
			questionNavigationBindingPreserved: questionNavigationBindingPreserved,
			conflictingBindingDetected: conflictingBindingDetected,
			fixedBacktrackOverlapStillAllowed: fixedBacktrackOverlapStillAllowed,
			conflictRejected: conflictRejected,
			noFalseBacktrackConflict: noFalseBacktrackConflict,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "interrupt/question-navigation keymap conflict was not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelInterruptQuestionNavigationKeymapOutcome {
		return new ModelInterruptQuestionNavigationKeymapOutcome({
			ok: false,
			code: "interrupt_question_navigation_keymap_conflict_failed",
			requestId: requestId,
			decisionKind: ModelInterruptQuestionNavigationKeymapDecisionKind.InterruptQuestionNavigationConflictMissed,
			interruptActionNamePreserved: false,
			questionNavigationActionNamePreserved: false,
			interruptRemapAcceptedBeforeValidation: false,
			questionNavigationBindingPreserved: false,
			conflictingBindingDetected: false,
			fixedBacktrackOverlapStillAllowed: false,
			conflictRejected: false,
			noFalseBacktrackConflict: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
