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
var Pick = preload("res://sfx/pick_sfx.wav")
var Sword = preload("res://sfx/sword_clash.wav")
var WARRIOR_COUNT = null
var GATHERER_COUNT = null
var MINER_COUNT = null
var ARCHER_COUNT = null
var SPEED = null
var WORK_SPEED = null
var DAY = null
var destionation_types = []

var AudioManager = preload("res://scenes/AudioManager.tscn")
var AudioInstance = null
var audio_players = 3
var bus = "master"
var available = [] 
var queue = []

func _ready():
	for i in audio_players:
		var player = AudioManager.instance()
		add_child(player)
		available.append(player)
		player.connect("finished", self, "_on_stream_finished", [player])
		player.bus = bus
	initialize()
	
func play(sound_path):
	queue.append(sound_path)
	
func _on_stream_finished(stream):
	available.append(stream)

func _process(delta):
	if not queue.empty() and not available.empty():
		available[0].stream = queue.pop_front()
		available[0].play()
		available.pop_front()

func initialize():
	randomize()
	SPEED = 3
	WORK_SPEED = 0.5
	WRITE_MODE = null
	COINS = 10
	TTL_CITY_SPAWN = 120
	MINER_COUNT = 0
	WARRIOR_COUNT = 0
	GATHERER_COUNT = 0
	ARCHER_COUNT = 0
	DAY = 1
	destionation_types = ["chest", "city", "rock"]

func pop_sound():
	play(Pop)	

func build_sound():
	play(Build)
	
func sword_sound():
	play(Sword)

func pick_sound():
	play(Pick)
	
func coin_sound():
	play(Get_Coin)

func warrior_leave_coin(coins):
	Global.COINS += coins
	play(Leave_Coin)
	
func warrior_get_coin():
	play(Get_Coin)
	
func purchase(cost):
	Global.COINS -= cost
	play(Purchase_Coin)
	
func matching_types(mode, type):
	return ((mode == "warrior" and type == "city") 
	or (mode == "gatherer" and type == "chest")
	or (mode == "gatherer" and type == "won city")
	or (mode == "miner" and type == "rock"))

func is_character(mode):
	return (mode == "warrior" or mode == "gatherer" or mode == "miner")

func get_cost(type):
	if type == "warrior":
		return 5 + WARRIOR_COUNT
	if type == "gatherer":
		return 5 + GATHERER_COUNT
	if type == "miner":
		return 5 + MINER_COUNT
	if type == "archer":
		return 10 + ARCHER_COUNT
	if type == "path":
		return 0
