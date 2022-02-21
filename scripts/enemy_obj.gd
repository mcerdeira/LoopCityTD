extends KinematicBody2D
var type = ""
var base_pos = null
var end_node = null
var destination_node = null
var current_speed = 0
var reverse = false
var current_path = []
var active = false
var dead = false
var doing_work = false

func _ready():
	pass
	
func get_path():
	var parent = get_parent()
	var path_find = parent.get_node("nav")
	if reverse:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, base_pos, false)
	else:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, end_node, false)	

func set_end_node(dest_node, position, pos):
	end_node = position
	base_pos = pos
	destination_node = dest_node

func initialize():
	$sprites.animation = type
	if type == "ogre":
		current_speed = 50

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

func die():
	pass

func finish_path():
	if type == "ogre":
		var trunc = null
		trunc = path_truncated(destination_node.position, position)
		if trunc:
			die()
			return
			
		if not doing_work:
			doing_work = true
			$sprites.animation = "ogre_fighting"
			Global.sword_sound()
#	elif type == "gatherer":
#		var trunc = null
#		if !reverse:
#			trunc = path_truncated(destination_node.position, position)
#		else:
#			trunc = path_truncated(base_pos, position)
#
#		if trunc:
#			die()
#			return
#
#		if !reverse:
#			destination_node.consume_action(1)
#		else:
#			var rem = destination_node.get_remaining_actions()
#			if rem <= 0:
#				destination_node.transform()
#				queue_free()
#
#		reverse = !reverse
#		$coin.visible = reverse
#		get_path()
