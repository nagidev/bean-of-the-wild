extends Node


var cutscene = true
var alive = true
var maxHearts = 10
var hearts = maxHearts


func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		OS.window_fullscreen = not OS.window_fullscreen


func change_scene(path, anim):
	if anim:
		UI.anim.play('fadeIn')
		yield(UI.anim, 'animation_finished')
	
	get_tree().change_scene(path)
	
	if anim:
		UI.anim.play('fadeOut')


func reset():
	get_tree().reload_current_scene()
	alive = true
	hearts = maxHearts
	UI.init()


func quit():
	get_tree().quit()


func damage(val):
	hearts = max(0, hearts - val)
	alive = (hearts > 0)
	UI.healthDisp.update()
	
	if not alive:
		UI.gameover.showScreen()
