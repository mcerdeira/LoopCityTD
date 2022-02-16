extends Button
export var tile_positioner = 0
export var mode = ""

func _ready():
	pass

func _pressed():
	if mode == "warrior":
		Global.sword_sound()
	elif mode == "path":
		Global.build_sound()
	elif mode == "miner":
		Global.pick_sound()
	elif mode == "gatherer":
		Global.coin_sound()
	
	tile_positioner.texture = icon
	Global.WRITE_MODE = mode

func _on_tile_button_mouse_entered():
	$button_label.text = mode + " $" + str(Global.get_cost(mode))
	$button_label.visible = true

func _on_tile_button_mouse_exited():
	$button_label.text = ""
	$button_label.visible = false
