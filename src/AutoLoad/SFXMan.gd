extends Node


var tower_placeSFX = load("res://Art n Music/SFX/towerPlaceSound.wav")
var enemy_deathSFX = load("res://Art n Music/SFX/fruitDeathSound.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_towerplacesfx():
	$Music.stream = tower_placeSFX
	$Music.play()
	
func play_enemydeathsfx():
	$Music.stream = enemy_deathSFX
	$Music.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
