extends Node

const COMPLETED_CIRCLE = preload("res://scenes/objects/completed_circle.tscn")

@export var next_scene: PackedScene
@onready var arc_markings: ArcMarkings = $ArcMarkings
@onready var hook_container: HookContainer = $HookContainer
@onready var scene_transitioner: SceneTransitioner = $SceneTransitioner
var skater: Skater

func _ready() -> void:
	arc_markings.circle_completed.connect(on_circle_completed)
	for child in get_children():
		if child is Skater:
			skater = child
			# i think im doing something wrong but the deadline is coming so screw good godot practices
			hook_container.skater = skater
			skater.died.connect(restart_level)
			skater.created_arc.connect(arc_markings.add_arc)
			skater.updated_arc.connect(arc_markings.update)

func restart_level() -> void:
	if is_inside_tree():
		get_tree().reload_current_scene()

func on_circle_completed(center: Vector2, radius: float) -> void:
	skater.is_disabled = true
	var completed_circle = COMPLETED_CIRCLE.instantiate()
	completed_circle.center = center
	completed_circle.radius = radius
	completed_circle.callback = goto_next_scene_after_transition
	add_child(completed_circle)

func goto_next_scene_after_transition():
	scene_transitioner.call_func_after_transition(goto_next_scene)

func goto_next_scene():
	get_tree().change_scene_to_packed(next_scene)
