class_name Blockade
extends RigidBody

export var destructable = true
export (PackedScene) onready var ExplosionScene

func destroy():
	if (destructable and ExplosionScene):
		var explosion = ExplosionScene.instance()
		explosion.global_transform.origin = global_transform.origin
		get_parent().add_child(explosion)
	queue_free()
