extends PanelContainer

func get_drag_data(_pos): #Retrieve info about the slot we are dragging
	
	var data = {}
	# data needed:
		# origin parent node (e.g. is it in hand? if so is draggable)
		# player colour - is card blue or red?
		# any textures (background, character art, border art, number texture)
		# number information

	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = $CardImage.texture
	drag_texture.rect_size = rect_size
	
	set_drag_preview(drag_texture)
	
	return data


func can_drop_data(_pos, data): #Check if we can drop an item in this slot
	
	
	
	#If slot being hovered over has card in it -- gameboard could keep track of this?
		#return false
	#else if slot is empty
		#return true
		
	return true
	return false

func drop_data(_pos, data): #What happens when we drop an item in this slot
	
	pass	
