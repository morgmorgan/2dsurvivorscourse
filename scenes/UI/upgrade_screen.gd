extends CanvasLayer
class_name UpgradeScreen

signal upgrade_selected(upgrade : AbilityUpgrade)

@export var upgrade_card_scene : PackedScene

@onready var card_container : HBoxContainer = $"%CardContainer"

func _ready():
	get_tree().paused = true
	BgmPlayer.bass_only(true)

func set_ability_upgrades(upgrades : Array[AbilityUpgrade]):
	var delay = 0.0
	for upgrade in upgrades:
		var card_instance : AbilityUpgradeCard = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)
		card_instance.play_in(delay)
		delay += 0.2
		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))
		
func on_upgrade_selected(upgrade : AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	BgmPlayer.bass_only(false)
	queue_free()
