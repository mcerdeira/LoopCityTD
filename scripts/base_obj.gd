extends StaticBody2D
var life = 100

func _ready():
	$base_label.visible = false
	$base_label.text = "Campfire\nH: " + str(life)

func _on_Area2D_mouse_entered():
	$base_label.visible = true	
	$base_label.text = "Campfire\nH: " + str(life)

func _on_Area2D_mouse_exited():
	$base_label.visible = false
	$base_label.text = "Campfire\nH: " + str(life)
	
func damage(amount):
	#TODO: Show label for a while
	life -= amount
	if life <= 0:
		life = 0

func consume_action(amount):
	Global.COINS -= amount
	if Global.COINS <= 0:
		Global.COINS = 0
	
func get_remaining_actions():
	return Global.COINS
