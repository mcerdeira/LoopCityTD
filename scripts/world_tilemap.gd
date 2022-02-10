extends TileMap

func _ready():
	pass

func _process(delta):
	if Global.WRITE_MODE == "path":
		var mouse_pos = get_global_mouse_position()	
		
		if mouse_ok(mouse_pos) and Input.is_action_pressed("mouse_left"):
			var real_pos = world_to_map(mouse_pos)
			var tile_id = tile_set.find_tile_by_name("path_tilemap")
			set_cell(real_pos.x, real_pos.y, tile_id)
			update_bitmask_region()
			
		if Input.is_action_pressed("mouse_right"):
			var real_pos = world_to_map(mouse_pos)
			set_cellv(real_pos, -1)
			update_bitmask_region()

func mouse_ok(mouse_pos):
	return (mouse_pos.y <= Global.BUTTON_ZONE_Y)
