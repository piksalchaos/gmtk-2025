class_name HookDetector extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var hook_count = 0

func _draw() -> void:
	for body in get_overlapping_bodies():
		if not body is Hook: continue
		var circle_position = body.global_position - global_position
		var circle_radius = global_position.distance_to(body.global_position)
		draw_circle(circle_position, circle_radius, Color("White", 0.1), false, 2, true)

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

func get_closest_hook_to_mouse() -> Hook:
	var closest_distance_squared: float = INF
	var closest_hook: Hook
	for body in get_overlapping_bodies():
		if not body is Hook: continue
		var distance_squared = get_global_mouse_position().distance_squared_to(body.global_position)
		if distance_squared < closest_distance_squared:
			closest_distance_squared = distance_squared
			closest_hook = body
	return closest_hook

func _on_body_entered(body: Node2D) -> void:
	if body is Hook:
		body.set_is_highlighted(true)
		hook_count += 1

func _on_body_exited(body: Node2D) -> void:
	if body is Hook:
		body.set_is_highlighted(false)
		hook_count -= 1
		queue_redraw()

func _process(_delta: float) -> void:
	if hook_count > 0:
		queue_redraw()
