extends PanelContainer

var holding_card = false

var empty_space = null

var focused_space = null

func _ready():
	
	#Assigns background texture based on slot position (uses name of Node)
	var slot_number = name.replace("CardSlot", "")
	var texture_filepath = "res://Resources/Board/Number Spaces/" + slot_number + ".png"
	$SlotTexture.texture = load(texture_filepath)
	

func _input(event):
	if Input.is_action_just_released("click") and holding_card == true:
		holding_card = false
		if empty_space == false:
			make_card_visible()


func get_drag_data(_pos): #Retrieve info about the slot we are dragging
	
	var hand_slot = "Slot " + name.replace("CardSlot", "")
	
	var data = {
		"card_id": get_parent().get_slot_usage()[hand_slot],
		"hand_slot": hand_slot
	}
	
	
	# data needed:
		# origin parent node (e.g. is it in hand? if so is draggable)
		# player colour - is card blue or red?
		# any textures (background, character art, border art, number texture)
		# number information

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
	
	
	
	#If slot being hovered over has card in it -- gameboard could keep track of this?
		#return false
	#else if slot is empty
		#return true
	
#	var focused_space = get_parent().get_focused_space()
	
	var key = "Slot " + str(focused_space)
	if get_parent().get_slot_usage()[key] == "0": 
		empty_space = true
		return true
	else: 
		empty_space = false
		return false
		


func drop_data(_pos, data): #What happens when we drop an item in this slot
	
#	var focused_space_gameboard = get_parent().get_focused_space()
	
	get_parent().update_gameboard_slots(data["card_id"], focused_space)
	
	#Remove card ID from hand slot 
	
	


func make_card_visible():
	$CardTexture.visible = true

func make_card_invisible():
	$CardTexture.visible = false














func _on_CardSlot_mouse_exited() -> void:
	reset_focused_space()

### CardSlot 1 ###

func _on_CardSlot_mouse_entered() -> void:
	focused_space = int(name.replace("CardSlot", ""))

func reset_focused_space():
	focused_space = null
