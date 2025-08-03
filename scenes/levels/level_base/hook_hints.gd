class_name HookHints extends Node2D

var skater_position := Vector2.ZERO
var is_skater_hooked := false

func update_skater_position(new_position: Vector2) -> void:
	skater_position = new_position
	queue_redraw()

func update_is_skater_hooked(new_is_skater_hooked: bool) -> void:
	is_skater_hooked = new_is_skater_hooked

func _draw() -> void:
	for hook: Hook in get_tree().get_nodes_in_group("hooks_in_range"):
		var radius = hook.global_position.distance_to(skater_position)
		draw_circle(hook.global_position, radius, Color("White", 0.1), false, 2, true)
		draw_line(hook.global_position, skater_position, Color("White", 0.1), 2, true)
