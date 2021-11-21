extends GridContainer

var grid_num
const MIN_GRID_SIZE = 500 #500x500


# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                                INITIALISATIONS                               #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #

var slot_usage = {
	"Slot 1": null,
	"Slot 2": null,
	"Slot 3": null,
	"Slot 4": null,
	"Slot 5": null,
	"Slot 6": null,
	"Slot 7": null,
	"Slot 8": null,
	"Slot 9": null,
}

func get_slot_usage(): #this can be deleted after individual slot ID handling is implemented
	return slot_usage

func set_grid_sizes():
	for n in get_children():
		n.rect_min_size.x = MIN_GRID_SIZE
		n.rect_min_size.y = MIN_GRID_SIZE

func _ready():
	set_grid_sizes()
	initialise_gameboard_slots("bsquall", 3)
	initialise_gameboard_slots("rsquall", 8)
	update_slot_ids()
	
	print_slot_usage()

func initialise_gameboard_slots(var card_id, var slot_num):
	var key = "Slot " + str(slot_num)
	slot_usage[key] = card_id
	initialise_slot_textures()


func initialise_slot_textures():
	for n in slot_usage.values().size():
		
		var slot_number = n + 1
		var key = "Slot " + str(slot_number)
		
		var node_name = "CardSlot" + str(slot_number)
		var new_card_texture_filepath = "res://Resources/Cards/" + str(slot_usage[key]) + ".jpg"
		
		var card_texture_node = get_node(node_name).get_node("CardTexture")
		
		card_texture_node.texture = load(new_card_texture_filepath)
		

func update_slot_ids():
	for n in get_children():
		var key = n.name.replace("CardSlot", "Slot ")
		n.slot_id = slot_usage[key]

# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                                INPUT HANDLING                                #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #


func _input(event):
	if Input.is_action_just_pressed("click") and get_focused_space() != null:
		set_neighbours()

# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                               GAMEBOARD LOGIC                                #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #

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

func print_slot_usage():
	for n in slot_usage.values().size():
		
		var slot_number = n + 1
		var key = "Slot " + str(slot_number)
		
	
		if slot_usage.values()[n] == null:
			print("Slot " + str(slot_number) + " is empty")
		else:
			print("Slot " + str(slot_number) + " Card ID = " + slot_usage[key])


# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                              GETTER FUNCTIONS                                #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #

#func get_slot_usage():
#	return slot_usage

func get_focused_space():
	for n in get_children():
		if n.focused_space != null:
			return n.focused_space




# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                                NEIGHBOUR LOGIC                               #
#	      EVENTUALLY WILL BE USED FOR WHICH CARDS ARE COMPARED AGAINST         #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #



func set_neighbours():
	var x = get_focused_space()
	var C = columns
	var R = get_children().size() / columns 
	var neighbours
	
	# //////////////////////////////  CORNERS  ////////////////////////////// #
	
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
	
	
	# ///////////////////////////////  EDGES  /////////////////////////////// #
	
	#Top middle edge CardSlots (2)
	elif x > 1 and x < C: 
		neighbours = [x-1, x+1, x+C]
	
	
	#Left middle edge CardSlots (4)
	elif ((x-1) % C) == 0:
		neighbours = [x-C, x+1, x+C]
	
	
	#Right middle edge CardSlots (6)
	elif x % C == 0:
		neighbours = [x-C, x-1, x+C]
	
	#Bottom middle edge CardSlots (8)
	elif x - ((R - 1) * C) > 1 and x - ((R - 1) * C) < C:
		neighbours = [x-C, x-1, x+1]
	
	
	# ///////////////////////////////  MIDDLE  /////////////////////////////// #
	
	#Middle CardSlots (CardSlots not on edges)
	else:
		neighbours = [x-C, x-1, x+1, x+C]
	
	print_neighbours(neighbours)


func print_neighbours(var neighbours):
	var neighbour_check = ("For CardSlot " + str(get_focused_space()) + ", Neighbours are: ")
	
	for n in neighbours.size():
			neighbour_check = neighbour_check + str(neighbours[n])
			
			if n != neighbours.size() - 1:
				neighbour_check = neighbour_check + ", "
	
	print (neighbour_check)


func set_grid_number():
	grid_num = name.substr(6,1)
