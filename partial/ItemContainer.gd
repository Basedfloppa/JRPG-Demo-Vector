extends Control

signal clicked(index: int)

@onready var icon := $Background/Icon

var active: bool = false
var index: int = 0

func set_icon(path: String):
	if path != "res://sprites/px.png" : active = true
	else: active = false
	icon.texture = load(path)

func _on_icon_gui_input(_event):
	if active && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		clicked.emit(index)
