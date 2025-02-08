extends Node2D

var selected = false
var mouse_offset = Vector2(0, 0)
var sprite
var camera

func _ready():
	sprite = $Sprite2D
	camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	if selected:
		followMouse()

func followMouse():
	position = get_global_mouse_position() + mouse_offset

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var sprite_rect_global = Rect2(sprite.global_position, sprite.texture.get_size())
			sprite_rect_global.position = (sprite_rect_global.position - camera.offset) * camera.zoom
			if sprite_rect_global.has_point(event.position):
				mouse_offset = position - get_global_mouse_position()
				selected = true
		else:
			selected = false
