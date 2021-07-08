extends Spatial


onready var area = $Area
onready var anim = $AnimationPlayer

var bodies = []


func _ready():
	hide()
	area.connect("body_entered", self, "_on_pointer_body_entered")
	area.connect("body_exited", self, "_on_pointer_body_exited")


func update(raycast):
	# show pointer
	show()
	if bodies.size() > 0:
		anim.play("idle")
	else:
		anim.play("rise")
	
	# set position
	global_transform.origin = raycast.get_collision_point()
	
	# set angle (Y)
	global_transform.basis.y = raycast.get_collision_normal()
	
	# set angle (Z)
	if raycast.get_collision_normal().dot(Vector3.UP) > 0.9:
		global_transform.basis.z = raycast.global_transform.basis.y * -1
	else:
		global_transform.basis.z = raycast.get_collider().global_transform.basis.x * -1
	
	# set angle (X)
	global_transform.basis.x = global_transform.basis.z.cross(global_transform.basis.y)
	
	global_transform.basis = global_transform.basis.orthonormalized()


func _on_pointer_body_entered(body):
	if not (body is RigidBody or body is Water):
		if not bodies.has(body):
			bodies.append(body)


func _on_pointer_body_exited(body):
	if not (body is RigidBody or body is Water):
		if bodies.has(body):
			bodies.erase(body)
