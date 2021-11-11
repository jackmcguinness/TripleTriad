extends VBoxContainer

var slot_usage = {
	"Slot 1": "0",
	"Slot 2": "0",
	"Slot 3": "0",
	"Slot 4": "0",
	"Slot 5": "0",
}

func _ready():
	update_hand_slots("bsquall", 3)
	update_hand_slots("rsquall", 1)
	update_hand_slots("bsquall", 4)


func update_hand_slots(var card_id, var slot_num):
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
		
		print(card_texture_node.name)

func get_slot_usage():
	return slot_usage
