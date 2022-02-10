extends KinematicBody2D

var current_path = []
var life = 5
var active = false
var player_destination = null
var end_node = null
var line_tscn = preload("res://scenes/line.tscn")
var line = null

func set_end_node(position):
	end_node = position

func get_path():
	var parent = get_parent()
	var path_find = parent.get_node("nav")
	var init_pos = position
	current_path = path_find.get_simple_path(init_pos, end_node, false)

func _ready():
	var parent = get_parent()
	line = line_tscn.instance()
	parent.add_child(line)
	
	get_path()

func _process(delta):
	if !active:
		get_path()
	line.points = current_path
	print(current_path)
	if !active and Input.is_action_just_pressed("vk_enter"):
		active = true
	
func _physics_process(delta):
	if active:
		if current_path.size() > 1:
			var d = position.distance_to(current_path[0])
			if d > 2:
				position = position.linear_interpolate(current_path[0], 100 * delta / d)
			else:
				current_path.remove(0)
