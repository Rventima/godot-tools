extends Node
class_name Test
var debug : Debug
func _ready() -> void:
	debug = Debug.new(self)
	pass
	
	#debug.log("Hola.")
	#debug.log_warn("Warning.")
	#debug.log_error("Error.")
	#debug.PrintImage.new().console_image("res://icon.svg")
	#debug.log_fps_every_seconds(1.0)
	

func _process(_delta: float) -> void:
	debug.log_fps_every_seconds(4)
	pass
	#debug.log_fps_every_seconds(1.0)
	
