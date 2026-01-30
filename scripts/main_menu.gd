extends Control

@export var game_scene_path: String = "res://scenes/game.tscn"

@onready var play_btn: Button = $Panel/VBoxContainer/Play

func _ready() -> void:
	play_btn.pressed.connect(_on_play)

func _on_play() -> void:
	get_tree().change_scene_to_file(game_scene_path)
