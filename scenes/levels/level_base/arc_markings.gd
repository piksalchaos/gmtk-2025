class_name ArcMarkings extends Node2D

const LINE_WIDTH := 2.0
@export var arcs: Array[Arc]

signal circle_completed(circle_position: Vector2, circle_radius: float);

func add_arc(arc: Arc):
	arcs.append(arc)

func _draw() -> void:
	for arc in arcs:
		if arc.is_length_completed:
			draw_circle(arc.center, arc.radius, Color.WHITE, false, LINE_WIDTH)
			continue
		var end_angle = arc.end_angle
		if arc.is_clockwise and end_angle < arc.start_angle: end_angle += TAU
		if not arc.is_clockwise and end_angle > arc.start_angle: end_angle -= TAU
		var point_count = arc.radius * abs(end_angle - arc.start_angle) / 15 + 2
		draw_arc(arc.center + Vector2(), arc.radius, arc.start_angle, end_angle, point_count, Color.WHITE, LINE_WIDTH, true)

func update() -> void:
	for arc in arcs:
		if arc.is_length_completed:
			circle_completed.emit(arc.center, arc.radius)
	queue_redraw()
