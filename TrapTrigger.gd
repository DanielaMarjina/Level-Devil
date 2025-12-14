extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	print("TrapTrigger ready")


func _on_body_entered(body):
	if body.name == "Player":
		print("Trigger activat")
		get_parent().activate(body)
		queue_free()
