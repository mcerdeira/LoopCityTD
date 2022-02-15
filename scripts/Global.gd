extends Node
var GRID_SIZE = 16
var BUTTON_ZONE_Y = (270 - GRID_SIZE * 2)
var TTL_CITY_SPAWN = null
var WRITE_MODE = null
var COINS = null
var Get_Coin = preload("res://sfx/Picked_Coin.wav")
var Purchase_Coin = preload("res://sfx/2_Coins.wav")
var Leave_Coin = preload("res://sfx/3_Coins.wav")
var Pop = preload("res://sfx/pop.wav")
var Build = preload("res://sfx/build.wav")
var WARRIOR_COUNT = null
var GATHERER_COUNT = null
var MINER_COUNT = null
var SPEED = null
var DAY = null
var destionation_types = []

var AudioManager = preload("res://scenes/AudioManager.tscn")
var AudioInstance = null

func _ready():
	AudioInstance = AudioManager.instance()
	add_child(AudioInstance)
	initialize()
	
func initialize():
	randomize()
	SPEED = 1
	WRITE_MODE = null
	COINS = 5
	TTL_CITY_SPAWN = 120
	MINER_COUNT = 0
	WARRIOR_COUNT = 0
	GATHERER_COUNT = 0
	DAY = 1
	destionation_types = ["chest", "city", "rock"]

func pop_sound():
	AudioInstance.stream = Pop
	AudioInstance.play()

func build_sound():
	AudioInstance.stream = Build
	AudioInstance.play()

func warrior_leave_coin(coins):
	Global.COINS += coins
	AudioInstance.stream = Leave_Coin
	AudioInstance.play()
	
func warrior_get_coin():
	AudioInstance.stream = Get_Coin
	AudioInstance.play()
	
func purchase(cost):
	Global.COINS -= cost
	AudioInstance.stream = Purchase_Coin
	AudioInstance.play()
	
func matching_types(mode, type):
	return ((mode == "warrior" and type == "city") 
	or (mode == "gatherer" and type == "chest")
	or (mode == "miner" and type == "rock"))

func is_character(mode):
	return (mode == "warrior" or mode == "gatherer" or mode == "miner")

func get_cost(type):
	if type == "warrior":
		return 5 + (WARRIOR_COUNT * 2)
	if type == "gatherer":
		return 5 + (GATHERER_COUNT * 2)
	if type == "miner":
		return 5 + (MINER_COUNT * 2)
	if type == "path":
		return 0
