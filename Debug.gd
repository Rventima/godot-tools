@tool
extends Node
class_name Debug

## colors
const _LOG_COLOR : String = "10FFFF"
const _WARNING_COLOR : String = "FFE100"
const _ERROR_COLOR : String = "FF4545"
const _MESSAGE_COLOR : String = "FFFFFF"

## name of this debug control (i.e., Node name where this class is instantiated). 
var where : String
var font_size : int = 20
var _node : Node


## inits the name for this instance to know from where the message comes from. 
func _init(_self : Node) -> void:
	where = _self.name
	_node = _self
	

## simple message
func log(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says:[/color][b] [color=%s]%s[/color]" %[_LOG_COLOR, where, _MESSAGE_COLOR, message])
		
		assert(not pause_execution, message)

## info message
func log_warn(message : String, pause_execution = false) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' warns a message:[/color][b] [color=%s]%s[/color]" %[_WARNING_COLOR, where, _MESSAGE_COLOR, message])
		push_warning(message)
		
		assert(not pause_execution, message)

## error message
func log_error(message : String, pause_execution = true) -> void:
	if _is_on_editor():
		print_rich("[b][color=%s]Script '%s' says there's an error:[/color][b] [color=%s]%s[/color]" %[_ERROR_COLOR, where, _MESSAGE_COLOR, message])
		push_error(message)
		
		assert(not pause_execution, message)
		
	
func _is_on_editor() -> bool:
	return OS.has_feature("editor")
	

func scope() -> void:
	const GD_EXTENSION = ".gd"
	
	var trl = RichTextLabel.new()
	trl.connect("meta_clicked",_on_url_click)
	
	## class_name and script file names must match to make this work
	var script_name : StringName = _node.get_script().get_global_name().to_lower() + GD_EXTENSION
	print(script_name)
	
	var files = DirAccess.get_directories_at("res://")
	print(files)
	
	var absolute_path = _get_user_file_path("res://Tools/"+script_name)
	
	print(absolute_path)
	trl.text = "[url=../computer_00.gd]aaa[/url]"
	print_rich(trl.text)
	
	pass


func _on_url_click(meta : String) -> void:
	print("url")
	OS.shell_open(str(meta))
	pass
	

## returns user absolute path or empty string if not running in editor and pushes a warning
func _get_user_file_path(editor_path) -> String:
	# Running in editor
	if _is_on_editor():
		return ProjectSettings.globalize_path(editor_path)
		
	else:
		push_warning("Not executing in editor")
		return ""
		
		
## Debug used colors must be here	
class DebugColor:
	const BLACK = "000000"


## Logic for printing images in console must be here
class PrintImage:
	
	func console_image(_path : String) -> void:
		#var path = "res://icon.svg"
		print_rich("[img]%s[/img]"%_path)


## Logic for finding files that Debug uses must be here
class FileFinder:
	
	func find_directories() -> PackedStringArray:
		if _is_on_editor():
			
			pass
		else:
			return []
		
		return []
		
		
	func find_files() -> PackedStringArray:
		if _is_on_editor():
			
			pass
		else:
			return []
			
		return []
		
	
	func find_file_name() -> String:
		if _is_on_editor():
			
			pass
		else:
			return ''
			
		return ''
	

	func _is_on_editor():
		return OS.has_feature("editor")
