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
	
	add_to_group("neighbour_comp")
	
	set_grid_sizes()
	initialise_gameboard_slots("squallb", 3)
	initialise_gameboard_slots("squallr", 8)
	initialise_gameboard_slots("squallb", 1)
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
		print_neighbours(set_neighbours(get_focused_space()))

# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                               GAMEBOARD LOGIC                                #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #


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

func get_focused_space():
	for n in get_children():
		if n.focused_space != null:
			return n.focused_space


# //////////////////////////////////////////////////////////////////////////// #
#                                                                              #
#                                NEIGHBOUR LOGIC                               #
#         EVENTUALLY WILL BE USED FOR WHICH CARDS ARE COMPARED AGAINST         #
#                                                                              #
# //////////////////////////////////////////////////////////////////////////// #

func compare_against_neighbours(var card_id, var slot):
	#Get dictionary of neighbours (number of neighbour slot or null)
	var neighbours = set_neighbours(slot)
	
	#Get card values as a dictionary
	var id_num = card_id.substr(0, (card_id.length() - 1 ))
	var card_values = get_values_from_json(id_num)
	
	#Sets up neighbour ID (either ID# or null) and values to compare against
	var u_neighbour = "CardSlot" + str(neighbours["above"])
	var r_neighbour = "CardSlot" + str(neighbours["right"])
	var d_neighbour = "CardSlot" + str(neighbours["below"])
	var l_neighbour = "CardSlot" + str(neighbours["left"])
	
	var u_neighbour_id = set_neighbour_id(neighbours, "above")
	var r_neighbour_id = set_neighbour_id(neighbours, "right")
	var d_neighbour_id = set_neighbour_id(neighbours, "below")
	var l_neighbour_id = set_neighbour_id(neighbours, "left" )
	
	var u_neighbour_id_num = null
	var r_neighbour_id_num = null
	var d_neighbour_id_num = null
	var l_neighbour_id_num = null
	
	var u_neighbour_d_value = null
	var r_neighbour_l_value = null
	var d_neighbour_u_value = null
	var l_neighbour_r_value = null
	
	var u_neighbour_colour = null
	var r_neighbour_colour = null
	var d_neighbour_colour = null
	var l_neighbour_colour = null
	
	
	if u_neighbour_id != null:
		u_neighbour_id_num = u_neighbour_id.substr(0, u_neighbour_id.length() - 1)
		u_neighbour_d_value = get_values_from_json(u_neighbour_id_num)["d"]
		u_neighbour_colour = u_neighbour_id.substr(u_neighbour_id.length() - 1, 1)
	if r_neighbour_id != null:
		r_neighbour_id_num = r_neighbour_id.substr(0, r_neighbour_id.length() - 1)
		r_neighbour_l_value = get_values_from_json(r_neighbour_id_num)["l"]
		r_neighbour_colour = r_neighbour_id.substr(r_neighbour_id.length() - 1, 1)
	if d_neighbour_id != null:
		d_neighbour_id_num = d_neighbour_id.substr(0, d_neighbour_id.length() - 1)
		d_neighbour_u_value = get_values_from_json(d_neighbour_id_num)["u"]
		d_neighbour_colour = d_neighbour_id.substr(d_neighbour_id.length() - 1, 1)
	if l_neighbour_id != null:
		l_neighbour_id_num = l_neighbour_id.substr(0, l_neighbour_id.length() - 1)
		l_neighbour_r_value = get_values_from_json(l_neighbour_id_num)["r"]
		l_neighbour_colour = l_neighbour_id.substr(l_neighbour_id.length() - 1, 1)
	
	if u_neighbour_d_value != null: print("u_neighbour_d_value = " + str(u_neighbour_d_value) + ". Colour = " + u_neighbour_colour)
	if r_neighbour_l_value != null: print("r_neighbour_l_value = " + str(r_neighbour_l_value))
	if d_neighbour_u_value != null: print("d_neighbour_u_value = " + str(d_neighbour_u_value))
	if l_neighbour_r_value != null: print("l_neighbour_r_value = " + str(l_neighbour_r_value))
	
	#Set up placed card colour
	var card_colour = card_id.substr(card_id.length()-1, 1)
	print(card_colour)
	
	
	
	#STILL TO FINISH:
	
	#Check if neighbours are flippable
	
#	This currently activates for ALL neighbours, leading to null error when no card is in neighbouring slot
#	Need to check if slot is empty and use in below ifs
	
	
	
	if neighbours["above"] != null and u_neighbour_id != null:
		if u_neighbour_d_value < card_values["u"] and card_colour != u_neighbour_colour:
			u_neighbour_colour = get_node(u_neighbour).change_colour(u_neighbour_colour, card_colour)
	if neighbours["right"] != null and r_neighbour_id != null:
		if r_neighbour_l_value < card_values["r"] and card_colour != r_neighbour_colour:
			r_neighbour_colour = get_node(r_neighbour).change_colour(r_neighbour_colour, card_colour)
	if neighbours["below"] != null and d_neighbour_id != null:
		if d_neighbour_u_value < card_values["d"] and card_colour != d_neighbour_colour:
			d_neighbour_colour = get_node(d_neighbour).change_colour(d_neighbour_colour, card_colour)
	if neighbours["left"]  != null and l_neighbour_id != null:
		if l_neighbour_r_value < card_values["l"] and card_colour != l_neighbour_colour:
			l_neighbour_colour = get_node(l_neighbour).change_colour(l_neighbour_colour, card_colour)
	
	#etc etc for all 4 possible neighbours
	
	print(neighbours)







func set_neighbour_id(var neighbours, var direction):
	if neighbours[direction] != null:
		return get_node("CardSlot" + str(neighbours[direction])).get_card_id()
	else:
		return null

func get_values_from_json(var id_num):
	var value_dict = {}
	var file = File.new()
	file.open("res://Data/CardData.json", file.READ)
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	value_dict = data_parse.result
	
	if id_num != null:
		return value_dict[id_num]
	else: 
		return null


func set_neighbours(var slot):
	var x = slot                               #space being focused on
	var C = columns                            #columns
	var R = get_children().size() / columns    #rows
	var neighbours = {
		"above": null, 
		"right": null, 
		"below": null,
		"left" : null
		}
	
	# //////////////////////////////  CORNERS  ////////////////////////////// #
	
	#Top left corner (1)
	if x == 1:  
		
		neighbours["right"] = x+1
		neighbours["below"] = x+C
	
	#Top right corner (3)
	elif x == C:
		neighbours["below"] = x+C
		neighbours["left"]  = x-1 
		
	
	#Bottom left corner (7)
	elif x == ((R-1)*C) + 1:
		neighbours["above"] = x-C
		neighbours["right"] = x+1
	
	#Bottom right corner (9)
	elif x == (R * C):
		neighbours["above"] = x-C
		neighbours["left"]  = x-1
	
	# ///////////////////////////////  EDGES  /////////////////////////////// #
	
	#Top middle edge CardSlots (2)
	elif x > 1 and x < C: 
		neighbours["right"] = x+1
		neighbours["below"] = x+C
		neighbours["left"] = x-1
	
	#Left middle edge CardSlots (4)
	elif ((x-1) % C) == 0:
		neighbours["above"] = x-C
		neighbours["right"] = x+1
		neighbours["below"] = x+C
	
	#Right middle edge CardSlots (6)
	elif x % C == 0:
		neighbours["above"] = x-C 
		neighbours["below"] = x+C
		neighbours["left"]  = x-1
	
	#Bottom middle edge CardSlots (8)
	elif x - ((R - 1) * C) > 1 and x - ((R - 1) * C) < C:
		neighbours["above"] = x-C
		neighbours["right"] = x+1
		neighbours["left"]  = x-1 
	
	# ///////////////////////////////  MIDDLE  /////////////////////////////// #
	
	#Middle CardSlots (CardSlots not on edges)
	else:
		neighbours["above"] = x-C 
		neighbours["right"] = x+1
		neighbours["below"] = x+C
		neighbours["left"]  = x-1 
	
	return neighbours

func print_neighbours(var neighbours):
	var neighbour_print : String = ("For CardSlot " + str(get_focused_space()) + ", Neighbours are: ")
	
	if neighbours["above"] != null: neighbour_print += "Above: " + str(neighbours["above"]) + ", "
	if neighbours["right"] != null: neighbour_print += "Right: " + str(neighbours["right"]) + ", "
	if neighbours["below"] != null: neighbour_print += "Below: " + str(neighbours["below"]) + ", "
	if neighbours["left"]  != null: neighbour_print += "Left: "  + str(neighbours["left"])
	
	print (neighbour_print)

func set_grid_number():
	grid_num = name.substr(6,1)
