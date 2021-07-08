extends Node


func _process(_delta):
	if Input.is_action_just_released("reset"):
		get_tree().reload_current_scene()
		UI._ready()
	elif Input.is_action_just_released("ui_cancel"):
		OS.window_fullscreen = not OS.window_fullscreen
