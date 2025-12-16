extends Area2D

# true = omoară, false = trece mai departe
export(bool) var is_deadly = false
export(String) var next_scene = "res://Level4.tscn"


onready var other_door = get_parent().get_node("DoorA" if name == "DoorB" else "DoorB")

func _ready():
	# setează is_deadly din manager
	if name == "DoorA":
		is_deadly = DoorManager.door_a_is_deadly
	else:
		is_deadly = !DoorManager.door_a_is_deadly

func _on_Door_body_entered(body):
	if body.name != "Player":
		return

	if is_deadly:
		# player moare → swap global + reload
		DoorManager.swap_doors()
		print("💀 Ai murit! Ușile s-au schimbat global!")
		get_tree().reload_current_scene()
	else:
		# player trece mai departe
		get_tree().change_scene(next_scene)
