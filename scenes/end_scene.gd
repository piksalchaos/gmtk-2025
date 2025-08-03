extends Control

@onready var scene_transitioner: SceneTransitioner = $SceneTransitioner

func _on_timer_timeout() -> void:
	scene_transitioner.call_func_after_transition(goto_main_menu)

func goto_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
