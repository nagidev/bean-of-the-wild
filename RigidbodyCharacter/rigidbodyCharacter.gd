extends RigidBody

export var speed = 10
export var mouse_sensitivity = 0.2

onready var pivot = $pivot
onready var label = $Label
onready var sauce = $sauce

var direction = Vector3()
var rotationY = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	# input
	direction = Vector3(
		Input.get_action_strength("left") - Input.get_action_strength("right"),
		0,
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	).rotated(Vector3.UP, rotation.y).normalized()
	
	sauce.rotation = -direction.cross(Vector3.UP)


func _integrate_forces(state):
	if Input.is_action_just_pressed("jump"):
		state.linear_velocity.y = 10
	
	if abs(rotationY) > 0:
		var xform = state.get_transform().rotated(Vector3.UP, rotationY)
		state.set_transform(xform)
		rotationY = 0
	
	if direction.length() > 0:
		var target_velocity = state.linear_velocity.linear_interpolate(-direction.rotated(Vector3.UP, rotation.y) * speed, 0.1)
		state.linear_velocity.x = target_velocity.x
		state.linear_velocity.z = target_velocity.z


func _input(event):
	if event is InputEventMouseMotion:
		rotationY = deg2rad(event.relative.x * -mouse_sensitivity)
		pivot.rotate_x(deg2rad(event.relative.y * -mouse_sensitivity))
		pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, -90, 90)
