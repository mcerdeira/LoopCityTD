extends Node
var GRID_SIZE = 16
var BUTTON_ZONE_Y = (270 - GRID_SIZE * 2)
var SPAWN_ENEMY = null
var TTL_CITY_SPAWN = null
var WRITE_MODE = null
var COINS = null
var Get_Coin = preload("res://sfx/Picked_Coin.wav")
var Purchase_Coin = preload("res://sfx/2_Coins.wav")
var Leave_Coin = preload("res://sfx/3_Coins.wav")
var Pop = preload("res://sfx/pop.wav")
var Build = preload("res://sfx/build.wav")

var AudioManager = preload("res://scenes/AudioManager.tscn")
var AudioInstance = null

func _ready():
	AudioInstance = AudioManager.instance()
	add_child(AudioInstance)
	initialize()
	
func initialize():
	SPAWN_ENEMY = 5
	WRITE_MODE = null
	COINS = 5
	TTL_CITY_SPAWN = 20

func pop_sound():
	AudioInstance.stream = Pop
	AudioInstance.play()

func build_sound():
	AudioInstance.stream = Build
	AudioInstance.play()

func warrior_leave_coin():
	Global.COINS += 1
	AudioInstance.stream = Leave_Coin
	AudioInstance.play()
	
func warrior_get_coin():
	AudioInstance.stream = Get_Coin
	AudioInstance.play()
	
func purchase(cost):
	Global.COINS -= cost
	AudioInstance.stream = Purchase_Coin
	AudioInstance.play()

func get_cost(type):
	if type == "warrior":
		return 5
	if type == "path":
		return 0
