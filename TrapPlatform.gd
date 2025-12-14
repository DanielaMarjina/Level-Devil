extends KinematicBody2D

export var speed := 250
var active := false
var player = null


func activate(p):
	active = true
	player = p
	player.velocity.x = -speed * 1.2
	$Sprite.visible = true

func _physics_process(delta):
	if not active:
		return

	# mișcăm platforma
	move_and_slide(Vector2.LEFT * speed)

	# împingem playerul în stânga
	if player:
		player.velocity.x = -speed * 1.2
