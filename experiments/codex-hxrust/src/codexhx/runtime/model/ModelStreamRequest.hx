package codexhx.runtime.model;

class ModelStreamRequest {
    public final requestId:String;
    public final model:String;
    public final prompt:String;

    public function new(requestId:String, model:String, prompt:String) {
        this.requestId = requestId;
        this.model = model;
        this.prompt = prompt;
    }
}
