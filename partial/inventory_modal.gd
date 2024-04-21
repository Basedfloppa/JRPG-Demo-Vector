extends Control

@export var parent: Node

@onready var container := preload("res://partial/item_container.tscn")
@onready var action_box := $Action/ActionBox
@onready var item_box := $Inventiry/ItemBox
@onready var name_label := $Info/InfoBox/Name
@onready var description_label := $Info/InfoBox/Description

var index: int = 0

func _ready(): #parse inventory and create all requiered objecs
	parse_inventory(parent.inventory)

func _input(_event): #close inventory on appropriate input
	if Input.is_action_just_pressed("Inventory"):
		get_tree().paused = false
		self.queue_free()
		get_viewport().set_input_as_handled() #prevent character from grabbing input and calling modal once again

func parse_inventory(inventory: inventory_manager): #create all objects and populate them with inventory data
	for i in inventory.inventory_size: #create all objects for inventory size
		var _container := container.instantiate()
		_container.index = i
		_container.clicked.connect(_on_container_clicked)
		item_box.add_child(_container)
	for _container in item_box.get_children(): #populate them with data
		if inventory.inventory_stash.size()-1 >= _container.index && inventory.inventory_stash[_container.index] != null:
			_container.set_icon(inventory.inventory_stash[_container.index]["icon"])

func add_button(text: String, action: Callable): #add button and bind a function to it
	var button := Button.new()
	button.pressed.connect(action)
	button.text = text
	action_box.add_child(button)

func destroy_buttons(): #destroys all created buttons
	for child in action_box.get_children(): child.queue_free()

func get_current_item() -> Dictionary: #get item with current index
	return parent.inventory.inventory_stash[index]

func set_ui(item: Dictionary): #set ui for current item
	if item.size() > 0:
		destroy_buttons() #clead buttons
		name_label.text = item['name']
		description_label.text = item['description']
		if item["consumable"] == true: #we dont want to create use button for items that we cant use
			add_button("use", Callable(self, "use_item"))
		add_button("drop", Callable(self, "drop_item"))
	else: #set all modal data to empty if there no item
		name_label.text = ""
		description_label.text = ""
		destroy_buttons()

func use_item():
	var item := get_current_item()
	parent.use_item(item.name) #pass item to parent to apply effect
	parent.inventory.remove_item(index) #remove item
	index = 0 #rest index
	update_ui(parent.inventory) #update ui
	#if inventory have items, set ui data to first item in array
	if parent.inventory.inventory_stash.size() > 0: set_ui(parent.inventory.inventory_stash[0]) 
	else: set_ui({}) #set ui to blank

func drop_item(): #dropts item on some point near the player
	var _item := get_current_item()
	var item_type: ItemsDb.Types
	for item in ItemsDb.Items.keys():
		if ItemsDb.Items[item]["name"] == _item["name"]: item_type = ItemsDb.Types[item]
	var viable := false
	var location: Vector2
	while(!viable):
		var angle = randf()
		location = parent.position + Vector2(cos(angle), sin(angle)) * 100 #100 is the max distance
		if (location.x >= 1150 || location.x <= 0): continue #arbitrary lvl borders
		if (location.y >= 650 || location.y <= 0): continue #arbitrary lvl borders
		var parameters := PhysicsPointQueryParameters2D.new()
		parameters.position = location
		parameters.collision_mask = 2147483647 #collision mask bits
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
		#set icons to appropriate icons
		if inventory.inventory_stash.size()-1 >= _container.index && inventory.inventory_stash[_container.index] != null:
			_container.set_icon(inventory.inventory_stash[_container.index]["icon"])
		else:
			_container.set_icon("res://sprites/px.png") #set placeholder

func _on_container_clicked(_index: int):
	index = _index
	set_ui(parent.inventory.inventory_stash[index])
