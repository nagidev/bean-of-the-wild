class_name IceBlock
extends StaticBody
# TODO : 

signal block_destroying
signal block_destroyed

onready var anim = $AnimationPlayer
onready var material = $MeshInstance.get_active_material(0)

var highlighted = false


func _ready():
	material.next_pass.resource_local_to_scene = true
	material.next_pass.set_shader_param("HighlightColor", Color("ff0000"))
	material.next_pass.set_shader_param("Energy", 0)
	anim.play("Rise")


func _process(_delta):
	if highlighted:
		material.next_pass.set_shader_param("Energy", 1)
		highlighted = false
	else:
		material.next_pass.set_shader_param("Energy", 0)


func highlight():
	highlighted = true
	material.next_pass.set_shader_param("HighlightColor", Color("ff0000"))


func destroy_block():
	emit_signal("block_destroying")
	anim.play("Break")
	yield(anim, "animation_finished")
	emit_signal("block_destroyed")
	queue_free()
