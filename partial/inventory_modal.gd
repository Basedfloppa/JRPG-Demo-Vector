extends Control

@export var parent: Node

@onready var container := preload("res://partial/item_container.tscn")
@onready var action_box := $Action/ActionBox
@onready var item_box := $Inventiry/ItemBox
@onready var name_label := $Info/InfoBox/Name
@onready var description_label := $Info/InfoBox/Description

var index: int = 0

func _ready():
	parse_inventory(parent.inventory)

func _input(_event):
	if Input.is_action_just_pressed("Inventory"):
		get_tree().paused = false
		self.queue_free()
		get_viewport().set_input_as_handled()

func parse_inventory(inventory: inventory_manager):
	for i in inventory.inventory_size:
		var _container := container.instantiate()
		_container.index = i
		_container.clicked.connect(_on_container_clicked)
		item_box.add_child(_container)
	for _container in item_box.get_children():
		if inventory.inventory_stash.size()-1 >= _container.index && inventory.inventory_stash[_container.index] != null:
			_container.set_icon(inventory.inventory_stash[_container.index]["icon"])

func add_button(text: String, action: Callable):
	var button := Button.new()
	button.pressed.connect(action)
	button.text = text
	action_box.add_child(button)

func destroy_buttons():
	for child in action_box.get_children(): child.queue_free()

func get_current_item() -> Dictionary:
	return parent.inventory.inventory_stash[index]

func set_ui(item: Dictionary):
	if item.size() > 0:
		destroy_buttons()
		name_label.text = item['name']
		description_label.text = item['description']
		if item["consumable"] == true:
			add_button("use", Callable(self, "use_item"))
		add_button("drop", Callable(self, "drop_item"))
	else:
		name_label.text = ""
		description_label.text = ""
		destroy_buttons()

func use_item():
	var item := get_current_item()
	parent.use_item(item.name)
	parent.inventory.remove_item(index)
	index = 0
	update_ui(parent.inventory)
	if parent.inventory.inventory_stash.size() > 0: set_ui(parent.inventory.inventory_stash[0])
	else: set_ui({})

func drop_item():
	var _item := get_current_item()
	var item_type: ItemsDb.Types
	for item in ItemsDb.Items.keys():
		if ItemsDb.Items[item]["name"] == _item["name"]: item_type = ItemsDb.Types[item]
	var viable := false
	var location: Vector2
	while(!viable):
		var angle = randf()
		location = parent.position + Vector2(cos(angle), sin(angle)) * 100
		if (location.x >= 1150 || location.x <= 0): continue
		if (location.y >= 650 || location.y <= 0): continue
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = location
		parameters.collision_mask = 2147483647
		viable = true
	var object = load("res://objects/CollectableObject.tscn").instantiate()
	object.type = item_type
	object.position = location
	get_node("../../../Collectable").add_child(object)
	parent.inventory.remove_item(index)
	update_ui(parent.inventory)
	set_ui({})

func update_ui(inventory: inventory_manager):
	for _container in item_box.get_children():
		if inventory.inventory_stash.size()-1 >= _container.index && inventory.inventory_stash[_container.index] != null:
			_container.set_icon(inventory.inventory_stash[_container.index]["icon"])
		else:
			_container.set_icon("res://sprites/px.png")

func _on_container_clicked(_index: int):
	index = _index
	set_ui(parent.inventory.inventory_stash[index])
