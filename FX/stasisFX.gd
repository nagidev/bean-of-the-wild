extends Spatial


func _ready():
	$Particles.emitting = true
	$Timer.connect("timeout", self, "queue_free")
