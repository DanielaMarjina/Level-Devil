extends Area2D

export(String, FILE, "*.tscn") var next_scene

func _on_Door_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene(next_scene)
