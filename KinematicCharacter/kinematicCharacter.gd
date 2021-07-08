class_name Player
extends KinematicBody


export var speed = 10
export var acceleration = 7
export (float, 0.0, 100.0) var gravity = 19.6
export (int, 0, 100) var jump = 10
export (int, 0, 200) var mass = 2
export var mouse_sensitivity = 0.2
export var max_angle = 75
export var min_angle = -80

onready var pivot = $Pivot
onready var sword  =$Sword
onready var magnet = $Pivot/magnet
onready var iceicebaby = $Pivot/iceicebaby

var direction = Vector3()
var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	# input
	direction = Vector3(
		Input.get_action_strength("left") - Input.get_action_strength("right"),
		0,
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	).rotated(Vector3.UP, rotation.y).normalized()
	
	#debug.text = str(iceicebaby.get_node("RayCast").is_colliding())


func _physics_process(delta):	
	
	# gravity
	var snap = Vector3.DOWN
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("jump"):
		velocity.y = jump
		snap = Vector3.ZERO
	
	if is_on_ceiling():
		velocity.y = 0
	
	# velocity
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
#	velocity = move_and_slide(velocity + (get_floor_velocity() * delta * 4), Vector3.UP, true, 4, PI/4, false)
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, PI/4, false)
	
	# rigidBody collision
	for index in get_slide_count():
		var collision = get_slide_collision( index )
		
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse( -collision.normal * mass * velocity.length() )
			


func _input(event):
	# rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(event.relative.y * mouse_sensitivity))
		pivot.rotation_degrees.x = clamp(pivot.rotation_degrees.x, min_angle, max_angle)
	
	if event.is_action_pressed("attack"):
		sword.attack()

