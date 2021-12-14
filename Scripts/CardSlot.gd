extends PanelContainer

var holding_card = false       #set to true when player is 'holding' a card 

var empty_space = null         #true when space being hovered over is empty

var focused_space = null       #int: set to number of slot being hovered over

var slot_id = null             #ID of card in slot; null if empty

func _ready():
	
	add_to_group("cardslots")
	
		
	#Assigns background texture based on slot position (uses name of Node)
	var slot_number = name.replace("CardSlot", "")
	var texture_filepath = "res://Resources/Board/Number Spaces/" + slot_number + ".png"
	$SlotTexture.texture = load(texture_filepath)
	
	update_slot_texture()


func _input(event):
	if Input.is_action_just_released("click") and holding_card == true:
		holding_card = false
		if empty_space == false:
			make_card_visible()



func get_drag_data(_pos): #Retrieve info about the slot we are dragging
	
	#Cannot drag if slot is in GameBoard
	if get_parent().name != "GameBoard":
	
		### Sets previous_slot number if card slot is being dragged from a hand (i.e. not in gameboard) ###
		var previous_slot = name.replace("CardSlot", "") 
		var parent_to_remove_from = get_parent().name
		
		var data = {
			"card_id": slot_id,
			"parent_from": parent_to_remove_from,
			"previous_slot": previous_slot
		}
		
		### Creates drag_texture for card being dragged ###
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = $CardTexture.texture
		drag_texture.rect_size = rect_size
		
		### Centres drag_texture around mouse ###
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		
		make_card_invisible()
		holding_card = true
		
		return data


func can_drop_data(_pos, data): #Check if we can drop an item in this slot
	
	if focused_space == int(name.replace("CardSlot", "")):
		if slot_id == null:
			empty_space = true 
			return true
		else:
			empty_space = false
			return false
	return false


func drop_data(_pos, data): #What happens when we drop an item in this slot - only affects slot being dropped into
	
	### Updates slot being dragged to with new ID and texture ###
	if focused_space == int(name.replace("CardSlot", "")):
		slot_id = data["card_id"]
		update_slot_texture()
	
	### Updates slot being dragged from with null ID and removes texture ###
	get_tree().call_group("cardslots", "remove_card_from_slot", data["previous_slot"], data["parent_from"])
	
	### Lets Gameboard know that a card has been dropped ###
	if get_parent().name == "GameBoard":
		get_tree().call_group("neighbour_comp", "compare_against_neighbours", data["card_id"], int(name.replace("CardSlot", "")))
	
	### Lets SelectableHand know that a card has been dropped ###
	get_tree().call_group("hand_selection", "check_if_hand_full")


func remove_card_from_slot(slot_to_remove, parent_to_remove_from):
	if get_parent().name == parent_to_remove_from and name.replace("CardSlot","") == slot_to_remove:
		slot_id = null
		update_slot_texture()


func update_slot_texture():
	if slot_id != null:
		var key = "Slot " + name.replace("CardSlot", "")
		var new_card_texture_filepath = "res://Resources/Cards/" + slot_id + ".jpg"
		$CardTexture.texture = load(new_card_texture_filepath)
	else:
		remove_card_texture()

func remove_card_texture():
	$CardTexture.texture = null

func make_card_visible():
	$CardTexture.visible = true

func make_card_invisible():
	$CardTexture.visible = false

func _on_CardSlot_mouse_exited() -> void:
	reset_focused_space()

### CardSlot ###

func _on_CardSlot_mouse_entered() -> void:
	focused_space = int(name.replace("CardSlot", ""))

func reset_focused_space():
	focused_space = null

### External calls ###

func get_card_id():
	print(name)
	if slot_id != null:
		return slot_id

func change_colour(var colour_to_change, var new_colour):
	
	#Plays animation and waits until card is 0 width (i.e. when card is halfway through being flipped)
	var animation_length = $AnimationPlayer.get_animation("card_flip").length
	
	$AnimationPlayer.play("card_flip")
	yield(get_tree().create_timer(animation_length/2), "timeout")
	
	#Sets new ID and changes card texture
	var new_slot_id_colour = slot_id.substr(0, slot_id.length() - 1) + new_colour
	slot_id = new_slot_id_colour
	update_slot_texture()
	
