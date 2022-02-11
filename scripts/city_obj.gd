extends StaticBody2D

onready var player = preload("res://scenes/player_obj.tscn")

func _ready():
	pass 

func create_warrior():
	if Global.WRITE_MODE == "warrior":
		var cost = Global.get_cost("warrior")
		if  Global.COINS >= cost:
			var parent = get_parent()
			Global.purchase(cost)
			var p = player.instance()
			var pos = parent.get_node("base_obj")
			p.set_end_node(position, pos.position)
			p.set_position(pos.position)
			parent.add_child(p)
