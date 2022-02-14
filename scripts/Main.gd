extends Node2D
onready var button = preload("res://scenes/tile_button.tscn")
onready var icon1 = preload("res://sprites/path1.png")
onready var icon2 = preload("res://sprites/warrior1.png")
onready var icon3 = preload("res://sprites/gatherer1.png")
onready var icon4 = preload("res://sprites/miner1.png")

onready var city = preload("res://scenes/city_obj.tscn")
var ttl_city_spawn = 0

func _ready():
	$tile_positioner.texture = null
	var buttons = [{icon = icon1, mode = "path"}, 
					{icon = icon2, mode = "warrior"},
					{icon = icon3, mode = "gatherer"},
					{icon = icon4, mode = "miner"}
					]
	
	for i in len(buttons):
		var b = button.instance()
		b.set_position(Vector2(5 + (i * Global.GRID_SIZE * 2), 270 - Global.GRID_SIZE * 2))
		b.icon = buttons[i].icon
		b.tile_positioner = $tile_positioner
		b.mode = buttons[i].mode
		add_child(b)

func _process(delta):
	ttl_city_spawn += Global.SPEED * delta
	$building_bar.calc_progress(ttl_city_spawn)
	if ttl_city_spawn >= Global.TTL_CITY_SPAWN:
		Global.DAY += 1
		ttl_city_spawn = 0
		spawn_destination()

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	if event.is_action_pressed("restart_game"):
		Global.initialize()
		get_tree().reload_current_scene()



func spawn_destination():
	var node = get_node("nav/world_tilemap")
	var c = node.spawn_destination()
	
