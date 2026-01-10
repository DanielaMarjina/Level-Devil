extends Area2D

func _on_Spike_body_entered(body):
	if body.name == "Player":
		# AICI E SCHIMBAREA: Nu da restart direct!
		# Îi spunem jucătorului să își înceapă secvența de moarte (sunet -> pauză -> restart)
		if body.has_method("die"):
			body.die()
		else:
			# Doar ca siguranță, dacă ceva nu merge, dăm restart
			get_tree().reload_current_scene()
