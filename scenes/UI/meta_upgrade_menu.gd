extends CanvasLayer

@export var upgrades: Array[MetaUpgrade] = []

@onready var grid_container = %GridContainer

var meta_upgrade_card_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	# Debug
	for child in %GridContainer.get_children():
		child.queue_free()
		
	%BackButton.pressed.connect(on_backButton_pressed)
	
	for upgrade in upgrades:
		var meta_card_instance : MetaUpgradeCard = meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_card_instance)
		meta_card_instance.set_meta_upgrade(upgrade)
		
func on_backButton_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
