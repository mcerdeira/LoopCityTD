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
		var real_pos = world_to_map(mouse_pos)
		
		if get_cellv(real_pos) == -1 and mouse_ok(mouse_pos) and Input.is_action_pressed("mouse_left"):
			if build_sound_cooldown <= 0:
				build_sound_cooldown = total_build_sound_cooldown
				Global.build_sound()
			
			set_cell(real_pos.x, real_pos.y, draft_tileid)
			update_bitmask_region()
			
		if Input.is_action_pressed("mouse_right"):
			if get_cellv(real_pos) == draft_tileid:
				if build_sound_cooldown <= 0:
					build_sound_cooldown = total_build_sound_cooldown
					Global.build_sound()
				
				set_cellv(real_pos, -1)
				update_bitmask_region()

func mouse_ok(mouse_pos):
	return (mouse_pos.y <= Global.BUTTON_ZONE_Y)
	
func path_confirmed(player_path, base_pos, end_node):
	base_pos = world_to_map(base_pos)
	end_node = world_to_map(end_node)
	set_cell(base_pos.x, base_pos.y, path_tileid)
	set_cell(end_node.x, end_node.y, path_tileid)
	var prev_cell = null
	
	for i in range(1, player_path.size() - 1):
		var p = world_to_map(player_path[i])
		if prev_cell:
			if prev_cell.x != p.x and prev_cell.y != p.y:
				if get_cellv(p + Vector2(1, 0)) == draft_tileid:
					set_cellv(p + Vector2(1, 0), path_tileid)
				if get_cellv(p + Vector2(0, 1)) == draft_tileid:
					set_cellv(p + Vector2(0, 1), path_tileid)
				if get_cellv(p + Vector2(-1, 0)) == draft_tileid:
					set_cellv(p + Vector2(-1, 0), path_tileid)
				if get_cellv(p + Vector2(0, -1)) == draft_tileid:
					set_cellv(p + Vector2(0, -1), path_tileid)
			
			prev_cell = p
		else:
			prev_cell = p
		
		set_cell(p.x, p.y, path_tileid)
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
