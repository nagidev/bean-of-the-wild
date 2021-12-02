extends KinematicBody
# TODO : make me stasisable like rotating platform

export var enabled = true
export (NodePath) var targetPositionNode
export (NodePath) var switch
export var loop = false

onready var timer = $Timer
onready var material = $MeshInstance.get_active_material(0)
onready var tween = Tween.new()
onready var original_pos = global_transform.origin

var speed = 4
var target_pos
var fade_speed = 4

func _ready():
	targetPositionNode = get_node(targetPositionNode)
	targetPositionNode.set_as_toplevel(true)
	target_pos = targetPositionNode.global_transform.origin
	
	if switch:
		switch = get_node(switch)


func _physics_process(delta):
	if not enabled:
		material.emission_energy = 0.0
		return

	if loop:
		if ( switch is NodePath ) or (switch and switch.on) :
			material.emission_energy = lerp(material.emission_energy, 1.0, fade_speed * delta)
			move(delta)
		else:
			material.emission_energy = lerp(material.emission_energy, 0.0, fade_speed * delta)
	elif switch:
		if switch.on:
			target_pos = targetPositionNode.global_transform.origin
			material.emission_energy = lerp(material.emission_energy, 1.0, fade_speed * delta)
		else:
			target_pos = original_pos
			material.emission_energy = lerp(material.emission_energy, 0.0, fade_speed * delta)
		move(delta)


func move(delta):
	if global_transform.origin.distance_to(target_pos) >= 0.1:
		global_transform.origin += global_transform.origin.direction_to(target_pos) * speed * delta
	
	if global_transform.origin.distance_to(target_pos) < 0.1:
		if loop and timer.is_stopped():
			timer.start()
			yield(timer, "timeout")
			target_pos = targetPositionNode.global_transform.origin if global_transform.origin.distance_to(original_pos) < 0.1 else original_pos
