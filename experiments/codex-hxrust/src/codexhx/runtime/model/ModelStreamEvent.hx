package codexhx.runtime.model;

import codexhx.protocol.JsonScalar;

class ModelStreamEvent {
    public final kind:String;
    public final responseId:String;
    public final itemId:String;
    public final text:String;
    public final errorCode:String;
    public final errorMessage:String;
    public final totalTokens:Int;

    public function new(kind:String, responseId:String, itemId:String, text:String, errorCode:String, errorMessage:String, totalTokens:Int) {
        this.kind = kind;
        this.responseId = responseId;
        this.itemId = itemId;
        this.text = text;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
        this.totalTokens = totalTokens;
    }

    public function canonicalJson():String {
        return "{"
            + "\"errorCode\":" + JsonScalar.quote(errorCode)
            + ",\"errorMessage\":" + JsonScalar.quote(errorMessage)
            + ",\"itemId\":" + JsonScalar.quote(itemId)
            + ",\"kind\":" + JsonScalar.quote(kind)
            + ",\"responseId\":" + JsonScalar.quote(responseId)
            + ",\"text\":" + JsonScalar.quote(text)
            + ",\"totalTokens\":" + Std.string(totalTokens)
            + "}";
    }
}
