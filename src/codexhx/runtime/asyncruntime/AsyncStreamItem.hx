package codexhx.runtime.asyncruntime;

class AsyncStreamItem<T> {
	public final sequence:Int;
	public final delivery:AsyncDeliveryKind;
	public final value:T;

	public function new(sequence:Int, delivery:AsyncDeliveryKind, value:T) {
		this.sequence = sequence;
		this.delivery = delivery;
		this.value = value;
	}

	public function summary(valueSummary:String):String {
		return "seq=" + Std.string(sequence) + ";delivery=" + delivery + ";value=" + valueSummary;
	}
}
