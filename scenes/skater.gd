@tool
class_name Skater extends CharacterBody2D

const SPEED := 250.0
const VECTOR_CHANGE_FACTOR := 250.0

@onready var direction_arrow: Line2D = $DirectionArrow
@onready var hook_detector: HookDetector = $HookDetector
@onready var hook_connector: Line2D = $HookConnector

@export_range(0, 2 * PI) var start_direction_angle := 0.0
@onready var direction_vector := Vector2.RIGHT.rotated(start_direction_angle)
var is_started := false
var connected_hook_position := Vector2.ZERO
var connected_hook_distance := 0.0
var is_connected_to_hook := false
var is_rotating_clockwise := false

func _ready():
	if Engine.is_editor_hint(): return
	rotation = 0
	direction_arrow.rotation = start_direction_angle

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint(): return
	if event.is_action_pressed("control_skater"):
		if not is_started:
			is_started = true
			return
		var closest_hook := hook_detector.get_closest_hook()
		if closest_hook:
			connect_to_hook(closest_hook)
	if event.is_action_released("control_skater"):
		disconnect_from_hook()

func connect_to_hook(hook: Hook) -> void:
	is_connected_to_hook = true
	hook_connector.visible = true
	connected_hook_position = hook.global_position
	connected_hook_distance = global_position.distance_to(connected_hook_position)
	var perpendicular_vector = (connected_hook_position - global_position).normalized()
	is_rotating_clockwise = perpendicular_vector.angle_to(direction_vector) < 0
	direction_vector = perpendicular_vector.rotated(PI/2 * (-1 if is_rotating_clockwise else 1))

func disconnect_from_hook() -> void:
	is_connected_to_hook = false
	hook_connector.visible = false

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		direction_arrow.rotation = start_direction_angle
	if not Engine.is_editor_hint() and is_started:
		if is_connected_to_hook:
			hook_connector.set_point_position(1, connected_hook_position - global_position)
			var angular_velocity = SPEED/connected_hook_distance * delta * (1 if is_rotating_clockwise else -1)
			direction_vector = direction_vector.rotated(angular_velocity)
		velocity = direction_vector * SPEED
		direction_arrow.rotation = direction_vector.angle()
		move_and_slide()
	
