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
var base_obj_ref = null

func _ready():
	$coin.visible = false
	
func get_path():
	var parent = get_parent()
	var path_find = parent.get_node("nav")
	if reverse:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, base_pos, false)
	else:
		var init_pos = position
		current_path = path_find.get_simple_path(init_pos, end_node, false)	

func set_end_node(dest_node, base_obj, position, pos):
	base_obj_ref = base_obj
	end_node = position
	base_pos = pos
	destination_node = dest_node

func initialize():
	$sprites.animation = type
	if type == "ogre":
		current_speed = 50
	elif type == "thief":
		current_speed = 120
	
func _process(delta):
	if dead:
		position.y -= 25 * delta
		return 
	
	if doing_work:
		queue_free()
	
	if !active:
		get_path()
		if !current_path.empty():
			active = true
	
func _physics_process(delta):
	if active and !dead:
		if current_path.size() > 0:
			var d = position.distance_to(current_path[0])
			if d > 2:
				var cur_spd = current_speed
				if Global.GAMESPEED != 1:
					cur_spd += 10 * Global.GAMESPEED
				var speed = (cur_spd * delta / d)
				position = position.linear_interpolate(current_path[0], speed)
			else:
				current_path.remove(0)
		else:
			finish_path()

func die():
	pass

func finish_path():
	if type == "ogre":
		if not doing_work:
			doing_work = true
			$sprites.animation = "ogre_fighting"
			base_obj_ref.damage(1)
			Global.sword_sound()
	elif type == "thief":
		if !reverse:
			base_obj_ref.consume_action(1)
		else:
			var rem = base_obj_ref.get_remaining_actions()
			if rem <= 0:
				queue_free()
		
		reverse = !reverse
		$coin.visible = reverse
		get_path()
		if !reverse:
			destination_node.replenish_action(1)
			Global.thief_leave_coin()
		else:
			Global.thief_get_coin()

		reverse = !reverse
		$coin.visible = reverse
		get_path()
