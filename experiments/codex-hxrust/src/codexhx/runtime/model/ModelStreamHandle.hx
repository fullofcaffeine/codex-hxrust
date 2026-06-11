package codexhx.runtime.model;

class ModelStreamHandle {
    public final provider:String;
    public final streamId:String;
    public final requestId:String;

    public function new(provider:String, streamId:String, requestId:String) {
        this.provider = provider;
        this.streamId = streamId;
        this.requestId = requestId;
    }
}
