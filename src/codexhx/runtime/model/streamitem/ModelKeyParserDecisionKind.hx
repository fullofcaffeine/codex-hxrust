package codexhx.runtime.model.streamitem;

enum abstract ModelKeyParserDecisionKind(String) to String {
	final KeyParserCasesPreserved = "key_parser_cases_preserved";
	final KeyParserCasesRejected = "key_parser_cases_rejected";
}
