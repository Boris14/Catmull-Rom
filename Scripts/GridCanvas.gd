class_name GridCanvas
extends Node2D

# Grid size and line configuration
@export var grid_size := 40.0  # Size of each cell in the grid
@export var grid_color := Color.LIGHT_GRAY 
@export var line_color := Color.RED
@export var points_color := Color.RED
@export var select_radius := 20.0

var points : Array[Marker2D]
var selected_point : Marker2D = null

func _ready():
	for child in get_children():
		var point := child as Marker2D
		if point:
			points.append(point)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_point and not event.pressed:
			# Stop dragging if the button is released.
			selected_point = null
		else:
			for point in points:
				if (event.position - point.position).length() < select_radius:
					# Start dragging if the click is on the sprite.
					if not selected_point and event.pressed:
						selected_point = point

	if event is InputEventMouseMotion and selected_point:
		# While dragging, move the sprite with the mouse.
		selected_point.position = event.position
		

func _draw():
	var viewport_size = get_viewport_rect().size

	# Draw vertical grid lines
	for x in range(0, int(viewport_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), grid_color, 1)

	# Draw horizontal grid lines
	for y in range(0, int(viewport_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), grid_color, 1)
	
	for i in range(points.size()):
		if i == 0: continue
		draw_line(points[i - 1].position, points[i].position, line_color, 2)
	
	for point in points:
		draw_circle(point.position, 3, Color.RED)
