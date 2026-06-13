package codexhx.runtime.app.bootstrap;

import codexhx.protocol.JsonScalar;

class BootstrapClientInfo {
    public final name:String;
    public final hasTitle:Bool;
    public final title:String;
    public final version:String;

    public function new(name:String, hasTitle:Bool, title:String, version:String) {
        this.name = name;
        this.hasTitle = hasTitle;
        this.title = title;
        this.version = version;
    }

    public function validate():BootstrapValidationOutcome {
        if (trim(name).length == 0) return BootstrapValidationOutcome.failure("invalid_client_name", "clientInfo.name must be non-empty");
        if (trim(version).length == 0) return BootstrapValidationOutcome.failure("invalid_client_version", "clientInfo.version must be non-empty");
        if (hasTitle && trim(title).length == 0) return BootstrapValidationOutcome.failure("invalid_client_title", "clientInfo.title must be non-empty when present");
        return BootstrapValidationOutcome.success("client-info");
    }

    public function toJson():String {
        final titleJson = hasTitle ? quote(title) : "null";
        return "{\"name\":" + quote(name) + ",\"title\":" + titleJson + ",\"version\":" + quote(version) + "}";
    }

    static function trim(value:String):String {
        return StringTools.trim(value);
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }
}
