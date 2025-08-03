class_name CompletedCircle extends Node2D

const LINE_WIDTH := 2.0
@export var center: Vector2
@export var radius: float
var callback: Callable
var shape_scale := 1.0

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "shape_scale", 1.2, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "shape_scale", 20, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_callback(callback)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(center, radius*shape_scale, Color.BLACK)
	draw_circle(center, radius*shape_scale, Color.WHITE, false, LINE_WIDTH)
