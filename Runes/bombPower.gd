extends Spatial


export (UI.Rune) var type = UI.Rune.BOMB_ROUND
export var BombScene = preload("res://Runes/bombRound.tscn")
export var max_distance = 50
export (NodePath) var hand


onready var timer = $waitTimer


var bomb = null
var holding = false
var waiting = false


func _ready():
	hand = get_node(hand)
	timer.connect("timeout", self, "_on_wait_timeout")


func _process(_delta):
	if Input.is_action_just_pressed("activate"):
		if UI.currentRune == type:
			if hand_holding():
				pass
			elif bomb:
				explodeBomb()
			elif not waiting:
				createBomb(BombScene)
	elif Input.is_action_just_pressed("cancel"):
		if hand_holding():
			cancelBomb()
			return
	
	# cancel if too far away
	if bomb:
		var distance = global_transform.origin.distance_to(bomb.global_transform.origin)
		if distance > max_distance:
			cancelBomb()


func hand_holding():
	return hand.holding and hand.holding is Bomb and hand.holding.type == type


func createBomb(bombScene):
	bomb = bombScene.instance()
	get_parent().owner.add_child(bomb)
	hand.pickup( bomb )


func cancelBomb():
	hand.drop()
	bomb.cancel()
	bomb = null


func explodeBomb():
	bomb.explode()
	bomb = null
	waiting = true
	timer.start()


func _on_wait_timeout():
	waiting = false
