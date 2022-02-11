extends Button
export var tile_positioner = 0
export var mode = ""

func _ready():
	pass

func _pressed():
	tile_positioner.texture = icon
	Global.WRITE_MODE = mode

func _on_tile_button_mouse_entered():
	$button_label.text = "$" + str(Global.get_cost(mode))
	$button_label.visible = true

func _on_tile_button_mouse_exited():
	$button_label.text = ""
	$button_label.visible = false
