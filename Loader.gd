extends Spatial


func _input(event):
	if event is InputEventMouseMotion:
		queue_free()
