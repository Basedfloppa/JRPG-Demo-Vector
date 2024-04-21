class_name character_mediator
extends Node

#default values for players that get assigned at start of each lvl
@export var hp: int = 10
@export var max_hp: int = 10
@export var keys: int = 0
var inventory: inventory_manager = inventory_manager.new()
