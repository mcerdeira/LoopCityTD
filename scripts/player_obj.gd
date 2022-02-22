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
var current_speed = 100
var dead = false

func set_end_node(dest_node, position, pos):
	destination_node = dest_node #City or structure from object
	end_node = position #City or structure position
	base_pos = pos #base position
	
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
		current_speed = 110
		Global.WARRIOR_COUNT += 1
	elif type == "gatherer":
		current_speed = 80
		Global.GATHERER_COUNT += 1
	elif type == "miner":
		current_speed = 100
		Global.MINER_COUNT += 1

func _process(delta):
	if dead:
		position.y -= 25 * delta
		return 
	
	if doing_work:
		work_cooldown -= Global.WORK_SPEED * delta
		if work_cooldown <= 0:
			work_cooldown = total_work_cooldown
			if type == "miner":
				Global.pick_sound()
			elif type == "warrior":
				Global.sword_sound()
				
			destination_node.consume_action(1)
			var rem = destination_node.get_remaining_actions()
			if rem <= 0:
				destination_node.transform()
				queue_free()
				
	if !active and !current_path.empty():
		get_path()		
		#line.points = current_path
		#print(current_path)
		var d = end_node.distance_to(current_path[current_path.size()-1])
		if d <= 8:
			active = true
			var map = get_parent().get_node("nav/world_tilemap")
			map.path_confirmed(current_path, base_pos, end_node)

func die():
	if !dead:
		$sprites.connect("animation_finished", self, "death_animation_finished")
		if type == "warrior":
			$sprites.animation = "warrior_death"
		elif type == "gatherer":
			$sprites.animation = "gatherer_death"
		elif type == "miner":
			$sprites.animation = "miner_death"
			
		$coin.visible = false
		dead = true
	
func death_animation_finished():
	queue_free()
	
func path_truncated(pos1, pos2):
	return (pos1.distance_to(pos2) >= 9)
	
func _physics_process(delta):
	if active and !dead:
		if current_path.size() > 0:
			var d = position.distance_to(current_path[0])
			if d > 2:
				position = position.linear_interpolate(current_path[0], current_speed * delta / d)
			else:
				current_path.remove(0)
		else:
			finish_path()

func finish_path():
	if type == "warrior":
		var trunc = null
		trunc = path_truncated(destination_node.position, position)
		if trunc:
			die()
			return
			
		if not doing_work:
			doing_work = true
			$sprites.animation = "warrior_fighting"
			Global.sword_sound()
	elif type == "gatherer":
		var trunc = null
		if !reverse:
			trunc = path_truncated(destination_node.position, position)
		else:
			trunc = path_truncated(base_pos, position)
		
		if trunc:
			die()
			return
		
		if !reverse:
			destination_node.consume_action(1)
		else:
			var rem = destination_node.get_remaining_actions()
			if rem <= 0:
				destination_node.transform()
				queue_free()
		
		reverse = !reverse
		$coin.visible = reverse
		get_path()
		if !reverse:
			Global.warrior_leave_coin(reward)
		else:
			Global.warrior_get_coin()
	elif type == "miner":
		var trunc = null
		trunc = path_truncated(destination_node.position, position)
		if trunc:
			die()
			return
		
		if not doing_work:
			doing_work = true
			$sprites.animation = "miner_mining"
			Global.pick_sound()

