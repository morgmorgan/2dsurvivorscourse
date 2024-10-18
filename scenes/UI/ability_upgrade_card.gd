extends PanelContainer
class_name AbilityUpgradeCard

signal selected

@onready var name_label : Label = %NameLabel
@onready var description_label : Label = %DescriptionLabel

var ignore_input : bool = false

func _ready():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	
func play_in(delay : float = 0.0):
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("in")
	
func play_discard():
	$AnimationPlayer.play("discard")
	
func select_card():
	ignore_input = true
	$AnimationPlayer.play("selected")
	
	for other_card in get_tree().get_nodes_in_group("upgrade_card"):
		if other_card != self:
			other_card.play_discard()
	
	await $AnimationPlayer.animation_finished
	selected.emit()

func set_ability_upgrade(upgrade : AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	
func on_gui_input(event : InputEvent):
	if ignore_input:
		return
		
	if event.is_action_pressed("left_click"):
		select_card()
		
func on_mouse_entered():
	if ignore_input:
		return
		
	$HoverAnimationPlayer.play("hover")
