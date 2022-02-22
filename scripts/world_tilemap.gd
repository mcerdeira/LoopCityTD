extends TileMap
onready var city = preload("res://scenes/city_obj.tscn")
var total_build_sound_cooldown = 0.8
var build_sound_cooldown = total_build_sound_cooldown
var draft_tileid = null
var path_tileid = null

func _ready():
	draft_tileid = tile_set.find_tile_by_name("draft_tilemap")
	path_tileid = tile_set.find_tile_by_name("path_tilemap")

func _process(delta):
	if build_sound_cooldown > 0:
		build_sound_cooldown -= 1 * delta
	
	if Global.WRITE_MODE == "path":
		var mouse_pos = get_global_mouse_position()	
		
		if mouse_ok(mouse_pos) and Input.is_action_pressed("mouse_left"):
			if build_sound_cooldown <= 0:
				build_sound_cooldown = total_build_sound_cooldown
				Global.build_sound()
			var real_pos = world_to_map(mouse_pos)
			set_cell(real_pos.x, real_pos.y, draft_tileid)
			update_bitmask_region()
			
		if Input.is_action_pressed("mouse_right"):
			var real_pos = world_to_map(mouse_pos)

			if get_cellv(real_pos) == draft_tileid:
				if build_sound_cooldown <= 0:
					build_sound_cooldown = total_build_sound_cooldown
					Global.build_sound()
				
				set_cellv(real_pos, -1)
				update_bitmask_region()

func mouse_ok(mouse_pos):
	return (mouse_pos.y <= Global.BUTTON_ZONE_Y)
	
func path_confirmed(full_path):
	for path in full_path:
		var real_pos = world_to_map(path)
		set_cell(real_pos.x, real_pos.y, path_tileid)
		update_bitmask_region()

func spawn_destination():
	var pos
	while(true):
		randomize()
		var xx = 5 + (randi() % 29)
		var yy = 2 + (randi() % 7)
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

func get_real_pos(pos):
	return world_to_map(map_to_world(pos))
