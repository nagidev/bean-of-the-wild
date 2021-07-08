extends RigidObject

var time = 0

func _process(delta):
	if stasised:
		return
	time += delta
	transform.origin.x = 2 + sin(time) * 6
#	rotate( Vector3.UP, delta )
