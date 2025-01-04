class_name GridCanvas
extends Node2D

# Grid size and line configuration
@export var grid_size = 40  # Size of each cell in the grid
@export var grid_color = Color(0.7, 0.7, 0.7)  # Light gray
@export var line_color = Color(1, 0, 0)  # Red
@export var line_start = Vector2(100, 100)  # Starting point of the custom line
@export var line_end = Vector2(300, 300)    # Ending point of the custom line

func _draw():
	var viewport_size = get_viewport_rect().size

	# Draw vertical grid lines
	for x in range(0, int(viewport_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), grid_color, 1)

	# Draw horizontal grid lines
	for y in range(0, int(viewport_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), grid_color, 1)

	# Draw the custom line
	draw_line(line_start, line_end, line_color, 2)
