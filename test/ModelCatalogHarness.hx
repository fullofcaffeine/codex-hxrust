import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.model.admission.ProviderAdmissionAccountKind;
import codexhx.runtime.model.admission.ProviderAdmissionCredentialKind;
import codexhx.runtime.model.admission.ProviderAdmissionModel;
import codexhx.runtime.model.admission.ProviderAdmissionNetworkKind;
import codexhx.runtime.model.admission.ProviderAdmissionProvider;
import codexhx.runtime.model.admission.ProviderAdmissionRequest;
import codexhx.runtime.model.catalog.ModelCatalogEntry;
import codexhx.runtime.model.catalog.ModelCatalogPolicy;
import codexhx.runtime.model.catalog.ModelCatalogRefreshStrategy;
import codexhx.runtime.model.catalog.ModelCatalogReport;
import codexhx.runtime.model.catalog.ModelCatalogRequest;
import codexhx.runtime.model.catalog.ModelCatalogToolMode;
import codexhx.runtime.model.catalog.ModelCatalogVisibility;
import codexhx.runtime.model.catalog.ModelCatalogWebSearchToolType;
import haxe.json.Value;
import sys.io.File;

class ModelCatalogHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ModelCatalogPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final request = objectField(objectValue(cases[i]), "request");
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			final secretProbe = stringField(expect, "secretProbe", "");
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "requestId", ""), outcome.requestId);
			assertEquals(stringField(expect, "providerId", ""), outcome.providerId);
			assertEquals(stringField(expect, "admissionCode", ""), outcome.admissionCode);
			assertEquals(stringField(expect, "catalogSource", ""), outcome.catalogSource);
			assertEquals(stringField(expect, "refreshStrategy", ""), outcome.refreshStrategy);
			assertEquals(boolText(boolField(expect, "liveFetchAttempted", false)), boolText(outcome.liveFetchAttempted));
			assertEquals(stringField(expect, "selectedModelId", ""), outcome.selectedModelId);
			assertEquals(boolText(boolField(expect, "selectedHidden", false)), boolText(outcome.selectedHidden));
			assertEquals(stringField(expect, "defaultModelId", ""), outcome.defaultModelId);
			assertEquals(Std.string(intField(expect, "catalogCount", 0)), Std.string(outcome.catalogCount));
			assertEquals(Std.string(intField(expect, "providerModelCount", 0)), Std.string(outcome.providerModelCount));
			assertEquals(Std.string(intField(expect, "visibleCount", 0)), Std.string(outcome.visibleCount));
			assertEquals(Std.string(intField(expect, "hiddenCount", 0)), Std.string(outcome.hiddenCount));
			assertEquals(Std.string(intField(expect, "apiFilteredCount", 0)), Std.string(outcome.apiFilteredCount));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			if (secretProbe.length > 0)
				assertNotContains(outcome.summary(), secretProbe);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ModelCatalogRequest> {
		final out:Array<ModelCatalogRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ModelCatalogRequest(stringField(request, "requestId", ""), admissionRequest(objectField(request, "admission")),
				stringField(request, "catalogSource", ""), refreshStrategy(stringField(request, "refreshStrategy", "")),
				boolField(request, "includeHidden", false), boolField(request, "allowLiveFetch", false), boolField(request, "usesCodexBackend", false),
				stringField(request, "requestedModelId", ""), catalog(arrayField(request, "catalog"))));
		}
		return out;
	}

	static function admissionRequest(request:Value):ProviderAdmissionRequest {
		return new ProviderAdmissionRequest(stringField(request, "requestId", ""), providerValue(objectField(request, "provider")),
			modelValue(objectField(request, "model")), credentialKind(stringField(request, "credentialKind", "")),
			accountKind(stringField(request, "accountKind", "")), networkKind(stringField(request, "networkKind", "")),
			boolField(request, "liveNetworkAllowed", false), boolField(request, "hasCredentialMaterial", false), stringField(request, "secretProbe", ""));
	}

	static function providerValue(value:Value):ProviderAdmissionProvider {
		return new ProviderAdmissionProvider(stringField(value, "providerId", ""), stringField(value, "name", ""), boolField(value, "hasBaseUrl", false),
			stringField(value, "baseUrl", ""), boolField(value, "envKeyConfigured", false), boolField(value, "envKeyPresent", false),
			boolField(value, "envKeyInstructionsPresent", false), boolField(value, "requiresOpenAiAuth", false),
			boolField(value, "supportsWebsockets", false), boolField(value, "hasAwsAuth", false), boolField(value, "hasCommandAuth", false),
			boolField(value, "experimentalBearerTokenPresent", false));
	}

	static function modelValue(value:Value):ProviderAdmissionModel {
		return new ProviderAdmissionModel(stringField(value, "modelId", ""), stringField(value, "providerId", ""), intField(value, "contextWindow", 0));
	}

	static function catalog(values:Array<Value>):Array<ModelCatalogEntry> {
		final out:Array<ModelCatalogEntry> = [];
		for (value in values) {
			final model = objectValue(value);
			out.push(new ModelCatalogEntry(stringField(model, "modelId", ""), stringField(model, "providerId", ""), stringField(model, "displayName", ""),
				intField(model, "priority", 0), visibility(stringField(model, "visibility", "")), boolField(model, "supportedInApi", false),
				intField(model, "contextWindow", 0), intField(model, "maxContextWindow", 0), boolField(model, "supportsSearchTool", false),
				webSearchToolType(stringField(model, "webSearchToolType", "")), toolMode(stringField(model, "toolMode", "")),
				stringArrayField(model, "inputModalities"), stringArrayField(model, "serviceTiers"), stringField(model, "defaultServiceTier", ""),
				stringArrayField(model, "additionalSpeedTiers"), stringArrayField(model, "experimentalSupportedTools"), false));
		}
		return out;
	}

	static function credentialKind(value:String):ProviderAdmissionCredentialKind {
		return switch value {
			case "none": ProviderAdmissionCredentialKind.None;
			case "no_credential_test": ProviderAdmissionCredentialKind.NoCredentialTest;
			case "openai_auth": ProviderAdmissionCredentialKind.OpenAiAuth;
			case "provider_env": ProviderAdmissionCredentialKind.ProviderEnv;
			case "aws": ProviderAdmissionCredentialKind.Aws;
			case _: throw "invalid credential kind: " + value;
		}
	}

	static function accountKind(value:String):ProviderAdmissionAccountKind {
		return switch value {
			case "none": ProviderAdmissionAccountKind.None;
			case "api_key": ProviderAdmissionAccountKind.ApiKey;
			case "chatgpt": ProviderAdmissionAccountKind.Chatgpt;
			case "agent_identity": ProviderAdmissionAccountKind.AgentIdentity;
			case "personal_access_token": ProviderAdmissionAccountKind.PersonalAccessToken;
			case "amazon_bedrock": ProviderAdmissionAccountKind.AmazonBedrock;
			case _: throw "invalid account kind: " + value;
		}
	}

	static function networkKind(value:String):ProviderAdmissionNetworkKind {
		return switch value {
			case "fixture_only": ProviderAdmissionNetworkKind.FixtureOnly;
			case "live_network": ProviderAdmissionNetworkKind.LiveNetwork;
			case _: throw "invalid network kind: " + value;
		}
	}

	static function refreshStrategy(value:String):ModelCatalogRefreshStrategy {
		return switch value {
			case "offline": ModelCatalogRefreshStrategy.Offline;
			case "online": ModelCatalogRefreshStrategy.Online;
			case "online_if_uncached": ModelCatalogRefreshStrategy.OnlineIfUncached;
			case _: throw "invalid refresh strategy: " + value;
		}
	}

	static function visibility(value:String):ModelCatalogVisibility {
		return switch value {
			case "list": ModelCatalogVisibility.List;
			case "hide": ModelCatalogVisibility.Hide;
			case "none": ModelCatalogVisibility.None;
			case _: throw "invalid model visibility: " + value;
		}
	}

	static function webSearchToolType(value:String):ModelCatalogWebSearchToolType {
		return switch value {
			case "text": ModelCatalogWebSearchToolType.Text;
			case "text_and_image": ModelCatalogWebSearchToolType.TextAndImage;
			case _: throw "invalid web search tool type: " + value;
		}
	}

	static function toolMode(value:String):ModelCatalogToolMode {
		return switch value {
			case "none": ModelCatalogToolMode.None;
			case "direct": ModelCatalogToolMode.Direct;
			case "code_mode": ModelCatalogToolMode.CodeMode;
			case "code_mode_only": ModelCatalogToolMode.CodeModeOnly;
			case _: throw "invalid tool mode: " + value;
		}
	}

	static function assertReport(root:Value, report:ModelCatalogReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "hiddenDeniedCount", 0)), Std.string(report.hiddenDeniedCount()));
		assertEquals(Std.string(intField(expect, "liveFetchDeniedCount", 0)), Std.string(report.liveFetchDeniedCount()));
		assertEquals(Std.string(intField(expect, "apiFilteredCount", 0)), Std.string(report.apiFilteredCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/model-catalog.v1.json")));
	}

	static function objectField(object:Value, name:String):Value {
		return objectValue(valueField(object, name));
	}

	static function arrayField(object:Value, name:String):Array<Value> {
		return switch valueField(object, name) {
			case JArray(values): values;
			case _: throw "expected array field: " + name;
		}
	}

	static function stringArrayField(object:Value, name:String):Array<String> {
		final out:Array<String> = [];
		for (value in arrayField(object, name)) {
			switch value {
				case JString(text):
					out.push(text);
				case _:
					throw "expected string array field: " + name;
			}
		}
		return out;
	}

	static function stringField(object:Value, name:String, fallback:String):String {
		return switch optionalField(object, name) {
			case JString(value): value;
			case JNull: fallback;
			case _: throw "expected string field: " + name;
		}
	}

	static function intField(object:Value, name:String, fallback:Int):Int {
		return switch optionalField(object, name) {
			case JNumber(value): Std.int(value);
			case JNull: fallback;
			case _: throw "expected int field: " + name;
		}
	}

	static function boolField(object:Value, name:String, fallback:Bool):Bool {
		return switch optionalField(object, name) {
			case JBool(value): value;
			case JNull: fallback;
			case _: throw "expected bool field: " + name;
		}
	}

	static function valueField(object:Value, name:String):Value {
		return optionalField(object, name);
	}

	static function optionalField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length && i < values.length) {
					if (keys[i] == name)
						return values[i];
					i = i + 1;
				}
				JNull;
			case _:
				throw "expected object while reading field: " + name;
		}
	}

	static function objectValue(value:Value):Value {
		return switch value {
			case JObject(_, _): value;
			case _: throw "expected object";
		}
	}

	static function expectParse(outcome:JsonParseOutcome):Value {
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}

	static function assertNotContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) >= 0)
			throw "did not expect to find secret probe in summary";
	}
}
