extends Node

@onready var arc_markings: ArcMarkings = $ArcMarkings
var skater: Skater

func _ready() -> void:
	for child in get_children():
		if child is Skater:
			skater = child
			skater.died.connect(restart_level)
			skater.created_arc.connect(add_new_arc)

func add_new_arc(arc: Arc):
	arc_markings.arcs.append(arc)
	print('wow')

func restart_level():
	if is_inside_tree():
		get_tree().reload_current_scene()
