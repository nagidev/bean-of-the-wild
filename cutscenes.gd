extends Spatial

export var enabled = true

onready var anim = $AnimationPlayer


func _input(event):
	if event.is_action_released("jump"):
		anim.play("stop")


func start():
	if not enabled:
		anim.play("stop")
		return
	
	anim.play("cutscene_0")
	Global.cutscene = true


func end():
	Global.cutscene = false
