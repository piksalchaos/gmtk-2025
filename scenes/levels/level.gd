extends Node

@onready var arc_markings: ArcMarkings = $ArcMarkings
var skater: Skater

func _ready() -> void:
	for child in get_children():
		if child is Skater:
			skater = child
			skater.died.connect(restart_level)
			skater.created_arc.connect(arc_markings.add_arc)
			skater.updated_arc.connect(arc_markings.update)

func restart_level():
	if is_inside_tree():
		get_tree().reload_current_scene()
