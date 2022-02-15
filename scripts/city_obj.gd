extends StaticBody2D
export var coin_reward = 1
export var type = "chest"
var remaining_actions = 0
export var total_actions = 0
onready var player = preload("res://scenes/player_obj.tscn")

func _ready():
	$city_label.visible = false
	initialize()

func randomize_me():
	type = Global.destionation_types[randi() % Global.destionation_types.size()]
	initialize()

func initialize():
	if type == "chest":
		total_actions = 5 + (randi() % 10)
		coin_reward = 1
		$sprites.frame = 0
	elif type == "city":
		total_actions = 15 + (randi() % 50)
		coin_reward = 3
		$sprites.frame = 2
	elif type == "rock":
		total_actions = 5 + (randi() % 25)
		coin_reward = 2
		$sprites.frame = 1
	if type == "won city":
		total_actions = 50 + (randi() % 100)
		$sprites.frame = 3
		coin_reward = 1
	
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
	$city_label.text = "$" + str(remaining_actions) + "/" + str(total_actions)

func transform():
	if type == "city":
		type = "won city"
	elif type == "rock":
		type = "chest"
	initialize()

func get_remaining_actions():
	return remaining_actions

func _on_city_area2d_mouse_entered():
	$city_label.visible = true
	$city_label.text = "$" + str(remaining_actions) + "/" + str(total_actions)

func _on_city_area2d_mouse_exited():
	$city_label.visible = false
