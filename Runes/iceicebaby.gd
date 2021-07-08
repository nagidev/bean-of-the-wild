extends Spatial


export var enabled = true
export var IceScene = preload("res://Runes/IceBlock.tscn")

onready var raycast = $RayCast
onready var pointer = $Pointer
onready var anim = $Pointer/AnimationPlayer

var blockList = []


func _ready():
	hide()
	UI.connect("rune_changed", self, "_on_rune_changed")


func _process(_delta):
	if not enabled:
		return
	
	if UI.currentRune == UI.Rune.CRYONIS:
		# activate if not already
		if Input.is_action_just_pressed("activate"):
			if UI.runeActive:
				deactivate()
			else:
				UI.runeActive = true
				raycast.enabled = true
				show()
				return
		
		# interaction
		if UI.runeActive and raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is Water:
				pointer.update(raycast)
				
				if Input.is_action_just_pressed("interact"):
					# Stop if pointer is colliding
					if pointer.bodies.size() > 0:
						return
					
					create_block()
					
					deactivate()
			elif collider is IceBlock:
				# Pointed at already created block
				pointer.hide()
				collider.highlight()
				
				if Input.is_action_just_pressed("interact"):
					raycast.add_exception( collider )
					collider.destroy_block()
					
					#deactivate()
			else:
				pointer.hide()
		else:
			pointer.hide()
		
		# canceling
		if Input.is_action_just_released("cancel"):
			deactivate()
	
	if UI.currentRune != UI.Rune.CRYONIS and Input.is_action_just_released("rune_select"):
		deactivate()


func deactivate():
	UI.runeActive = false
	raycast.enabled = false
	anim.play("idle")
	hide()


func create_block():
	## Create new block
	var block = IceScene.instance()
	
	block.global_transform = pointer.global_transform
	
	get_parent().get_parent().owner.add_child(block)
	
	blockList.append(block)
	
	# connect signals
	block.connect("block_destroying", self, "_on_block_destroying", [block])
	block.connect("block_destroyed", self, "_on_block_destroyed", [block])
	
	## Delete old block if needed
	if blockList.size() > 3:
		block = blockList.front()
		block.destroy_block()


func _on_block_destroying( block ):
	blockList.erase(block)


func _on_block_destroyed(block):
	raycast.remove_exception( block )


func _on_rune_changed():
	if UI.currentRune != UI.Rune.CRYONIS:
		deactivate()
