extends Control


onready var anim = $AnimationPlayer


func _ready():
	$VBoxContainer/ContinueButton.connect("button_up", self, "restart")
	$VBoxContainer/QuitButton.connect("button_up", self, "quit")


func showScreen():
	anim.play("show")
	yield(anim, "animation_finished")
	$VBoxContainer/ContinueButton.grab_focus()


func restart():
	anim.play("hide")
	yield(anim, "animation_finished")
	Global.reset()
	UI.anim.play('fadeOut')


func quit():
	anim.play("hide")
	yield(anim, "animation_finished")
	UI.start.init()
