extends Control
# TODO : Pause menu

signal rune_changed
signal rune_activated
signal rune_selected

enum Rune {
	BOMB_ROUND,
	BOMB_CUBE,
	MAGNESIS,
	STASIS,
	CRYONIS
}

export (Rune) var currentRune = Rune.BOMB_ROUND
export var BombRoundTimeout = 5
export var BombCubeTimeout = 5
export var StasisTimeout = 5

onready var anim = $AnimationPlayer
onready var blur = $Blur
onready var runeIndicator = $RuneIndicator
onready var runeIcon = $CurrentRune
onready var timers = $Timers
onready var bombRoundTimer = $Timers/BombRoundTimer
onready var bombCubeTimer = $Timers/BombCubeTimer
onready var stasisTimer = $Timers/StasisTimer
onready var crosshair = $Crosshair
onready var healthDisp = $Health
onready var gameover = $Gameover
onready var start = $Start
onready var debug = $Debug

var _last_rune = Rune.BOMB_ROUND

var selectingRune = false
var runeActive = false setget rune_active_set
var runeSelected = false setget rune_selected_set
var aiming = false


func _ready():
	init()
	
	start.init()


func _process(_delta):
	if Global.cutscene or not Global.alive:
		runeIndicator.hide()
		runeIcon.hide()
		crosshair.hide()
		healthDisp.hide()
		timers.hide()
	else:
		healthDisp.show()
		timers.show()
		rune_update()


func init():
	runeActive = false
	currentRune = Rune.BOMB_ROUND
	
	bombRoundTimer.value = 100
	bombRoundTimer.timer.stop()
	bombCubeTimer.value = 100
	bombCubeTimer.timer.stop()
	stasisTimer.value = 100
	stasisTimer.timer.stop()
	
	healthDisp.update()
	
	rune_indicator_update()


func rune_update():
	if Input.is_action_just_pressed("rune_select"):
		_last_rune = currentRune
	elif Input.is_action_pressed("rune_select"):
		get_tree().paused = true
		selectingRune = true
		blur.show()
		runeIndicator.show()
		runeIcon.hide()
		if Input.is_action_just_released("up"):
			currentRune += 1
		elif Input.is_action_just_released("down"):
			currentRune -= 1
		currentRune = max(0, min(currentRune, 4))
		rune_indicator_update()
	elif Input.is_action_just_released("rune_select"):
		if _last_rune != currentRune:
			emit_signal("rune_changed")
	else:
		get_tree().paused = false
		selectingRune = false
		blur.hide()
		runeIndicator.hide()
		runeIcon.show()
	
	crosshair.visible = runeActive
	if runeActive:
		crosshair.get_node("default").visible = not aiming
		crosshair.get_node("active").visible = aiming
	aiming = false


func rune_indicator_update():
	runeIndicator.set_focus( currentRune )


func rune_active_set(value):
	runeActive = value
	emit_signal("rune_activated")


func rune_selected_set(value):
	runeSelected = value
	emit_signal("rune_selected")


func aim():
	aiming = true
