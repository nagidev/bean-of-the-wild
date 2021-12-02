extends Control


onready var label = $Label
onready var draw = $Draw


func _process(_delta):
	#label.text = "Rune Active:" + str(UI.runeActive)
	#label.text += "\nRune Selected:" + str(UI.runeSelected)
	pass

func debug_text( text ):
	label.text = str(text)


func debug_draw_line( from, to, clear= true ):
	
	if clear:
		draw.clear()
	
	draw.begin(Mesh.PRIMITIVE_LINE_STRIP)
	
	draw.add_vertex( from )
	draw.add_vertex( to )
	
	draw.end()
