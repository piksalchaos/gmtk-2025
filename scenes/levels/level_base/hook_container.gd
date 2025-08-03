class_name HookContainer extends Node2D

var skater: Skater

func _draw() -> void:
	if not skater or not skater.closest_hook: return
	var hook_position = skater.closest_hook.global_position
	var skater_position = skater.global_position
	var radius = hook_position.distance_to(skater_position)
	draw_circle(hook_position, radius, Color("White", 0.1), false, 1, true)
	draw_line(hook_position, skater_position, Color("White", 0.1), 1, true)

func _process(delta: float) -> void:
	queue_redraw() # THIS IS BAD CODE IDC
