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
	update_hand_slots("edea", 1)
	update_hand_slots("edea", 2)
	update_hand_slots("irvine", 3)
	update_hand_slots("irvine", 4)
	update_hand_slots("squall", 5)
	update_slot_ids()

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
	update_slot_textures()

func update_slot_textures():
	for n in slot_usage.values().size():

		var slot_number = n + 1
		var key = "Slot " + str(slot_number)

		var node_name = "CardSlot" + str(slot_number)
		var new_card_texture_filepath = "res://Resources/Cards/" + slot_usage[key] + ".jpg"

		var card_texture_node = get_node(node_name).get_node("CardTexture")

		card_texture_node.texture = load(new_card_texture_filepath)
		

func update_slot_ids():
	for n in get_children():
		var key = n.name.replace("CardSlot", "Slot ")
		n.slot_id = slot_usage[key]

func get_slot_usage():
	return slot_usage
