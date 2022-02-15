extends KinematicBody2D

var current_path = []
export var type = ""
export var destination_type = ""
var life = 5
var active = false
var player_destination = null
var end_node = null
var line_tscn = preload("res://scenes/line.tscn")
var line = null
var reverse = false
var base_pos = null
var destination_node = null
var reward = 0
var doing_work = false
var total_work_cooldown = 1.5
var work_cooldown = total_work_cooldown

func set_end_node(dest_node, position, pos):
	end_node = position
	base_pos = pos
	destination_node = dest_node

func get_path():
	var parent = get_parent()
	var path_find = parent.get_node("nav")
	if reverse:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, base_pos, false)
	else:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, end_node, false)

func _ready():
	$coin.visible = false
	var parent = get_parent()
#	line = line_tscn.instance()
#	parent.add_child(line)
	
	get_path()
	
func initialize():
	$sprites.animation = type
	if type == "warrior":
		Global.WARRIOR_COUNT += 1
	elif type == "gatherer":
		Global.GATHERER_COUNT += 1
	elif type == "miner":
		Global.MINER_COUNT += 1

func _process(delta):
	if doing_work:
		work_cooldown -= 0.2 * delta
		if work_cooldown <= 0:
			work_cooldown = total_work_cooldown
			destination_node.consume_action(1)
			var rem = destination_node.get_remaining_actions()
			if rem <= 0:
				destination_node.transform()
				queue_free()
	
	if !active:
		get_path()
	#line.points = current_path
	##print(current_path)
	if !active and Input.is_action_just_pressed("vk_enter"):
		active = true
	
func _physics_process(delta):
	if active:
		if current_path.size() > 0:
			var d = position.distance_to(current_path[0])
			if d > 2:
				position = position.linear_interpolate(current_path[0], 100 * delta / d)
			else:
				current_path.remove(0)
		else:
			finish_path()

func finish_path():
	if type == "warrior":
		doing_work = true
	elif type == "gatherer":
		if !reverse:
			destination_node.consume_action(1)
		else:
			var rem = destination_node.get_remaining_actions()
			if rem <= 0:
				queue_free()
		
		reverse = !reverse
		$coin.visible = reverse
		get_path()
		if !reverse:
			Global.warrior_leave_coin(reward)
		else:
			Global.warrior_get_coin()
	elif type == "miner":
		doing_work = true

