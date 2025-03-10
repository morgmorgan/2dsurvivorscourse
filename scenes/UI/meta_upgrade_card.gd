extends PanelContainer
class_name MetaUpgradeCard

@onready var name_label : Label = %NameLabel
@onready var description_label : Label = %DescriptionLabel
@onready var progress_bar = $%ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel

var upgrade : MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)
	
func update_progress():
	var current_quantity = 0
	if MetaProgression.meta_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.meta_data["meta_upgrades"][upgrade.id]["quantity"]
	var is_maxed = current_quantity >= upgrade.max_quantity
	var currency = MetaProgression.meta_data["meta_upgrade_currency"]
	var percent =  currency / upgrade.exp_cost
	percent = min(percent, 1.0)
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_maxed
	if is_maxed:
		purchase_button.text = "Max Level"
	progress_label.text = str(currency) + " / " + str(upgrade.exp_cost)
	count_label.text = "Lvl. %d" % current_quantity

func set_meta_upgrade(new_upgrade : MetaUpgrade):
	upgrade = new_upgrade
	name_label.text = new_upgrade.title
	description_label.text = new_upgrade.description
	update_progress()

func on_purchase_pressed():
	if upgrade == null:
		return
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.meta_data["meta_upgrade_currency"] -= upgrade.exp_cost
	MetaProgression.save_data()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	$AnimationPlayer.play("selected")
