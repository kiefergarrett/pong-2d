extends AnimatableBody2D

@export var speed := 325
@export var yBounds: = 1080
var ball : Node2D = null

func _physics_process(delta: float) -> void:
	if ball == null:
		return

	var target_y = ball.global_position.y
	var dy = target_y - global_position.y

	# Move toward the ball
	var step = speed * delta
	
	if dy > 0:
		if global_position.y < yBounds - 110:
			global_position.y += clamp(dy, -step, step)
	elif dy < 0:
		if global_position.y > 0 + 110:
			global_position.y += clamp(dy, -step, step)
