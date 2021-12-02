extends Spatial

var ObjectScene

func _ready():
	ObjectScene = PackedScene.new()
	ObjectScene.pack(get_child(0))


func _process(_delta):
	if ObjectScene and get_child_count() == 0:
		var object = ObjectScene.instance()
		
		add_child(object)
