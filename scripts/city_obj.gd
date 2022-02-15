extends StaticBody2D
export var coin_reward = 1
export var type = "chest"
var remaining_actions = 0
var visible_ttl = 0
export var total_actions = 0
onready var player = preload("res://scenes/player_obj.tscn")
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
	if $city_label.visible and visible_ttl > 0:
		visible_ttl -= 1 * delta
		if visible_ttl <= 0:
			visible_ttl = 0
			$city_label.visible = false
			
func randomize_me():
	type = Global.destionation_types[randi() % Global.destionation_types.size()]
	initialize()

func initialize():
	if type == "chest":
		total_actions = 10 + (randi() % 10)
		coin_reward = 1
		$sprites.frame = sprite_indexes.chest
	elif type == "city":
		total_actions = 20 + (randi() % 50)
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
		$sprites.frame = sprite_indexes.wrecked_city
	elif type == "haunted chest":
		total_actions = 50 + (randi() % 100)
		coin_reward = 1
		$sprites.frame = sprite_indexes.haunted_chest
		
	remaining_actions = total_actions

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

func transform():
	if type == "chest":
		type = "haunted chest"
	elif type == "city":
		type = "won city"
	elif type == "rock":
		type = "chest"
	elif "won city":
		type = "wrecked city"
	initialize()

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
