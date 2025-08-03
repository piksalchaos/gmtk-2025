extends StaticBody2D

var collision_polygon: CollisionPolygon2D

func _ready() -> void:
	for child in get_children():
		if child is CollisionPolygon2D:
			collision_polygon = child

func _draw() -> void:
	var polygon = collision_polygon.polygon.duplicate()
	polygon.push_back(polygon[0])
	draw_polyline(polygon, Color.RED, 2)
