extends Node2D
var released = false

func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
