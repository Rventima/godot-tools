extends Node
class_name Test

func _ready() -> void:
	var debug : Debug = Debug.new(self)
	
	debug.log("Hola.")
	debug.log_warn("Warning.")
	debug.log_error("Error.",false)
	#debug.scope()
	
	#debug.PrintImage.new().console_image("res://icon.svg")
	
	
