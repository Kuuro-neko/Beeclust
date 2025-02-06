extends Label

@export var nBeesSlider: Slider

func _ready() -> void:
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return
	self.text = str(config.get_value("Settings", "NBees"))
	
	nBeesSlider.value = config.get_value("Settings", "NBees")

func _on_n_bees_slider_value_changed(value: float) -> void:
	self.text = str(value)
