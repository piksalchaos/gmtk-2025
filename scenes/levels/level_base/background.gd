extends Node2D

const SQUARE_WIDTH = 150
const SPEED = 50.0

var square_positions:Array[Vector2] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#new_square()
	for i in range(80):
		square_positions.push_back(Vector2(randf()*(1152+SQUARE_WIDTH*2)-SQUARE_WIDTH, randf()*(648+SQUARE_WIDTH*2)-SQUARE_WIDTH))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in square_positions.size():
		square_positions[i].x += SPEED * delta
		square_positions[i].y += SPEED * delta
		if square_positions[i].x > 1152:
			square_positions[i].x = -SQUARE_WIDTH
		if square_positions[i].y > 648:
			square_positions[i].y = -SQUARE_WIDTH
	queue_redraw()

func new_square():
	square_positions.push_back(Vector2(randf()*(1152+SQUARE_WIDTH*2)-SQUARE_WIDTH, -SQUARE_WIDTH))

func _draw():
	for square_position in square_positions:
		draw_rect(Rect2(square_position, Vector2(SQUARE_WIDTH, SQUARE_WIDTH)), Color("#3c2a5e", 0.05))
