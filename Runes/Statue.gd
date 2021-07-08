extends Spatial


export var enabled = true

onready var raycast = $RayCast
onready var arrow = $Arrow
onready var timer = $Timer

var targetObject = null # stores reference of object stasised


func _ready():
	timer.connect("timeout", self, "_on_timeout")
	UI.connect("rune_changed", self, "_on_rune_changed")


func _process(delta):
	if not enabled:
		return
	
	if UI.currentRune == UI.Rune.STASIS:
		# activate / deactivate rune
		if Input.is_action_just_pressed("activate"):
			if UI.runeActive:
				deactivate()
			elif not targetObject:
				activate()
		
		# interaction
		if UI.runeActive:
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				
				if collider is RigidObject:
					collider.highlight()
					if Input.is_action_just_pressed("interact"):
						statue( collider )
						deactivate()
		
		# cancel rune
		if Input.is_action_just_released("cancel"):
			deactivate()
	
	if targetObject and targetObject.accumulation.length() > 0.1:
		arrow.show()
		
		var accum = targetObject.accumulation * 0.01
		
		# arrow position
		arrow.global_transform.origin = targetObject.global_transform.origin + accum
		
		# arrow angle
		arrow.global_transform.basis.y = targetObject.accumulation
		arrow.global_transform.basis.z = global_transform.basis.y * -1
		arrow.global_transform.basis.x = arrow.global_transform.basis.z.cross(arrow.global_transform.basis.y)
		arrow.global_transform = arrow.global_transform.orthonormalized()
		arrow.global_transform.basis.y = accum


func activate():
	UI.runeActive = true
	raycast.enabled = true


func deactivate():
	UI.runeActive = false
	raycast.enabled = false


func statue( body ):
	targetObject = body
	targetObject.statue()
	UI.runeSelected = true
	timer.start()


func unstatue():
	if targetObject:
		targetObject.unstatue()
		UI.runeSelected = false
		targetObject = null
		arrow.hide()


func _on_timeout():
	unstatue()


func _on_rune_changed():
	if UI.currentRune != UI.Rune.STASIS:
		deactivate()
