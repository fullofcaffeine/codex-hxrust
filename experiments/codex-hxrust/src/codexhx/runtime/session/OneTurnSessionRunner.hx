package codexhx.runtime.session;

import codexhx.runtime.model.ModelClient;
import codexhx.runtime.model.ModelStreamEvent;
import codexhx.runtime.model.ModelStreamRequest;
import codexhx.runtime.model.MockModelStreamParser;

class OneTurnSessionRunner {
    public static function run(client:ModelClient, request:ModelStreamRequest):OneTurnSessionOutcome {
        final started = client.startStream(request);
        if (!started.ok) {
            return OneTurnSessionOutcome.failure("", started.errorCode, "$.provider.startStream", started.errorMessage);
        }

        final parsed = MockModelStreamParser.parseSse(started.stream);
        if (!parsed.ok) {
            return OneTurnSessionOutcome.failure(started.handle.streamId, parsed.errorCode, parsed.errorPath, parsed.errorMessage);
        }

        return OneTurnSessionOutcome.success(started.handle.streamId, terminalStateForEvents(parsed.events), parsed.events, parsed.assistantText);
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
