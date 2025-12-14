extends KinematicBody2D

export var speed = 1000
export var push_strength = 1.0  # cât de mult "împinge" platforma playerul
var active = false
var player = null

func _ready():
	$Sprite.visible = false

func activate(p):
	active = true
	player = p
	$Sprite.visible = true

func _physics_process(delta):
	if not active:
		return

	# platforma se mișcă la stânga
	var motion = Vector2(-speed, 0)
	move_and_slide(motion)

	# împinge playerul doar dacă este pe platformă
	if player and player.is_on_floor():
		# blend între viteza playerului și platformei
		var player_motion = motion * push_strength
		player.move_and_slide(player_motion) 
