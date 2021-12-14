extends Button

func _ready():
	add_to_group("hand_selection")
	disable_button()

func enable_button():
	disabled = false
	visible = true

func disable_button():
	disabled = true
	visible = false

