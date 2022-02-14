extends StaticBody2D
export var coin_reward = 1
export var type = "chest"
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
		$sprites.frame = 0
	elif type == "city":
		total_actions = 15 + (randi() % 50)
		$sprites.frame = 2
	elif type == "rock":
		total_actions = 5 + (randi() % 25)
		$sprites.frame = 1

func create_character():
	if Global.is_character(Global.WRITE_MODE) and Global.matching_types(Global.WRITE_MODE, type):
		var cost = Global.get_cost(Global.WRITE_MODE)
		if  Global.COINS >= cost:
			var parent = get_parent()
			Global.purchase(cost)
			var p = player.instance()
			var pos = parent.get_node("base_obj")
			p.set_end_node(position, pos.position)
			p.set_position(pos.position)
			p.destination_type = type
			p.reward = coin_reward
			p.type = Global.WRITE_MODE
			p.initialize()
			parent.add_child(p)

func _on_city_area2d_mouse_entered():
	$city_label.visible = true
	$city_label.text = "$" + str(coin_reward)

func _on_city_area2d_mouse_exited():
	$city_label.visible = false
