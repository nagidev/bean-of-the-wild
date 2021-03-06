extends Spatial
# TODO : 

export var enabled = true
export (UI.Rune) var type = UI.Rune.BOMB_ROUND
export var BombScene = preload("res://Runes/bombRound.tscn")
export var max_distance = 80
export (NodePath) var hand


var bomb = null
var holding = false
var charged = true
var rechargeTimer = null


func _ready():
	# set timer
	match(type):
		UI.Rune.BOMB_ROUND:
			rechargeTimer = UI.bombRoundTimer
		UI.Rune.BOMB_CUBE:
			rechargeTimer = UI.bombCubeTimer
	hand = get_node(hand)
	rechargeTimer.connect("timeout", self, "_on_recharged")


func _process(_delta):
	if (not enabled) or Global.cutscene or not Global.alive:
		return
	
	if Input.is_action_just_pressed("activate"):
		if UI.currentRune == type:
			if hand_holding():
				pass
			elif bomb:
				explodeBomb()
			elif charged:
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
	charged = false
	rechargeTimer.start()


func _on_recharged():
	charged = true
