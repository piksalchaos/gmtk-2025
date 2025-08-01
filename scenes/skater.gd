extends CharacterBody2D

const SPEED := 250

@export_range(0, 2 * PI) var initial_direction_angle := 0.0
@onready var direction_angle := initial_direction_angle
var is_started := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("control_skater"):
		if not is_started:
			is_started = true
		else:
			pass

func _physics_process(delta: float) -> void:
	if is_started:
		velocity = Vector2.RIGHT.rotated(direction_angle) * SPEED
	move_and_slide()
