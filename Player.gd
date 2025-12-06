extends KinematicBody2D

var speed = 200
var gravity = 600
var velocity = Vector2.ZERO
var jump_force = -350

func _physics_process(delta):
	# gravitație
	velocity.y += gravity * delta

	# mișcare pe X
	var direction = 0
	if Input.is_action_pressed("ui_right"):
		direction = 1
		velocity.x = speed
	elif Input.is_action_pressed("ui_left"):
		direction = -1
		velocity.x = -speed
	else:
		velocity.x = 0

	# săritură
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	# mișcare fizică
	velocity = move_and_slide(velocity, Vector2.UP)

	# actualizăm animația în funcție de direcție & dacă e pe podea
	_update_animation(direction)


func _update_animation(direction):
	var anim = $AnimatedSprite   # schimbă dacă nodul tău are alt nume

	# întoarce sprite-ul stânga/dreapta
	if direction != 0:
		anim.flip_h = direction < 0

	# dacă NU e pe podea -> săritură
	if not is_on_floor():
		# dacă ai animație "jump"
		if anim.animation != "jump":
			anim.play("jump")
		return

	# dacă e pe podea:
	if direction == 0:
		# stă pe loc -> idle (sau primul frame din run)
		if anim.animation != "idle":
			anim.play("idle")
			# dacă nu ai animație "idle", poți face:
			# anim.play("run")
			# anim.stop()
			# anim.frame = 0
	else:
		# se mișcă pe X -> run
		if anim.animation != "run":
			anim.play("run")


func _on_Door_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Nivel2.tscn")

