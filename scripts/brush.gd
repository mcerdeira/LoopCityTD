extends Sprite
var area_inst = null
var map = null

func _ready():
	map = get_parent().get_node("nav/world_tilemap")
	global_position = get_global_mouse_position()

func _process(delta):
	global_position = get_global_mouse_position()
	#position = map.get_real_pos(global_position)
	position = position.snapped(Vector2.ONE * Global.GRID_SIZE)
	position.x += 8
	position.y += 8
	if(position.y >= Global.BUTTON_ZONE_Y):
		visible = false

func destroy_area():
	if area_inst:
		area_inst.queue_free()

func set_area(sprite, area):
	var area_inst = area.instance()
	add_child(area_inst)
	texture = sprite
