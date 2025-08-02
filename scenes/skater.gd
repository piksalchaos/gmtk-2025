@tool
class_name Skater extends CharacterBody2D

const SPEED := 250.0
const VECTOR_CHANGE_FACTOR := 250.0

@onready var direction_arrow: Line2D = $DirectionArrow
@onready var hook_detector: HookDetector = $HookDetector
@onready var hook_connector: Line2D = $HookConnector

@export_range(0, TAU) var start_direction_angle := 0.0
@onready var direction_vector := Vector2.RIGHT.rotated(start_direction_angle)
var is_started := false
var connected_hook_position := Vector2.ZERO
var connected_hook_distance := 0.0
var is_connected_to_hook := false
var is_rotating_clockwise := false
var current_arc: Arc

signal died
signal created_arc(arc: Arc)

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
	create_new_arc()

func create_new_arc():
	current_arc = Arc.new()
	current_arc.center = connected_hook_position
	current_arc.radius = connected_hook_distance
	var start_angle = (global_position - connected_hook_position).angle()
	current_arc.start_angle = start_angle
	current_arc.end_angle = start_angle
	current_arc.is_clockwise = is_rotating_clockwise
	created_arc.emit(current_arc)

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
			current_arc.end_angle = (global_position - connected_hook_position).angle()
		velocity = direction_vector * SPEED
		direction_arrow.rotation = direction_vector.angle()
		move_and_slide()
		check_danger_collisions()

func check_danger_collisions():
	for i in get_slide_collision_count():
		var collider: PhysicsBody2D = get_slide_collision(i).get_collider()
		if collider.is_in_group("danger"):
			died.emit()
