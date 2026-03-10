class_name SimpleJSONMapperImpl
extends RefCounted
var missing_any_to_null:=false
var mismatch_primitive_to_zero:=false
var missing_primitive_to_zero:=false
var mismatch_array_to_empty:=true
var missing_array_to_empty:=true
var mismatch_dict_to_empty:=true
var missing_dict_to_empty:=true
var mismatch_object_to_null:=true
var missing_object_to_null:=true

func parse_by_script(src: Dictionary, script:Script)->Object:
	var base_type := script.get_instance_base_type()
	if not ClassDB.class_exists(base_type):
		return null
	var instance:Object = ClassDB.instantiate(base_type)
	instance.set_script(script)
	map_into_instance(src, instance)
	return instance

func map_into_instance(src: Dictionary, dst:Object)->void:
	var property_list = dst.get_property_list()
	for property in property_list:
		if (property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE == 0):
			continue
		match property.type:
			# Any Type
			TYPE_NIL:
				if src.has(property.name):
					dst.set(property.name, src.get(property.name))
				elif missing_any_to_null:
					dst.set(property.name, null)
			# Primitives
			TYPE_BOOL:
				if src.has(property.name):
					var value = src.get(property.name)
					if value is bool:
						dst.set(property.name, value)
					elif mismatch_primitive_to_zero:
						dst.set(property.name, false)
				elif missing_primitive_to_zero:
					dst.set(property.name, false)
			TYPE_FLOAT, TYPE_INT:
				if src.has(property.name):
					var value = src.get(property.name)
					if value is int or value is float:
						dst.set(property.name, value)
					elif mismatch_primitive_to_zero:
						dst.set(property.name, 0)
				elif missing_primitive_to_zero:
					dst.set(property.name, 0)
			TYPE_STRING:
				if src.has(property.name):
					var value = src.get(property.name)
					if value is String:
						dst.set(property.name, value)
					elif mismatch_primitive_to_zero:
						dst.set(property.name, "")
				elif missing_primitive_to_zero:
					dst.set(property.name, "")
			# Object
			TYPE_OBJECT:
				var current = dst.get(property.name)
				if current == null:
					continue
				if src.has(property.name):
					var value = src.get(property.name)
					if value is Dictionary:
						map_into_instance(value, current)
						dst.set(property.name, current)
					elif mismatch_object_to_null:
						dst.set(property.name, null)
				elif missing_object_to_null:
					dst.set(property.name, null)
			# Dictionary
			TYPE_DICTIONARY:
				if src.has(property.name):
					var value = src.get(property.name)
					if value is Dictionary:
						dst.set(property.name, value)
					elif mismatch_dict_to_empty:
						dst.set(property.name, {})
				elif missing_dict_to_empty:
					dst.set(property.name, {})
			# Array
			TYPE_ARRAY:
				if src.has(property.name):
					var value = src.get(property.name)
					if value is Array:
						_set_array(value, dst.get(property.name))
					elif mismatch_array_to_empty:
						dst.set(property.name, [])
				elif missing_array_to_empty:
					dst.set(property.name, [])


func _set_array(src: Array, dst:Array)->void:
	dst.clear()
	if dst.is_typed():
		match dst.get_typed_builtin():
			TYPE_NIL:
				dst.append_array(src)
			TYPE_BOOL:
				for item in src:
					if item is bool:
						dst.append(item)
					else:
						dst.append(false)
			TYPE_INT:
				for item in src:
					if item is int or item is float:
						dst.append(int(item))
					else:
						dst.append(0)
			TYPE_FLOAT:
				for item in src:
					if item is int or item is float:
						dst.append(float(item))
					else:
						dst.append(0.0)
			TYPE_STRING:
				for item in src:
					if item is String:
						dst.append(item)
					else:
						dst.append("")
			TYPE_OBJECT:
				var typed_script = dst.get_typed_script()
				for item in src:
					if item is Dictionary and typed_script != null:
						var object := parse_by_script(item, typed_script)
						dst.append(object)
					else:
						dst.append(null)
	else:
		dst.append_array(src)
