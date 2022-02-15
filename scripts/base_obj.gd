extends StaticBody2D

func _ready():
	$base_label.visible = false
	$base_label.text = "campfire"

func _on_Area2D_mouse_entered():
	$base_label.visible = true	

func _on_Area2D_mouse_exited():
	$base_label.visible = false
