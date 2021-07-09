extends Area


export var threshold_mass = 10
export var throwForce = 15

onready var hand = $Position3D
onready var raycast = $RayCast

var holding = null
var hand_offset = Vector3.ZERO

func _process(_delta):
	if holding:
		if raycast.is_colliding():
			_set_hand_offset()
		holding.global_transform = hand.global_transform
		holding.global_transform.origin += hand_offset


func _input(_event):
	if UI.runeActive:
		return
	var bodies = get_overlapping_bodies()
	var object
	if bodies.size() > 0:
		object = bodies.front()
		# show "Pickup (E)"
	else:
		object = null
	
	if Input.is_action_just_released("interact"):
		if object:
			pickup(object)
		else:
			drop()
	elif Input.is_action_just_pressed("throw"):
		throw()
	elif Input.is_action_just_pressed("activate") or Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("attack"):
		if holding is Bomb and UI.currentRune == holding.type:
			pass
		else:
			drop()


func _set_hand_offset():
	if holding:
		if raycast.is_colliding() and raycast.get_collider() == holding:
			hand_offset = hand.global_transform.origin - raycast.get_collision_point()
		
		hand_offset.x = 0
		hand_offset.z = 0


func pickup(item):
	if (item is RigidObject or item is Bomb) and item.pickable and item.mass <= threshold_mass:
		# pickup object
		if holding:
			drop()
		holding = item
		holding.mode = RigidBody.MODE_KINEMATIC
		hand_offset = Vector3.ZERO


func drop():
	if holding:
		holding.mode = RigidBody.MODE_RIGID
		holding.apply_central_impulse(holding.transform.basis.z * holding.mass * 2)
		holding = null


func throw():
	if holding:
		var force = holding.transform.rotated(holding.transform.basis.x, -PI/6).basis.z * throwForce * holding.mass
		holding.mode = RigidBody.MODE_RIGID
		holding.apply_impulse(transform.basis.z, force)
		holding.angular_velocity = Vector3.ZERO
		holding = null
