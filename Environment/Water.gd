class_name Water
extends Area

export (NodePath) var mesh

var material = preload("res://Runes/highlight1.material")
var shader_energy = 0.0
var shader_speed = 20


func _ready():
	get_node(mesh).get_active_material(0).next_pass = material


func _process(delta):
	if UI.currentRune == UI.Rune.CRYONIS and UI.runeActive:
		shader_energy = lerp(shader_energy, 1, shader_speed * delta)
	else:
		shader_energy = lerp(shader_energy, 0, shader_speed * delta)
	shader_energy = clamp(shader_energy, 0.0, 1.0)
	material.set_shader_param("Energy", shader_energy)
