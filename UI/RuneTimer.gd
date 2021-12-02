extends TextureProgress


signal timeout

enum Rune {
	BOMB_ROUND,
	BOMB_CUBE,
	MAGNESIS,
	STASIS,
	CRYONIS
}

export (Rune) var type

onready var timer = Timer.new()


func _ready():
	match(type):
		UI.Rune.BOMB_ROUND:
			timer.set_wait_time( UI.BombRoundTimeout )
		UI.Rune.BOMB_CUBE:
			timer.set_wait_time( UI.BombCubeTimeout )
		UI.Rune.STASIS:
			timer.set_wait_time( UI.StasisTimeout )
	
	timer.set_one_shot( true )
	set_pause_mode( Node.PAUSE_MODE_STOP )
	
	modulate.a = 0
	
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")


func _process(_delta):
	value = (100 - (timer.get_time_left() / timer.get_wait_time()) * 100)
	
	if value > 98:
		modulate.a = max(0, modulate.a * 0.8)
	else:
		modulate.a = min(1, modulate.a * 2)


func start():
	timer.start()
	modulate.a = 0.01


func _on_timeout():
	emit_signal("timeout")
