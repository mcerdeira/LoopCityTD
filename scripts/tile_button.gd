extends Button
export var tile_positioner = 0
export var mode = ""

func _ready():
	pass

func _pressed():
	tile_positioner.texture = icon
	Global.WRITE_MODE = mode
