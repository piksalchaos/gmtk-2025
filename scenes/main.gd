extends Node

@onready var level_container: Node = $LevelContainer
var level_paths: Array[String]

func _ready() -> void:
	for i in range(2):
		level_paths.append("res://scenes/levels/level_" + str(i+1) + ".tscn")
