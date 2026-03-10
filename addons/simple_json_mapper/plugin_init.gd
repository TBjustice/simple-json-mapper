@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("SimpleJSONMapper", "res://addons/simple_json_mapper/simple_json_mapper.gd")
	pass

func _exit_tree() -> void:
	remove_autoload_singleton("SimpleJSONMapper")
	pass
