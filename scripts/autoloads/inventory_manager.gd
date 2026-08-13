extends Node

#ITEMS
const BOSS_KEYS: ItemData = preload("res://scripts/items/BossKeys.tres")

const MAX_SIZE = 3

var obtained_items: Array[ItemData] = []

signal inventory_modified

func send_inventory_modified_signal():
	inventory_modified.emit()

func remove_item(item: ItemData):
	obtained_items.erase(item)
	call_deferred("send_inventory_modified_signal")
	
func add_item(item: ItemData):
	if obtained_items.size() < MAX_SIZE:
		obtained_items.append(item)
		call_deferred("send_inventory_modified_signal")

func reset_data():
	obtained_items = []
