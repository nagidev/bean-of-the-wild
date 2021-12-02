extends Spatial


export var enabled = true
export (NodePath) var switch
export var offset = Vector3.ZERO

onready var door = $Door

var speed = 10

func _ready():
	if switch:
		switch = get_node(switch)


func _process(delta):
	if switch:
		if switch.on:
			move(offset, delta)
		else:
			move(Vector3.ZERO, delta)
	else:
		move(offset, delta)


func _displacement(position, delta):
	return door.translation.direction_to(position).normalized() * speed * delta


func move(position, delta):
	door.translation = ( door.translation + _displacement(position, delta) ) if door.translation.distance_to(position) > 0.1 else position
