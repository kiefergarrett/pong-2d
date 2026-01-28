extends Area2D

@export var hit_sounds: Array[AudioStream]
@export var speed : float = 7.0
@export var max_degree_angle = 50
@onready var startTimer : Timer = $Timer
@onready var sound_player : AudioStreamPlayer = $AudioStreamPlayer
var radClampAngle : float
var hit_count : int = 0
var canMove : bool = false

signal ball_scored

var angle : float
var ballAngle : float = 0.0
var direction : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	radClampAngle = deg_to_rad(max_degree_angle)
	angle = randf_range(-radClampAngle, radClampAngle)
	direction = Vector2.from_angle(angle)
	

func _physics_process(delta: float) -> void:
	if canMove:
		position += direction * speed * 100 * delta


func handle_paddle_bounce(body: Node2D) -> void:
	
	play_random_hit_sound()
	hit_count = hit_count + 1
	
	if hit_count > 0 and hit_count < 2:
		speed = speed + 5.0
	elif hit_count > 1:
		speed = speed + 0.1
	
	var paddle_pos_y = body.global_position.y
	var ball_pos_y = global_position.y
	
	var ball_to_paddle_offset : float = ball_pos_y - paddle_pos_y
	var vertical_ball_bounce_direction : int = 1
	
	if ball_to_paddle_offset < 0:
		vertical_ball_bounce_direction = -1
	
	ball_to_paddle_offset = abs(ball_to_paddle_offset)
	
	var paddleLength : float = body.get_node("CollisionShape2D").shape.get_rect().size.y
	var max_offset = paddleLength / 2
	
	ball_to_paddle_offset = clampf(ball_to_paddle_offset, 0, max_offset)
	
	var ball_bounce_position_ratio = ball_to_paddle_offset / max_offset

	if direction.x >= 0:
		var bounce_degree_angle = (max_degree_angle * ball_bounce_position_ratio) * (vertical_ball_bounce_direction * -1)
		direction = Vector2.from_angle(deg_to_rad(bounce_degree_angle - 180))
	else:
		var bounce_degree_angle = (max_degree_angle * ball_bounce_position_ratio) * vertical_ball_bounce_direction
		direction = Vector2.from_angle(deg_to_rad(bounce_degree_angle))
	
	
func handle_boundary_bounce() -> void:
	play_random_hit_sound()
	direction.y = direction.y * -1

func handle_score(goal: String) -> void:
	emit_signal("ball_scored", goal)

func play_random_hit_sound():
	if hit_sounds.is_empty():
		return
	sound_player.stream = hit_sounds.pick_random()
	sound_player.play()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("paddle"):
		handle_paddle_bounce(body)
	elif body.is_in_group("boundary"):
		handle_boundary_bounce()



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("score_box_left"):
		handle_score("left")
	elif area.is_in_group("score_box_right"):
		handle_score("right")


func _on_timer_timeout() -> void:
	canMove = true
