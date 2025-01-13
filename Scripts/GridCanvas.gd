class_name GridCanvas
extends Node2D

# Grid size and line configuration
@export var grid_size := 40.0  # Size of each cell in the grid
@export var grid_color := Color.LIGHT_GRAY 
@export var line_color := Color.RED
@export var points_color := Color.RED
@export var select_radius := 20.0
@export var curve_segments := 100

var points : Array[Marker2D]
var selected_point : Marker2D = null

func _ready() -> void:
	%AddPointButton.pressed.connect(_on_add_point_button_pressed)
	%RemovePointButton.pressed.connect(_on_remove_point_button_pressed)
	
	for child in get_children():
		var point := child as Marker2D
		if point:
			points.append(point)

func _input(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if selected_point and not event.pressed:
			# Stop dragging if the button is released.
			selected_point = null
		else:
			for point in points:
				if (event.position - point.global_position).length() < select_radius:
					# Start dragging if the click is on the sprite.
					if not selected_point and event.pressed:
						selected_point = point

	if event is InputEventMouseMotion and selected_point:
		# While dragging, move the sprite with the mouse.
		selected_point.global_position = event.position
		queue_redraw()

func _physics_process(delta: float) -> void:
	pass
	#points.sort_custom(func(p1,p2): return p1.global_position.x < p2.global_position.x)

func get_curve_point(points, t):
	var constructed_points = []
	for point in points:
		constructed_points.push_back(point.global_position)
	while constructed_points.size() > 1:		
		var new_points = []
		for i in range(1, constructed_points.size()):
			var next_point_pos = (1 - t) * constructed_points[i - 1] + t * constructed_points[i]
			new_points.push_back(next_point_pos)
		constructed_points = new_points
	return constructed_points[0]

func get_curve_points(points) -> PackedVector2Array:
	var result : PackedVector2Array
	var t := 0.0
	var step := 1.0 / curve_segments
	while t < 1.0:
		result.append(get_curve_point(points, t))
		t += step
	return result

func _draw() -> void:
	var viewport_size = get_viewport_rect().size

	# Draw vertical grid lines
	for x in range(0, int(viewport_size.x), grid_size):
		draw_line(Vector2(x, 0), Vector2(x, viewport_size.y), grid_color, 1)

	# Draw horizontal grid lines
	for y in range(0, int(viewport_size.y), grid_size):
		draw_line(Vector2(0, y), Vector2(viewport_size.x, y), grid_color, 1)
	
	# Draw the points and the lines between them
	for i in range(points.size()):
		var p_pos = points[i].global_position
		draw_circle(p_pos, 4, Color.RED)
		draw_string(ThemeDB.fallback_font, p_pos + Vector2(-10, -30), \
		 	"(%d, %d)" % [p_pos.x, p_pos.x], HORIZONTAL_ALIGNMENT_CENTER)
		if i > 0:
			draw_line(points[i - 1].global_position, p_pos, line_color, 2)
			
	draw_polyline(get_curve_points(points), Color.GREEN_YELLOW)

func _on_add_point_button_pressed():
	var new_point = Marker2D.new()
	add_child(new_point)
	
	var viewport_size = get_viewport_rect().size
	new_point.global_position.x = randf_range(0, viewport_size.x)
	new_point.global_position.y = randf_range(0, viewport_size.y)
	points.push_back(new_point)
	queue_redraw()
	
func _on_remove_point_button_pressed():
	var removed_point : Marker2D = points.pop_back()
	removed_point.queue_free()
	queue_redraw()
