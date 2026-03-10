# simple-json-mapper
A lightweight and minimalistic tool to map JSON/Dictionary data into Godot custom class.

## How to use
1. Install and enable the plugin.
2. Define the class.
3. Run `SimpleJSONMapper.map_by_script(dictionary, ClassName)`

### Sample code
```gdscript
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
```

### Test sample code
```
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
	print(my_class.any, ",", my_class.flag, ",", my_class.id)
	print(my_class.text, ",", my_class.value_list)

func _ready()->void:
	var my_class := parse_my_class(JSON.parse_string(JSON_TEXT1))
	debug(my_class)
	
	print("=====")
	
	var other_class := parse_other_class(JSON.parse_string(JSON_TEXT2))
	debug(other_class.my_class)
	for item in other_class.my_class_list:
		debug(item)
```

**Output**
```
any:["Hello", 123, "World"], flag:true, id:45
text:"Simple JSON Mapper", value_list:[3.14, 6.28, 9.42]
=====
any:<null>, flag:false, id:1
text:"", value_list:[]
any:<null>, flag:false, id:1
text:"first", value_list:[]
any:<null>, flag:true, id:2
text:"", value_list:[]
any:<null>, flag:true, id:3
text:"last", value_list:[]
```
