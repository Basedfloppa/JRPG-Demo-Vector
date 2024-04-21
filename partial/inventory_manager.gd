class_name inventory_manager

signal inventory_updated

var inventory_size: int = 10
var inventory_stash: Array = []

func add_item(item: Dictionary): #add item to the end of array
	inventory_updated.emit()
	inventory_stash.append(item)

func remove_item(index: int): #removes item and rebuilds inventory
	inventory_updated.emit()
	inventory_stash.pop_at(index)
	var _stash: Array = []
	for inv_item in inventory_stash: _stash.append(inv_item) #move all items closer to zero index
	inventory_stash = _stash #update array

func resize(size: int): #changes size
	inventory_updated.emit()
	inventory_size = size
