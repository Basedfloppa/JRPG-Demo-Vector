extends StaticBody2D

@export var openable: bool = true
@export var opened: bool = false
@export var cost: int = 1
@export var next_scene: String = "res://levels/home_interior.tscn"

@onready var area := $TransitionArea
@onready var modal := preload("res://partial/modal.tscn")

var current_modal: Node
var character: Node

func _on_transition_area_body_entered(_body):
	for node in area.get_overlapping_bodies():
		if(node.name == "Character"):
			if opened:
				SceneSaver.current_scene.save_character()
				SceneSaver.switch_scene(next_scene)
			elif !opened and openable:
				if node.keys > 0:
					character = node
					current_modal = modal.instantiate()
					current_modal.initialize("spend 1 key to open this house?","yes","no")
					self.add_child(current_modal)
					current_modal.connect("result",_on_modal_result)
					get_tree().paused = true

func _on_modal_result(result: bool):
	if result :
		character.keys -= 1
		opened = true
		SceneSaver.current_scene.save_character()
		SceneSaver.switch_scene(next_scene)

