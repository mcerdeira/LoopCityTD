extends StaticBody2D
export var coin_reward = 1
export var type = "chest"
var enemy_spawn = 0
var enemy_spawn_total = 0
var spawner = false
var remaining_actions = 0
var visible_ttl = 0
export var total_actions = 0
onready var player = preload("res://scenes/player_obj.tscn")
onready var enemy = preload("res://scenes/enemy_obj.tscn")

const sprite_indexes = {
	chest = 0,
	rock = 1,
	city = 2,
	won_city = 3,
	haunted_chest = 4,
	wrecked_city = 5
}

func _ready():
	$city_label.visible = false
	initialize()
	
func _process(delta):
	if spawner:
		enemy_spawn -= 1 * delta
		if enemy_spawn <= 0:
			enemy_spawn = enemy_spawn_total
			create_enemy()
	
	if $city_label.visible and visible_ttl > 0:
		visible_ttl -= 1 * delta
		if visible_ttl <= 0:
			visible_ttl = 0
			$city_label.visible = false
			
func randomize_me():
	type = Global.destionation_types[randi() % Global.destionation_types.size()]
	print(type)
	initialize()

func initialize(transformed := false):
	if type == "chest":
		var coins = 10
		if transformed:
			coins = 30
			var dissapear = randi() % 3
			if dissapear == 0:
				queue_free()
				return 0

		total_actions = coins + (randi() % 10)
		coin_reward = 1
		$sprites.frame = sprite_indexes.chest
	elif type == "city":
		total_actions = 20 + (randi() % 51)
		coin_reward = 3
		$sprites.frame = sprite_indexes.city
	elif type == "rock":
		total_actions = 5 + (randi() % 25)
		coin_reward = 2
		$sprites.frame = sprite_indexes.rock
	elif type == "won city":
		total_actions = 50 + (randi() % 100)
		coin_reward = 1
		$sprites.frame = sprite_indexes.won_city
	elif type == "wrecked city":
		total_actions = 50 + (randi() % 100)
		coin_reward = 1
		enemy_spawn_total = 3
		enemy_spawn = enemy_spawn_total
		spawner = true
		$sprites.frame = sprite_indexes.wrecked_city
	elif type == "haunted chest":
		total_actions = 5 + (randi() % 20)
		coin_reward = 1
		$sprites.frame = sprite_indexes.haunted_chest
		enemy_spawn_total = 5
		enemy_spawn = enemy_spawn_total
		spawner = true
		
	remaining_actions = total_actions

func create_enemy():
	if type == "haunted chest":
		var parent = get_parent()
		var e = enemy.instance()
		var pos = parent.get_node("base_obj")
		e.set_end_node(self, pos, pos.position, position)
		e.set_position(position)
		e.type = "ogre"
		e.initialize()
		parent.add_child(e)
	elif type == "wrecked city":
		var parent = get_parent()
		var e = enemy.instance()
		var pos = parent.get_node("base_obj")
		e.set_end_node(self, pos, pos.position, position)
		e.set_position(position)
		e.type = "thief"
		e.initialize()
		parent.add_child(e)

func create_character():
	if Global.is_character(Global.WRITE_MODE) and Global.matching_types(Global.WRITE_MODE, type):
		var cost = Global.get_cost(Global.WRITE_MODE)
		if  Global.COINS >= cost:
			var parent = get_parent()
			Global.purchase(cost)
			var p = player.instance()
			var pos = parent.get_node("base_obj")
			p.set_end_node(self, position, pos.position)
			p.set_position(pos.position)
			p.destination_type = type
			p.reward = coin_reward
			p.type = Global.WRITE_MODE
			p.initialize()
			parent.add_child(p)

func consume_action(amount):
	remaining_actions -= amount
	set_label()
	if !$city_label.visible:
		visible_ttl = 1
		$city_label.visible = true

func replenish_action(amount):
	remaining_actions += amount
	set_label()
	if !$city_label.visible:
		visible_ttl = 1
		$city_label.visible = true

func transform():
	if type == "chest":
		type = "haunted chest"
	elif type == "city":
		type = "won city"
	elif type == "rock":
		var bad_chest = randi() % 5
		if bad_chest == 0:
			type = "haunted chest"
		else:
			type = "chest"
	elif "won city":
		type = "wrecked city"
	initialize(true)

func set_label():
	var text = type + "\n"
	if type == "chest" or type == "won city":
		text += "$" + str(remaining_actions) + "/" + str(total_actions)
	else:
		text += "H: " + str(remaining_actions) + "/" + str(total_actions)
	$city_label.text = text

func get_remaining_actions():
	return remaining_actions

func _on_city_area2d_mouse_entered():
	$city_label.visible = true	
	set_label()

func _on_city_area2d_mouse_exited():
	$city_label.visible = false
