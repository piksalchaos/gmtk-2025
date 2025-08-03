@tool
class_name Skater extends CharacterBody2D

const SPEED := 160.0
const REVOLVE_SPEED := 160.0
const VECTOR_CHANGE_FACTOR := 250.0
const ARC_CENTER_OFFSET := Vector2(0, 0)

@onready var direction_arrow: Line2D = $DirectionArrow
@onready var hook_detector: HookDetector = $HookDetector
@onready var hook_connector: Line2D = $HookConnector
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export_range(0, TAU) var start_direction_angle := 0.0
@onready var direction_vector := Vector2.RIGHT.rotated(start_direction_angle)
var is_started := false
var is_disabled := false
var closest_hook: Hook
var connected_hook_position := Vector2.ZERO
var connected_hook_distance := 0.0
var is_connected_to_hook := false
var is_rotating_clockwise := false
var current_arc: Arc

signal changed_position(new_global_position: Vector2)
signal died
#signal hook_connected(hook_index: int)
#signal hook_disconnected()
signal created_arc(arc: Arc)
signal updated_arc

func _ready():
	if Engine.is_editor_hint(): return
	rotation = 0
	direction_arrow.rotation = start_direction_angle
	changed_position.emit(global_position)

func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint() or is_disabled: return
	if event.is_action_pressed("control_skater"):
		if not is_started:
			is_started = true
			animated_sprite_2d.animation = "skate"
			return
		if closest_hook:
			connect_to_hook(closest_hook)
	if event.is_action_released("control_skater"):
		disconnect_from_hook()

func connect_to_hook(hook: Hook) -> void:
	#hook_connected.emit(hook.get_index())
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
	current_arc.center = connected_hook_position + ARC_CENTER_OFFSET
	current_arc.radius = connected_hook_distance
	var start_angle = (global_position - connected_hook_position).angle()
	current_arc.start_angle = start_angle
	current_arc.end_angle = start_angle
	current_arc.is_clockwise = is_rotating_clockwise
	created_arc.emit(current_arc)

func disconnect_from_hook() -> void:
	#hook_disconnected.emit()
	is_connected_to_hook = false
	hook_connector.visible = false

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		direction_arrow.rotation = start_direction_angle
	if not Engine.is_editor_hint() and is_started and not is_disabled:
		closest_hook = hook_detector.get_closest_hook()
		if is_connected_to_hook:
			hook_connector.set_point_position(1, connected_hook_position - global_position)
			var angular_velocity = REVOLVE_SPEED/connected_hook_distance * delta * (1 if is_rotating_clockwise else -1)
			direction_vector = direction_vector.rotated(angular_velocity)
			update_arc_length()
			
		velocity = direction_vector * (REVOLVE_SPEED if is_connected_to_hook else SPEED)
		direction_arrow.rotation = direction_vector.angle()
		move_and_slide()
		check_danger_collisions()
		changed_position.emit(global_position)
		
		animated_sprite_2d.flip_h = velocity.x < 0

func update_arc_length():
	current_arc.end_angle = (global_position - connected_hook_position).angle()
	if current_arc.is_length_completed: return
	var arc_length = abs(current_arc.end_angle-current_arc.start_angle)
	if arc_length > 0.05 and not current_arc.is_length_started:
		current_arc.is_length_started = true
	if arc_length < 0.05 and current_arc.is_length_started:
		current_arc.is_length_completed = true
	updated_arc.emit()

func check_danger_collisions():
	for i in get_slide_collision_count():
		var collider: PhysicsBody2D = get_slide_collision(i).get_collider()
		if collider.is_in_group("danger"):
			died.emit()
