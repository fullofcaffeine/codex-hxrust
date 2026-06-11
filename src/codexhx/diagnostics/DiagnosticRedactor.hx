package codexhx.diagnostics;

class DiagnosticRedactor {
    public final secretFields:Array<String>;

    public function new(secretFields:Array<String>) {
        this.secretFields = secretFields;
    }

    public function redact(name:String, value:String):String {
        if (isSecret(name)) return "[redacted]";
        return value;
    }

    public function isSecret(name:String):Bool {
        final lower = name.toLowerCase();
        for (field in secretFields) {
            if (lower == field.toLowerCase()) return true;
        }
        return lower.indexOf("apikey") >= 0
            || lower.indexOf("api_key") >= 0
            || lower.indexOf("token") >= 0
            || lower == "authorization"
            || lower == "secrets";
    }
}
