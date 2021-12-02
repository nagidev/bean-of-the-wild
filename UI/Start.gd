extends Control


onready var pointer = preload("res://UI/Pointer.png")
onready var buttons = $VBoxContainer


var time = 0.0


func _ready():
	for button in buttons.get_children():
		button.connect("focus_entered", self, "_on_button_focussed", [button])
		button.connect("focus_exited", self, "_on_button_unfocussed", [button])
		button.connect("button_up", self, "_on_button_pressed", [button])


func _process(delta):
	time += delta
	
	$ArtBG.rect_position.x = -240 + sin(time * 0.5) * 10.0
	$ArtFG.rect_position.x = -240 + cos(time * 0.6) * 10.5


func init():
	show()
	
	UI.anim.play('fadeOut')
	yield(UI.anim, 'animation_finished')
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	buttons.get_child(0).grab_focus()


func start_game():
	UI.anim.play('fadeIn')
	yield(UI.anim, 'animation_finished')
	
	hide()
	
	Global.reset()
	
	UI.anim.play('fadeOut')
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func quit_game():
	UI.anim.play('fadeIn')
	yield(UI.anim, 'animation_finished')
	
	Global.quit()


func _on_button_focussed(button):
	button.icon = pointer


func _on_button_unfocussed(button):
	button.icon = null


func _on_button_pressed(button):
	match(button.name):
		"StartButton":
			start_game()
		"QuitButton":
			quit_game()
