extends RigidObject


func _physics_process(delta):
	if not stasised:
		rotation_degrees.x = wrapf( rotation_degrees.x + 50 * delta, 0, 360 )
