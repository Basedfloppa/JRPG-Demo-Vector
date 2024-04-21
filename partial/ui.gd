extends Control

var timer: int = 100

@export var hp_val: int = 0
@export var max_hp_val: int = 0
@export var keys_val: int = 0

@onready var hp := $Values/HpValContainer/HpVal
@onready var keys := $Values/KeysValContainer/KeysVal
@onready var interact := $InteractiveLabel

func _process(delta):
	if interact.text != "" : #if text not empty decrease timer  
		timer -= delta
		if timer <= 0 : #if timer ended reset timer and set text to blank
			timer = 100
			interact.text = ""
	
	hp.text = "{0}/{1}".format([hp_val,max_hp_val])
	keys.text = str(keys_val)

func set_message(message: String): #set message and reset timer
	interact.text = message
	timer = 100
