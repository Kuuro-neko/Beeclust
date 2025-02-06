extends Control



func _on_return_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_n_bees_slider_value_changed(value: float) -> void:
	var config = ConfigFile.new()
	config.set_value("Settings", "NBees", int(value))
	config.save("user://config.cfg")
