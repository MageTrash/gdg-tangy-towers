extends Node


var tower_placeSFX = load("res://Art n Music/SFX/towerPlaceSound.wav")
var enemy_deathSFX = load("res://Art n Music/SFX/fruitDeathSound.wav")
var fruit_pickupSFX = load("res://Art n Music/SFX/fruitPickupSound.wav")
var tower_shootKnifeSFX = load("res://Art n Music/SFX/knifeShootSound.wav")
var tower_explosiveSFX = load("res://Art n Music/SFX/explosionSound.wav")
var tower_jamballshootSFX = load("res://Art n Music/SFX/jamShootSound.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_towerplacesfx():
	$Music.stream = tower_placeSFX
	$Music.play()
	
func play_enemydeathsfx():
	$Music.stream = enemy_deathSFX
	$Music.play()

func play_fruitpickupsfx():
	$Music.stream = fruit_pickupSFX
	$Music.play()
	
func play_shootknifesfx():
	$Music.stream = tower_shootKnifeSFX
	$Music.play()
	
func play_explosionsfx():
	$Music.stream = tower_explosiveSFX
	$Music.play()
	
func play_jamballshootsfx():
	$Music.stream = tower_jamballshootSFX
	$Music.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
