extends KinematicBody2D

export var speed = 1200
export var push_strength = 60

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

	# platforma NU poate fi blocată
	global_position.x -= speed * delta

	if player and _player_on_platform():
		# 🔥 EXACT CA ÎNAINTE – forță brutală
		player.global_position.x -= speed * push_strength * delta


func _player_on_platform() -> bool:
	var space = get_world_2d().direct_space_state
	var from = player.global_position
	var to = from + Vector2(0, 10)

	var result = space.intersect_ray(
		from,
		to,
		[player],
		collision_mask
	)

	return result and result.collider == self
