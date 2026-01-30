extends Control

@export var game_scene_path: String = "res://scenes/main_menu.tscn"

@onready var resume_btn: Button = $Panel/VBoxContainer/Resume
@onready var restart_btn: Button = $Panel/VBoxContainer/Restart
@onready var quit_btn: Button = $Panel/VBoxContainer/Quit


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	resume_btn.pressed.connect(_on_resume)
	restart_btn.pressed.connect(_on_restart)
	quit_btn.pressed.connect(_on_quit)

func toggle_pause() -> void:
	var paused := !get_tree().paused
	get_tree().paused = paused
	visible = paused

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_resume() -> void:
	toggle_pause()

func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit() -> void:
	toggle_pause()
	get_tree().change_scene_to_file(game_scene_path)
