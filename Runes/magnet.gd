extends Spatial

# NOTE : xform ( world space position ), xform_inv ( relative position )
# TODO : 

export var enabled = true
export (NodePath) var player

onready var raycast = $RayCast
onready var pointer = $Pointer
onready var skeleton = $Skeleton
onready var endPos = $EndPos
onready var startPos = $StartPos
onready var animation = $AnimationPlayer


var startBone = null
var endBone = null
var interactObject = null


func _ready():
	player = get_node(player)
	startBone = skeleton.find_bone("bone_0")
	endBone = skeleton.find_bone("bone_1")
	hide()
	$Skeleton/MagMesh.show()
	UI.connect("rune_changed", self, "_on_rune_changed")


func _process(_delta):
	if (not enabled) or Global.cutscene or not Global.alive:
		return
	
	# start position
	var rest = skeleton.get_bone_rest(startBone)
	var offset = rest.xform_inv(startPos.transform.origin) + skeleton.transform.origin #rest.xform(-skeleton.transform.origin)
	var pose = rest.translated(offset)
	skeleton.set_bone_rest(startBone, pose)
	
	# end position
	rest = skeleton.get_bone_rest(endBone)
	offset = rest.xform_inv(endPos.transform.origin) + skeleton.transform.origin
	pose = rest.translated(offset)
	skeleton.set_bone_rest(endBone, pose)
	
#	var startLoc = global_transform.origin
#	var midLoc = skeleton.global_transform.origin
#	var endLoc = endPos.global_transform.origin
#	UI.debug.debug_draw_line( player.global_transform.origin, startLoc )
#	UI.debug.debug_draw_line( startLoc, midLoc, false )
#	UI.debug.debug_draw_line( midLoc, endLoc, false )
	
	if UI.currentRune == UI.Rune.MAGNESIS:
		# activate if not already
		if Input.is_action_just_pressed("activate"):
			if UI.runeActive:
				deactivate()
			else:
				activate()
				return
		
		# interaction
		if UI.runeActive and raycast.is_colliding() and interactObject == null:
			var collider = raycast.get_collider()
			
			if collider is Metal:
				UI.aim()
				
				collider.highlight()
				
				if Input.is_action_just_pressed("interact"):
					# pickup metal object
					pointer.global_transform.origin = raycast.get_collision_point()
					pointer.translation.z += raycast.get_collision_point().distance_to( collider.global_transform.origin )
					if collider.pickUp( pointer ):
						interactObject = collider
						UI.runeSelected = true
						show()
					else:
						deactivate()
		
		# canceling
		if Input.is_action_just_released("cancel"):
			deactivate()
		
		# move pointer
		if Input.is_action_just_released("up"):
			pointer.translation.z += 1
		elif Input.is_action_just_released("down"):
			pointer.translation.z -= 1
		pointer.translation.z = clamp(pointer.translation.z, 4, 20)
	
	# Effect Posisiton Update
	if interactObject:
		var start = translation + global_transform.xform_inv( player.global_transform.origin + Vector3.UP * 2 )
		var end = translation + global_transform.xform_inv(interactObject.global_transform.origin - transform.origin)
		set_pos(start, end)
	else:
		set_pos(Vector3.ZERO, Vector3.ZERO)


func activate():
	UI.runeActive = true
	raycast.enabled = true


func deactivate():
	if interactObject != null:
		interactObject.drop()
		UI.runeSelected = false
		interactObject = null
		hide()
	UI.runeActive = false
	raycast.enabled = false


func set_pos(startPosition, endPosition):
	startPos.translation = startPosition
	endPos.translation = endPosition


func _on_rune_changed():
	if UI.currentRune != UI.Rune.MAGNESIS:
		deactivate()
