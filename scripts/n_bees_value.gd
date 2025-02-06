extends Label

@export var nBeesSlider: Slider

func _on_n_bees_slider_value_changed(value: float) -> void:
	self.text = str(value)
