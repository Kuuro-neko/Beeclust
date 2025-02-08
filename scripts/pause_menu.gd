extends Control

@export var esc_button : TextureButton
var normal_texture_esc = preload("res://assets/Keys/ESC_key.png")

func _ready() -> void:
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	hide()
	get_tree().paused = false
	esc_button.texture_normal = normal_texture_esc
	$AnimationPlayer.play_backwards("blur")

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("Escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Escape") and get_tree().paused:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta: float) -> void:
	testEsc()


func _on_esc_button_pressed() -> void:
	if !get_tree().paused:
		pause()
	elif get_tree().paused:
		resume()
