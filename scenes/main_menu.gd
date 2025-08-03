extends Control

const LEVEL_1 = preload("res://scenes/levels/level_1.tscn")
@onready var scene_transitioner: SceneTransitioner = $SceneTransitioner

func _on_start_button_pressed() -> void:
	scene_transitioner.call_func_after_transition(goto_level_1)

func goto_level_1():
	get_tree().change_scene_to_packed(LEVEL_1)
