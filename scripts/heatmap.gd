extends Control

@export var up_left_corner: Node2D
@export var up_right_corner: Node2D
@export var down_left_corner: Node2D
@export var down_right_corner: Node2D

var canvas_size

var world_width
var world_height

var heatmap_image: Image
var heatmap_texture: ImageTexture
var heatmap_grid
var heatmap_enabled = false

var n = 3

func _ready():
	world_width = int(up_left_corner.position.distance_to(up_right_corner.position))
	world_height = int(up_left_corner.position.distance_to(down_left_corner.position))
	canvas_size = Vector2(world_width, world_height)

	heatmap_image = Image.create(canvas_size.x, canvas_size.y, false, Image.FORMAT_RGBA8)
	heatmap_image.fill(Color(0, 0, 0, 1))
	heatmap_texture = ImageTexture.create_from_image(heatmap_image)
	
	init_heatmap_grid()

	$TextureRect.texture = heatmap_texture
	$TextureRect.visible = false

func _process(delta: float) -> void:
	if heatmap_enabled:
		draw_heatmap()
	else:
		$TextureRect.visible = false

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			toggle_heatmap()

func init_heatmap_grid():
	heatmap_grid = Array()
	for i in range(world_width):
		var column = Array()
		for j in range(world_height):
			column.append(0)
		heatmap_grid.append(column)

func store_bee_position(pos: Vector2):
	var map_x = int(remap(pos.x, up_left_corner.position.x, up_right_corner.position.x, 0, world_width))
	var map_y = int(remap(pos.y, up_left_corner.position.y, down_left_corner.position.y, 0, world_height))

	for dx in range(-n, n + 1):
		for dy in range(-n, n + 1):
			var neighbor_x = map_x + dx
			var neighbor_y = map_y + dy
			if neighbor_x >= 0 and neighbor_x < world_width and neighbor_y >= 0 and neighbor_y < world_height:
				heatmap_grid[neighbor_x][neighbor_y] += 1

func draw_heatmap():
	if not heatmap_enabled:
		return

	var max_count = 0
	for column in heatmap_grid:
		for cell in column:
			max_count = max(max_count, cell)
	
	if max_count == 0:
		return

	heatmap_image.fill(Color(0, 0, 1, 1))
	for x in range(world_width):
		for y in range(world_height):
			var count = heatmap_grid[x][y]
			if count > 0:
				var intensity = sqrt(float(count) / max_count)
				var color = Color(0.0, 0.0, 1-intensity)
				heatmap_image.set_pixel(x, y, color)
	heatmap_texture.update(heatmap_image)

func _on_h_button_pressed() -> void:
	toggle_heatmap()

func clear_heatmap():
	init_heatmap_grid()

func toggle_heatmap():
	heatmap_enabled = !heatmap_enabled
	$TextureRect.visible = heatmap_enabled
