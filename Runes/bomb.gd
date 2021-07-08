class_name Bomb
extends RigidBody


export (UI.Rune) var type = UI.Rune.BOMB_ROUND
export var throwForce = 15
export var max_distance = 5


onready var Explosion = preload("res://FX/explosion.tscn")


var hand = null
var pickable = true


func _ready():
	can_sleep = false
	gravity_scale = 2.0


func explode():
	var explosion = Explosion.instance()
	get_parent().add_child(explosion)
	explosion.global_transform.origin = global_transform.origin
	queue_free()


func cancel():
	# TODO : disappear fx
	queue_free()
