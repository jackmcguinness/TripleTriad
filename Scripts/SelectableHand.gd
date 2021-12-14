extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("hand_selection")


func _process(delta):
	pass

# Called when card is dropped into a new slot
func check_if_hand_full():
	var num_full_slots = 0
	for n in get_children():
		if n.slot_id != null:
			num_full_slots += 1
	
	if num_full_slots == get_child_count():
		get_tree().call_group("hand_selection", "enable_button")
	elif num_full_slots != get_child_count():
		get_tree().call_group("hand_selection", "disable_button")


func lock_in_card_ids():
	var hand_dict = {}
	
	for n in get_children():
		hand_dict[n.name.replace("CardSlot", "Slot ")] = n.slot_id 
	
	return hand_dict


func _on_StartGameButton_pressed() -> void:
	var player_hand = lock_in_card_ids()
	PLAYER_HAND_DATA.player_hand = player_hand
	#change scene to gameplay
	get_tree().change_scene("res://Main Scenes/TestMainScene.tscn")
	
