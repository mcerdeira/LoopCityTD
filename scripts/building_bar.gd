extends Node2D

func _ready():
	pass

func calc_progress(prog):
	$bar.scale = Vector2(prog / Global.TTL_CITY_SPAWN, 1)
	$Label.text = "DAY " + str(Global.DAY)
	$gamespeed_label.text = ">".repeat(Global.GAMESPEED)
