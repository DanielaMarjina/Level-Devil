extends KinematicBody2D

var speed = 250
var gravity = 600
var velocity = Vector2.ZERO
var jump_force = -350

# Prag sub care considerăm că jucătorul „a căzut”
var fall_limit_y = 1000 
var is_dead = false
func die():
	# ADAPTARE 2: Dacă suntem deja morți, oprim funcția imediat!
	# Asta rezolvă problema cu țepul mobil care declanșa sunetul de 100 de ori.
	if is_dead:
		return
	
	is_dead = true # Setăm steagul pe "mort"
	
	# Oprim fizica și mișcarea
	velocity = Vector2.ZERO 
	set_physics_process(false)
	
	# ADAPTARE 3: Ascundem jucătorul INSTANTANEU
	# Așa nu se mai vede urât cum intră în țepi în timpul morții
	hide()
	
	# Dezactivăm coliziunea ca să nu ne mai lovească nimic altceva
	# (Aceasta e siguranța supremă pentru țepii mobili)
	$CollisionShape2D.set_deferred("disabled", true)

	# Redăm sunetul
	if has_node("DeathSound"):
		$DeathSound.play()
		# ADAPTARE 4: Așteptăm exact cât ține sunetul, nu o secundă fixă!
		yield($DeathSound, "finished")
	else:
		# Dacă nu avem sunet, dăm o pauză foarte scurtă (0.1s)
		yield(get_tree().create_timer(0.1), "timeout")
	
	# Restartăm nivelul
	get_tree().reload_current_scene()

func _physics_process(delta):
	# Gravitație
	velocity.y += gravity * delta

	# Mișcare pe X
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction = 1
		velocity.x = speed
	elif Input.is_action_pressed("ui_left"):
		direction = -1
		velocity.x = -speed
	else:
		velocity.x = 0

	# Săritură
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		# Asigură-te că nodul se numește exact JumpSound
		if has_node("JumpSound"):
			$JumpSound.play()

	# Aplicăm mișcarea
	velocity = move_and_slide(velocity, Vector2.UP)

	# Dacă cade prea jos (în groapă), moare
	if global_position.y > fall_limit_y:
		die()

	# Actualizăm animația
	_update_animation(direction)


func _update_animation(direction):
	# Verificăm dacă există nodul AnimatedSprite înainte să îl folosim
	if not has_node("AnimatedSprite"):
		return
		
	var anim = $AnimatedSprite 

	# Întoarce sprite-ul stânga/dreapta
	if direction != 0:
		anim.flip_h = direction < 0

	# Dacă NU e pe podea -> animație de săritură
	if not is_on_floor():
		if anim.frames.has_animation("jump") and anim.animation != "jump":
			anim.play("jump")
		return

	# Dacă e pe podea:
	if direction == 0:
		# Stă pe loc -> idle
		if anim.frames.has_animation("idle") and anim.animation != "idle":
			anim.play("idle")
	else:
		# Se mișcă -> run
		if anim.frames.has_animation("run") and anim.animation != "run":
			anim.play("run")
