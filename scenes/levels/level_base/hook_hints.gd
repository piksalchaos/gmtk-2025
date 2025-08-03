class_name HookHints extends Node2D

const COLOR := Color(0.25, 0.25, 0.25)
const LINE_WIDTH := 1
var skater: Skater

func _draw() -> void:
	if not skater: return
	if skater.is_connected_to_hook:
		draw_circle(skater.connected_hook_position, skater.connected_hook_distance, COLOR, false, LINE_WIDTH)
	elif skater.closest_hook:
		var hook_position = skater.closest_hook.global_position
		var skater_position = skater.global_position
		var radius = hook_position.distance_to(skater_position)
		draw_circle(hook_position, radius, COLOR, false, LINE_WIDTH)
		draw_line(hook_position, skater_position, COLOR, LINE_WIDTH)

func _process(_delta: float) -> void: 
	queue_redraw() # THIS IS BAD CODE IDC
