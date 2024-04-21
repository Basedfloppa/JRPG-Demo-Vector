extends StaticBody2D

@onready var ui: Control = $"../../Character/UI"
@onready var area: Area2D = $InteractionArea
@export_multiline var message: String = "this is a message of current interactable onject"

func _input(_event):
	if(!Input.is_action_pressed("Interact")): return
	if(area.get_overlapping_bodies().size() <= 0): return
	for node in area.get_overlapping_bodies():
		if(node.name == "Character"):
			if(node.position - position).dot(node.last_vect) < 0:
				ui.set_message(message)
