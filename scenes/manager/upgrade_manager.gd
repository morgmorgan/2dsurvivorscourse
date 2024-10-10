extends Node

@export var experience_manager : ExperienceManager
@export var upgrade_screen_scene : PackedScene
@export var all_upgrades : Array[AbilityUpgrade]

var current_upgrades = {}
var upgrade_pool : WeightedTable = WeightedTable.new()
var upgrade_options = 3

###### Upgrades
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")

func _ready():
	create_upgrade_pool()	
	experience_manager.level_up.connect(on_level_up)
	
func create_upgrade_pool():
	upgrade_pool.add_item(upgrade_axe, 10)
	upgrade_pool.add_item(upgrade_sword_rate, 10)
	upgrade_pool.add_item(upgrade_sword_damage, 10)
	
func update_upgrade_pool(chosen_upgrade : AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
		
	#for 

func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []

	for i in upgrade_options:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		
		var this_chosen_upgrade : AbilityUpgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(this_chosen_upgrade)
		
	return chosen_upgrades

func apply_upgrade(upgrade : AbilityUpgrade):
	if !current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0:
		if current_upgrades[upgrade.id]["quantity"] == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	
	update_upgrade_pool(upgrade)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	
func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(_new_level : int):
	var chosen_upgrades = pick_upgrades()
	
	var upgrade_screen_instance : UpgradeScreen = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
