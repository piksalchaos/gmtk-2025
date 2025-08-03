class_name SceneTransitioner extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var func_to_call_after_transition: Callable

func _ready() -> void:
	show()
	animation_player.play("transition_out")

func call_func_after_transition(func_to_call: Callable):
	func_to_call_after_transition = func_to_call
	animation_player.play("transition_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition_in":
		func_to_call_after_transition.call()
