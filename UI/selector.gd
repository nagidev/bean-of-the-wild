extends Container


onready var container = $HBoxContainer
onready var currentRune = get_node("../CurrentRune")
onready var button_fade = preload("res://UI/button_fade.material")

var selected = null


func _ready():
	for button in container.get_children():
		button.material = button_fade


func set_focus( idx ):
	var center_pos = get_viewport_rect().size.x / 2
	selected = container.get_child( idx )
	selected.grab_focus()
	rect_position.x = lerp(rect_position.x, center_pos - selected.rect_position.x - selected.rect_size.x*0.5, 0.5)
	
	# set corner icon
	currentRune.texture = selected.texture_normal
