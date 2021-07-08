extends Spatial


export var enabled = true
export (NodePath) var player

onready var raycast = $RayCast
onready var pointer = $Pointer
onready var skeleton = $Skeleton
onready var endPos = $EndPos
onready var animation = $AnimationPlayer


var startBone = null
var endBone = null
var endRest = Transform()
var interactObject = null


func _ready():
	player = get_node(player)
	startBone = skeleton.find_bone("bone_0")
	endBone = skeleton.find_bone("bone_1")
	endRest = skeleton.get_bone_rest(endBone)
	hide()
	$Skeleton/MagMesh.show()
	UI.connect("rune_changed", self, "_on_rune_changed")


func _process(_delta):
	if not enabled:
		return
	
	# start position
#	var startRest = skeleton.get_bone_rest(startBone)
#	var soffset = global_transform.xform_inv( player.transform.origin - transform.origin + Vector3.UP * 2 ).rotated(Vector3.LEFT, PI/2) - startRest.origin
#	var spose = startRest.translated(soffset)
##	startRest.origin = global_transform.xform( player.global_transform.rotated(Vector3.LEFT, PI/2).origin )
#	skeleton.set_bone_rest(startBone, spose)
	
	# end position
#	endRest = skeleton.get_bone_rest(endBone)
#	var offset = endPos.transform.rotated(Vector3.LEFT, PI/2).origin - endRest.origin
#	var pose = endRest.translated(offset)
#
#	skeleton.set_bone_rest(endBone, pose)
	
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
				collider.highlight()
				$UI/CrossAim.show()
				$UI/CrossDefault.hide()
				if Input.is_action_just_pressed("interact"):
					# pickup metal object
					pointer.global_transform.origin = raycast.get_collision_point()
					if collider.pickUp( pointer ):
						interactObject = collider
						UI.runeSelected = true
						show()
					else:
						deactivate()
			else:
				$UI/CrossAim.hide()
				$UI/CrossDefault.show()
		else:
			$UI/CrossAim.hide()
			$UI/CrossDefault.show()
		
		# canceling
		if Input.is_action_just_released("cancel"):
			deactivate()
		
		# move pointer
		if Input.is_action_just_released("up"):
			pointer.translation.z += 1
		elif Input.is_action_just_released("down"):
			pointer.translation.z -= 1
		pointer.translation.z = clamp(pointer.translation.z, 4, 20)
	
	# cancel rune
	if UI.currentRune != UI.Rune.MAGNESIS and Input.is_action_just_released("rune_select"):
		deactivate()
	
	# magnet fx
	if interactObject:
		var position = (interactObject.transform.origin - transform.origin)
		position = global_transform.xform_inv(position)
		set_end(position + translation)
	else:
		set_end(Vector3.ZERO)


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


func set_end(newPosition):
	endPos.translation = newPosition


func _on_rune_changed():
	if UI.currentRune != UI.Rune.MAGNESIS:
		deactivate()
