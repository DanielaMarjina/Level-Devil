extends KinematicBody2D

# Faza 1 – vine spre tine (rapid)
export var start_speed := 40.0        # viteza inițială la plecare
export var acceleration := 3000.0     # cât de repede accelerează
export var max_speed := 400000.0      # viteza maximă pe prima trecere

# Faza 2 – se întoarce (mai încet)
export var return_start_speed := 80.0     # viteza inițială la întoarcere
export var return_acceleration := 2000.0   # accelerația la întoarcere
export var return_max_speed := 4000000.0      # viteza maximă la întoarcere

# Limite (în afara camerei, le reglezi tu din Inspector)
export var left_limit := -200.0      # cât de mult iese în stânga înainte să întoarcă
export var right_limit := 2000.0     # cât de mult iese în dreapta înainte să dispară

var current_speed := 0.0
var active := false
var returning := false   # false = vine prima oară spre tine, true = se întoarce

func _physics_process(delta):
	if not active:
		return

	# Alegem parametrii în funcție de fază (prima trecere sau întoarcere)
	var acc := acceleration
	var max_spd := max_speed
	var dir := -1   # -1 = spre stânga (prima trecere)

	if returning:
		acc = return_acceleration
		max_spd = return_max_speed
		dir = 1    # la întoarcere merge spre dreapta

	# creștem viteza până la limita fazei curente
	current_speed = min(current_speed + acc * delta, max_spd)

	# mișcare pe X în funcție de direcție
	var motion = Vector2(dir * current_speed * delta, 0)

	var collision = move_and_collide(motion)
	if collision and collision.collider and collision.collider.name == "Player":
		get_tree().reload_current_scene()

	# LOGICA LIMITELOR

	# 1) Prima trecere: când a ieșit suficient de mult în stânga, îl întoarcem
	if not returning and position.x < left_limit:
		position.x = left_limit
		returning = true
		# resetăm viteza pentru faza a 2-a (mai lentă)
		current_speed = return_start_speed

	# 2) A doua trecere: când a ieșit suficient de mult în dreapta, îl scoatem din joc
	if returning and position.x > right_limit:
		# e complet în afara cadrului -> nu ne mai interesează
		queue_free()     # sau active = false; hide(); etc, cum preferi

func start_chase():
	active = true
	current_speed = start_speed    # pornește deja cu o viteză minimă

func _on_StartChase_body_entered(body):
	if body.name == "Player":
		start_chase()
