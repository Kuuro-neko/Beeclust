extends Control

@export var h_button : TextureButton
@export var esc_button : TextureButton

var normal_texture_h = preload("res://assets/Keys/H_key.png")
var pressed_texture_h = preload("res://assets/Keys/H_key_pressed.png")

var normal_texture_esc = preload("res://assets/Keys/ESC_key.png")
var pressed_texture_esc = preload("res://assets/Keys/ESC_key_pressed.png")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			h_button.texture_normal = pressed_texture_h
	elif event is InputEventKey and not event.pressed:
		if event.keycode == KEY_H:
			h_button.texture_normal = normal_texture_h

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			esc_button.texture_normal = pressed_texture_esc
	elif event is InputEventKey and not event.pressed:
		if event.keycode == KEY_ESCAPE:
			esc_button.texture_normal = normal_texture_esc
