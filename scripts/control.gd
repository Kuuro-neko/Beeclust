extends Control

var bee_positions: Array = []  # Store bee positions
const MAX_POSITIONS = 134217728  # ~1GB limit
var heatmap_enabled = false  # Only draw when requested

@export var up_left_corner: Node2D
@export var up_right_corner: Node2D
@export var down_left_corner: Node2D
@export var down_right_corner: Node2D

var canvas_size
var heatmap_image: Image
var heatmap_texture: ImageTexture
var world_width
var world_height
func _ready():
	world_width = int(up_left_corner.position.distance_to(up_right_corner.position))
	world_height = int(up_left_corner.position.distance_to(down_left_corner.position))
	canvas_size = Vector2(world_width, world_height)

	# Create an empty heatmap image
	heatmap_image = Image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	heatmap_image.fill(Color(0, 0, 0, 0))  # Fully transparent

	# Properly initialize texture
	heatmap_texture = ImageTexture.create_from_image(heatmap_image)

	# Assign texture to TextureRect
	$TextureRect.texture = heatmap_texture
	$TextureRect.visible = false  # Hide it initially

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			heatmap_enabled = !heatmap_enabled
			if heatmap_enabled:
				draw_heatmap()  # Only draw when requested
			$TextureRect.visible = heatmap_enabled

func store_bee_position(pos: Vector2):
	if bee_positions.size() >= MAX_POSITIONS:
		bee_positions.pop_front()  # Keep size within limit
	bee_positions.append(pos)

func draw_heatmap():
	if not heatmap_enabled:
		return

	# Initialize a 2D array for the heatmap grid
	var heatmap_grid = Array()
	for i in range(world_width):
		var column = Array()
		for j in range(world_height):
			column.append(0)
		heatmap_grid.append(column)

	# Define the size of the neighborhood (n x n)
	var n = 3  # Example: 3x3 neighborhood (adjust as needed)

	# Map positions to grid and update the counts in the neighborhood
	for pos in bee_positions:
		var map_x = int(remap(pos.x, up_left_corner.position.x, up_right_corner.position.x, 0, world_width))
		var map_y = int(remap(pos.y, up_left_corner.position.y, down_left_corner.position.y, 0, world_height))

		# Ensure the coordinates are within bounds
		if map_x < 0 or map_x >= world_width or map_y < 0 or map_y >= world_height:
			continue

		# Add counts to the neighborhood of size n around the pixel (map_x, map_y)
		for dx in range(-n, n + 1):
			for dy in range(-n, n + 1):
				var neighbor_x = map_x + dx
				var neighbor_y = map_y + dy

				# Check if the neighbor is within bounds
				if neighbor_x >= 0 and neighbor_x < world_width and neighbor_y >= 0 and neighbor_y < world_height:
					heatmap_grid[neighbor_x][neighbor_y] += 1

	# Find the maximum count in the heatmap grid
	var max_count = 0
	for column in heatmap_grid:
		for cell in column:
			max_count = max(max_count, cell)

	# Create the heatmap texture
	heatmap_image.fill(Color(0, 0, 1, 1))  # Clear the image

	# Map the counts to colors and draw the heatmap
	for x in range(world_width):
		for y in range(world_height):
			var count = heatmap_grid[x][y]
			if count > 0:
				var intensity = sqrt(float(count) / max_count)  # Normalize the intensity based on the max count
				var color = Color(0.0, 0.0, 1-intensity)  # Red intensity based on the count
				heatmap_image.set_pixel(x, y, color)

	# Update the heatmap texture
	heatmap_texture.update(heatmap_image)
