class_name Hook extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_is_highlighted(is_highlighted: bool):
	sprite_2d.frame = 1 if is_highlighted else 0

func _on_range_body_entered(body: Node2D) -> void:
	if body is Skater:
		add_to_group("hooks_in_range")

func _on_range_body_exited(body: Node2D) -> void:
	if body is Skater:
		remove_from_group("hooks_in_range")
