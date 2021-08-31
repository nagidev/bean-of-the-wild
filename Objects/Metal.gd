extends RigidObject
class_name Metal
# TODO : more angles when selecting, color off when RuneSelect

export var metal_h_color = Color("ff0061")
export var metal_s_color = Color("ffd700")

var targetObject = null


func _ready():
	collision_layer = 32
	collision_mask = 47
	
	type.append( UI.Rune.MAGNESIS )
	
	UI.connect("rune_changed", self, "_on_rune_changed")
	connect("unstasised", self, "_on_rune_changed")


func _integrate_forces(state):
	if targetObject:
		# set position
		state.linear_velocity = state.linear_velocity.linear_interpolate((targetObject.global_transform.origin - state.transform.origin) * 4, 0.1)
		
		# set rotation
		var target_basis = targetObject.global_transform.basis
		target_basis.y = Vector3.UP
		target_basis.z = global_transform.basis.z.project( target_basis.z )
		target_basis = target_basis.orthonormalized()
		var angular_vel = global_transform.basis.y.cross( target_basis.y ) + global_transform.basis.z.cross( target_basis.z )
		state.angular_velocity = angular_vel
		state.angular_velocity = state.angular_velocity * 3


func _process(delta):
	if UI.currentRune == UI.Rune.MAGNESIS and not targetObject and not stasised:
		unhighlight()


func pickUp( tObject ):
	if stasised:
		return false
	targetObject = tObject
	pickable = false
	return true


func drop():
	targetObject = null
	pickable = true
	unhighlight()


func _on_rune_changed():
	if UI.currentRune == UI.Rune.MAGNESIS and not stasised:
		highlightColor = metal_h_color
		selectColor = metal_s_color
	elif UI.currentRune == UI.Rune.STASIS:
		highlightColor = rigid_h_color
		selectColor = rigid_s_color


func _on_rune_selected():
	._on_rune_selected()
	if UI.currentRune == UI.Rune.MAGNESIS and not targetObject and not stasised:
		material.next_pass.set_shader_param("Energy", 0)
