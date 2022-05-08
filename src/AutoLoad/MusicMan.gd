extends Node


var menu_track = load("res://Art n Music/Music/TT_Menu.wav")
var gameplay_track = load("res://Art n Music/Music/TT_Gameplay.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_menutrack():
	$Music.stream = menu_track
	$Music.play()
	
func play_gameplaytrack():
	$Music.stream = gameplay_track
	$Music.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
