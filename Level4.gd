extends Control

func _on_BtnRestart_pressed():
	# Te duce înapoi la primul nivel
	get_tree().change_scene("res://Level1.tscn")

func _on_BtnQuit_pressed():
	# Închide jocul
	get_tree().quit()


func _on_Label_draw():
	pass # Replace with function body.
