extends Node

@onready var arc_markings: ArcMarkings = $ArcMarkings
@onready var hook_hints: Node2D = $HookHints
var skater: Skater

func _ready() -> void:
	for child in get_children():
		if child is Skater:
			skater = child
			hook_hints.update_skater_position(skater.global_position)
			skater.changed_position.connect(hook_hints.update_skater_position)
			skater.died.connect(restart_level)
			skater.created_arc.connect(arc_markings.add_arc)
			skater.updated_arc.connect(arc_markings.update)

func restart_level():
	if is_inside_tree():
		get_tree().reload_current_scene()
