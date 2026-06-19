package haxe.json;

enum Value {
	JNull;
	JBool(value:Bool);
	JNumber(value:Float);
	JString(value:String);
	JObject(keys:Array<String>, values:Array<Value>);
	JArray(items:Array<Value>);
}
