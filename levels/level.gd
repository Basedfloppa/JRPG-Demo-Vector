extends Node2D

@export var path: String = ""

@onready var character := get_node("Character")

func _notification(what): #clear saved scenes on game close
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var dir := DirAccess.open("res://saved_scenes/")
		for file in dir.get_files():
			dir.remove("res://saved_scenes/"+file)

func _ready(): #load default values from mediator into character
	character.hp = PlayerInfo.hp
	character.max_hp = PlayerInfo.max_hp
	character.keys = PlayerInfo.keys
	character.inventory = PlayerInfo.inventory

func save_character(): #offload values from character to mediator
	PlayerInfo.hp = character.hp
	PlayerInfo.max_hp = character.max_hp
	PlayerInfo.keys = character.keys
	PlayerInfo.inventory = character.inventory
