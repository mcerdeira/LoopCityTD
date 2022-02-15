extends TileMap
onready var city = preload("res://scenes/city_obj.tscn")

func _ready():
	pass

func _process(delta):
	if Global.WRITE_MODE == "path":
		var mouse_pos = get_global_mouse_position()	
		
		if mouse_ok(mouse_pos) and Input.is_action_pressed("mouse_left"):
			Global.build_sound()
			var real_pos = world_to_map(mouse_pos)
			var tile_id = tile_set.find_tile_by_name("path_tilemap")
			set_cell(real_pos.x, real_pos.y, tile_id)
			update_bitmask_region()
			
		if Input.is_action_pressed("mouse_right"):
			Global.build_sound()
			var real_pos = world_to_map(mouse_pos)
			set_cellv(real_pos, -1)
			update_bitmask_region()

func mouse_ok(mouse_pos):
	return (mouse_pos.y <= Global.BUTTON_ZONE_Y)

func spawn_destination():
	var pos
	while(true):
		randomize()
		var xx = randi() % 29
		var yy = randi() % 14
		pos = Vector2(xx, yy)
		pos = map_to_world(pos)
		pos.x += 8
		pos.y += 8
		if is_empty(pos):
			break

	Global.pop_sound()
	var h = city.instance()
	h.set_position(pos)
	h.randomize_me()
	get_parent().get_parent().add_child(h)

func is_empty(pos):
	return get_world_2d().direct_space_state.intersect_point(pos, 1, [], 0x7FFFFFFF, true, true).empty()
