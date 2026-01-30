extends Control

@export var game_scene_path: String = "res://scenes/main_menu.tscn"

@onready var play_again_btn: Button = $Panel/VBoxContainer/Play
@onready var quit_btn: Button = $Panel/VBoxContainer/Quit


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	play_again_btn.pressed.connect(_on_play_again)
	quit_btn.pressed.connect(_on_quit)

func toggle_pause() -> void:
	var paused := !get_tree().paused
	get_tree().paused = paused

func _on_play_again() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit() -> void:
	get_tree().change_scene_to_file(game_scene_path)
