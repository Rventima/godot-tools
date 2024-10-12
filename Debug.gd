extends Node
class_name Debug

## colors
const LOG_COLOR : String = "10FFFF"
const WARNING_COLOR : String = "FFE100"
const ERROR_COLOR : String = "FF4545"
const MESSAGE_COLOR : String = "FFFFFF"

## name of this debug control (i.e., Node name where this class is instantiated). 
var where : String

## inits the name for this instance to know from where the message comes from. 
func _init(_where : String) -> void:
	where = _where


## simple message
func log(message : String) -> void:
	print_rich("[b][color=%s]Script %s says:[/color][b] [color=%s]%s[/color]" %[LOG_COLOR, where, MESSAGE_COLOR, message])
	

## info message
func log_warn(message : String) -> void:
	print_rich("[b][color=%s]Script %s warns a message:[/color][b] [color=%s]%s[/color]" %[WARNING_COLOR, where, MESSAGE_COLOR, message])
	

## error message
func log_error(message : String) -> void:
	print_rich("[b][color=%s]Script %s says there's an error:[/color][b] [color=%s]%s[/color]" %[ERROR_COLOR, where, MESSAGE_COLOR, message])

	
	
