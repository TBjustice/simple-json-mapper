extends Node
var simple_json_mapper:=SimpleJSONMapperImpl.new()

func map_by_script(src: Dictionary, script:Script)->Object:
	return simple_json_mapper.map_by_script(src, script)

func map_into_instance(src: Dictionary, dst:Object)->void:
	return simple_json_mapper.map_into_instance(src, dst)
