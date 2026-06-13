import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.model.admission.ProviderAdmissionAccountKind;
import codexhx.runtime.model.admission.ProviderAdmissionCredentialKind;
import codexhx.runtime.model.admission.ProviderAdmissionModel;
import codexhx.runtime.model.admission.ProviderAdmissionNetworkKind;
import codexhx.runtime.model.admission.ProviderAdmissionPolicy;
import codexhx.runtime.model.admission.ProviderAdmissionProvider;
import codexhx.runtime.model.admission.ProviderAdmissionReport;
import codexhx.runtime.model.admission.ProviderAdmissionRequest;
import haxe.json.Value;
import sys.io.File;

class ProviderAdmissionHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ProviderAdmissionPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final request = objectField(objectValue(cases[i]), "request");
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			final secretProbe = stringField(request, "secretProbe", "");
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "requestId", ""), outcome.requestId);
			assertEquals(stringField(expect, "providerId", ""), outcome.providerId);
			assertEquals(stringField(expect, "modelId", ""), outcome.modelId);
			assertEquals(stringField(expect, "modelProviderId", ""), outcome.modelProviderId);
			assertEquals(boolText(boolField(expect, "requiresOpenAiAuth", false)), boolText(outcome.requiresOpenAiAuth));
			assertEquals(stringField(expect, "credentialKind", ""), outcome.credentialKind);
			assertEquals(stringField(expect, "accountKind", ""), outcome.accountKind);
			assertEquals(stringField(expect, "networkKind", ""), outcome.networkKind);
			assertEquals(boolText(boolField(expect, "credentialAccepted", false)), boolText(outcome.credentialAccepted));
			assertEquals(stringField(expect, "credentialBucket", ""), outcome.credentialBucket);
			assertEquals(stringField(expect, "providerEnvKeyNameBucket", ""), outcome.providerEnvKeyNameBucket);
			assertEquals(boolText(boolField(expect, "providerEnvKeyPresent", false)), boolText(outcome.providerEnvKeyPresent));
			assertEquals(boolText(boolField(expect, "liveNetworkAllowed", false)), boolText(outcome.liveNetworkAllowed));
			assertEquals(stringField(expect, "admittedNetworkKind", ""), outcome.admittedNetworkKind);
			assertEquals(stringField(expect, "accountVisible", ""), outcome.accountVisible);
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			if (secretProbe.length > 0) assertNotContains(outcome.summary(), secretProbe);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ProviderAdmissionRequest> {
		final out:Array<ProviderAdmissionRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ProviderAdmissionRequest(
				stringField(request, "requestId", ""),
				providerValue(objectField(request, "provider")),
				modelValue(objectField(request, "model")),
				credentialKind(stringField(request, "credentialKind", "")),
				accountKind(stringField(request, "accountKind", "")),
				networkKind(stringField(request, "networkKind", "")),
				boolField(request, "liveNetworkAllowed", false),
				boolField(request, "hasCredentialMaterial", false),
				stringField(request, "secretProbe", "")
			));
		}
		return out;
	}

	static function providerValue(value:Value):ProviderAdmissionProvider {
		return new ProviderAdmissionProvider(
			stringField(value, "providerId", ""),
			stringField(value, "name", ""),
			boolField(value, "hasBaseUrl", false),
			stringField(value, "baseUrl", ""),
			boolField(value, "envKeyConfigured", false),
			boolField(value, "envKeyPresent", false),
			boolField(value, "envKeyInstructionsPresent", false),
			boolField(value, "requiresOpenAiAuth", false),
			boolField(value, "supportsWebsockets", false),
			boolField(value, "hasAwsAuth", false),
			boolField(value, "hasCommandAuth", false),
			boolField(value, "experimentalBearerTokenPresent", false)
		);
	}

	static function modelValue(value:Value):ProviderAdmissionModel {
		return new ProviderAdmissionModel(
			stringField(value, "modelId", ""),
			stringField(value, "providerId", ""),
			intField(value, "contextWindow", 0)
		);
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

	static function assertReport(root:Value, report:ProviderAdmissionReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "credentialAcceptedCount", 0)), Std.string(report.credentialAcceptedCount()));
		assertEquals(Std.string(intField(expect, "redactedCredentialCount", 0)), Std.string(report.redactedCredentialCount()));
		assertEquals(Std.string(intField(expect, "liveNetworkDeniedCount", 0)), Std.string(report.liveNetworkDeniedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/provider-admission.v1.json")));
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
					if (keys[i] == name) return values[i];
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
		if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) throw "expected " + expected + " but got " + actual;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) < 0) throw "expected to find " + needle + " in " + haystack;
	}

	static function assertNotContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) >= 0) throw "did not expect to find secret probe in summary";
	}
}
