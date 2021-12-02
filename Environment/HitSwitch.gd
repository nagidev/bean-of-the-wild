extends Switch


export (NodePath) var link

onready var material = $MeshInstance.get_active_material(0)


func _ready():
	if link:
		link = get_node(link)


func _process(_delta):
	if not link is NodePath:
		on = link.on
	
	if on:
		material.set_shader_param("switch_val", 1.0)
	else:
		material.set_shader_param("switch_val", 0.0)


func hit():
	if link is NodePath:
		on = not on
	else:
		link.on = not link.on
