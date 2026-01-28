extends Node

@export var ball_spawn_position : Vector2 = Vector2(960, 540)
@export var paddle_spawn_position : Vector2 = Vector2(120, 540)
@export var ball_scene : PackedScene
@export var ai_paddle_scene : PackedScene
@export var score_left : HBoxContainer
@export var score_right : HBoxContainer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@export var score_sound : AudioStream

var left_score = 0
var right_score = 0

var label_left : Label
var label_right : Label
var ball
var ai_paddle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball = ball_scene.instantiate()
	ai_paddle = ai_paddle_scene.instantiate()
	ball.global_position = ball_spawn_position
	ball.ball_scored.connect(on_ball_scored)
	ai_paddle.global_position = paddle_spawn_position
	
	ai_paddle.ball = ball
	
	add_child(ball)
	add_child(ai_paddle)
	
	label_left = score_left.get_node("Label")
	label_right = score_right.get_node("Label")


func on_ball_scored(goal: String) -> void:
	if score_sound == null:
		pass
	else:
		audio_player.stream = score_sound
		audio_player.play()
	
	if goal == "left":
		left_score = left_score + 1
		label_left.text = str(left_score)
	elif goal == "right":
		right_score = right_score + 1
		label_right.text = str(right_score)
	
	call_deferred("_respawn_ball")

func _respawn_ball() -> void:
	# If there's an existing ball, remove it safely
	if is_instance_valid(ball):
		ball.queue_free()

	ball = ball_scene.instantiate()
	ball.global_position = ball_spawn_position

	# Connect before adding is fine either way, but this is clean
	ball.ball_scored.connect(on_ball_scored)

	add_child(ball)

	# Update AI reference after the ball exists in the tree
	ai_paddle.ball = ball
