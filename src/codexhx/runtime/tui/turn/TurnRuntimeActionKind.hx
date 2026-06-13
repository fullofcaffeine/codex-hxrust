package codexhx.runtime.tui.turn;

enum abstract TurnRuntimeActionKind(String) from String to String {
    var TaskStarted = "task_started";
    var AssistantDelta = "assistant_delta";
    var AssistantFinal = "assistant_final";
    var PlanDelta = "plan_delta";
    var PlanFinal = "plan_final";
    var QueueFollowUp = "queue_follow_up";
    var QueueSteer = "queue_steer";
    var TaskCompleted = "task_completed";
    var TaskFailed = "task_failed";
    var TaskCancelled = "task_cancelled";
}
