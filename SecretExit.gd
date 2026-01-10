extends Area2D

func _ready():
	# Conectează semnalul din cod, dacă nu vrei să îl faci manual din editor
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		print("🎉 VICTORIE! Ai găsit ieșirea secretă!")
		# Sau cand ai scena gata:
		get_tree().change_scene("res://Level4.tscn")
