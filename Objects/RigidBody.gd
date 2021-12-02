extends RigidBody
class_name RigidObject
# TODO : 

const MAX_FORCE = 550

signal body_hit
signal stasised
signal unstasised

export var pickable = false
export var rigid_h_color = Color("ffd700")
export var rigid_s_color = Color("85ff00")

onready var material = $MeshInstance.get_active_material(0)
onready var StasisFX = load("res://FX/stasisFX.tscn")
onready var StasisOutFX = load("res://FX/stasisOutFX.tscn")

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
#	if material.next_pass == null:
#		material.set_next_pass( preload("res://Runes/highlight.material") )
#		material.next_pass.resource_local_to_scene = true
#		print(self.name, material.next_pass)
	
	_on_rune_activated()
	
	UI.connect("rune_activated", self, "_on_rune_activated")
	UI.connect("rune_selected", self, "_on_rune_selected")


func _process(_delta):
	if UI.currentRune == UI.Rune.STASIS:
		unhighlight()


func hit( hit_pos, hit_amt ):
	var direction = (global_transform.origin - hit_pos ).normalized()
	#UI.debug.debug_draw_line( hit_pos, global_transform.origin )
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
	material.next_pass.set_shader_param("energy", 1)
	material.next_pass.set_shader_param("blinking", 1)
	
	var fx = StasisFX.instance()
	fx.translation = translation
	get_parent().add_child(fx)
	
	emit_signal("stasised")


func unstatue():
	stasised = false
	pickable = true
	mode = default_mode
	material.next_pass.set_shader_param("energy", 0)
	material.next_pass.set_shader_param("blinking", 0)
	
	var fx = StasisOutFX.instance()
	fx.translation = translation
	get_parent().add_child(fx)
	
	# accumulated force
	if accumulation.length() > 0.1:
		apply_central_impulse( accumulation )
		accumulation = Vector3.ZERO
	
	emit_signal("unstasised")


func highlight():
	material.next_pass.set_shader_param("highlightColor", selectColor)


func unhighlight():
	material.next_pass.set_shader_param("highlightColor", highlightColor)


func _on_rune_activated():
	if UI.runeActive:
		if type.has(UI.currentRune):
			unhighlight()
			material.next_pass.set_shader_param("energy", 1)
	elif not stasised:
		material.next_pass.set_shader_param("energy", 0)


func _on_rune_selected():
	if UI.currentRune == UI.Rune.STASIS and not stasised:
		material.next_pass.set_shader_param("energy", 0)
