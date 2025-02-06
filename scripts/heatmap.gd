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

	heatmap_image = Image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	heatmap_image.fill(Color(0, 0, 0, 1))
	heatmap_texture = ImageTexture.create_from_image(heatmap_image)

	$TextureRect.texture = heatmap_texture
	$TextureRect.visible = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			heatmap_enabled = !heatmap_enabled
			if heatmap_enabled:
				draw_heatmap()
			$TextureRect.visible = heatmap_enabled

func store_bee_position(pos: Vector2):
	if bee_positions.size() >= MAX_POSITIONS:
		bee_positions.pop_front()
	bee_positions.append(pos)

func draw_heatmap():
	if not heatmap_enabled:
		return

	var heatmap_grid = Array()
	for i in range(world_width):
		var column = Array()
		for j in range(world_height):
			column.append(0)
		heatmap_grid.append(column)
		
	var n = 3

	for pos in bee_positions:
		var map_x = int(remap(pos.x, up_left_corner.position.x, up_right_corner.position.x, 0, world_width))
		var map_y = int(remap(pos.y, up_left_corner.position.y, down_left_corner.position.y, 0, world_height))

		if map_x < 0 or map_x >= world_width or map_y < 0 or map_y >= world_height:
			continue

		for dx in range(-n, n + 1):
			for dy in range(-n, n + 1):
				var neighbor_x = map_x + dx
				var neighbor_y = map_y + dy
				if neighbor_x >= 0 and neighbor_x < world_width and neighbor_y >= 0 and neighbor_y < world_height:
					heatmap_grid[neighbor_x][neighbor_y] += 1

	var max_count = 0
	for column in heatmap_grid:
		for cell in column:
			max_count = max(max_count, cell)

	# Create the heatmap texture
	heatmap_image.fill(Color(0, 0, 1, 1))
	for x in range(world_width):
		for y in range(world_height):
			var count = heatmap_grid[x][y]
			if count > 0:
				var intensity = sqrt(float(count) / max_count)
				var color = Color(0.0, 0.0, 1-intensity)
				heatmap_image.set_pixel(x, y, color)
	heatmap_texture.update(heatmap_image)
