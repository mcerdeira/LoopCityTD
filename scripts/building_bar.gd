extends Node2D

func _ready():
	pass

func calc_progress(prog):
	$bar.scale = Vector2(prog / Global.TTL_CITY_SPAWN, 1)
