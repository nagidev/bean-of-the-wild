extends Area


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body is Player:
		Global.damage(1000)
	elif body is RigidObject:
		body.queue_free()
