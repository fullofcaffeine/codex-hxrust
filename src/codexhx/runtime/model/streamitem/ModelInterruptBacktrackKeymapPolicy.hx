package codexhx.runtime.model.streamitem;

class ModelInterruptBacktrackKeymapPolicy {
	static final EscBinding = "esc";
	static final F12Binding = "f12";
	static final CtrlVBinding = "ctrl-v";
	static final ChatInterruptTurnName = "chat.interrupt_turn";
	static final FixedPasteImageName = "fixed.paste_image";

	public static function apply(request:ModelInterruptBacktrackKeymapRequest):ModelInterruptBacktrackKeymapOutcome {
		if (request == null)
			return failure("", "missing interrupt/backtrack keymap request");

		final defaultEscInterruptPreserved = request.defaultInterruptBinding == EscBinding;
		final fixedBacktrackEscPreserved = request.fixedBacktrackBinding == EscBinding;
		final backtrackOverlapAllowed = defaultEscInterruptPreserved && fixedBacktrackEscPreserved;
		final remapToF12Accepted = request.remappedInterruptBinding == F12Binding;
		final unbindAccepted = request.unboundInterruptCount == 0;
		final otherFixedShortcutRejected = request.conflictingInterruptBinding == request.fixedPasteImageBinding
			&& request.fixedPasteImageBinding == CtrlVBinding;
		final conflictActionNamePreserved = otherFixedShortcutRejected
			&& request.conflictOuterAction == ModelInterruptBacktrackFixedShortcutActionKind.ChatInterruptTurn
			&& request.conflictInnerAction == ModelInterruptBacktrackFixedShortcutActionKind.FixedPasteImage
			&& request.expectedOuterActionName == ChatInterruptTurnName
			&& request.expectedInnerActionName == FixedPasteImageName;
		final dispatchGatingDeferredToHandler = backtrackOverlapAllowed;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final ok = backtrackOverlapAllowed && remapToF12Accepted && unbindAccepted && otherFixedShortcutRejected && conflictActionNamePreserved
			&& dispatchGatingDeferredToHandler && eventOrderingPreserved;
		final decisionKind = ok ? ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapAccepted : ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapRejected;

		return new ModelInterruptBacktrackKeymapOutcome({
			ok: ok,
			code: ok ? "interrupt_backtrack_keymap_modeled" : "interrupt_backtrack_keymap_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			defaultEscInterruptPreserved: defaultEscInterruptPreserved,
			fixedBacktrackEscPreserved: fixedBacktrackEscPreserved,
			backtrackOverlapAllowed: backtrackOverlapAllowed,
			remapToF12Accepted: remapToF12Accepted,
			unbindAccepted: unbindAccepted,
			otherFixedShortcutRejected: otherFixedShortcutRejected,
			conflictActionNamePreserved: conflictActionNamePreserved,
			dispatchGatingDeferredToHandler: dispatchGatingDeferredToHandler,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "interrupt/backtrack keymap invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelInterruptBacktrackKeymapOutcome {
		return new ModelInterruptBacktrackKeymapOutcome({
			ok: false,
			code: "interrupt_backtrack_keymap_failed",
			requestId: requestId,
			decisionKind: ModelInterruptBacktrackKeymapDecisionKind.InterruptBacktrackKeymapRejected,
			defaultEscInterruptPreserved: false,
			fixedBacktrackEscPreserved: false,
			backtrackOverlapAllowed: false,
			remapToF12Accepted: false,
			unbindAccepted: false,
			otherFixedShortcutRejected: false,
			conflictActionNamePreserved: false,
			dispatchGatingDeferredToHandler: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
