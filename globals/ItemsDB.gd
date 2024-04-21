class_name collectable_items
extends Node

const item_path: String = "res://sprites/" #template path for sprites
enum Types {Key,Apple,Orange,Pepper,Olive,AlarmPotion,TeleportationPotion,Amulet,Coin}
const Items: Dictionary = { #"json" object that stores all items and their values
	"Key": {
		"name": "",
		"description": "",
		"icon": item_path+"icon.svg",
		"usable": false,
		"consumable": false
	},
	"Apple": {
		"name": "Apple",
		"description": "Increases hp by 1.",
		"icon": item_path+"apple-logo-svgrepo-com.svg",
		"usable": true,
		"consumable": true
	},
	"Orange": {
		"name": "Orange",
		"description": "Increases hp and max hp by 1.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": true
	},
	"Pepper": {
		"name": "Chili pepper",
		"description": "Decreases health by 1.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": true
	},
	"Olive": {
		"name": "Olive",
		"description": "Decreases max health by 1.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": true
	},
	"AlarmPotion": {
		"name": "Potion of alarm",
		"description": "Closes all homes, can only be used on the street.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": true
	},
	"TeleportationPotion": {
		"name": "Potion of Teleportation",
		"description": "Teleports the user in a random direction over a certain distance.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": true
	},
	"Amulet": {
		"name": "Amulet",
		"description": "Decreases health by 9, increases max health by 1. Is not consumed upon use.",
		"icon": item_path+"icon.svg",
		"usable": true,
		"consumable": false
	},
	"Coin": {
		"name": "Coin",
		"description": "Round piece of metal with number 14 inscribed upon it.",
		"icon": item_path+"icon.svg",
		"usable": false,
		"consumable": false
	}
}
