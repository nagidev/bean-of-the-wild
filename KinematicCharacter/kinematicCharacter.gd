class_name Player
extends KinematicBody
# TODO : 

export var god_mode = false

export var speed = 10
export var acceleration = 7
export (float, 0.0, 100.0) var gravity = 19.6
export (int, 0, 100) var jump = 10
export (int, 0, 200) var mass = 2
export var mouse_sensitivity = 0.2
export var joystick_sensitivity = 2
export var angular_vel = 16
export var max_angle = 75
export var min_angle = -80
export var push_force = 10

onready var pivot = $Pivot
onready var cam_arm = $Pivot/CamArm
onready var sword  =$Sword
onready var hand = $Hand
onready var magnet = $Pivot/CamArm/magnet
onready var iceicebaby = $Pivot/CamArm/iceicebaby

var direction = Vector3()
var velocity = Vector3()
var cam_rot = Vector3()

func _ready():
	pivot.set_as_toplevel(true)
	
	$Head.connect("body_entered", self, "on_head_damaged")


func _process(delta):
	# cutscene or death
	if Global.cutscene or not Global.alive:
		direction = Vector3.ZERO
		return
	# input
	direction = Vector3(
		Input.get_action_strength("left") - Input.get_action_strength("right"),
		0,
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	).rotated(Vector3.UP, pivot.global_transform.basis.get_euler().y).normalized()
	
	cam_rot.y -= Input.get_joy_axis(0, JOY_AXIS_2) * joystick_sensitivity
	cam_rot.x -= Input.get_joy_axis(0, JOY_AXIS_3) * joystick_sensitivity
	
	if Input.is_action_pressed("shield"):
		cam_rot.x = rad2deg(lerp_angle(deg2rad(cam_rot.x), rotation.x, angular_vel * delta))
		cam_rot.y = rad2deg(lerp_angle(deg2rad(cam_rot.y), rotation.y, angular_vel * delta))
	elif UI.runeActive:
		rotation.y = lerp_angle(rotation.y, pivot.rotation.y, angular_vel * delta)
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("forward") or Input.is_action_pressed("backward"):
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), angular_vel * delta)


func _physics_process(delta):	
	
	# gravity
	var snap = Vector3.DOWN
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_pressed("jump") and Global.alive:
		velocity.y = jump * 4 if god_mode else jump
		snap = Vector3.ZERO
	
	if is_on_ceiling():
		velocity.y = 0
	
	# velocity
	velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	
#	velocity = move_and_slide(velocity + (get_floor_velocity() * delta * 4), Vector3.UP, true, 4, PI/4, false)
	velocity = move_and_slide_with_snap(velocity, snap, Vector3.UP, true, 4, PI/4, false)
	
	if Global.alive:
		# pivot motion
		pivot.translation = translation
	
		# camera rotation
		cam_rot.x = clamp(cam_rot.x, min_angle, max_angle)
		pivot.rotation_degrees.y = cam_rot.y
		cam_arm.rotation_degrees.x = cam_rot.x
	
	
	# rigidBody collision
	for index in get_slide_count():
		var collision = get_slide_collision( index )
		
		if collision.collider is RigidBody:
			var force = -collision.normal * mass/collision.collider.mass * push_force
			collision.collider.apply_central_impulse( force )
			


func _input(event):
	# cutscene or death
	if Global.cutscene or not Global.alive:
		return
	# rotation
	if event is InputEventMouseMotion:
		cam_rot.x -= event.relative.y * mouse_sensitivity
		cam_rot.y -= event.relative.x * mouse_sensitivity
	
	if event.is_action_pressed("attack"):
		sword.attack()


func hurt(damage):
	if not Global.alive or god_mode:
		return
	Global.damage(damage)


func on_head_damaged(body):
	if body is RigidObject and body != hand.holding:
		var damage = int( (body.mass * body.linear_velocity.length()) * 0.01 )
		if damage > 0:
			hurt(damage)

