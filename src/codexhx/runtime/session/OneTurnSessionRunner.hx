package codexhx.runtime.session;

import codexhx.runtime.model.ModelClient;
import codexhx.runtime.model.ModelStreamEvent;
import codexhx.runtime.model.ModelStreamHandle;
import codexhx.runtime.model.ModelStreamRequest;
import codexhx.runtime.model.MockModelStreamParser;

class OneTurnSessionRunner {
    public static function run(client:ModelClient, request:ModelStreamRequest):OneTurnSessionOutcome {
        return runWithInterrupt(client, request, OneTurnInterruptPolicy.never());
    }

    public static function runWithInterrupt(client:ModelClient, request:ModelStreamRequest, interrupt:OneTurnInterruptPolicy):OneTurnSessionOutcome {
        if (interrupt.cancelBeforeStart) {
            return OneTurnSessionOutcome.cancelled("", [], "");
        }

        final started = client.startStream(request);
        if (!started.ok) {
            return OneTurnSessionOutcome.failure("", started.errorCode, "$.provider.startStream", started.errorMessage);
        }

        if (interrupt.shouldCancelAfterEvents(0)) {
            return cancelAtCheckpoint(client, started.handle, [], "");
        }

        if (interrupt.cancelAfterEvents >= 0) {
            final partial = MockModelStreamParser.parseSsePrefix(started.stream, interrupt.cancelAfterEvents);
            if (!partial.ok) {
                return OneTurnSessionOutcome.failure(started.handle.streamId, partial.errorCode, partial.errorPath, partial.errorMessage);
            }
            if (interrupt.shouldCancelAfterEvents(partial.events.length)) {
                return cancelAtCheckpoint(client, started.handle, partial.events, partial.assistantText);
            }
            return OneTurnSessionOutcome.success(started.handle.streamId, terminalStateForEvents(partial.events), partial.events, partial.assistantText);
        }

        final parsed = MockModelStreamParser.parseSse(started.stream);
        if (!parsed.ok) {
            return OneTurnSessionOutcome.failure(started.handle.streamId, parsed.errorCode, parsed.errorPath, parsed.errorMessage);
        }

        return OneTurnSessionOutcome.success(started.handle.streamId, terminalStateForEvents(parsed.events), parsed.events, parsed.assistantText);
    }

    static function cancelAtCheckpoint(client:ModelClient, handle:ModelStreamHandle, events:Array<ModelStreamEvent>, assistantText:String):OneTurnSessionOutcome {
        final cancelled = client.cancelStream(handle);
        if (!cancelled.ok) {
            return OneTurnSessionOutcome.failure(handle.streamId, cancelled.errorCode, "$.provider.cancelStream", cancelled.errorMessage);
        }
        return OneTurnSessionOutcome.cancelled(handle.streamId, events, assistantText);
    }

    static function terminalStateForEvents(events:Array<ModelStreamEvent>):String {
        var sawFailure = false;
        var sawCompleted = false;
        for (event in events) {
            if (event.kind == "response_failed") sawFailure = true;
            if (event.kind == "response_completed") sawCompleted = true;
        }
        if (sawFailure) return "failed";
        if (sawCompleted) return "completed";
        return "incomplete";
    }
}
