extends Area2D

func _ready():
	print("TrapTrigger ready")

func _on_TrapTrigger_body_entered(body):
	print("A intrat:", body, " tip:", body.get_class())

