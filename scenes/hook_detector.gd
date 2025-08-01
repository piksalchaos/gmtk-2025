class_name HookDetector extends Area2D

func get_closest_hook() -> Hook:
	var closest_distance_squared: float = INF
	var closest_hook: Hook
	for body in get_overlapping_bodies():
		if not body is Hook: continue
		var distance_squared = global_position.distance_squared_to(body.global_position)
		if distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			closest_hook = body
	return closest_hook
