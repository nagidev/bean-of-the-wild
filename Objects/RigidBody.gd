extends RigidBody
class_name RigidObject


const MAX_FORCE = 550

signal body_hit
signal stasised
signal unstasised

export var pickable = true
export var rigid_h_color = Color("ffd700")
export var rigid_s_color = Color("a1ff00")

onready var material = $MeshInstance.get_active_material(0)

var default_mode = RigidBody.MODE_RIGID
var type = [UI.Rune.STASIS]
var stasised = false
var accumulation = Vector3.ZERO
var highlightColor = rigid_h_color
var selectColor = rigid_s_color

func _ready():
	default_mode = mode
	contact_monitor = true
	can_sleep = false
	
	# highlight material
	if material.next_pass == null:
		material.next_pass = load("res://Runes/highlight.material")
		material.resource_local_to_scene = true
		material.next_pass.resource_local_to_scene = true
	
	material.next_pass.set_shader_param("Energy", 0)
	
	UI.connect("rune_activated", self, "_on_rune_activated")
	UI.connect("rune_selected", self, "_on_rune_selected")


func _process(delta):
	if UI.currentRune == UI.Rune.STASIS:
		unhighlight()


func hit( hit_pos, hit_amt ):
	var direction = (transform.origin - hit_pos ).normalized()
	#UI.debug.debug_draw_line( hit_pos, transform.origin )
	if stasised:
		var magnitude = accumulation.length() + hit_amt
		accumulation = direction * magnitude
		
		# cap force
		if accumulation.length() > MAX_FORCE:
			accumulation = accumulation.normalized() * MAX_FORCE
		
		#UI.debug.debug_draw_line( transform.origin, transform.origin + accumulation )
	else:
		apply_central_impulse( direction * hit_amt )
	
	emit_signal("body_hit")


func statue():
	stasised = true
	pickable = false
	mode = RigidBody.MODE_STATIC
	material.next_pass.set_shader_param("Energy", 1)
	# TODO : show some fx here
	emit_signal("stasised")


func unstatue():
	stasised = false
	pickable = true
	mode = default_mode
	material.next_pass.set_shader_param("Energy", 0)
	# TODO : show some release fx here
	
	# accumulated force
	if accumulation.length() > 0.1:
		apply_central_impulse( accumulation )
		accumulation = Vector3.ZERO
	
	emit_signal("unstasised")


func highlight():
	material.next_pass.set_shader_param("HighlightColor", selectColor)


func unhighlight():
	material.next_pass.set_shader_param("HighlightColor", highlightColor)


func _on_rune_activated():
	if UI.runeActive:
		if type.has(UI.currentRune):
			unhighlight()
			material.next_pass.set_shader_param("Energy", 1)
	elif not stasised:
		material.next_pass.set_shader_param("Energy", 0)


func _on_rune_selected():
	if UI.currentRune == UI.Rune.STASIS and not stasised:
		material.next_pass.set_shader_param("Energy", 0)
