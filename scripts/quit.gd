extends Button

func _pressed():
	Global.button_click_sound()
	get_tree().quit()

func _on_quit_mouse_entered():
	Global.button_hover_sound()
