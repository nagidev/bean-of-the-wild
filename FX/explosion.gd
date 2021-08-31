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
	print( "Signal connect: ", connect("body_entered", self, "_on_body_entered") == OK )
	print( "Signal connect: ", anim.connect("animation_finished", self, "_on_finished") == OK )


func _process(delta):
	t = max(t - delta * 6, 0.0)
	material.set_shader_param("Energy", t)


func _on_body_entered(body):
	#print(body.name + ': ' + str(body is RigidBody))
	var direction = ( body.global_transform.origin - global_transform.origin ).normalized()
	var distance = max(( body.global_transform.origin - global_transform.origin ).length()/size, 0.01)
	var power = min((force / pow(distance, 2)), MAX_POWER)
	if body is RigidObject:
		body.hit( global_transform.origin, power )
	elif body is RigidBody:
		body.apply_central_impulse(direction * power)
	elif body is Player:
		print("direction: ", direction, "\ndistance: ", distance, "\npower: ", power)
		body.velocity = direction * power
		body.velocity.y *= 0.1
	elif body is IceBlock:
		body.destroy_block()


func _on_finished(_anim_name):
	queue_free()
