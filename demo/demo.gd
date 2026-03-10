extends Control
# Define some class
class MyClass:
	var any
	var flag:bool
	var id:int
	var value:float
	var text:String
	var value_list:Array[float]

# SimpleJSONMapper.map_by_script() will map Dictionary into a class member
func parse_my_class(data: Dictionary)->MyClass:
	return SimpleJSONMapper.map_by_script(data, MyClass)

# If a class member is an object, it must be initialized with `.new()`.
class OtherClass:
	var my_class:=MyClass.new()
	var my_class_list:Array[MyClass]

func parse_other_class(data: Dictionary)->OtherClass:
	return SimpleJSONMapper.map_by_script(data, OtherClass)


const JSON_TEXT1 = """{
	"any": ["Hello", 123, "World"],
	"flag": true,
	"id": 45,
	"text": "Simple JSON Mapper",
	"value_list": [3.14, 6.28, 9.42]
}"""

const JSON_TEXT2 = """{
	"my_class": { "flag": false, "id": 1 },
	"my_class_list": [
		{ "flag": false, "id": 1, "text": "first" },
		{ "flag": true, "id": 2 },
		{ "flag": true, "id": 3, "text": "last" },
	]
}"""

func debug(my_class: MyClass)->void:
	print("any:", my_class.any, ", flag:", my_class.flag, ", id:", my_class.id)
	print("text:\"", my_class.text, "\", value_list:", my_class.value_list)

func _ready()->void:
	var my_class := parse_my_class(JSON.parse_string(JSON_TEXT1))
	debug(my_class)
	
	print("=====")
	
	var other_class := parse_other_class(JSON.parse_string(JSON_TEXT2))
	debug(other_class.my_class)
	for item in other_class.my_class_list:
		debug(item)
