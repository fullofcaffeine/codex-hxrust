package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;

class CafNativeLiveStatus {
    public static inline final schema = "cafetera.codex.native-live-status.v1";

    public final model:String;
    public final reasoning:String;
    public final mode:String;
    public final observedAt:String;
    public final source:String;

    public function new(model:String, reasoning:String, mode:String, observedAt:String, source:String) {
        this.model = model;
        this.reasoning = reasoning;
        this.mode = mode;
        this.observedAt = observedAt;
        this.source = source;
    }

    public function json(indent:String):String {
        return "{\n"
            + indent + "  \"schema\": " + quote(schema) + ",\n"
            + indent + "  \"model\": " + quote(model) + ",\n"
            + indent + "  \"reasoning\": " + quote(reasoning) + ",\n"
            + indent + "  \"mode\": " + quote(mode) + ",\n"
            + indent + "  \"observedAt\": " + quote(observedAt) + ",\n"
            + indent + "  \"authority\": \"codex_native_runtime_witness\",\n"
            + indent + "  \"source\": " + quote(source) + "\n"
            + indent + "}";
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }
}
