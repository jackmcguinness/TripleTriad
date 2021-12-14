extends VBoxContainer

var slot_usage = {
	"Slot 1": "0",
	"Slot 2": "0",
	"Slot 3": "0",
	"Slot 4": "0",
	"Slot 5": "0",
}

func _process(delta: float) -> void:
	
	if is_connected("test_signal", self, "_on_CardSlot_test_signal"):
		print("connected")

func _ready():
	
	initialise_hands()

func initialise_hands():
	if name == "HandBlue":
		#Set player hand
		slot_usage = set_player_hand()
		#Update slot IDs for player
		update_slot_ids()
		update_slot_textures()
	elif name == "HandRed":
		#Set opponent hand
		set_opponent_hand()
		#Update slot IDs for opponent
		update_slot_ids()


func set_player_hand():
	if name == "HandBlue":
		print(PLAYER_HAND_DATA.player_hand)
		return PLAYER_HAND_DATA.player_hand

func set_opponent_hand():
	if name == "HandRed":
#		update_hand_slots("edea", 1)
#		update_hand_slots("rinoa", 2)
#		update_hand_slots("rinoa", 3)
#		update_hand_slots("rinoa", 4)
#		update_hand_slots("rinoa", 5)
		
		create_random_hand("FF8")
		print("Slot usage: " + str(slot_usage))
		update_slot_textures()

func create_random_hand(var faction):
	#open relevant json file for faction and create hand 
	var faction_dict = initialise_card_dict()
	
	for n in get_child_count():
		#Get all values in dictionary as an Array
		var cards_to_select = faction_dict.keys()
		print(cards_to_select)
		#Randomly select a card
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var random_card = rng.randi_range(0, cards_to_select.size() - 1)
		#Update hand slot n with randomly selected card
		update_hand_slots(cards_to_select[random_card], n+1)
		#Remove selected card from dictionary of available cards (faction_dict)
		faction_dict.erase(str(cards_to_select[random_card]))

func initialise_card_dict():
	var card_dict = {}
	var file = File.new()
	file.open("res://Data/CardData.json", file.READ) #EDIT THIS FILEPATH TO READ FACTION
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	card_dict = data_parse.result 
	return card_dict

func update_hand_slots(var card_name, var slot_num):
	
	
	#Sets card_id for each card based on colour (adds b or r to name)
	var card_id = null
	
	if name == "HandBlue":
		card_id = card_name + "b"
	elif name == "HandRed":
		card_id = card_name + "r"
	
	#Sets card_id to slot_usage dictionary field and updates textures
	var key = "Slot " + str(slot_num)
	slot_usage[key] = card_id
#	update_slot_textures()

func update_slot_textures():
	for n in (slot_usage.size()):
		
		if n == 5:
			break
		
		var slot_number = n + 1
		var key = "Slot " + str(slot_number)
		
		var node_name = "CardSlot" + str(slot_number)
		var new_card_texture_filepath = "res://Resources/Cards/" + slot_usage[key] + ".jpg"
		
		var card_texture_node = get_node(node_name).get_node("CardTexture")
		
		card_texture_node.texture = load(new_card_texture_filepath)
		

func update_slot_ids():
	for n in get_children():
		var key = n.name.replace("CardSlot", "Slot ")
		if slot_usage != null:
			n.slot_id = slot_usage[key]

func get_slot_usage():
	return slot_usage
