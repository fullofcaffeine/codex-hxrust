package codexhx.runtime.asyncruntime;

enum abstract AsyncCancelReason(String) to String {
	var UserInterrupt = "user_interrupt";
	var ConsumerDropped = "consumer_dropped";
	var Timeout = "timeout";
	var Shutdown = "shutdown";
	var TestFixture = "test_fixture";
}
