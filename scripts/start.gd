extends Button

func _pressed():
	Global.button_click_sound()
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_start_mouse_entered():
	Global.button_hover_sound()
