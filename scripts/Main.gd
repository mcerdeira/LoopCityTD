extends Node2D
onready var button = preload("res://scenes/tile_button.tscn")
onready var icon1 = preload("res://sprites/path1.png")
onready var icon2 = preload("res://sprites/warrior1.png")
#

func _ready():
	$tile_positioner.texture = null
	var buttons = [{icon = icon1, mode = "path"}, {icon = icon2, mode = "warrior"}]
	
	for i in len(buttons):
		var b = button.instance()
		b.set_position(Vector2(5 + (i * Global.GRID_SIZE * 2), 270 - Global.GRID_SIZE * 2))
		b.icon = buttons[i].icon
		b.tile_positioner = $tile_positioner
		b.mode = buttons[i].mode
		add_child(b)
		
func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
	if event.is_action_pressed("restart_game"):
		get_tree(). reload_current_scene()
