extends Control


onready var maxHeartDisp = $MaxHearts
onready var heartDisp = $Hearts


func _ready():
	update()


func update():
	maxHeartDisp.rect_size.x = Global.maxHearts * 16
	heartDisp.rect_size.x = Global.hearts * 16
