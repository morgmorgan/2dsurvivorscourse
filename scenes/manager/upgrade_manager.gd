extends Node

@export var upgrade_pool : Array[AbilityUpgrade]
@export var experience_manager : ExperienceManager
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}

func _ready():
	experience_manager.level_up.connect(on_level_up)
	
func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_pool.duplicate()
	var num_upgrades = 3
	
	for i in num_upgrades:
		if filtered_upgrades.is_empty():
			break
		
		var this_chosen_upgrade : AbilityUpgrade = filtered_upgrades.pick_random()
		chosen_upgrades.append(this_chosen_upgrade)
		filtered_upgrades.erase(this_chosen_upgrade)
		#filtered_upgrades = filtered_upgrades.filter(func(upgrade): return upgrade.id != this_chosen_upgrade.id)
	
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
			#upgrade_pool = upgrade_pool.filter(
			#	func(pool_upgrade): return pool_upgrade.id != upgrade
			#)
			upgrade_pool.erase(upgrade)
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	
func on_upgrade_selected(upgrade : AbilityUpgrade):
	apply_upgrade(upgrade)

func on_level_up(_new_level : int):
	var chosen_upgrades = pick_upgrades()
	
	var upgrade_screen_instance : UpgradeScreen = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
