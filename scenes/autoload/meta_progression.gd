extends Node

const save_filepath = "user://game_data.save"

var meta_data : Dictionary = {
	"meta_upgrade_currency" : 0,
	"meta_upgrades" : {}
}

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_data()
	
func load_data():
	if not FileAccess.file_exists(save_filepath):
		return
	
	var file = FileAccess.open(save_filepath, FileAccess.READ)
	print_debug(file.get_path_absolute())
	meta_data = file.get_var()
	print_debug(meta_data)
	
func save_data():
	var file = FileAccess.open(save_filepath, FileAccess.WRITE)
	file.store_var(meta_data)
	
func on_experience_collected(number : float):
	meta_data["meta_upgrade_currency"] += number

func add_meta_upgrade(upgrade : MetaUpgrade):
	if not meta_data["meta_upgrades"].has(upgrade.id):
		meta_data["meta_upgrades"][upgrade.id] = {
			"quantity":0
		}
	
	meta_data["meta_upgrades"][upgrade.id]["quantity"] += 1
