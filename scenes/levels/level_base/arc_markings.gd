class_name ArcMarkings extends Node2D

const LINE_WIDTH := 2.0
@export var arcs: Array[Arc]

var is_shape_completed := false
signal circle_completed(center: Vector2, radius: float)

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
		draw_arc(arc.center + Vector2(), arc.radius, arc.start_angle, end_angle, point_count, Color.WHITE, LINE_WIDTH)
	#if is_circle_completed:
		#draw_circle(circle_center, circle_radius*shape_scale, Color.BLACK)
		#draw_circle(circle_center, circle_radius*shape_scale, Color.WHITE, false, LINE_WIDTH)

func update() -> void:
	queue_redraw()
	if is_shape_completed: return
	for arc in arcs:
		if arc.is_length_completed:
			is_shape_completed = true
			circle_completed.emit(arc.center, arc.radius)
			#circle_center = arc.center
			#circle_radius = arc.radius
			#start_completed_shape_animation()

#func _process(_delta: float) -> void:
	#queue_redraw()
	#if is_circle_completed: return
	#for arc in arcs:
		#if arc.is_length_completed:
			#is_circle_completed = true
			#circle_center = arc.center
			#circle_radius = arc.radius
			#start_completed_shape_animation()

func start_completed_shape_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "shape_scale", 1.2, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "shape_scale", 15, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
