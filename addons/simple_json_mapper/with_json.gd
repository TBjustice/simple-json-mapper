extends Node

func with_json(target: Object, json_string: String)->void:
	var parsed = JSON.parse_string(json_string)
	if parsed is Dictionary:
		with_dict(target, parsed)

func with_dict(target: Object, dict: Dictionary)->void:
	var property_list = target.get_property_list()
	for property in property_list:
		if (property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == 0) or not dict.has(property.name):
			continue
		var src = dict.get(property.name)
		match property.type:
			TYPE_NIL:
				target.set(property.name, src)
			TYPE_BOOL:
				if src is bool:
					target.set(property.name, src)
			TYPE_FLOAT, TYPE_INT:
				if src is bool or src is int or src is float:
					target.set(property.name, src)
			TYPE_STRING:
				if src is String:
					target.set(property.name, src)
			TYPE_OBJECT:
				var dst:Object = target.get(property.name)
				if dst != null and src is Dictionary:
					var object := _object_like(dst)
					with_dict(object, src)
					target.set(property.name, object)
			TYPE_DICTIONARY:
				if src is Dictionary:
					target.set(property.name, src)
			TYPE_ARRAY:
				if src is Array:
					_set_array(target.get(property.name), src)

func _object_like(like:Object)->Object:
	var object := ClassDB.instantiate(like.get_class())
	if like.get_script() != null:
		object.set_script(like.get_script())
	return object

func _set_array(target:Array, src: Array)->void:
	if target.is_typed():
		match target.get_typed_builtin():
			TYPE_NIL:
				target.append_array(src)
			TYPE_BOOL:
				for item in src:
					if item is bool:
						target.append(item)
					else:
						target.append(false)
			TYPE_INT, TYPE_FLOAT:
				for item in src:
					if item is int or item is float:
						target.append(item)
					else:
						target.append(0)
			TYPE_STRING:
				for item in src:
					if item is String:
						target.append(item)
					else:
						target.append("")
			TYPE_OBJECT:
				var typed_class_name := target.get_typed_class_name()
				if typed_class_name.length() == 0:
					return
				var typed_script = target.get_typed_script()
				for item in src:
					if item is Dictionary:
						var object := ClassDB.instantiate(typed_class_name)
						if typed_script is Script:
							object.set_script(typed_script)
						with_dict(object, item)
						target.append(object)
					else:
						target.append(null)
	else:
		target.clear()
		target.append_array(src)
