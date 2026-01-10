extends Area2D

# Dacă bifezi asta în Inspector, ușa te va omorî mereu (Level 3)
export(bool) var is_always_trap = false

# Variabilele vechi
export(bool) var is_deadly = false
export(String) var next_scene = "res://Level4.tscn"

onready var other_door = get_parent().get_node_or_null("DoorA" if name == "DoorB" else "DoorB")

func _ready():
	# Dacă e mod capcană (Troll), ignorăm logica cu DoorManager
	if is_always_trap:
		return
		
	# Logica veche pentru nivelele normale
	if name == "DoorA":
		is_deadly = DoorManager.door_a_is_deadly
	else:
		is_deadly = !DoorManager.door_a_is_deadly

func _on_Door_body_entered(body):
	if body.name != "Player":
		return

	# Verificăm: E mod Troll SAU e ușa mortală din manager?
	if is_always_trap or is_deadly:
		print("💀 Ai murit! (Capcană)")
		
		# --- AICI ERA LIPSA ---
		# Verificăm dacă player-ul are noua funcție die() făcută de noi
		if body.has_method("die"):
			body.die()  # Asta declanșează sunetul -> pauză -> restart
		else:
			# Siguranță: dacă nu ai apucat să pui funcția die, dăm restart clasic
			get_tree().reload_current_scene()
		
		# Dacă nu e troll mode (adică e level 1 sau 2), schimbăm norocul
		if not is_always_trap:
			DoorManager.swap_doors()
			
	else:
		# player trece mai departe
		print("Ai trecut nivelul!")
		get_tree().change_scene(next_scene)
