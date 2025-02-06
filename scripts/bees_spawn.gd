extends Node2D

var bee = preload("res://scenes/bee.tscn")
@export var target: Node2D
@export var up_left_corner: Node2D
@export var up_right_corner: Node2D
@export var down_left_corner: Node2D
@export var down_right_corner: Node2D
@export var heatmap: Control

var bees = []

func getNBees() -> int:
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return 20
	return int(config.get_value("Settings", "NBees"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nBees = getNBees()
	print("creating bees : ", nBees)

	for i in range(nBees):
		var new_bee = create_bee()
		if new_bee:
			add_child(new_bee)
			bees.append(new_bee)

func get_random_position() -> Vector2:
	var x = randf_range(up_left_corner.position.x, up_right_corner.position.x)
	var y = randf_range(up_left_corner.position.y, down_left_corner.position.y)
	return Vector2(x, y)

func is_colliding(pos: Vector2) -> bool:
	if bees.is_empty():
		return false
	for bee in bees:
		if bee.position.distance_to(pos) < 20: # Adjust collision radius if needed
			return true
	return false
	
func create_bee() -> Node2D:
	var max_attempts = 10
	for _i in range(max_attempts):
		var pos = get_random_position()
		
		# Check for collisions with existing bees
		if not is_colliding(pos):
			var new_bee = bee.instantiate()
			new_bee.position = pos
			
			# Pass exported variables to bee
			new_bee.target = target
			new_bee.heatmap = heatmap
			new_bee.up_left_corner = up_left_corner
			new_bee.up_right_corner = up_right_corner
			new_bee.down_left_corner = down_left_corner
			new_bee.down_right_corner = down_right_corner

			return new_bee
	return null
