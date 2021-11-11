extends GridContainer

var grid_num
var focused_space
const MIN_GRID_SIZE = 500 #500x500

var slot_usage = {
	"Slot 1": "0",
	"Slot 2": "0",
	"Slot 3": "0",
	"Slot 4": "0",
	"Slot 5": "0",
	"Slot 6": "0",
	"Slot 7": "0",
	"Slot 8": "0",
	"Slot 9": "0",
}

func _ready():
	set_grid_sizes()
	initialise_gameboard_slots("bsquall", 3)
	initialise_gameboard_slots("rsquall", 8)
	
	print_slot_usage()

func _input(event):
	if Input.is_action_just_pressed("click") and focused_space != null:
		set_neighbours()


func set_grid_sizes():
	for n in get_children():
		n.rect_min_size.x = MIN_GRID_SIZE
		n.rect_min_size.y = MIN_GRID_SIZE






func update_gameboard_slots(var card_id, var slot_num):
	var key = "Slot " + str(slot_num)
	slot_usage[key] = card_id
	update_focused_slot_texture(card_id, slot_num)

func update_focused_slot_texture(var card_id, var slot_num):
	var key = "Slot " + str(slot_num)
	
	var node_name = "CardSlot" + str(slot_num)
	
	var new_card_texture_filepath = "res://Resources/Cards/" + slot_usage[key] + ".jpg"
	
	var card_texture_node = get_node(node_name).get_node("CardTexture")
	
	card_texture_node.texture = load(new_card_texture_filepath)
	


func initialise_gameboard_slots(var card_id, var slot_num):
	var key = "Slot " + str(slot_num)
	slot_usage[key] = card_id
	initialise_slot_textures()


####### ONLY NEED TO UPDATE FOCUSED SLOT!!!!!!


func initialise_slot_textures():
	for n in slot_usage.values().size():
		
		var slot_number = n + 1
		var key = "Slot " + str(slot_number)
		
		var node_name = "CardSlot" + str(slot_number)
		var new_card_texture_filepath = "res://Resources/Cards/" + slot_usage[key] + ".jpg"
		
		var card_texture_node = get_node(node_name).get_node("CardTexture")
		
		card_texture_node.texture = load(new_card_texture_filepath)
		
		print(card_texture_node.name)

func print_slot_usage():
	for n in slot_usage.values().size():
		
		var slot_number = n + 1
		var key = "Slot " + str(slot_number)
		
	
		if slot_usage.values()[n] == "0":
			print("Slot " + str(slot_number) + " is empty")
		else:
			print("Slot " + str(slot_number) + " Card ID = " + slot_usage[key])





# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                              GETTER FUNCTIONS                                #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #

func get_slot_usage():
	return slot_usage

func get_focused_space():
	return focused_space



# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                                NEIGHBOUR LOGIC                               #
#	      EVENTUALLY WILL BE USED FOR WHICH CARDS ARE COMPARED AGAINST         #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #



func set_neighbours():
	var x = focused_space
	var C = columns
	var R = get_children().size() / columns 
	var neighbours
	
	### CORNERS ###
	
	#Top left corner (1)
	if x == 1:  
		neighbours = [x+1, x+C]
	
	#Top right corner (3)
	elif x == C:
		neighbours = [x-1, x+C]
	
	#Bottom left corner (7)
	elif x == ((R-1)*C) + 1:
		neighbours = [x-C, x+1]
	
	#Bottom right corner (9)
	elif x == (R * C):
		neighbours = [x-C, x-1]
	
	
	### EDGES ###
	
	#Top middle CardSlots (2)
	elif x > 1 and x < C: 
		neighbours = [x-1, x+1, x+C]
	
	
	#Left middke CardSlots (4)
	elif ((x-1) % C) == 0:
		neighbours = [x-C, x+1, x+C]
	
	
	#Right middle CardSlots (6)
	elif x % C == 0:
		neighbours = [x-C, x-1, x+C]
	
	#Bottom middle CardSlots (8)
	elif x - ((R - 1) * C) > 1 and x - ((R - 1) * C) < C:
		neighbours = [x-C, x-1, x+1]
	
	
	
	#Middle CardSlots (CardSlots not on edges)
	else:
		neighbours = [x-C, x-1, x+1, x+C]
	
	show_neighbours(neighbours)

func show_neighbours(var neighbours):
	var neighbour_check = ("For CardSlot " + str(focused_space) + ", Neighbours are: ")
	
	for n in neighbours.size():
			neighbour_check = neighbour_check + str(neighbours[n])
			
			if n != neighbours.size() - 1:
				neighbour_check = neighbour_check + ", "
	
	print (neighbour_check)


func set_grid_number():
	grid_num = name.substr(6,1)

func reset_focused_space():
	focused_space = null


###  //////////   SIGNALS   ////////// ###

### All CardSlots ###

#func _on_CardSlot_mouse_exited() -> void:
#	reset_focused_space()
#
#### CardSlot 1 ###
#
#func _on_CardSlot1_mouse_entered() -> void:
#	focused_space = 1
#
#### CardSlot 2 ###
#
#func _on_CardSlot2_mouse_entered() -> void:
#	focused_space = 2
#
#### CardSlot 3 ###
#
#func _on_CardSlot3_mouse_entered() -> void:
#	focused_space = 3
#
#### CardSlot 4 ###
#
#func _on_CardSlot4_mouse_entered() -> void:
#	focused_space = 4
#
#### CardSlot 5 ###
#
#func _on_CardSlot5_mouse_entered() -> void:
#	focused_space = 5
#
#### CardSlot 6 ###
#
#func _on_CardSlot6_mouse_entered() -> void:
#	focused_space = 6
#
#### CardSlot 7 ###
#
#func _on_CardSlot7_mouse_entered() -> void:
#	focused_space = 7
#
#### CardSlot 8 ###
#
#func _on_CardSlot8_mouse_entered() -> void:
#	focused_space = 8
#
#### CardSlot 9 ###
#
#func _on_CardSlot9_mouse_entered() -> void:
#	focused_space = 9
#
