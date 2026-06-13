package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoal;

class ThreadReadCreateGoalToolRequest {
	public final threadId:String;
	public final turnId:String;
	public final argumentsJson:String;
	public final insertOutcomeKind:ThreadReadCreateGoalToolInsertOutcomeKind;
	public final insertErrorMessage:String;
	public final previewOutcomeKind:ThreadReadCreateGoalToolPreviewOutcomeKind;
	public final previewErrorMessage:String;
	public final insertedGoal:ThreadGoal;

	public function new(
		threadId:String,
		turnId:String,
		argumentsJson:String,
		insertOutcomeKind:ThreadReadCreateGoalToolInsertOutcomeKind,
		insertErrorMessage:String,
		previewOutcomeKind:ThreadReadCreateGoalToolPreviewOutcomeKind,
		previewErrorMessage:String,
		insertedGoal:ThreadGoal
	) {
		this.threadId = threadId;
		this.turnId = turnId;
		this.argumentsJson = argumentsJson;
		this.insertOutcomeKind = insertOutcomeKind;
		this.insertErrorMessage = insertErrorMessage;
		this.previewOutcomeKind = previewOutcomeKind;
		this.previewErrorMessage = previewErrorMessage;
		this.insertedGoal = insertedGoal;
	}
}
