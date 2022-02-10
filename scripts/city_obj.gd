extends StaticBody2D

onready var player = preload("res://scenes/player_obj.tscn")

func _ready():
	pass 

func create_warrior():
	if Global.WRITE_MODE == "warrior":
		var parent = get_parent()
		var p = player.instance()
		var pos = parent.get_node("base_obj")
		p.set_end_node(position)
		p.set_position(pos.position)
		parent.add_child(p)
