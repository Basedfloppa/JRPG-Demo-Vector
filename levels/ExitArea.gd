extends Area2D

@export var next_scene: String = "res://levels/level.tscn"

func _on_body_entered(body): #change scene to next_scene
	for node in get_overlapping_bodies():
		if(node.name == "Character"):
			SceneSaver.current_scene.save_character()
			SceneSaver.switch_scene(next_scene)
