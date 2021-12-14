extends GridContainer

func _ready():
	var card_collection = initialise_card_dict()
	add_slots_to_library(card_collection)

#This function doesn't really count 'collection' size, it counts the number of
#cards that have been added to the game. Will need to be changed when creating 
#user accounts, but is fine for prototyping purposes
func initialise_card_dict():
	var card_dict = {}
	var file = File.new()
	file.open("res://Data/CardData.json", file.READ)
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	card_dict = data_parse.result 
	
	return card_dict


func add_slots_to_library(var card_collection : Dictionary):
	var keys = []
	
	#Adds instance of CardSlot as a child of CardLibrary for each card in collection
	for n in card_collection:
		var scene = load("res://Main Scenes/CardSlot.tscn").instance()
		add_child(scene)
		
		#Creates array of keys (card names) to loop through
		keys.append(n)
	
	print(keys)
	print(keys[0], " , ", keys[1])
	
	var index_count = 0
	
	for n in get_children():
		
		
		#Renames CardSlot nodes as per scene tree convention
		n.name = "CardSlot" + str(index_count+1)
		
		#assign ID to slot
		var slot_id = str(keys[index_count]) + "b"
		n.slot_id = slot_id
		
		#update slot texture
		n.update_slot_texture()
		
		index_count += 1
		
