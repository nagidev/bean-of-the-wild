extends Switch
# TODO : 

export (NodePath) var targetObjectSpawner

func _ready():
	if targetObjectSpawner:
		targetObjectSpawner = get_node(targetObjectSpawner)
	
	$Area.connect("body_entered", self, "_on_body_detected")
	$Area.connect("body_exited", self, "_on_body_exited")


func _on_body_detected(body):
	if targetObjectSpawner.get_child_count() > 0:
		var targetObject = targetObjectSpawner.get_child(0)
		on = (targetObject and body == targetObject) or ( targetObjectSpawner is NodePath and body is RigidObject )


func _on_body_exited(body):
	if targetObjectSpawner.get_child_count() > 0:
		var targetObject = targetObjectSpawner.get_child(0)
		if (targetObject and body == targetObject) or ( targetObjectSpawner is NodePath and body is RigidObject ):
			on = false
