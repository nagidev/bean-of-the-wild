extends Control
# TODO : Crosshairs

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

onready var blur = $Blur
onready var runeIndicator = $RuneIndicator
onready var runeIcon = $CurrentRune
onready var debug = $Debug

var selectingRune = false
var runeActive = false setget rune_active_set
var runeSelected = false setget rune_selected_set
var currentRune = Rune.BOMB_ROUND


func _ready():
	runeActive = false
	currentRune = Rune.BOMB_ROUND
	
	rune_indicator_update()


func _process(_delta):
	rune_update()


func rune_update():
	if Input.is_action_pressed("rune_select"):
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
		emit_signal("rune_changed")
	else:
		get_tree().paused = false
		selectingRune = false
		blur.hide()
		runeIndicator.hide()
		runeIcon.show()


func rune_indicator_update():
	runeIndicator.set_focus( currentRune )


func rune_active_set(value):
	runeActive = value
	emit_signal("rune_activated")


func rune_selected_set(value):
	runeSelected = value
	emit_signal("rune_selected")
