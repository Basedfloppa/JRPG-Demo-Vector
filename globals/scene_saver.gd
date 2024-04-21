class_name scene_manager
extends Node

var current_scene: Node = null
func _ready():
	var root := get_tree().root
	current_scene = root.get_child(root.get_child_count()-1)

func switch_scene(new_path):
	new_path = _get_load_path(new_path)
	call_deferred("_deffered_switch_scene", new_path)

func _deffered_switch_scene(new_path):
	_save_scene()
	current_scene.free()
	var scene := load(new_path)
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func _save_scene():
	var path_arr: PackedStringArray = current_scene.path.split("/")
	var packed_scene := PackedScene.new()
	packed_scene.pack(current_scene)
	ResourceSaver.save(packed_scene,"res://saved_scenes/"+path_arr[path_arr.size()-1])

func _get_load_path(new_path) -> String:
	var files = DirAccess.open("res://saved_scenes/").get_files()
	for file in files:
		var arr = new_path.split('/')
		if file == arr[arr.size()-1]:
			var packed_path = "res://saved_scenes/"+arr[arr.size()-1]
			return packed_path
	return new_path
