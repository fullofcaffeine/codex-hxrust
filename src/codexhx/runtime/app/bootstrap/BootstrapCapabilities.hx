package codexhx.runtime.app.bootstrap;

import codexhx.protocol.JsonScalar;

class BootstrapCapabilities {
    public final experimentalApi:Bool;
    public final requestAttestation:Bool;
    public final optOutNotificationMethods:Array<String>;

    public function new(experimentalApi:Bool, requestAttestation:Bool, optOutNotificationMethods:Array<String>) {
        this.experimentalApi = experimentalApi;
        this.requestAttestation = requestAttestation;
        this.optOutNotificationMethods = copyStrings(optOutNotificationMethods);
    }

    public function validate():BootstrapValidationOutcome {
        final seen:Array<String> = [];
        for (method in optOutNotificationMethods) {
            if (StringTools.trim(method).length == 0) {
                return BootstrapValidationOutcome.failure("invalid_opt_out_notification", "opt-out notification methods must be non-empty");
            }
            if (method.indexOf("/") < 0) {
                return BootstrapValidationOutcome.failure("invalid_opt_out_notification", "opt-out notification method must use an exact app-server method name");
            }
            if (contains(seen, method)) {
                return BootstrapValidationOutcome.failure("duplicate_opt_out_notification", "duplicate opt-out notification method");
            }
            seen.push(method);
        }
        return BootstrapValidationOutcome.success("capabilities");
    }

    public function toJson():String {
        return "{\"experimentalApi\":" + boolJson(experimentalApi)
            + ",\"optOutNotificationMethods\":" + stringArrayJson(optOutNotificationMethods)
            + ",\"requestAttestation\":" + boolJson(requestAttestation) + "}";
    }

    static function copyStrings(values:Array<String>):Array<String> {
        final out:Array<String> = [];
        for (value in values) {
            out.push(value);
        }
        return out;
    }

    static function contains(values:Array<String>, needle:String):Bool {
        for (value in values) {
            if (value == needle) return true;
        }
        return false;
    }

    static function stringArrayJson(values:Array<String>):String {
        if (values.length == 0) return "null";
        final parts:Array<String> = [];
        for (value in values) {
            parts.push(JsonScalar.quote(value));
        }
        return "[" + parts.join(",") + "]";
    }

    static function boolJson(value:Bool):String {
        return value ? "true" : "false";
    }
}
