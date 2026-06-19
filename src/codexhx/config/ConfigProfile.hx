package codexhx.config;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;

class ConfigProfile {
	public final schema:String;
	public final profileName:String;
	public final model:String;
	public final modelProviderId:String;
	public final reasoningEffort:String;
	public final approvalPolicy:String;
	public final sandboxMode:String;
	public final webSearchEnabled:Bool;
	public final imageGenerationEnabled:Bool;
	public final developerInstructions:String;
	public final writableRoots:Array<String>;
	public final unsupportedFields:Array<String>;
	public final secretsPresent:Bool;

	public function new(schema:String, profileName:String, model:String, modelProviderId:String, reasoningEffort:String, approvalPolicy:String,
			sandboxMode:String, webSearchEnabled:Bool, imageGenerationEnabled:Bool, developerInstructions:String, writableRoots:Array<String>,
			unsupportedFields:Array<String>, secretsPresent:Bool) {
		this.schema = schema;
		this.profileName = profileName;
		this.model = model;
		this.modelProviderId = modelProviderId;
		this.reasoningEffort = reasoningEffort;
		this.approvalPolicy = approvalPolicy;
		this.sandboxMode = sandboxMode;
		this.webSearchEnabled = webSearchEnabled;
		this.imageGenerationEnabled = imageGenerationEnabled;
		this.developerInstructions = developerInstructions;
		this.writableRoots = writableRoots;
		this.unsupportedFields = unsupportedFields;
		this.secretsPresent = secretsPresent;
	}

	public static function empty():ConfigProfile {
		return new ConfigProfile("", "", "", "", "", "", "", false, false, "", [], [], false);
	}

	public function diagnosticJson():String {
		final parts:Array<String> = [];
		parts.push(pair("schema", schema));
		parts.push(pair("profileName", profileName));
		parts.push(pair("model", model));
		parts.push(pair("modelProviderId", modelProviderId));
		parts.push(pair("reasoningEffort", reasoningEffort));
		parts.push(pair("approvalPolicy", approvalPolicy));
		parts.push(pair("sandboxMode", sandboxMode));
		parts.push(boolPair("webSearchEnabled", webSearchEnabled));
		parts.push(boolPair("imageGenerationEnabled", imageGenerationEnabled));
		parts.push(boolPair("secretsPresent", secretsPresent));
		parts.push("\"secretPreview\":\"[redacted]\"");
		parts.push("\"writableRoots\":" + stringArray(writableRoots));
		parts.push("\"unsupportedFields\":" + stringArray(unsupportedFields));
		return "{" + parts.join(",") + "}";
	}

	static function pair(key:String, value:String):String {
		return JsonScalar.quote(key) + ":" + JsonScalar.quote(value);
	}

	static function boolPair(key:String, value:Bool):String {
		return JsonScalar.quote(key) + ":" + (if (value) "true" else "false");
	}

	static function stringArray(values:Array<String>):String {
		final encoded:Array<String> = [];
		for (value in values) {
			encoded.push(CodexJson.quote(value));
		}
		return "[" + encoded.join(",") + "]";
	}
}
