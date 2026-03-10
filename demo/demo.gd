extends Control
@export_multiline var json_text:String

class DemoClass:
	# primitives
	var any
	var flag:bool
	var id:int = 2
	var value:float
	var text:String
	func _to_string()->String:
		return """{
	\"any\":%s,
	\"flag\":%s,
	\"id\":%d,
	\"value\":%f,
	\"text\":\"%s\",
}""" % [str(any), str(flag), id, value, text]

class DemoInheritance:
	extends DemoClass
	var config: Dictionary
	var int_values:Array[int]
	var text_values:Array[String]
	func _to_string()->String:
		return """{
	\"any\":%s,
	\"flag\":%s,
	\"id\":%d,
	\"value\":%f,
	\"text\":%s,
	\"config\":%s,
	\"int_values\":%s,
	\"text_values\":%s,
}""" % [str(any), str(flag), id, value, text, str(config), str(int_values), str(text_values)]

class DemoComposition:
	var int_list:Array[int]
	var demo_class:=DemoClass.new()
	var demo_class_list:Array[DemoClass]
	func _to_string()->String:
		return """{
	\"int_list\":%s
	\"demo_class\":%s,
	\"demo_class_list\":%s
}""" % [str(int_list), str(demo_class), str(demo_class_list)]

func _ready() -> void:
	var json_data = JSON.parse_string(json_text)
	var demo_composition:DemoComposition = SimpleJSONMapper.parse_by_script(json_data, DemoComposition)
	print(demo_composition)
	
