class_name Hook extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func set_is_highlighted(is_highlighted: bool):
	sprite_2d.frame = 1 if is_highlighted else 0
