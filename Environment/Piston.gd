extends Spatial


export var enabled = true
export (NodePath) var switch
export var loop = false
export var speed = 4

onready var body = $KinematicBody
onready var timer = $Timer

var original_pos = 0
var active_pos = 4
var target_pos = active_pos


func _ready():
	if switch:
		switch = get_node(switch)
	original_pos = body.translation.y


func _process(delta):
	if not enabled:
		return
	
	if loop:
		if ( switch is NodePath ) or (switch and switch.on) :
			move(delta)
	elif switch:
		if switch.on:
			target_pos = active_pos
		else:
			target_pos = original_pos
		move(delta)


func move(delta):
	if abs(body.translation.y - target_pos) >= 0.1:
		body.translation.y += (target_pos - body.translation.y) * speed * delta
	else:
		if loop and timer.is_stopped():
			timer.start()
			yield(timer, "timeout")
			target_pos = active_pos if abs(body.translation.y - original_pos) < 0.1 else original_pos
