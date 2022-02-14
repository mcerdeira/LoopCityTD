extends StaticBody2D
export var coin_reward = 1
onready var player = preload("res://scenes/player_obj.tscn")

func _ready():
	$city_label.visible = false

func create_character():
	if Global.WRITE_MODE == "warrior" or Global.WRITE_MODE == "gatherer":
		var cost = Global.get_cost(Global.WRITE_MODE)
		if  Global.COINS >= cost:
			var parent = get_parent()
			Global.purchase(cost)
			var p = player.instance()
			var pos = parent.get_node("base_obj")
			p.set_end_node(position, pos.position)
			p.set_position(pos.position)
			p.reward = coin_reward
			parent.add_child(p)

func _on_city_area2d_mouse_entered():
	$city_label.visible = true
	$city_label.text = "$" + str(coin_reward)

func _on_city_area2d_mouse_exited():
	$city_label.visible = false
