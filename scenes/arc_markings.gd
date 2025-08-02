class_name ArcMarkings extends Node2D

@export var arcs: Array[Arc]

func _draw() -> void:
	for arc in arcs:
		var end_angle = arc.end_angle
		if arc.is_clockwise and end_angle < arc.start_angle: end_angle += TAU
		if not arc.is_clockwise and end_angle > arc.start_angle: end_angle -= TAU
		var point_count = arc.radius * abs(end_angle - arc.start_angle) / 15 + 2
		print(point_count)
		draw_arc(arc.center, arc.radius, arc.start_angle, end_angle, point_count, Color.WHITE, 2, true)

func _process(_delta: float) -> void: #change this to only redraw arcs when they change
	queue_redraw()
