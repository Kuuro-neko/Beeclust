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

#func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			 #print("hye")
				## Debugging the global mouse position
				#
#
				## Get the sprite's global bounding box
			var sprite_rect_global = Rect2(sprite.global_position, sprite.texture.get_size())
			print("Global Mouse Position: ", event.position)
				## Debugging the global sprite bounding box
			print("Sprite Global Position: ", sprite.global_position)
			print("Sprite Global Rect: ", sprite_rect_global)
			var local_mouse = ((event.position / camera.zoom) + camera.offset)
			print("Local Mouse Position: ", local_mouse)
				## Check if the global mouse position is inside the sprite's global bounding box
			if sprite_rect_global.has_point(local_mouse):
				mouse_offset = position - get_global_mouse_position()
				selected = true
		else:
			selected = false
