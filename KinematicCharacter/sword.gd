extends Area


export var damage = 50

onready var anim = $AnimationPlayer


func _ready():
	connect("body_entered", self, "_on_body_entered")


func attack():
	if anim.is_playing():
		return
	anim.play("attack")


func _on_body_entered( body ):
	if body.has_method("hit"):
		body.hit( global_transform.origin, damage )
