extends StaticBody2D

const COLOR = Color("#900b3a")
const JIGGLE_RANGE = 2
var collision_polygon: CollisionPolygon2D

func _ready() -> void:
	for child in get_children():
		if child is CollisionPolygon2D:
			collision_polygon = child

func _draw() -> void:
	var polygon = collision_polygon.polygon.duplicate()
	polygon.push_back(polygon[0])
	for i in polygon.size():
		polygon[i] += Vector2((randf()-0.5)*JIGGLE_RANGE, (randf()-0.5)*JIGGLE_RANGE)
	draw_polyline(polygon, COLOR, 3)

func _on_timer_timeout() -> void:
	queue_redraw()
