extends Node

@onready var main_menu: Control = $GUI/MainMenu
@onready var start_button: Button = $GUI/MainMenu/StartButton
@onready var transition_player: AnimationPlayer = $GUI/BlackTransition/TransitionPlayer
@onready var level_container: Node = $LevelContainer
var level_paths: Array[String]
var func_to_call_during_transition: Callable

func _ready() -> void:
	for i in range(2):
		level_paths.append("res://scenes/levels/level_" + str(i+1) + ".tscn")

func _on_start_button_pressed() -> void:
	start_button.disabled = true
	transition_state(load_first_level)

func load_first_level():
	main_menu.hide()
	load_level(0)

func load_level(level_index: int):
	for level in level_container.get_children():
		level.queue_free()
	var level_scene: PackedScene = load(level_paths[level_index])
	var new_level = level_scene.instantiate()
	level_container.add_child(new_level)
	
func transition_state(func_to_call: Callable):
	transition_player.play("fade_in")
	func_to_call_during_transition = func_to_call

func _on_transition_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		func_to_call_during_transition.call()
		transition_player.play("fade_out")
