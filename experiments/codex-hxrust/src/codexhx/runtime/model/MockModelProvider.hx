package codexhx.runtime.model;

import sys.io.File;

class MockModelProvider implements ModelClient {
    static inline final providerName = "mock";

    final fixturePath:String;
    final activeStreams:Array<String>;
    var nextStreamNumber:Int;

    public function new(fixturePath:String) {
        this.fixturePath = fixturePath;
        this.activeStreams = [];
        this.nextStreamNumber = 1;
    }

    public function startStream(request:ModelStreamRequest):ModelStreamStartOutcome {
        if (request == null) {
            return ModelStreamStartOutcome.failure("missing_request", "model stream request is required");
        }
        if (request.requestId.length == 0) {
            return ModelStreamStartOutcome.failure("missing_request_id", "model stream request id is required");
        }

        final streamId = "mock-stream-" + Std.string(nextStreamNumber);
        nextStreamNumber = nextStreamNumber + 1;
        activeStreams.push(streamId);
        final handle = new ModelStreamHandle(providerName, streamId, request.requestId);
        return ModelStreamStartOutcome.success(handle, File.getContent(fixturePath));
    }

    public function cancelStream(handle:ModelStreamHandle):ModelStreamCancelOutcome {
        if (handle == null) {
            return ModelStreamCancelOutcome.failure("", "missing_handle", "model stream handle is required");
        }
        if (handle.provider != providerName) {
            return ModelStreamCancelOutcome.failure(handle.streamId, "provider_mismatch", "model stream handle belongs to a different provider");
        }

        final index = activeStreamIndex(handle.streamId);
        if (index < 0) {
            return ModelStreamCancelOutcome.failure(handle.streamId, "stream_not_active", "model stream is not active");
        }

        activeStreams.splice(index, 1);
        return ModelStreamCancelOutcome.success(handle.streamId);
    }

    function activeStreamIndex(streamId:String):Int {
        var i = 0;
        while (i < activeStreams.length) {
            if (activeStreams[i] == streamId) return i;
            i = i + 1;
        }
        return -1;
    }
}
