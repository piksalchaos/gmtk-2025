extends Node

var skater: Skater

func _ready() -> void:
	for child in get_children():
		if child is Skater:
			skater = child
			skater.died.connect(restart_level)

func restart_level():
	if is_inside_tree():
		get_tree().reload_current_scene()
