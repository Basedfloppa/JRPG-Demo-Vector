extends CharacterBody2D

var speed: int = 300
var max_hp: int
var hp: int
var keys: int
var last_vect: Vector2
var inventory: inventory_manager = inventory_manager.new()

@onready var ui: Control = $UI
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_up: Texture = preload("res://sprites/up.png")
@onready var sprite_down: Texture = preload("res://sprites/down.png")
@onready var sprite_right: Texture = preload("res://sprites/right.png")
@onready var sprite_left: Texture = preload("res://sprites/left.png")
@onready var inventory_modal: PackedScene = preload("res://partial/inventory_modal.tscn")

func _input(_event): # handle inventory input
	if Input.is_action_just_pressed("Inventory"):
		get_tree().paused = true
		var modal = inventory_modal.instantiate()
		modal.parent = self
		ui.add_child(modal)

func _physics_process(_delta):
	movement()
	update_ui()

func update_ui(): # set var's of ui to current values
	ui.set_deferred("hp_val",hp)
	ui.set_deferred("max_hp_val",max_hp)
	ui.set_deferred("keys_val",keys)

func movement():
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (input_direction != Vector2.ZERO) : last_vect = input_direction
	velocity = input_direction * speed
	move_and_slide()
	
	#change sprite on direction change
	if(input_direction.y != 0):
		if(input_direction.y < 0):
			sprite.texture = sprite_up
		else:
			sprite.texture = sprite_down
	if(input_direction.x != 0):
		if(input_direction.x > 0):
			sprite.texture = sprite_right
		else:
			sprite.texture = sprite_left

func on_collectable_collected(type: String, obj: Node): #called when colliding with collectable item
	match(type):
		"Key":
			keys += 1
			obj.queue_free()
		_: #all items aside from keys should be added to inventory if possible
			if !(inventory.inventory_stash.size() >= inventory.inventory_size):
				inventory.add_item(ItemsDb.Items[type])
				obj.queue_free()

func use_item(item: String): #called when item used from inventory
	match item:
		"Apple":
			if hp < max_hp:
				hp += 1
		"Orange":
			max_hp += 1
			hp += 1
		"Chili pepper":
			hp -= 1
			if hp <= 0 :
				SceneSaver.switch_scene("res://levels/game_over_screen.tscn")
		"Olive":
			max_hp -= 10
			if max_hp <= 0: max_hp = 1
			if hp > max_hp: hp = max_hp
		"Potion of alarm":
			var home_coll := get_node("../Homes") 
			for home in home_coll.get_children():
				home.opened = false
		"Amulet":
			max_hp += 1
			hp -= 9
			if hp <= 0 :
				SceneSaver.switch_scene("res://levels/game_over_screen.tscn")
		"Potion of Teleportation":
			var viable := false
			var location: Vector2
			while(!viable):
				var angle = randf()
				location = position + Vector2(cos(angle), sin(angle)) * 100 #100 is the max distance
				if (location.x >= 1150 || location.x <= 0): continue #arbitrary lvl borders
				if (location.y >= 650 || location.y <= 0): continue #arbitrary lvl borders
				var parameters := PhysicsPointQueryParameters2D.new()
				parameters.position = location
				parameters.collision_mask = 2147483647 #collision mask bits
				#check if point collides with any solid object
				if (get_world_2d().get_direct_space_state().intersect_point(parameters).size() == 0): continue
				viable = true
			position = location #teleport
