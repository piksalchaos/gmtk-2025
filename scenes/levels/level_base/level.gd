extends Node

@onready var arc_markings: ArcMarkings = $ArcMarkings
@onready var hook_container: HookContainer = $HookContainer
var skater: Skater

func _ready() -> void:
	arc_markings.shape_completed.connect()
	for child in get_children():
		if child is Skater:
			skater = child
			# i think im doing something wrong but the deadline is coming so screw good godot practices
			hook_container.skater = skater
			skater.died.connect(restart_level)
			skater.created_arc.connect(arc_markings.add_arc)
			skater.updated_arc.connect(arc_markings.update)

func restart_level():
	if is_inside_tree():
		get_tree().reload_current_scene()
