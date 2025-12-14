extends StaticBody2D

export(float) var delay_before_fall := 0.1
export(float) var fall_speed := 10000

var activated = false
var falling = false

func _on_Trigger_body_entered(player):
	if activated:
		return
	if player.name != "Player":
		return
	activated = true
	yield(get_tree().create_timer(delay_before_fall), "timeout")
	falling = true


func _physics_process(delta):
	if falling:
		position.y += fall_speed * delta
