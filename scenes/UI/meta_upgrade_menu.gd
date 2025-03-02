extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = $MarginContainer/GridContainer

var meta_upgrade_card_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	for upgrade in upgrades:
		var meta_card_instance : MetaUpgradeCard = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_card_instance)
		meta_card_instance.set_meta_upgrade(upgrade)
