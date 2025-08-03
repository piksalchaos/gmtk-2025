class_name HookDetector extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func get_closest_hook() -> Hook:
	var closest_hook: Hook
	var closest_distance_squared: float = INF
	for hook in get_tree().get_nodes_in_group("hooks_in_range"):
		var distance_squared = global_position.distance_squared_to(hook.global_position)
		if distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			closest_hook = hook
	return closest_hook

func _on_body_entered(body: Node2D) -> void:
	if body is Hook:
		body.add_to_group("hooks_in_range")
#
func _on_body_exited(body: Node2D) -> void:
	if body is Hook:
		body.remove_from_group("hooks_in_range")
