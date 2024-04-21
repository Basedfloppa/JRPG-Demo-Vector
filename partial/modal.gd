class_name modal_window
extends Control

signal result(result: bool)

func initialize(message: String, option1: String, option2: String):
	var _message := $VBoxContainer/Message
	var _option1 := $VBoxContainer/HBoxContainer/Option1
	var _option2 := $VBoxContainer/HBoxContainer/Option2
	_message.text = message
	_option1.text = option1
	_option2.text = option2

func _on_option_1_pressed():
	result.emit(true)
	get_tree().paused = false
	self.queue_free()

func _on_option_2_pressed():
	result.emit(false)
	get_tree().paused = false
	self.queue_free()
