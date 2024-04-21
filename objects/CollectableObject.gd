extends Node2D

@export var type: ItemsDb.Types
@onready var area: Area2D = $CollectableArea
@onready var sprite := $Icon

func _on_collectable_area_body_entered(_body):
	for node in area.get_overlapping_bodies():
		if(node.name == "Character"):
			node.on_collectable_collected(str(ItemsDb.Types.keys()[type]),self)

func _ready():
	sprite.texture = load(ItemsDb.Items[str(ItemsDb.Types.keys()[type])]["icon"])
