extends KinematicBody2D

var speed = 200
var gravity = 600
var velocity = Vector2.ZERO
var jump_force = -350

func _physics_process(delta):
	velocity.y += gravity * delta

	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force

	velocity = move_and_slide(velocity, Vector2.UP)
