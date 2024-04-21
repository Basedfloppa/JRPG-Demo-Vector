class_name inventory_manager

signal inventory_updated

var inventory_size: int = 10
var inventory_stash: Array = []

func add_item(item: Dictionary):
	inventory_updated.emit()
	inventory_stash.append(item)

func remove_item(index: int):
	inventory_updated.emit()
	inventory_stash.pop_at(index)
	var _stash: Array = []
	for inv_item in inventory_stash: _stash.append(inv_item)
	inventory_stash = _stash

func resize(size: int):
	inventory_updated.emit()
	inventory_size = size
