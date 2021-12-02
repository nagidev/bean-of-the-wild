extends Area
# TODO : better force calculation
const MAX_POWER = 1000

export var force = 50

onready var anim = $AnimationPlayer
onready var material = $MeshInstance.get_active_material(0)

var scanned = false
var size = 0
var t = 1.0

func _ready():
	$Particles.emitting = true
	size = get_node("CollisionShape").shape.radius
	material.set_shader_param("HighlightColor", Color("0880ff"))
	connect("body_entered", self, "_on_body_entered")
	anim.connect("animation_finished", self, "_on_finished")


func explode():
	anim.play("explode")


func _on_body_entered(body):	
	var direction = ( body.global_transform.origin - global_transform.origin ).normalized()
	var distance = max(( global_transform.origin.distance_to(body.global_transform.origin) )/size, 0.01)
	var power = min((force / pow(distance, 2)), MAX_POWER)
	if body is RigidObject:
		body.hit( global_transform.origin, power )
	elif body is Switch:
		body.hit()
	elif body is Player:
		body.velocity = direction * power
		body.velocity.y *= 0.1
		var damage = int( power * 0.1 )
		body.hurt(damage)
	elif body is IceBlock:
		body.destroy_block()
	elif body is Blockade:
		body.destroy()
	elif body is RigidBody:
		body.apply_central_impulse(direction * power)


func _on_finished(_anim_name):
	queue_free()
