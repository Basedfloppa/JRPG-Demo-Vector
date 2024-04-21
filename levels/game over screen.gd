extends Node2D

func _on_button_pressed():
	var dir := DirAccess.open("res://saved_scenes/")
	for file in dir.get_files():
		dir.remove("res://saved_scenes/"+file)
	get_tree().quit()
